using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;

namespace SueTheChef
{
    public partial class Checkout : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            BindPage();
            if (!IsPostBack)
                RefreshLocationCard();
        }

        void RefreshLocationCard()
        {
            int id;
            if (!int.TryParse(ddlPickupLocation.SelectedValue, out id)) return;

            string cs = ConfigurationManager.ConnectionStrings["RollinCoConnectionString"].ConnectionString;
            try
            {
                using (var conn = new SqlConnection(cs))
                using (var cmd = new SqlCommand(
                    "SELECT LocationName, Address, Phone FROM LOCATIONS WHERE LocationID = @LocationID", conn))
                {
                    conn.Open();
                    cmd.Parameters.AddWithValue("@LocationID", id);
                    using (var r = cmd.ExecuteReader())
                    {
                        if (!r.Read())
                        {
                            litLocationCard.Text = "";
                            return;
                        }
                        string name = Convert.ToString(r["LocationName"]);
                        string addr = Convert.ToString(r["Address"]);
                        string phone = r["Phone"] == DBNull.Value ? "" : Convert.ToString(r["Phone"]);
                        litLocationCard.Text =
                            "<div class=\"kr-location-card-body\"><p class=\"kr-location-name\">" + Server.HtmlEncode(name) +
                            "</p><p class=\"kr-location-address\">" + Server.HtmlEncode(addr) + "</p>" +
                            (string.IsNullOrWhiteSpace(phone)
                                ? ""
                                : "<p class=\"kr-location-phone\">" + Server.HtmlEncode(phone) + "</p>") + "</div>";
                    }
                }
            }
            catch
            {
                litLocationCard.Text = "";
            }
        }

        protected void ddlPickupLocation_SelectedIndexChanged(object sender, EventArgs e)
        {
            RefreshLocationCard();
        }

        void BindPage()
        {
            litCheckoutError.Visible = false;
            var cart = RollinCart.GetCart(Session);
            if (cart.Count == 0)
            {
                pnlEmpty.Visible = true;
                pnlCheckout.Visible = false;
                return;
            }

            pnlEmpty.Visible = false;
            pnlCheckout.Visible = true;

            var lines = new List<CartLineVm>();
            string cs = ConfigurationManager.ConnectionStrings["RollinCoConnectionString"].ConnectionString;

            using (var conn = new SqlConnection(cs))
            {
                conn.Open();
                foreach (var kv in cart)
                {
                    using (var cmd = new SqlCommand(
                        "SELECT ProductName, Price FROM PRODUCTS WHERE ProductID = @ProductID", conn))
                    {
                        cmd.Parameters.AddWithValue("@ProductID", kv.Key);
                        using (var r = cmd.ExecuteReader())
                        {
                            if (!r.Read()) continue;
                            decimal price = Convert.ToDecimal(r["Price"]);
                            lines.Add(new CartLineVm
                            {
                                ProductId = kv.Key,
                                ProductName = Convert.ToString(r["ProductName"]),
                                UnitPrice = price,
                                Quantity = kv.Value
                            });
                        }
                    }
                }

                decimal subtotal = RollinCart.GetSubtotal(conn, cart);
                litOrderSubtotal.Text = "<strong>Subtotal:</strong> " + subtotal.ToString("c");

                rptOrder.DataSource = lines;
                rptOrder.DataBind();
            }
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            litCheckoutError.Visible = false;
            var cart = RollinCart.GetCart(Session);
            if (cart.Count == 0)
            {
                BindPage();
                return;
            }

            string name = (txtName.Text ?? string.Empty).Trim();
            string email = (txtEmail.Text ?? string.Empty).Trim();
            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(email))
            {
                ShowError("Please enter your name and email.");
                return;
            }

            int locationId;
            if (!int.TryParse(ddlPickupLocation.SelectedValue, out locationId))
            {
                ShowError("Please select a pickup location.");
                return;
            }

            string cs = ConfigurationManager.ConnectionStrings["RollinCoConnectionString"].ConnectionString;

            try
            {
                using (var conn = new SqlConnection(cs))
                {
                    conn.Open();
                    decimal total = RollinCart.GetSubtotal(conn, cart);

                    int customerId = CustomerHelper.EnsureCustomer(conn, name, email, string.Empty);
                    Session[SiteMaster.SessionCustomerIdKey] = customerId;

                    using (var tran = conn.BeginTransaction())
                    {
                        try
                        {
                            int orderId;
                            using (var insertOrder = new SqlCommand(@"
INSERT INTO ORDERS (CustomerID, LocationID, OrderDate, TotalAmount)
VALUES (@CustomerID, @LocationID, GETDATE(), @TotalAmount);
SELECT CAST(SCOPE_IDENTITY() AS INT);", conn, tran))
                            {
                                insertOrder.Parameters.AddWithValue("@CustomerID", customerId);
                                insertOrder.Parameters.AddWithValue("@LocationID", locationId);
                                insertOrder.Parameters.AddWithValue("@TotalAmount", total);
                                orderId = Convert.ToInt32(insertOrder.ExecuteScalar());
                            }

                            foreach (var kv in cart.ToList())
                            {
                                decimal unitPrice;
                                using (var priceCmd = new SqlCommand(
                                    "SELECT Price FROM PRODUCTS WHERE ProductID = @ProductID", conn, tran))
                                {
                                    priceCmd.Parameters.AddWithValue("@ProductID", kv.Key);
                                    unitPrice = Convert.ToDecimal(priceCmd.ExecuteScalar());
                                }

                                using (var insertLine = new SqlCommand(@"
INSERT INTO ORDER_ITEMS (OrderID, ProductID, Quantity, PriceAtPurchase)
VALUES (@OrderID, @ProductID, @Quantity, @PriceAtPurchase)", conn, tran))
                                {
                                    insertLine.Parameters.AddWithValue("@OrderID", orderId);
                                    insertLine.Parameters.AddWithValue("@ProductID", kv.Key);
                                    insertLine.Parameters.AddWithValue("@Quantity", kv.Value);
                                    insertLine.Parameters.AddWithValue("@PriceAtPurchase", unitPrice);
                                    insertLine.ExecuteNonQuery();
                                }
                            }

                            tran.Commit();
                            RollinCart.Clear(Session);
                            Response.Redirect("~/OrderConfirmation.aspx?OrderID=" + orderId);
                        }
                        catch
                        {
                            tran.Rollback();
                            throw;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Could not place order. (" + Server.HtmlEncode(ex.Message) + ")");
                BindPage();
            }
        }

        void ShowError(string msg)
        {
            litCheckoutError.Visible = true;
            litCheckoutError.Text = "<p class=\"kr-inline-error\">" + Server.HtmlEncode(msg) + "</p>";
        }
    }
}
