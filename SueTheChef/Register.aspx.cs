using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace SueTheChef
{
    public partial class Register : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            litRegisterError.Visible = false;
            if (!Page.IsValid) return;

            string first = (txtFirstName.Text ?? string.Empty).Trim();
            string last = (txtLastName.Text ?? string.Empty).Trim();
            string email = (txtEmail.Text ?? string.Empty).Trim();
            string pwd = txtPassword.Text ?? string.Empty;
            string phone = (txtPhone.Text ?? string.Empty).Trim();
            string vehicle = (txtVehicleInfo.Text ?? string.Empty).Trim();

            string cs = ConfigurationManager.ConnectionStrings["RollinCoConnectionString"].ConnectionString;
            try
            {
                using (var conn = new SqlConnection(cs))
                {
                    conn.Open();
                    using (var exists = new SqlCommand("SELECT COUNT(1) FROM CUSTOMERS WHERE Email = @Email", conn))
                    {
                        exists.Parameters.AddWithValue("@Email", email);
                        if (Convert.ToInt32(exists.ExecuteScalar()) > 0)
                        {
                            ShowError("That email is already registered. Sign in or use another email.");
                            return;
                        }
                    }

                    using (var ins = new SqlCommand(@"
INSERT INTO CUSTOMERS (FirstName, LastName, Email, Phone, VehicleInfo, [Password])
VALUES (@FirstName, @LastName, @Email, @Phone, @VehicleInfo, @Pwd);", conn))
                    {
                        ins.Parameters.AddWithValue("@FirstName", first);
                        ins.Parameters.AddWithValue("@LastName", last);
                        ins.Parameters.AddWithValue("@Email", email);
                        ins.Parameters.AddWithValue("@Phone", string.IsNullOrEmpty(phone) ? (object)DBNull.Value : phone);
                        ins.Parameters.AddWithValue("@VehicleInfo", string.IsNullOrEmpty(vehicle) ? (object)DBNull.Value : vehicle);
                        ins.Parameters.AddWithValue("@Pwd", pwd);
                        ins.ExecuteNonQuery();
                    }
                }

                Response.Redirect("~/RegisterSuccess.aspx?email=" + Server.UrlEncode(email));
            }
            catch (SqlException ex)
            {
                if (ex.Message.IndexOf("Password", StringComparison.OrdinalIgnoreCase) >= 0
                    && ex.Message.IndexOf("Invalid column name", StringComparison.OrdinalIgnoreCase) >= 0)
                    ShowError("Add a Password column (see App_Data/AuthProfileSchema.sql) or fix the column name.");
                else if (ex.Message.IndexOf("Invalid column name", StringComparison.OrdinalIgnoreCase) >= 0)
                    ShowError(ex.Message);
                else
                    ShowError(ex.Message);
            }
        }

        void ShowError(string message)
        {
            litRegisterError.Text = Server.HtmlEncode(message);
            litRegisterError.Visible = true;
        }
    }
}
