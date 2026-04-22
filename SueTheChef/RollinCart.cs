using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;

namespace SueTheChef
{
    /// <summary>Session-backed cart: ProductID → quantity.</summary>
    public static class RollinCart
    {
        public const string SessionKey = "RollinCart";

        public static Dictionary<int, int> GetCart(HttpSessionState session)
        {
            var cart = session[SessionKey] as Dictionary<int, int>;
            if (cart == null)
            {
                cart = new Dictionary<int, int>();
                session[SessionKey] = cart;
            }
            return cart;
        }

        public static void Add(HttpSessionState session, int productId, int quantity = 1)
        {
            var cart = GetCart(session);
            int q = quantity < 1 ? 1 : quantity;
            int existing;
            cart[productId] = cart.TryGetValue(productId, out existing) ? existing + q : q;
        }

        public static void SetQuantity(HttpSessionState session, int productId, int quantity)
        {
            var cart = GetCart(session);
            if (quantity <= 0)
                cart.Remove(productId);
            else
                cart[productId] = quantity;
        }

        public static void Clear(HttpSessionState session)
        {
            session[SessionKey] = new Dictionary<int, int>();
        }

        public static decimal GetSubtotal(SqlConnection conn, Dictionary<int, int> cart)
        {
            decimal total = 0;
            foreach (var kv in cart)
            {
                using (var cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT Price FROM PRODUCTS WHERE ProductID = @ProductID";
                    cmd.Parameters.AddWithValue("@ProductID", kv.Key);
                    object o = cmd.ExecuteScalar();
                    if (o != null && o != DBNull.Value)
                        total += Convert.ToDecimal(o) * kv.Value;
                }
            }
            return total;
        }
    }
}
