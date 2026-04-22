using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;

namespace SueTheChef
{
    public partial class Schedule : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtApptDate.Attributes["type"] = "datetime-local";
                var dt = DateTime.Now.AddDays(3).Date.AddHours(10);
                txtApptDate.Text = dt.ToString("yyyy-MM-ddTHH:mm", CultureInfo.InvariantCulture);
            }
        }

        protected void btnConfirmAppt_Click(object sender, EventArgs e)
        {
            litScheduleError.Visible = false;
            string name = (txtName.Text ?? string.Empty).Trim();
            string email = (txtEmail.Text ?? string.Empty).Trim();
            string phone = (txtPhone.Text ?? string.Empty).Trim();
            string vehicle = (txtVehicle.Text ?? string.Empty).Trim();
            string service = rblService.SelectedValue;

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(email))
            {
                ShowError("Please enter your name and email.");
                return;
            }

            int locationId;
            if (!int.TryParse(ddlLocation.SelectedValue, out locationId))
            {
                ShowError("Please select a location.");
                return;
            }

            DateTime apptWhen;
            if (!DateTime.TryParse(txtApptDate.Text, CultureInfo.CurrentCulture, DateTimeStyles.AssumeLocal, out apptWhen)
                && !DateTime.TryParse(txtApptDate.Text, CultureInfo.InvariantCulture, DateTimeStyles.AssumeLocal, out apptWhen))
            {
                ShowError("Please choose a valid appointment date and time.");
                return;
            }

            string cs = ConfigurationManager.ConnectionStrings["RollinCoConnectionString"].ConnectionString;
            try
            {
                using (var conn = new SqlConnection(cs))
                {
                    conn.Open();
                    int customerId = CustomerHelper.EnsureCustomer(conn, name, email, phone);
                    Session[SiteMaster.SessionCustomerIdKey] = customerId;

                    using (var up = new SqlCommand(
                        @"UPDATE CUSTOMERS SET VehicleInfo = @VehicleInfo,
Phone = CASE WHEN @Phone IS NULL OR LTRIM(RTRIM(@Phone)) = N'' THEN Phone ELSE @Phone END
WHERE CustomerID = @CustomerID",
                        conn))
                    {
                        up.Parameters.AddWithValue("@VehicleInfo", string.IsNullOrWhiteSpace(vehicle) ? (object)DBNull.Value : vehicle.Trim());
                        up.Parameters.AddWithValue("@Phone", string.IsNullOrWhiteSpace(phone) ? (object)DBNull.Value : phone.Trim());
                        up.Parameters.AddWithValue("@CustomerID", customerId);
                        up.ExecuteNonQuery();
                    }

                    using (var cmd = new SqlCommand(@"
INSERT INTO APPOINTMENTS (CustomerID, LocationID, ServiceType, AppointmentDate, Status)
VALUES (@CustomerID, @LocationID, @ServiceType, @When, N'Scheduled');
SELECT CAST(SCOPE_IDENTITY() AS INT);", conn))
                    {
                        cmd.Parameters.AddWithValue("@CustomerID", customerId);
                        cmd.Parameters.AddWithValue("@LocationID", locationId);
                        cmd.Parameters.AddWithValue("@ServiceType", (object)service ?? DBNull.Value);
                        cmd.Parameters.AddWithValue("@When", apptWhen);

                        object o = cmd.ExecuteScalar();
                        int newId = Convert.ToInt32(o);
                        Response.Redirect("~/AppointmentConfirmation.aspx?ID=" + newId);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Could not save your appointment. (" + Server.HtmlEncode(ex.Message) + ")");
            }
        }

        void ShowError(string message)
        {
            litScheduleError.Visible = true;
            litScheduleError.Text = "<p class=\"kr-inline-error\">" + Server.HtmlEncode(message) + "</p>";
        }
    }
}
