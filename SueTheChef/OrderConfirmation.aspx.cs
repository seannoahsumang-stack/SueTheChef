using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace SueTheChef
{
    public partial class OrderConfirmation : Page
    {
        sealed class OrderLineVm
        {
            public string ProductName { get; set; }
            public int Quantity { get; set; }
            public decimal LineAmount { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            int orderId;
            if (!int.TryParse(Request.QueryString["OrderID"], out orderId) || orderId <= 0)
            {
                pnlOk.Visible = false;
                pnlMissing.Visible = true;
                return;
            }

            string cs = ConfigurationManager.ConnectionStrings["RollinCoConnectionString"].ConnectionString;
            try
            {
                using (var conn = new SqlConnection(cs))
                {
                    conn.Open();

                    decimal total = 0;
                    string branch = "";
                    string addr = "";

                    using (var cmd = new SqlCommand(@"
SELECT o.TotalAmount, o.OrderDate, l.LocationName, l.Address
FROM ORDERS o
INNER JOIN LOCATIONS l ON l.LocationID = o.LocationID
WHERE o.OrderID = @OrderID", conn))
                    {
                        cmd.Parameters.AddWithValue("@OrderID", orderId);
                        using (var r = cmd.ExecuteReader())
                        {
                            if (!r.Read())
                            {
                                pnlOk.Visible = false;
                                pnlMissing.Visible = true;
                                return;
                            }
                            total = r["TotalAmount"] == DBNull.Value ? 0 : Convert.ToDecimal(r["TotalAmount"]);
                            branch = Convert.ToString(r["LocationName"]);
                            addr = Convert.ToString(r["Address"]);
                        }
                    }

                    var lines = new List<OrderLineVm>();
                    using (var cmd = new SqlCommand(@"
SELECT p.ProductName, oi.Quantity, oi.PriceAtPurchase
FROM ORDER_ITEMS oi
INNER JOIN PRODUCTS p ON p.ProductID = oi.ProductID
WHERE oi.OrderID = @OrderID
ORDER BY p.ProductName", conn))
                    {
                        cmd.Parameters.AddWithValue("@OrderID", orderId);
                        using (var r = cmd.ExecuteReader())
                        {
                            while (r.Read())
                            {
                                int qty = Convert.ToInt32(r["Quantity"]);
                                decimal unit = Convert.ToDecimal(r["PriceAtPurchase"]);
                                lines.Add(new OrderLineVm
                                {
                                    ProductName = Convert.ToString(r["ProductName"]),
                                    Quantity = qty,
                                    LineAmount = unit * qty
                                });
                            }
                        }
                    }

                    rptLines.DataSource = lines;
                    rptLines.DataBind();

                    litPickup.Text = Server.HtmlEncode(branch) + " — " + Server.HtmlEncode(addr);
                    litTotal.Text = "<strong>Total:</strong> " + total.ToString("c");

                    pnlOk.Visible = true;
                    pnlMissing.Visible = false;
                }
            }
            catch
            {
                pnlOk.Visible = false;
                pnlMissing.Visible = true;
            }
        }
    }
}
