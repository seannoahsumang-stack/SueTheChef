<%@ Page Title="Appointment confirmed" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AppointmentConfirmation.aspx.cs" Inherits="SueTheChef.AppointmentConfirmation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Keep Rollin Co — Appointment scheduled
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:SqlDataSource ID="dsAppointment" runat="server"
        ConnectionString="<%$ ConnectionStrings:RollinCoConnectionString %>"
        SelectCommand="SELECT a.ServiceType, a.AppointmentDate AS ApptWhen, c.VehicleInfo, l.LocationName AS BranchName, l.Address FROM APPOINTMENTS AS a INNER JOIN CUSTOMERS AS c ON c.CustomerID = a.CustomerID INNER JOIN LOCATIONS AS l ON l.LocationID = a.LocationID WHERE a.AppointmentID = @AppointmentID">
        <SelectParameters>
            <asp:QueryStringParameter Name="AppointmentID" QueryStringField="ID" Type="Int32" DefaultValue="0" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:Panel ID="pnlOk" runat="server" CssClass="kr-confirm-wrap">
        <p class="kr-confirm-status">✓ Appointment scheduled</p>

        <asp:FormView ID="fvAppt" runat="server" DataSourceID="dsAppointment" RenderOuterTable="false">
            <ItemTemplate>
                <section class="kr-summary-panel" aria-labelledby="sum-heading">
                    <h2 id="sum-heading" class="kr-summary-heading">Appointment details</h2>
                    <dl class="kr-summary-list">
                        <div class="kr-summary-row"><dt>Service</dt><dd><%# Eval("ServiceType") %></dd></div>
                        <div class="kr-summary-row"><dt>Date</dt><dd><%# Eval("ApptWhen", "{0:g}") %></dd></div>
                        <div class="kr-summary-row"><dt>Location</dt><dd><%# Eval("BranchName") %> — <%# Eval("Address") %></dd></div>
                        <div class="kr-summary-row"><dt>Vehicle</dt><dd><%# Eval("VehicleInfo") %></dd></div>
                    </dl>
                </section>
            </ItemTemplate>
            <EmptyDataTemplate>
                <p class="kr-empty">We could not load this appointment. Check the link or return to scheduling.</p>
            </EmptyDataTemplate>
        </asp:FormView>

        <div class="kr-confirm-actions">
            <asp:HyperLink ID="lnkScheduleAnother" runat="server" NavigateUrl="~/Schedule.aspx" CssClass="kr-btn kr-btn-secondary">Schedule another</asp:HyperLink>
        </div>
    </asp:Panel>
</asp:Content>
