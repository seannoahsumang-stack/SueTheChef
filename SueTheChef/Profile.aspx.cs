using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace SueTheChef
{
    public partial class Profile : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var master = Master as SiteMaster;
            if (master == null || !master.CustomerId.HasValue)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
                LoadCustomer(master.CustomerId.Value);
        }

        void LoadCustomer(int customerId)
        {
            string cs = ConfigurationManager.ConnectionStrings["RollinCoConnectionString"].ConnectionString;
            try
            {
                using (var conn = new SqlConnection(cs))
                using (var cmd = new SqlCommand(
                    @"SELECT FirstName, LastName, Email, Phone, VehicleInfo
                      FROM CUSTOMERS WHERE CustomerID = @Id", conn))
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

                        txtFirstName.Text = Convert.ToString(r["FirstName"]);
                        txtLastName.Text = Convert.ToString(r["LastName"]);
                        txtEmail.Text = Convert.ToString(r["Email"]);
                        txtPhone.Text = r["Phone"] == DBNull.Value ? "" : Convert.ToString(r["Phone"]);
                        txtVehicleInfo.Text = r["VehicleInfo"] == DBNull.Value ? "" : Convert.ToString(r["VehicleInfo"]);
                    }
                }
            }
            catch (SqlException ex)
            {
                ShowError(ex.Message);
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            litProfileError.Visible = litProfileMessage.Visible = false;
            if (!Page.IsValid) return;

            var master = Master as SiteMaster;
            if (master == null || !master.CustomerId.HasValue)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            int customerId = master.CustomerId.Value;
            string first = (txtFirstName.Text ?? string.Empty).Trim();
            string last = (txtLastName.Text ?? string.Empty).Trim();
            string email = (txtEmail.Text ?? string.Empty).Trim();
            string phone = (txtPhone.Text ?? string.Empty).Trim();
            string vehicle = (txtVehicleInfo.Text ?? string.Empty).Trim();

            string newPwd = txtNewPassword.Text ?? string.Empty;
            string newPwd2 = txtNewPasswordConfirm.Text ?? string.Empty;
            string currentPwd = txtCurrentPassword.Text ?? string.Empty;

            if (newPwd.Length > 0 || newPwd2.Length > 0)
            {
                if (newPwd != newPwd2)
                {
                    ShowError("New password and confirmation must match.");
                    return;
                }
            }

            string cs = ConfigurationManager.ConnectionStrings["RollinCoConnectionString"].ConnectionString;
            try
            {
                using (var conn = new SqlConnection(cs))
                {
                    conn.Open();

                    string storedPassword;
                    using (var sel = new SqlCommand("SELECT [Password] FROM CUSTOMERS WHERE CustomerID = @Id", conn))
                    {
                        sel.Parameters.AddWithValue("@Id", customerId);
                        object o = sel.ExecuteScalar();
                        storedPassword = o == null || o == DBNull.Value ? null : Convert.ToString(o);
                    }

                    bool hasPassword = !string.IsNullOrEmpty(storedPassword);
                    string newPasswordToStore = null;
                    if (newPwd.Length > 0)
                    {
                        if (hasPassword)
                        {
                            if (currentPwd != storedPassword)
                            {
                                ShowError("Current password is incorrect.");
                                return;
                            }
                            newPasswordToStore = newPwd;
                        }
                        else
                            newPasswordToStore = newPwd;
                    }

                    using (var exists = new SqlCommand(
                        "SELECT COUNT(1) FROM CUSTOMERS WHERE Email = @Email AND CustomerID <> @Id", conn))
                    {
                        exists.Parameters.AddWithValue("@Email", email);
                        exists.Parameters.AddWithValue("@Id", customerId);
                        if (Convert.ToInt32(exists.ExecuteScalar()) > 0)
                        {
                            ShowError("Another account already uses that email.");
                            return;
                        }
                    }

                    using (var up = new SqlCommand(@"
UPDATE CUSTOMERS SET
  FirstName = @FirstName,
  LastName = @LastName,
  Email = @Email,
  Phone = @Phone,
  VehicleInfo = @VehicleInfo,
  [Password] = CASE WHEN @NewPwd IS NULL THEN [Password] ELSE @NewPwd END
WHERE CustomerID = @Id", conn))
                    {
                        up.Parameters.AddWithValue("@FirstName", first);
                        up.Parameters.AddWithValue("@LastName", last);
                        up.Parameters.AddWithValue("@Email", email);
                        up.Parameters.AddWithValue("@Phone", string.IsNullOrEmpty(phone) ? (object)DBNull.Value : phone);
                        up.Parameters.AddWithValue("@VehicleInfo", string.IsNullOrEmpty(vehicle) ? (object)DBNull.Value : vehicle);
                        up.Parameters.AddWithValue("@NewPwd", newPasswordToStore == null ? (object)DBNull.Value : newPasswordToStore);
                        up.Parameters.AddWithValue("@Id", customerId);
                        up.ExecuteNonQuery();
                    }
                }

                string display = (first + " " + last).Trim();
                if (string.IsNullOrEmpty(display)) display = email;
                Session[SiteMaster.SessionDisplayNameKey] = display;

                litProfileMessage.Text = Server.HtmlEncode("Your profile was updated.");
                litProfileMessage.Visible = true;
                txtCurrentPassword.Text = txtNewPassword.Text = txtNewPasswordConfirm.Text = string.Empty;
            }
            catch (SqlException ex)
            {
                if (ex.Message.IndexOf("Invalid column name", StringComparison.OrdinalIgnoreCase) >= 0
                    && ex.Message.IndexOf("Password", StringComparison.OrdinalIgnoreCase) >= 0)
                    ShowError("Check that CUSTOMERS has a [Password] column (see App_Data/AuthProfileSchema.sql).");
                else
                    ShowError(ex.Message);
            }
        }

        void ShowError(string message)
        {
            litProfileError.Text = Server.HtmlEncode(message);
            litProfileError.Visible = true;
        }
    }
}
