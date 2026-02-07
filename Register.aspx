<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="HomeDecorStore.Register" MasterPageFile="~/Site.Master" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="css/Register.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="register-page">

    <!-- LEFT IMAGE PANEL -->
    <div class="register-image"></div>

    <!-- RIGHT PANEL -->
    <div class="register-form-wrapper">
        <div class="register-form-box">
            <div class="brand">SoftSpace</div>
            <h2>Create Account</h2>

            <div class="form-group">
                <asp:TextBox ID="txtName" runat="server" placeholder="Full Name" CssClass="form-input"></asp:TextBox>
                <!-- Validation Label -->
                <asp:Label ID="lblNameErr" runat="server" Text="Enter a valid name (min 3 letters)" Visible="false" style="color:#D47B7B; font-size:11px; margin-top:4px; display:block; text-align:left;"></asp:Label>
            </div>

            <div class="form-group">
                <asp:TextBox ID="txtEmail" runat="server" placeholder="Email Address" CssClass="form-input"></asp:TextBox>
                <!-- Validation Label -->
                <asp:Label ID="lblEmailErr" runat="server" Text="Enter a valid email address" Visible="false" style="color:#D47B7B; font-size:11px; margin-top:4px; display:block; text-align:left;"></asp:Label>
            </div>

            <div class="form-group">
                <asp:TextBox ID="txtPhone" runat="server" placeholder="Phone Number" CssClass="form-input"></asp:TextBox>
                <!-- Validation Label -->
                <asp:Label ID="lblPhoneErr" runat="server" Text="Enter a valid 10-digit number" Visible="false" style="color:#D47B7B; font-size:11px; margin-top:4px; display:block; text-align:left;"></asp:Label>
            </div>

            <div class="form-group">
                <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-input">
                    <asp:ListItem Value="">City (Optional)</asp:ListItem>
                    <asp:ListItem>Mumbai</asp:ListItem>
                    <asp:ListItem>Delhi</asp:ListItem>
                    <asp:ListItem>Bangalore</asp:ListItem>
                    <asp:ListItem>Pune</asp:ListItem>
                </asp:DropDownList>
            </div>

            <!-- Password Split Row -->
            <div class="form-group split">
                <div style="flex:1;">
                    <asp:TextBox ID="txtPass" runat="server" TextMode="Password" placeholder="Password" CssClass="form-input"></asp:TextBox>
                    <asp:Label ID="lblPassErr" runat="server" Text="Min 6 chars + 1 number" Visible="false" style="color:#D47B7B; font-size:10px; margin-top:4px; display:block; text-align:left;"></asp:Label>
                </div>
                <div style="flex:1;">
                    <asp:TextBox ID="txtConfirmPass" runat="server" TextMode="Password" placeholder="Confirm" CssClass="form-input"></asp:TextBox>
                </div>
            </div>

            <asp:Button ID="btnRegister" runat="server" Text="Join DecorNest →" CssClass="register-btn" OnClick="btnRegister_Click" />

            <p class="login-link">
                Already have an account? <a href="Login.aspx">Login</a>
            </p>
        </div>
    </div>
</div>
</asp:Content>