<%@ Page Title="My account" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="SueTheChef.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Keep Rollin Co — My account
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="kr-page-title-center">My account</h1>
    <p class="kr-auth-lead">Update your name, email, phone, and vehicle. Optional: change your password below.</p>

    <asp:Label ID="litProfileMessage" runat="server" Visible="false" CssClass="kr-block-success" />
    <asp:Label ID="litProfileError" runat="server" Visible="false" CssClass="kr-block-error" />

    <div class="kr-panel kr-auth-panel">
        <h2 class="kr-subheading">Profile</h2>
        <div class="kr-form-field">
            <asp:Label ID="lblFirst" runat="server" AssociatedControlID="txtFirstName" CssClass="kr-input-label">First name</asp:Label>
            <asp:TextBox ID="txtFirstName" runat="server" CssClass="kr-input" MaxLength="50" />
            <asp:RequiredFieldValidator ID="rfvFirst" runat="server" ControlToValidate="txtFirstName" ErrorMessage="First name is required." Display="Dynamic" CssClass="kr-field-error" />
        </div>
        <div class="kr-form-field">
            <asp:Label ID="lblLast" runat="server" AssociatedControlID="txtLastName" CssClass="kr-input-label">Last name</asp:Label>
            <asp:TextBox ID="txtLastName" runat="server" CssClass="kr-input" MaxLength="50" />
            <asp:RequiredFieldValidator ID="rfvLast" runat="server" ControlToValidate="txtLastName" ErrorMessage="Last name is required." Display="Dynamic" CssClass="kr-field-error" />
        </div>
        <div class="kr-form-field">
            <asp:Label ID="lblEmail" runat="server" AssociatedControlID="txtEmail" CssClass="kr-input-label">Email</asp:Label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="kr-input" TextMode="Email" MaxLength="100" />
            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required." Display="Dynamic" CssClass="kr-field-error" />
        </div>
        <div class="kr-form-field">
            <asp:Label ID="lblPhone" runat="server" AssociatedControlID="txtPhone" CssClass="kr-input-label">Phone</asp:Label>
            <asp:TextBox ID="txtPhone" runat="server" CssClass="kr-input" MaxLength="20" />
        </div>
        <div class="kr-form-field">
            <asp:Label ID="lblVehicle" runat="server" AssociatedControlID="txtVehicleInfo" CssClass="kr-input-label">Vehicle</asp:Label>
            <asp:TextBox ID="txtVehicleInfo" runat="server" CssClass="kr-input" MaxLength="255" />
        </div>

        <h2 class="kr-subheading kr-subheading-spaced">Password</h2>
        <p class="kr-auth-hint">Leave password fields blank to keep your current password. If you never set one, enter only a new password.</p>
        <div class="kr-form-field">
            <asp:Label ID="lblCurrentPwd" runat="server" AssociatedControlID="txtCurrentPassword" CssClass="kr-input-label">Current password</asp:Label>
            <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="kr-input" TextMode="Password" />
        </div>
        <div class="kr-form-field">
            <asp:Label ID="lblNewPwd" runat="server" AssociatedControlID="txtNewPassword" CssClass="kr-input-label">New password</asp:Label>
            <asp:TextBox ID="txtNewPassword" runat="server" CssClass="kr-input" TextMode="Password" />
        </div>
        <div class="kr-form-field">
            <asp:Label ID="lblNewPwd2" runat="server" AssociatedControlID="txtNewPasswordConfirm" CssClass="kr-input-label">Confirm new password</asp:Label>
            <asp:TextBox ID="txtNewPasswordConfirm" runat="server" CssClass="kr-input" TextMode="Password" />
        </div>

        <div class="kr-panel-actions">
            <asp:Button ID="btnSave" runat="server" Text="Save changes" CssClass="kr-btn kr-btn-primary" OnClick="btnSave_Click" />
        </div>
    </div>

    <div class="kr-panel kr-danger-panel">
        <h2 class="kr-subheading">Delete account</h2>
        <p class="kr-danger-text">Permanently remove your customer record, orders, and appointments. This cannot be undone.</p>
        <asp:HyperLink ID="lnkDelete" runat="server" NavigateUrl="~/DeleteAccount.aspx" CssClass="kr-btn kr-btn-danger">Go to delete account</asp:HyperLink>
    </div>
</asp:Content>
