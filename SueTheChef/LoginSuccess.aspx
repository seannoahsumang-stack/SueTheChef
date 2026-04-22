<%@ Page Title="Welcome" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LoginSuccess.aspx.cs" Inherits="SueTheChef.LoginSuccess" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Keep Rollin Co — Signed in
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="kr-panel kr-success-panel">
        <h1 class="kr-page-title-center">You are signed in</h1>
        <p class="kr-success-lead">Welcome back, <strong><asp:Literal ID="litName" runat="server" /></strong>.</p>
        <p class="kr-success-actions">
            <asp:HyperLink ID="lnkProfile" runat="server" NavigateUrl="~/Profile.aspx" CssClass="kr-btn kr-btn-primary">My account</asp:HyperLink>
            <asp:HyperLink ID="lnkShop" runat="server" NavigateUrl="~/Shop.aspx" CssClass="kr-btn kr-btn-secondary">Shop</asp:HyperLink>
        </p>
    </div>
</asp:Content>
