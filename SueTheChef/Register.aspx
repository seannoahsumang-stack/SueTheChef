<%@ Page Title="Create account" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="SueTheChef.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Keep Rollin Co — Create account
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="kr-page-title-center">Create account</h1>
    <p class="kr-auth-lead">Columns: FirstName, LastName, Email, Phone, VehicleInfo, Password — same as the CUSTOMERS table in SSMS.</p>

    <asp:Label ID="litRegisterError" runat="server" Visible="false" CssClass="kr-block-error" />

    <asp:ValidationSummary ID="vsRegister" runat="server" CssClass="kr-validation-summary" DisplayMode="BulletList" HeaderText="Please fix the following:" />

    <div class="kr-panel kr-auth-panel">
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
            <asp:Label ID="lblPwd" runat="server" AssociatedControlID="txtPassword" CssClass="kr-input-label">Password</asp:Label>
            <asp:TextBox ID="txtPassword" runat="server" CssClass="kr-input" TextMode="Password" />
            <asp:RequiredFieldValidator ID="rfvPwd" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required." Display="Dynamic" CssClass="kr-field-error" />
        </div>
        <div class="kr-form-field">
            <asp:Label ID="lblPwd2" runat="server" AssociatedControlID="txtPasswordConfirm" CssClass="kr-input-label">Confirm password</asp:Label>
            <asp:TextBox ID="txtPasswordConfirm" runat="server" CssClass="kr-input" TextMode="Password" />
            <asp:CompareValidator ID="cvPwd" runat="server" ControlToValidate="txtPasswordConfirm" ControlToCompare="txtPassword" Operator="Equal" Type="String" ErrorMessage="Passwords must match." Display="Dynamic" CssClass="kr-field-error" />
        </div>
        <div class="kr-form-field">
            <asp:Label ID="lblPhone" runat="server" AssociatedControlID="txtPhone" CssClass="kr-input-label">Phone</asp:Label>
            <asp:TextBox ID="txtPhone" runat="server" CssClass="kr-input" MaxLength="20" />
        </div>
        <div class="kr-form-field">
            <asp:Label ID="lblVehicle" runat="server" AssociatedControlID="txtVehicleInfo" CssClass="kr-input-label">Vehicle</asp:Label>
            <asp:TextBox ID="txtVehicleInfo" runat="server" CssClass="kr-input" MaxLength="255" />
        </div>
        <div class="kr-panel-actions">
            <asp:Button ID="btnRegister" runat="server" Text="Create account" CssClass="kr-btn kr-btn-primary" OnClick="btnRegister_Click" />
        </div>
        <p class="kr-auth-foot">Already have an account? <asp:HyperLink ID="lnkLogin" runat="server" NavigateUrl="~/Login.aspx" CssClass="kr-link-muted">Sign in</asp:HyperLink></p>
    </div>
</asp:Content>
