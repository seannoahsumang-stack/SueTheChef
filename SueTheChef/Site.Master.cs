using System;
using System.Web.UI;

namespace SueTheChef
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        public const string SessionCustomerIdKey = "CustomerID";

        /// <summary>Current logged-in customer id from Session, or null.</summary>
        public int? CustomerId
        {
            get
            {
                object v = Session[SessionCustomerIdKey];
                if (v == null || v == DBNull.Value) return null;
                int id;
                return int.TryParse(Convert.ToString(v), out id) ? (int?)id : null;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            int? cid = CustomerId;
            if (cid.HasValue)
                litSessionCustomer.Text =
                    "<span class=\"kr-session\">Signed in <span class=\"kr-session-id\">#" + cid.Value + "</span></span>";
            else
                litSessionCustomer.Text =
                    "<span class=\"kr-session\"><a href=\"#\" class=\"kr-link-muted\">Sign in</a><span class=\"kr-session-note\"> — Guest</span></span>";
        }
    }
}
