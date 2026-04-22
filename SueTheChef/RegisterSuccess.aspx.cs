using System;
using System.Web.UI;

namespace SueTheChef
{
    public partial class RegisterSuccess : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string email = Request.QueryString["email"];
            if (string.IsNullOrWhiteSpace(email))
            {
                Response.Redirect("~/Register.aspx");
                return;
            }
            litEmail.Text = Server.HtmlEncode(email.Trim());
        }
    }
}
