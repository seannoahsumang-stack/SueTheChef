using System;
using System.Web.UI;

namespace SueTheChef
{
    public partial class Logout : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session.Remove(SiteMaster.SessionCustomerIdKey);
            Session.Remove(SiteMaster.SessionDisplayNameKey);
            Response.Redirect("~/Default.aspx");
        }
    }
}
