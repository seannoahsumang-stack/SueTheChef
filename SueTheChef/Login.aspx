<%@ Page Title="Sign in" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="SueTheChef.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Keep Rollin Co — Sign in
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="kr-page-title-center">Sign in</h1>
    <p class="kr-auth-lead">Sign in with the email and password you used at registration.</p>

    <asp:Label ID="litLoginError" runat="server" Visible="false" CssClass="kr-block-error" />

    <div class="kr-panel kr-auth-panel">
        <div class="kr-form-field">
            <asp:Label ID="lblEmail" runat="server" AssociatedControlID="txtEmail" CssClass="kr-input-label">Email</asp:Label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="kr-input" TextMode="Email" />
            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required." Display="Dynamic" CssClass="kr-field-error" />
        </div>
        <div class="kr-form-field">
            <asp:Label ID="lblPwd" runat="server" AssociatedControlID="txtPassword" CssClass="kr-input-label">Password</asp:Label>
            <asp:TextBox ID="txtPassword" runat="server" CssClass="kr-input" TextMode="Password" />
            <asp:RequiredFieldValidator ID="rfvPwd" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required." Display="Dynamic" CssClass="kr-field-error" />
        </div>
        <div class="kr-panel-actions">
            <asp:Button ID="btnLogin" runat="server" Text="Sign in" CssClass="kr-btn kr-btn-primary" OnClick="btnLogin_Click" />
        </div>
        <p class="kr-auth-foot">Need an account? <asp:HyperLink ID="lnkRegister" runat="server" NavigateUrl="~/Register.aspx" CssClass="kr-link-muted">Create one</asp:HyperLink></p>
    </div>
</asp:Content>
