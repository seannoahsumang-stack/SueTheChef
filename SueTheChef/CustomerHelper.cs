using System;
using System.Data.SqlClient;

namespace SueTheChef
{
    /// <summary>Upserts CUSTOMERS rows using FirstName/LastName schema.</summary>
    public static class CustomerHelper
    {
        public static void SplitFullName(string fullName, out string firstName, out string lastName)
        {
            fullName = (fullName ?? string.Empty).Trim();
            int i = fullName.IndexOf(' ');
            if (i <= 0)
            {
                firstName = fullName.Length > 0 ? fullName : "Guest";
                lastName = "";
                return;
            }
            firstName = fullName.Substring(0, i).Trim();
            lastName = fullName.Substring(i + 1).Trim();
            if (lastName.Length == 0)
                lastName = firstName;
        }

        /// <returns>CUSTOMERS.CustomerID</returns>
        public static int EnsureCustomer(SqlConnection conn, string fullName, string email, string phone)
        {
            using (var sel = new SqlCommand("SELECT CustomerID FROM CUSTOMERS WHERE Email = @Email", conn))
            {
                sel.Parameters.AddWithValue("@Email", email.Trim());
                object o = sel.ExecuteScalar();
                if (o != null && o != DBNull.Value)
                    return Convert.ToInt32(o);
            }

            string first;
            string last;
            SplitFullName(fullName, out first, out last);

            using (var ins = new SqlCommand(
                "INSERT INTO CUSTOMERS (FirstName, LastName, Email, Phone) OUTPUT INSERTED.CustomerID VALUES (@FirstName, @LastName, @Email, @Phone)",
                conn))
            {
                ins.Parameters.AddWithValue("@FirstName", first);
                ins.Parameters.AddWithValue("@LastName", last);
                ins.Parameters.AddWithValue("@Email", email.Trim());
                ins.Parameters.AddWithValue("@Phone",
                    string.IsNullOrWhiteSpace(phone) ? (object)DBNull.Value : phone.Trim());
                return (int)ins.ExecuteScalar();
            }
        }
    }
}
