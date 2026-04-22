using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SueTheChef
{
    public partial class Shop : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnApplyFilters_Click(object sender, EventArgs e)
        {
            rptProducts.DataBind();
        }

        protected void rptProducts_DataBinding(object sender, EventArgs e)
        {
            pnlEmpty.Visible = false;
        }

        protected void rptProducts_DataBound(object sender, EventArgs e)
        {
            pnlEmpty.Visible = rptProducts.Items.Count == 0;
        }
    }
}
