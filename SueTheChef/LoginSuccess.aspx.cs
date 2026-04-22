using System;
using System.Web.UI;

namespace SueTheChef
{
    public partial class LoginSuccess : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var master = Master as SiteMaster;
            if (master == null || !master.CustomerId.HasValue)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            object display = Session[SiteMaster.SessionDisplayNameKey];
            litName.Text = Server.HtmlEncode(display != null ? Convert.ToString(display) : ("Customer #" + master.CustomerId.Value));
        }
    }
}
