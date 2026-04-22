<%@ Page Title="Checkout" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="SueTheChef.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Keep Rollin Co — Checkout
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="kr-page-title-center">Checkout</h1>

    <asp:Literal ID="litCheckoutError" runat="server" Visible="false" />

    <asp:Panel ID="pnlEmpty" runat="server" CssClass="kr-empty" Visible="false">
        Your cart is empty. <asp:HyperLink runat="server" NavigateUrl="~/Shop.aspx" CssClass="kr-link-muted">Shop products</asp:HyperLink>
    </asp:Panel>

    <asp:Panel ID="pnlCheckout" runat="server" CssClass="kr-checkout-layout">
        <div class="kr-checkout-columns">
            <section class="kr-panel kr-checkout-order" aria-labelledby="order-heading">
                <h2 id="order-heading" class="kr-panel-title">Your order</h2>
                <asp:Repeater ID="rptOrder" runat="server">
                    <ItemTemplate>
                        <article class="kr-checkout-line">
                            <div class="kr-checkout-line-img" aria-hidden="true"><span>Img</span></div>
                            <div class="kr-checkout-line-main">
                                <span class="kr-checkout-line-name"><%# Eval("ProductName") %></span>
                                <span class="kr-checkout-line-qty">Qty <%# Eval("Quantity") %></span>
                            </div>
                            <div class="kr-checkout-line-price"><%# Eval("LineTotal", "{0:c}") %></div>
                        </article>
                    </ItemTemplate>
                </asp:Repeater>
                <p class="kr-checkout-subtotal"><asp:Literal ID="litOrderSubtotal" runat="server" /></p>
            </section>

            <section class="kr-panel kr-checkout-contact" aria-labelledby="contact-heading">
                <h2 id="contact-heading" class="kr-panel-title">Contact info</h2>
                <div class="kr-form-field">
                    <asp:Label ID="lblName" runat="server" AssociatedControlID="txtName" CssClass="kr-input-label">Name</asp:Label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="kr-input" AutoPostBack="false" />
                </div>
                <div class="kr-form-field">
                    <asp:Label ID="lblEmail" runat="server" AssociatedControlID="txtEmail" CssClass="kr-input-label">Email</asp:Label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="kr-input" TextMode="Email" AutoPostBack="false" />
                </div>
            </section>
        </div>

        <section class="kr-location-card" aria-labelledby="pickup-heading">
            <h2 id="pickup-heading" class="kr-panel-title">Pickup location</h2>
            <asp:SqlDataSource ID="dsLocations" runat="server"
                ConnectionString="<%$ ConnectionStrings:RollinCoConnectionString %>"
                SelectCommand="SELECT LocationID, LocationName, Address, Phone FROM LOCATIONS ORDER BY LocationName">
            </asp:SqlDataSource>
            <asp:DropDownList ID="ddlPickupLocation" runat="server" DataSourceID="dsLocations"
                DataTextField="LocationName" DataValueField="LocationID" CssClass="kr-input kr-input-select" AutoPostBack="true"
                OnSelectedIndexChanged="ddlPickupLocation_SelectedIndexChanged">
            </asp:DropDownList>
            <asp:Literal ID="litLocationCard" runat="server" Mode="PassThrough" />
        </section>

        <div class="kr-checkout-place">
            <asp:Button ID="btnPlaceOrder" runat="server" Text="Place Order" CssClass="kr-btn kr-btn-primary" OnClick="btnPlaceOrder_Click" CausesValidation="false" />
        </div>
    </asp:Panel>
</asp:Content>
