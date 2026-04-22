using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SueTheChef
{
    public partial class Details : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void fvProduct_ItemCommand(object sender, FormViewCommandEventArgs e)
        {
            if (e.CommandName != "AddToCart") return;
            int productId;
            if (!int.TryParse(Convert.ToString(e.CommandArgument), out productId) || productId <= 0) return;
            RollinCart.Add(Session, productId, 1);
            Response.Redirect("~/Cart.aspx");
        }
    }
}
