using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace SueTheChef
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            litLoginError.Visible = false;
            if (!Page.IsValid) return;

            string email = (txtEmail.Text ?? string.Empty).Trim();
            string pwd = txtPassword.Text ?? string.Empty;

            string cs = ConfigurationManager.ConnectionStrings["RollinCoConnectionString"].ConnectionString;
            try
            {
                using (var conn = new SqlConnection(cs))
                using (var cmd = new SqlCommand(
                    @"SELECT CustomerID, FirstName, LastName FROM CUSTOMERS
                      WHERE Email = @Email AND [Password] = @Pwd AND [Password] IS NOT NULL", conn))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Pwd", pwd);
                    conn.Open();
                    using (var r = cmd.ExecuteReader())
                    {
                        if (!r.Read())
                        {
                            ShowError("Invalid email or password.");
                            return;
                        }

                        int id = Convert.ToInt32(r["CustomerID"]);
                        string fn = Convert.ToString(r["FirstName"]).Trim();
                        string ln = Convert.ToString(r["LastName"]).Trim();
                        string display = (fn + " " + ln).Trim();
                        if (string.IsNullOrEmpty(display)) display = email;

                        Session[SiteMaster.SessionCustomerIdKey] = id;
                        Session[SiteMaster.SessionDisplayNameKey] = display;
                    }
                }

                Response.Redirect("~/LoginSuccess.aspx");
            }
            catch (SqlException ex)
            {
                if (ex.Message.IndexOf("Invalid column name", StringComparison.OrdinalIgnoreCase) >= 0
                    && ex.Message.IndexOf("Password", StringComparison.OrdinalIgnoreCase) >= 0)
                    ShowError("Add a [Password] column (see App_Data/AuthProfileSchema.sql) or match your table name.");
                else if (ex.Message.IndexOf("Invalid column name", StringComparison.OrdinalIgnoreCase) >= 0)
                    ShowError(ex.Message);
                else
                    ShowError(ex.Message);
            }
        }

        void ShowError(string message)
        {
            litLoginError.Text = Server.HtmlEncode(message);
            litLoginError.Visible = true;
        }
    }
}
