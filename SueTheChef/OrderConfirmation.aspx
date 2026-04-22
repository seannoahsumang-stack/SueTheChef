<%@ Page Title="Order confirmed" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderConfirmation.aspx.cs" Inherits="SueTheChef.OrderConfirmation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Keep Rollin Co — Order confirmed
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="pnlOk" runat="server" CssClass="kr-confirm-wrap" Visible="false">
        <p class="kr-confirm-status">✔ Order confirmed</p>

        <section class="kr-summary-panel" aria-labelledby="items-heading">
            <h2 id="items-heading" class="kr-summary-heading">Order items</h2>
            <div class="kr-order-items-table" role="table" aria-label="Order line items">
                <div class="kr-order-items-header" role="row">
                    <span class="kr-oi-name" role="columnheader">Product</span>
                    <span class="kr-oi-qty" role="columnheader">Qty</span>
                    <span class="kr-oi-price" role="columnheader">Price</span>
                </div>
                <asp:Repeater ID="rptLines" runat="server">
                    <ItemTemplate>
                        <div class="kr-order-items-row" role="row">
                            <span class="kr-oi-name" role="cell"><%# Eval("ProductName") %></span>
                            <span class="kr-oi-qty" role="cell"><%# Eval("Quantity") %></span>
                            <span class="kr-oi-price" role="cell"><%# Eval("LineAmount", "{0:c}") %></span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </section>

        <section class="kr-summary-panel" aria-labelledby="pickup-heading">
            <h2 id="pickup-heading" class="kr-summary-heading">Pickup info</h2>
            <p class="kr-pickup-address"><asp:Literal ID="litPickup" runat="server" Mode="PassThrough" /></p>
        </section>

        <p class="kr-order-total"><asp:Literal ID="litTotal" runat="server" /></p>

        <div class="kr-confirm-actions">
            <asp:HyperLink ID="lnkContinue" runat="server" NavigateUrl="~/Shop.aspx" CssClass="kr-btn kr-btn-secondary">Continue shopping</asp:HyperLink>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlMissing" runat="server" CssClass="kr-empty" Visible="false">
        <p>We could not find that order.</p>
        <asp:HyperLink runat="server" NavigateUrl="~/Shop.aspx" CssClass="kr-link-muted">Continue shopping</asp:HyperLink>
    </asp:Panel>
</asp:Content>
