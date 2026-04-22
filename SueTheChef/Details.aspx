<%@ Page Title="Product details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Details.aspx.cs" Inherits="SueTheChef.Details" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Keep Rollin Co — Product
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:SqlDataSource ID="dsProduct" runat="server"
        ConnectionString="<%$ ConnectionStrings:RollinCoConnectionString %>"
        SelectCommand="SELECT ProductID AS ID, ProductName AS Name, Description, Price, ProductType AS Type, Specs AS Size, ImageURL AS ImageUrl FROM PRODUCTS WHERE ProductID = @ProductID">
        <SelectParameters>
            <asp:QueryStringParameter Name="ProductID" QueryStringField="ID" Type="Int32" DefaultValue="0" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:FormView ID="fvProduct" runat="server" DataSourceID="dsProduct" RenderOuterTable="false"
        DataKeyNames="ID" OnItemCommand="fvProduct_ItemCommand">
        <ItemTemplate>
            <div class="kr-detail-grid">
                <div class="kr-detail-media">
                    <asp:Image ID="imgDetail" runat="server" CssClass="kr-detail-img"
                        ImageUrl='<%# GetProductImageUrl(Eval("ImageUrl"), Eval("Type")) %>'
                        AlternateText='<%# Eval("Name") + " product image" %>' />
                </div>
                <div class="kr-detail-info">
                    <h1 class="kr-detail-title"><%# Eval("Name") %></h1>
                    <p class="kr-detail-desc"><%# Eval("Description") %></p>
                    <h2 class="kr-detail-specs-heading">Specs</h2>
                    <ul class="kr-spec-list">
                        <li><span class="kr-spec-key">Type</span> <%# Eval("Type") %></li>
                        <li><span class="kr-spec-key">Specs</span> <%# Eval("Size") %></li>
                    </ul>
                    <p class="kr-detail-price"><%# Eval("Price", "{0:c}") %></p>
                    <asp:LinkButton ID="btnAddToCart" runat="server" CommandName="AddToCart" CommandArgument='<%# Eval("ID") %>'
                        CssClass="kr-btn kr-btn-primary">Add to Cart</asp:LinkButton>
                </div>
            </div>
        </ItemTemplate>
        <EmptyDataTemplate>
            <p class="kr-empty">This product could not be found. <asp:HyperLink runat="server" NavigateUrl="~/Shop.aspx" CssClass="kr-link-muted">Return to Shop Products</asp:HyperLink></p>
        </EmptyDataTemplate>
    </asp:FormView>
</asp:Content>
