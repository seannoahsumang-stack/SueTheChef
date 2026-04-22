using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SueTheChef
{
    public partial class Shop : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlBrowseAll.Visible = true;
                pnlFilteredResults.Visible = false;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (!pnlFilteredResults.Visible)
            {
                pnlEmpty.Visible = false;
                rptProducts.Visible = false;
                return;
            }

            pnlEmpty.Visible = rptProducts.Items.Count == 0;
            rptProducts.Visible = rptProducts.Items.Count > 0;
        }

        protected void btnApplyFilters_Click(object sender, EventArgs e)
        {
            pnlBrowseAll.Visible = false;
            pnlFilteredResults.Visible = true;
            rptProducts.DataBind();
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
