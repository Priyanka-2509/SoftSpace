<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="HomeDecorStore.Login" MasterPageFile="~/Site.Master" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="css/Login.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="login-wrapper">
    <div class="login-left"></div>
    <div class="login-right">
        <div class="login-card">
            <div class="brand">SoftSpace</div>
            <h2>Welcome Back</h2>
            <p class="subtitle">Sign in to continue styling your space</p>

            <div class="form-group">
                <asp:TextBox ID="txtEmail" runat="server" placeholder="Email Address" CssClass="form-input"></asp:TextBox>
                <!-- Label for Email Error -->
                <asp:Label ID="lblLoginEmailErr" runat="server" Text="Please enter your email" Visible="false" style="color:#D47B7B; font-size:11px; margin-top:4px; display:block; text-align:left;"></asp:Label>
            </div>

            <div class="form-group">
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Password" CssClass="form-input"></asp:TextBox>
                <!-- Label for Password Error -->
                <asp:Label ID="lblLoginPassErr" runat="server" Text="Invalid password" Visible="false" style="color:#D47B7B; font-size:11px; margin-top:4px; display:block; text-align:left;"></asp:Label>
            </div>

            <div class="form-row">
                <label class="remember">
                    <asp:CheckBox ID="chkRemember" runat="server" /> Remember Me
                </label>
                <a href="#" class="forgot">Forgot Password?</a>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="login-btn" OnClick="btnLogin_Click" />

            <p class="register-link">
                Don’t have an account? <a href="Register.aspx">Register</a>
            </p>
        </div>
    </div>
</div>
</asp:Content>