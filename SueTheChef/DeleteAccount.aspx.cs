using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace SueTheChef
{
    public partial class DeleteAccount : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var master = Master as SiteMaster;
            if (master == null || !master.CustomerId.HasValue)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            LoadEmail(master.CustomerId.Value);
        }

        void LoadEmail(int customerId)
        {
            string cs = ConfigurationManager.ConnectionStrings["RollinCoConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(cs))
            using (var cmd = new SqlCommand("SELECT Email FROM CUSTOMERS WHERE CustomerID = @Id", conn))
            {
                cmd.Parameters.AddWithValue("@Id", customerId);
                conn.Open();
                object o = cmd.ExecuteScalar();
                string accountEmail = o == null || o == DBNull.Value ? "" : Convert.ToString(o).Trim();
                litEmail.Text = Server.HtmlEncode(accountEmail);
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            litDeleteError.Visible = false;

            var master = Master as SiteMaster;
            if (master == null || !master.CustomerId.HasValue)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!chkUnderstand.Checked)
            {
                ShowError("Please check the box to confirm you understand.");
                return;
            }

            int customerId = master.CustomerId.Value;
            string confirmEmail = (txtEmailConfirm.Text ?? string.Empty).Trim();
            string pwd = txtPassword.Text ?? string.Empty;

            string cs = ConfigurationManager.ConnectionStrings["RollinCoConnectionString"].ConnectionString;
            try
            {
                string email;
                string storedPassword;
                using (var conn = new SqlConnection(cs))
                using (var cmd = new SqlCommand(
                    "SELECT Email, [Password] FROM CUSTOMERS WHERE CustomerID = @Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", customerId);
                    conn.Open();
                    using (var r = cmd.ExecuteReader())
                    {
                        if (!r.Read())
                        {
                            Response.Redirect("~/Login.aspx");
                            return;
                        }
                        email = Convert.ToString(r["Email"]).Trim();
                        object ph = r["Password"];
                        storedPassword = ph == null || ph == DBNull.Value ? null : Convert.ToString(ph);
                    }
                }

                if (!string.Equals(confirmEmail, email, StringComparison.OrdinalIgnoreCase))
                {
                    ShowError("Type your account email exactly in the confirmation field.");
                    return;
                }

                bool hasPassword = !string.IsNullOrEmpty(storedPassword);
                if (hasPassword && pwd != storedPassword)
                {
                    ShowError("Password is incorrect.");
                    return;
                }

                using (var conn = new SqlConnection(cs))
                {
                    conn.Open();
                    using (var tran = conn.BeginTransaction())
                    {
                        try
                        {
                            using (var delOi = new SqlCommand(@"
DELETE FROM ORDER_ITEMS WHERE OrderID IN (SELECT OrderID FROM ORDERS WHERE CustomerID = @CustomerID)",
                                conn, tran))
                            {
                                delOi.Parameters.AddWithValue("@CustomerID", customerId);
                                delOi.ExecuteNonQuery();
                            }

                            using (var delO = new SqlCommand("DELETE FROM ORDERS WHERE CustomerID = @CustomerID", conn, tran))
                            {
                                delO.Parameters.AddWithValue("@CustomerID", customerId);
                                delO.ExecuteNonQuery();
                            }

                            using (var delA = new SqlCommand("DELETE FROM APPOINTMENTS WHERE CustomerID = @CustomerID", conn, tran))
                            {
                                delA.Parameters.AddWithValue("@CustomerID", customerId);
                                delA.ExecuteNonQuery();
                            }

                            using (var delC = new SqlCommand("DELETE FROM CUSTOMERS WHERE CustomerID = @CustomerID", conn, tran))
                            {
                                delC.Parameters.AddWithValue("@CustomerID", customerId);
                                delC.ExecuteNonQuery();
                            }

                            tran.Commit();
                        }
                        catch
                        {
                            tran.Rollback();
                            throw;
                        }
                    }
                }

                Session.Remove(SiteMaster.SessionCustomerIdKey);
                Session.Remove(SiteMaster.SessionDisplayNameKey);
                Response.Redirect("~/Default.aspx");
            }
            catch (SqlException ex)
            {
                if (ex.Message.IndexOf("Invalid column name", StringComparison.OrdinalIgnoreCase) >= 0
                    && ex.Message.IndexOf("Password", StringComparison.OrdinalIgnoreCase) >= 0)
                    ShowError("Check CUSTOMERS.[Password] exists (App_Data/AuthProfileSchema.sql).");
                else if (ex.Message.IndexOf("Invalid column name", StringComparison.OrdinalIgnoreCase) >= 0)
                    ShowError(ex.Message);
                else
                    ShowError("Could not delete account: " + ex.Message);
            }
        }

        void ShowError(string message)
        {
            litDeleteError.Text = Server.HtmlEncode(message);
            litDeleteError.Visible = true;
        }
    }
}
