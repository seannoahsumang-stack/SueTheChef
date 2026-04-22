<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SueTheChef.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Keep Rollin Co — Home
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <section class="kr-hero" aria-labelledby="hero-heading">
        <div class="kr-hero-visual" role="img" aria-label="Hero: premium tires and wheels">
            <span class="kr-hero-visual-label">Hero image</span>
        </div>
        <h1 id="hero-heading" class="kr-hero-title">Keep Rollin Co</h1>
        <p class="kr-hero-tagline">Performance meets poise — gear, service, and a look that stays on the road.</p>
        <p class="kr-hero-lead">
            Curated tires and wheels, pro install, and the same clean, high-contrast experience on every page.
        </p>
        <div class="kr-hero-actions">
            <asp:HyperLink ID="lnkShopProducts" runat="server" NavigateUrl="~/Shop.aspx" CssClass="kr-btn kr-btn-primary">Shop Products</asp:HyperLink>
            <asp:HyperLink ID="lnkHeroSchedule" runat="server" NavigateUrl="~/Schedule.aspx" CssClass="kr-btn kr-btn-secondary">Schedule</asp:HyperLink>
        </div>
    </section>

    <section class="kr-about-panel" aria-labelledby="about-heading">
        <h2 id="about-heading" class="kr-about-heading">About</h2>
        <p class="kr-about-text">
            Keep Rollin Co is a specialty tire and wheel retailer built for drivers who care how their vehicle looks and performs.
            We combine premium product selection with honest guidance and dependable service bays — so you can shop with clarity and roll with confidence.
        </p>
    </section>
</asp:Content>
