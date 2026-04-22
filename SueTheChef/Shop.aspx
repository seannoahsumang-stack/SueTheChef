<%@ Page Title="Shop" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Shop.aspx.cs" Inherits="SueTheChef.Shop" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Keep Rollin Co — Shop Products
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="kr-page-title-center">Shop Products</h1>

    <section class="kr-info-panel" aria-labelledby="info-heading">
        <h2 id="info-heading" class="kr-info-heading">Info panel</h2>
        <p class="kr-info-body">
            <strong>Tires vs wheels:</strong> tires are the rubber that meets the road — diameter, width, aspect ratio,
            speed and load ratings define fitment and handling. Wheels are the metal or alloy rims that mount the tire;
            bolt pattern, offset, and width determine whether your setup clears brakes and suspension.
            Use filters below to narrow types and spec tags (stored per product), then open details for full specs and pricing.
        </p>
    </section>

    <asp:SqlDataSource ID="dsProductTypes" runat="server"
        ConnectionString="<%$ ConnectionStrings:RollinCoConnectionString %>"
        SelectCommand="SELECT DISTINCT CAST(ProductType AS NVARCHAR(100)) AS Type FROM PRODUCTS WHERE ProductType IS NOT NULL AND LTRIM(RTRIM(CAST(ProductType AS NVARCHAR(100)))) &lt;&gt; '' ORDER BY CAST(ProductType AS NVARCHAR(100))">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="dsTireSizes" runat="server"
        ConnectionString="<%$ ConnectionStrings:RollinCoConnectionString %>"
        SelectCommand="SELECT DISTINCT CAST(Specs AS NVARCHAR(100)) AS Size FROM PRODUCTS WHERE CHARINDEX(N'tire', LOWER(CAST(ISNULL(ProductType, N'') AS NVARCHAR(100)))) &gt; 0 AND Specs IS NOT NULL AND LTRIM(RTRIM(CAST(Specs AS NVARCHAR(100)))) &lt;&gt; '' ORDER BY CAST(Specs AS NVARCHAR(100))">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="dsWheelSizes" runat="server"
        ConnectionString="<%$ ConnectionStrings:RollinCoConnectionString %>"
        SelectCommand="SELECT DISTINCT CAST(Specs AS NVARCHAR(100)) AS Size FROM PRODUCTS WHERE CHARINDEX(N'wheel', LOWER(CAST(ISNULL(ProductType, N'') AS NVARCHAR(100)))) &gt; 0 AND Specs IS NOT NULL AND LTRIM(RTRIM(CAST(Specs AS NVARCHAR(100)))) &lt;&gt; '' ORDER BY CAST(Specs AS NVARCHAR(100))">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="dsProducts" runat="server"
        ConnectionString="<%$ ConnectionStrings:RollinCoConnectionString %>"
        SelectCommand="SELECT ProductID AS ID, ProductName AS Name, Description, Price, CAST(ProductType AS NVARCHAR(100)) AS Type, CAST(Specs AS NVARCHAR(100)) AS Size, ImageURL AS ImageUrl FROM PRODUCTS WHERE (@ProductType = '' OR CAST(ProductType AS NVARCHAR(100)) = @ProductType) AND ((CHARINDEX(N'tire', LOWER(CAST(ISNULL(ProductType, N'') AS NVARCHAR(100)))) = 0) OR (@TireSize = '') OR (CAST(Specs AS NVARCHAR(100)) = @TireSize)) AND ((CHARINDEX(N'wheel', LOWER(CAST(ISNULL(ProductType, N'') AS NVARCHAR(100)))) = 0) OR (@WheelSize = '') OR (CAST(Specs AS NVARCHAR(100)) = @WheelSize)) ORDER BY ProductName">
        <SelectParameters>
            <asp:ControlParameter Name="ProductType" ControlID="ddlProductType" PropertyName="SelectedValue" Type="String" DefaultValue="" ConvertEmptyStringToNull="false" />
            <asp:ControlParameter Name="TireSize" ControlID="ddlTireSize" PropertyName="SelectedValue" Type="String" DefaultValue="" ConvertEmptyStringToNull="false" />
            <asp:ControlParameter Name="WheelSize" ControlID="ddlWheelSize" PropertyName="SelectedValue" Type="String" DefaultValue="" ConvertEmptyStringToNull="false" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="dsTiresAll" runat="server"
        ConnectionString="<%$ ConnectionStrings:RollinCoConnectionString %>"
        SelectCommand="SELECT ProductID AS ID, ProductName AS Name, Description, Price, CAST(ProductType AS NVARCHAR(100)) AS Type, CAST(Specs AS NVARCHAR(100)) AS Size, ImageURL AS ImageUrl FROM PRODUCTS WHERE CHARINDEX(N'tire', LOWER(CAST(ISNULL(ProductType, N'') AS NVARCHAR(100)))) &gt; 0 ORDER BY ProductName">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="dsWheelsAll" runat="server"
        ConnectionString="<%$ ConnectionStrings:RollinCoConnectionString %>"
        SelectCommand="SELECT ProductID AS ID, ProductName AS Name, Description, Price, CAST(ProductType AS NVARCHAR(100)) AS Type, CAST(Specs AS NVARCHAR(100)) AS Size, ImageURL AS ImageUrl FROM PRODUCTS WHERE CHARINDEX(N'wheel', LOWER(CAST(ISNULL(ProductType, N'') AS NVARCHAR(100)))) &gt; 0 ORDER BY ProductName">
    </asp:SqlDataSource>

    <div class="kr-filters">
        <p class="kr-filters-label">Filters:</p>
        <div class="kr-filters-row">
            <div class="kr-field">
                <span class="kr-field-label" id="lblType">Product type</span>
                <asp:DropDownList ID="ddlProductType" runat="server" DataSourceID="dsProductTypes"
                    DataTextField="Type" DataValueField="Type" AppendDataBoundItems="true" AutoPostBack="false"
                    aria-labelledby="lblType">
                    <asp:ListItem Text="All types" Value="" Selected="True"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="kr-field">
                <span class="kr-field-label" id="lblTire">Tire size</span>
                <asp:DropDownList ID="ddlTireSize" runat="server" DataSourceID="dsTireSizes"
                    DataTextField="Size" DataValueField="Size" AppendDataBoundItems="true" AutoPostBack="false"
                    aria-labelledby="lblTire">
                    <asp:ListItem Text="All tire sizes" Value="" Selected="True"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="kr-field">
                <span class="kr-field-label" id="lblWheel">Wheel size</span>
                <asp:DropDownList ID="ddlWheelSize" runat="server" DataSourceID="dsWheelSizes"
                    DataTextField="Size" DataValueField="Size" AppendDataBoundItems="true" AutoPostBack="false"
                    aria-labelledby="lblWheel">
                    <asp:ListItem Text="All wheel sizes" Value="" Selected="True"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="kr-field">
                <span class="kr-field-label">&nbsp;</span>
                <asp:Button ID="btnApplyFilters" runat="server" Text="Apply filters" CssClass="kr-btn-filter" OnClick="btnApplyFilters_Click" CausesValidation="false" />
            </div>
        </div>
    </div>

    <asp:Panel ID="pnlBrowseAll" runat="server">
        <h2 class="kr-subheading">Tires</h2>
        <div class="kr-product-list">
            <asp:Repeater ID="rptTires" runat="server" DataSourceID="dsTiresAll">
                <ItemTemplate>
                    <article class="kr-product-row">
                        <div class="kr-product-row-img">
                            <asp:Image ID="imgTire" runat="server" CssClass="kr-product-row-photo"
                                ImageUrl='<%# GetProductImageUrl(Eval("ImageUrl"), Eval("Type")) %>'
                                AlternateText='<%# Eval("Name") + " product image" %>' />
                        </div>
                        <div class="kr-product-row-main">
                            <div class="kr-product-row-meta"><%# Eval("Type") %> · <%# Eval("Size") %></div>
                            <h2 class="kr-product-row-title"><%# Eval("Name") %></h2>
                            <div class="kr-product-row-price"><%# Eval("Price", "{0:c}") %></div>
                        </div>
                        <div class="kr-product-row-actions">
                            <asp:HyperLink ID="lnkViewTire" runat="server" CssClass="kr-btn kr-btn-view" NavigateUrl='<%# ResolveUrl("~/Details.aspx?ID=" + Eval("ID")) %>'>View</asp:HyperLink>
                        </div>
                    </article>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <h2 class="kr-subheading kr-subheading-spaced">Wheels</h2>
        <div class="kr-product-list">
            <asp:Repeater ID="rptWheels" runat="server" DataSourceID="dsWheelsAll">
                <ItemTemplate>
                    <article class="kr-product-row">
                        <div class="kr-product-row-img">
                            <asp:Image ID="imgWheel" runat="server" CssClass="kr-product-row-photo"
                                ImageUrl='<%# GetProductImageUrl(Eval("ImageUrl"), Eval("Type")) %>'
                                AlternateText='<%# Eval("Name") + " product image" %>' />
                        </div>
                        <div class="kr-product-row-main">
                            <div class="kr-product-row-meta"><%# Eval("Type") %> · <%# Eval("Size") %></div>
                            <h2 class="kr-product-row-title"><%# Eval("Name") %></h2>
                            <div class="kr-product-row-price"><%# Eval("Price", "{0:c}") %></div>
                        </div>
                        <div class="kr-product-row-actions">
                            <asp:HyperLink ID="lnkViewWheel" runat="server" CssClass="kr-btn kr-btn-view" NavigateUrl='<%# ResolveUrl("~/Details.aspx?ID=" + Eval("ID")) %>'>View</asp:HyperLink>
                        </div>
                    </article>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlFilteredResults" runat="server" Visible="false">
        <asp:Panel ID="pnlEmpty" runat="server" CssClass="kr-empty" Visible="false">
            No products match these filters. Try widening your selections.
        </asp:Panel>

        <div class="kr-product-list">
            <asp:Repeater ID="rptProducts" runat="server" DataSourceID="dsProducts">
                <ItemTemplate>
                    <article class="kr-product-row">
                        <div class="kr-product-row-img">
                            <asp:Image ID="imgProduct" runat="server" CssClass="kr-product-row-photo"
                                ImageUrl='<%# GetProductImageUrl(Eval("ImageUrl"), Eval("Type")) %>'
                                AlternateText='<%# Eval("Name") + " product image" %>' />
                        </div>
                        <div class="kr-product-row-main">
                            <div class="kr-product-row-meta"><%# Eval("Type") %> · <%# Eval("Size") %></div>
                            <h2 class="kr-product-row-title"><%# Eval("Name") %></h2>
                            <div class="kr-product-row-price"><%# Eval("Price", "{0:c}") %></div>
                        </div>
                        <div class="kr-product-row-actions">
                            <asp:HyperLink ID="lnkView" runat="server" CssClass="kr-btn kr-btn-view" NavigateUrl='<%# ResolveUrl("~/Details.aspx?ID=" + Eval("ID")) %>'>View</asp:HyperLink>
                        </div>
                    </article>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </asp:Panel>
</asp:Content>
