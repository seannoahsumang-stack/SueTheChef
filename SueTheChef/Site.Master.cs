using System;
using System.Web.UI;

namespace SueTheChef
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        public const string SessionCustomerIdKey = "CustomerID";

        /// <summary>Display name shown in the header after sign-in.</summary>
        public const string SessionDisplayNameKey = "CustomerDisplayName";

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
            string login = ResolveUrl("~/Login.aspx");
            string reg = ResolveUrl("~/Register.aspx");
            string profile = ResolveUrl("~/Profile.aspx");
            string logout = ResolveUrl("~/Logout.aspx");

            int? cid = CustomerId;
            if (cid.HasValue)
            {
                object d = Session[SessionDisplayNameKey];
                string label = d != null ? Server.HtmlEncode(Convert.ToString(d)) : Server.HtmlEncode("Customer #" + cid.Value);
                litSessionCustomer.Text =
                    "<span class=\"kr-session\"><span class=\"kr-session-name\">" + label + "</span>" +
                    " <span class=\"kr-session-sep\">—</span> " +
                    "<a href=\"" + profile + "\" class=\"kr-link-muted\">My account</a>" +
                    " <span class=\"kr-session-sep\">·</span> " +
                    "<a href=\"" + logout + "\" class=\"kr-link-muted\">Sign out</a></span>";
            }
            else
            {
                litSessionCustomer.Text =
                    "<span class=\"kr-session\">" +
                    "<a href=\"" + login + "\" class=\"kr-link-muted\">Sign in</a>" +
                    " <span class=\"kr-session-sep\">·</span> " +
                    "<a href=\"" + reg + "\" class=\"kr-link-muted\">Register</a>" +
                    "<span class=\"kr-session-note\"> — Guest</span></span>";
            }
        }
    }
}
