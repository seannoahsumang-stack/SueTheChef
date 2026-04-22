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
            RollinCart.Add(productId, 1);
            Response.Redirect("~/Cart.aspx");
        }

        public string GetProductImageUrl(object imageUrlObj, object typeObj)
        {
            string imageUrl = Convert.ToString(imageUrlObj);
            if (!string.IsNullOrWhiteSpace(imageUrl))
            {
                imageUrl = imageUrl.Trim();
                if (imageUrl.StartsWith("http://", StringComparison.OrdinalIgnoreCase)
                    || imageUrl.StartsWith("https://", StringComparison.OrdinalIgnoreCase))
                    return imageUrl;
                if (imageUrl.StartsWith("~/", StringComparison.Ordinal))
                    return ResolveUrl(imageUrl);
                if (imageUrl.StartsWith("/", StringComparison.Ordinal))
                    return imageUrl;
                return ResolveUrl("~/" + imageUrl.TrimStart('/'));
            }

            string type = Convert.ToString(typeObj);
            bool isWheel = type != null && type.IndexOf("wheel", StringComparison.OrdinalIgnoreCase) >= 0;
            return ResolveUrl(isWheel ? "~/Images/wheel-placeholder.svg" : "~/Images/tire-placeholder.svg");
        }
    }
}
