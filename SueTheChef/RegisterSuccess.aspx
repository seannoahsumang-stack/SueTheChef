<%@ Page Title="Account created" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RegisterSuccess.aspx.cs" Inherits="SueTheChef.RegisterSuccess" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Keep Rollin Co — Account created
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="kr-panel kr-success-panel">
        <h1 class="kr-page-title-center">Account created</h1>
        <p class="kr-success-lead">Thanks for joining. We saved your profile for <strong><asp:Literal ID="litEmail" runat="server" /></strong>.</p>
        <p class="kr-success-actions">
            <asp:HyperLink ID="lnkLogin" runat="server" NavigateUrl="~/Login.aspx" CssClass="kr-btn kr-btn-primary">Sign in</asp:HyperLink>
            <asp:HyperLink ID="lnkHome" runat="server" NavigateUrl="~/Default.aspx" CssClass="kr-btn kr-btn-secondary">Home</asp:HyperLink>
        </p>
    </div>
</asp:Content>
