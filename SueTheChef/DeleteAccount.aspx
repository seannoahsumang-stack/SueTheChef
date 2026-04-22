<%@ Page Title="Delete account" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DeleteAccount.aspx.cs" Inherits="SueTheChef.DeleteAccount" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Keep Rollin Co — Delete account
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="kr-page-title-center">Delete account</h1>

    <asp:Label ID="litDeleteError" runat="server" Visible="false" CssClass="kr-block-error" />

    <div class="kr-panel kr-danger-panel">
        <p class="kr-danger-text">You are about to delete the account for <strong><asp:Literal ID="litEmail" runat="server" /></strong>. All orders and appointments tied to this profile will be removed.</p>

        <div class="kr-form-field">
            <asp:Label ID="lblPwd" runat="server" AssociatedControlID="txtPassword" CssClass="kr-input-label">Password</asp:Label>
            <asp:TextBox ID="txtPassword" runat="server" CssClass="kr-input" TextMode="Password" />
            <p class="kr-auth-hint">If your account has a password, enter it here. Otherwise leave blank and type your email exactly as shown above.</p>
        </div>
        <div class="kr-form-field">
            <asp:Label ID="lblEmailConfirm" runat="server" AssociatedControlID="txtEmailConfirm" CssClass="kr-input-label">Type your email to confirm</asp:Label>
            <asp:TextBox ID="txtEmailConfirm" runat="server" CssClass="kr-input" TextMode="Email" />
        </div>
        <div class="kr-form-field kr-checkbox-field">
            <asp:CheckBox ID="chkUnderstand" runat="server" Text="I understand this cannot be undone." CssClass="kr-checkbox" />
        </div>
        <div class="kr-panel-actions">
            <asp:Button ID="btnDelete" runat="server" Text="Delete my account permanently" CssClass="kr-btn kr-btn-danger" OnClick="btnDelete_Click" />
            <asp:HyperLink ID="lnkCancel" runat="server" NavigateUrl="~/Profile.aspx" CssClass="kr-btn kr-btn-secondary">Cancel</asp:HyperLink>
        </div>
    </div>
</asp:Content>
