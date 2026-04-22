using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SueTheChef
{
    public partial class Cart : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                BindCart();
        }

        protected void rptCart_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int productId;
            if (!int.TryParse(Convert.ToString(e.CommandArgument), out productId))
                return;

            var cart = RollinCart.GetCart(Session);
            int qty = cart.ContainsKey(productId) ? cart[productId] : 0;

            if (e.CommandName == "Minus")
                RollinCart.SetQuantity(Session, productId, qty - 1);
            else if (e.CommandName == "Plus")
                RollinCart.SetQuantity(Session, productId, qty + 1);

            BindCart();
        }

        void BindCart()
        {
            litCartMessage.Visible = false;
            var cart = RollinCart.GetCart(Session);
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
                            lines.Add(new CartLineVm
                            {
                                ProductId = kv.Key,
                                ProductName = Convert.ToString(r["ProductName"]),
                                UnitPrice = Convert.ToDecimal(r["Price"]),
                                Quantity = kv.Value
                            });
                        }
                    }
                }

                decimal subtotal = RollinCart.GetSubtotal(conn, cart);
                litSubtotal.Text = "<strong>Subtotal:</strong> " + subtotal.ToString("c");
            }

            rptCart.DataSource = lines;
            rptCart.DataBind();

            bool empty = lines.Count == 0;
            pnlEmpty.Visible = empty;
            divCartFooter.Visible = !empty;
            rptCart.Visible = !empty;
        }
    }
}
