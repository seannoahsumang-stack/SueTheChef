<%@ Page Title="Schedule" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Schedule.aspx.cs" Inherits="SueTheChef.Schedule" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Keep Rollin Co — Schedule Service
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1 class="kr-page-title-center">Schedule Service</h1>

    <asp:Literal ID="litScheduleError" runat="server" Visible="false" />

    <div class="kr-schedule-layout">
        <section class="kr-panel" aria-labelledby="svc-heading">
            <h2 id="svc-heading" class="kr-panel-title">Select service</h2>
            <asp:RadioButtonList ID="rblService" runat="server" CssClass="kr-radio-list" RepeatLayout="Flow" RepeatDirection="Vertical">
                <asp:ListItem Text="Tire Install" Value="Tire Install" Selected="True"></asp:ListItem>
                <asp:ListItem Text="Mounting" Value="Mounting"></asp:ListItem>
                <asp:ListItem Text="Rotation" Value="Rotation"></asp:ListItem>
                <asp:ListItem Text="Alignment" Value="Alignment"></asp:ListItem>
                <asp:ListItem Text="TPMS" Value="TPMS"></asp:ListItem>
            </asp:RadioButtonList>
        </section>

        <section class="kr-panel" aria-labelledby="info-heading">
            <h2 id="info-heading" class="kr-panel-title">Your information</h2>

            <asp:SqlDataSource ID="dsLocations" runat="server"
                ConnectionString="<%$ ConnectionStrings:RollinCoConnectionString %>"
                SelectCommand="SELECT LocationID, LocationName, Address FROM LOCATIONS ORDER BY LocationName">
            </asp:SqlDataSource>

            <div class="kr-form-field">
                <asp:Label ID="lblName" runat="server" AssociatedControlID="txtName" CssClass="kr-input-label">Name</asp:Label>
                <asp:TextBox ID="txtName" runat="server" CssClass="kr-input" AutoPostBack="false" placeholder="First Last" />
            </div>
            <div class="kr-form-field">
                <asp:Label ID="lblEmail" runat="server" AssociatedControlID="txtEmail" CssClass="kr-input-label">Email</asp:Label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="kr-input" TextMode="Email" AutoPostBack="false" />
            </div>
            <div class="kr-form-field">
                <asp:Label ID="lblPhone" runat="server" AssociatedControlID="txtPhone" CssClass="kr-input-label">Phone</asp:Label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="kr-input" AutoPostBack="false" />
            </div>
            <div class="kr-form-field">
                <asp:Label ID="lblVehicle" runat="server" AssociatedControlID="txtVehicle" CssClass="kr-input-label">Vehicle</asp:Label>
                <asp:TextBox ID="txtVehicle" runat="server" CssClass="kr-input" AutoPostBack="false" />
            </div>
            <div class="kr-form-field">
                <asp:Label ID="lblLocation" runat="server" AssociatedControlID="ddlLocation" CssClass="kr-input-label">Location</asp:Label>
                <asp:DropDownList ID="ddlLocation" runat="server" DataSourceID="dsLocations"
                    DataTextField="LocationName" DataValueField="LocationID" CssClass="kr-input kr-input-select" AutoPostBack="false">
                </asp:DropDownList>
            </div>
            <div class="kr-form-field">
                <asp:Label ID="lblApptDate" runat="server" AssociatedControlID="txtApptDate" CssClass="kr-input-label">Appointment date &amp; time</asp:Label>
                <asp:TextBox ID="txtApptDate" runat="server" CssClass="kr-input" AutoPostBack="false" />
            </div>

            <div class="kr-panel-actions">
                <asp:Button ID="btnConfirmAppt" runat="server" Text="Confirm Appt" CssClass="kr-btn kr-btn-primary" OnClick="btnConfirmAppt_Click" CausesValidation="false" />
            </div>
        </section>
    </div>
</asp:Content>
