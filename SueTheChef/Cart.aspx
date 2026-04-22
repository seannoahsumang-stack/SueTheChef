<%@ Page Title="Cart" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="SueTheChef.Cart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Keep Rollin Co — Cart
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="kr-page-title-center">Your cart</h1>

    <asp:Literal ID="litCartMessage" runat="server" Visible="false" />

    <asp:Panel ID="pnlEmpty" runat="server" CssClass="kr-empty" Visible="false">
        Your cart is empty. <asp:HyperLink ID="lnkShop" runat="server" NavigateUrl="~/Shop.aspx" CssClass="kr-link-muted">Shop products</asp:HyperLink>
    </asp:Panel>

    <asp:Repeater ID="rptCart" runat="server" OnItemCommand="rptCart_ItemCommand">
        <ItemTemplate>
            <article class="kr-cart-row">
                <div class="kr-cart-img" aria-hidden="true"><span class="kr-cart-img-label">Img</span></div>
                <div class="kr-cart-main">
                    <h2 class="kr-cart-title"><%# Eval("ProductName") %></h2>
                    <p class="kr-cart-unit"><%# Eval("UnitPrice", "{0:c}") %> each</p>
                </div>
                <div class="kr-cart-qty" role="group" aria-label="Quantity">
                    <asp:LinkButton ID="btnMinus" runat="server" CssClass="kr-qty-btn" CommandName="Minus" CommandArgument='<%# Eval("ProductId") %>' CausesValidation="false">−</asp:LinkButton>
                    <span class="kr-qty-val"><%# Eval("Quantity") %></span>
                    <asp:LinkButton ID="btnPlus" runat="server" CssClass="kr-qty-btn" CommandName="Plus" CommandArgument='<%# Eval("ProductId") %>' CausesValidation="false">+</asp:LinkButton>
                </div>
                <div class="kr-cart-lineprice"><%# Eval("LineTotal", "{0:c}") %></div>
            </article>
        </ItemTemplate>
    </asp:Repeater>

    <div class="kr-cart-actions" runat="server" id="divCartFooter">
        <div class="kr-cart-subtotal"><asp:Literal ID="litSubtotal" runat="server" /></div>
        <asp:HyperLink ID="lnkCheckout" runat="server" NavigateUrl="~/Checkout.aspx" CssClass="kr-btn kr-btn-primary">Checkout</asp:HyperLink>
    </div>
</asp:Content>
