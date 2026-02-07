<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="HomeDecorStore.Home" MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="css/Home.css" rel="stylesheet" />
    <link href="css/Animations.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="main-container">
        <!-- HERO SECTION -->
        <section class="hero-fullscreen">
            <div class="hero-overlay"></div> 
            <div class="hero-content">
                <h1 class="main-title">Crafting Memories <br /><span class="italic-text">In Every Corner</span></h1>
                <p class="hero-subtext">Redefine your surroundings with effortless style. Premium decor for the modern aesthetic</p>
                <div class="hero-btn-container">
                    <a href="#shop" class="btn-pill">Shop now</a>
                </div>
                <br />
                <asp:LinkButton ID="btnOrders" runat="server" Visible="false" PostBackUrl="~/Orders.aspx" CssClass="btn-hero-secondary">
                    Your Orders
                </asp:LinkButton>
                <asp:LinkButton ID="btnLogoutHome" runat="server" Visible="false" OnClick="btnLogoutHome_Click" CssClass="btn-hero-secondary" style="color: #D4B2B2;">
                    Logout
                </asp:LinkButton>
            </div>
        </section>

        <!-- SHOP SECTION -->
        <section id="shop" class="container py">
            <div class="center-text">
                <h2>Our Collection</h2>
                <div class="divider"></div>
            </div>

            <asp:UpdatePanel ID="UP1" runat="server">
                <ContentTemplate>
                    <div class="product-grid">
                        <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
                            <ItemTemplate>
                                <div class="p-card">
                                    <div class="p-img"><img src='<%# Eval("ImageUrl") %>' alt="Product" /></div>
                                    <h3><%# Eval("Name") %></h3>
                                    <p class="price">₹<%# Eval("Price") %></p>
                                    <div class="btn-row">
                                        <asp:Button ID="btnView" runat="server" Text="Details" CssClass="b-view" 
                                            CommandName="ViewDetails" CommandArgument='<%# Eval("Id") %>' />
                                        <asp:Button ID="btnOrder" runat="server" Text="Order" CssClass="b-order" 
                                            CommandName="OrderNow" CommandArgument='<%# Eval("Id") %>' />
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <!-- POPUP 1: PRODUCT DETAILS -->
                    <asp:Panel ID="pnlDetails" runat="server" Visible="false" CssClass="modal-overlay">
                        <div class="modal-box details-box">
                            <asp:LinkButton runat="server" OnClick="btnClose_Click" CssClass="close-x">&times;</asp:LinkButton>
                            <div class="modal-split">
                                <div class="m-left">
                                    <asp:Image ID="imgModal" runat="server" style="width:100%; height:100%; object-fit:cover;" />
                                </div>
                                <div class="m-right">
                                    <span class="eyebrow" style="color:#A7BCB9; letter-spacing:2px; text-transform:uppercase; font-size:12px;">Limited Edition</span>
                                    <h2 class="modal-title" style="font-family:'Playfair Display'; font-size:2.2rem; margin:10px 0;">
                                        <asp:Label ID="lblProdName" runat="server" />
                                    </h2>
                                    <div style="width:30px; height:2px; background:#D4B2B2; margin-bottom:20px;"></div>
                                    <p class="modal-desc" style="color:#666; line-height:1.6; margin-bottom:25px;">
                                        <asp:Literal ID="litDesc" runat="server" />
                                    </p>
                                    <h3 class="modal-price" style="font-size:1.8rem; color:#4A4A4A; margin-bottom:30px;">
                                        ₹<asp:Label ID="lblPrice" runat="server" />
                                    </h3>
                                    <asp:Button ID="btnOrderFromModal" runat="server" Text="Add to sanctuary" 
                                        CssClass="b-order" OnClick="btnOrderFromModal_Click" 
                                        style="width:100%; padding:15px; background:#7E8976; color:white; border:none; border-radius:5px; cursor:pointer;" />
                                </div>
                            </div>
                        </div>
                    </asp:Panel>

                    <!-- POPUP 2: ADDRESS ENTRY -->
                    <!-- POPUP 2: ADDRESS ENTRY (Updated Button Text) -->
<asp:Panel ID="pnlAddress" runat="server" Visible="false" CssClass="modal-overlay">
    <div class="modal-box address-box">
        <asp:LinkButton runat="server" OnClick="btnClose_Click" CssClass="close-x">&times;</asp:LinkButton>
        <h2 class="modal-title">Shipping Address</h2>
        <p>Where should we deliver your luxury piece?</p>
        <asp:Label ID="lblAddressError" runat="server" Text="Please enter your address!" ForeColor="#D47B7B" Visible="false" style="display:block; margin-bottom:-10px; font-size: 0.8rem; font-weight: 500;"></asp:Label>
        <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="3" placeholder="Enter full address..." CssClass="m-input"></asp:TextBox>
        <!-- CHANGED CLICK TO MOVE TO PAYMENT -->
        <asp:Button ID="btnToPayment" runat="server" Text="Proceed to Payment" CssClass="b-order" OnClick="btnToPayment_Click" />
    </div>
</asp:Panel>

<!-- POPUP 3: SIMULATED PAYMENT GATEWAY -->
<asp:Panel ID="pnlPayment" runat="server" Visible="false" CssClass="modal-overlay">
    <div class="modal-box address-box" style="width:450px;">
        <asp:LinkButton runat="server" OnClick="btnClose_Click" CssClass="close-x">&times;</asp:LinkButton>
        <span class="eyebrow" style="color:var(--sage);">Secure Checkout</span>
        <h2 class="modal-title">Payment Method</h2>
        
        <div style="text-align:left; margin:20px 0; padding:20px; border:1px solid #EEE; border-radius:15px; background:#FBFAF8;">
            <p style="font-size:0.9rem; margin-bottom:15px;"><strong>Amount to Pay: </strong> ₹<asp:Label ID="lblFinalPrice" runat="server"></asp:Label></p>
            
            <!-- Payment Selection -->
            <asp:RadioButtonList ID="rblPaymentMethod" runat="server" AutoPostBack="true" OnSelectedIndexChanged="rblPaymentMethod_SelectedIndexChanged" RepeatDirection="Vertical" style="width:100%; margin-bottom:15px;">
                <asp:ListItem Value="Card" Selected="True"> &nbsp;Credit / Debit Card</asp:ListItem>
                <asp:ListItem Value="COD"> &nbsp;Cash on Delivery (COD)</asp:ListItem>
            </asp:RadioButtonList>

            <!-- Card Details Section (This will show/hide) -->
            <asp:Panel ID="pnlCardDetails" runat="server">
                <label style="font-size:0.75rem; color:#999;">Card Number</label>
                <asp:TextBox ID="txtCardNum" runat="server" placeholder="XXXX XXXX XXXX 1234" CssClass="m-input" style="margin-bottom:10px;"></asp:TextBox>
                <div style="display:flex; gap:10px;">
                    <div style="flex:1">
                        <label style="font-size:0.75rem; color:#999;">Expiry</label>
                        <asp:TextBox ID="txtExpiry" runat="server" placeholder="MM/YY" CssClass="m-input"></asp:TextBox>
                    </div>
                    <div style="flex:1">
                        <label style="font-size:0.75rem; color:#999;">CVV</label>
                        <asp:TextBox ID="txtCVV" runat="server" TextMode="Password" placeholder="***" CssClass="m-input"></asp:TextBox>
                    </div>
                </div>
            </asp:Panel>

            <!-- COD Info Section (Hidden by default) -->
            <asp:Panel ID="pnlCODInfo" runat="server" Visible="false">
                <p style="font-size:0.8rem; color:#7E8976; background:#F2F6F1; padding:10px; border-radius:8px;">
                    ✦ You can pay via Cash or UPI upon delivery.
                </p>
            </asp:Panel>
        </div>

        <asp:Button ID="btnPayNow" runat="server" Text="Complete Order" CssClass="b-order" OnClick="btnPayNow_Click" />
        <p style="font-size:10px; margin-top:15px; opacity:0.5;">🔒 100% Secure Checkout</p>
    </div>
</asp:Panel>
                </ContentTemplate>
            </asp:UpdatePanel>
        </section>

       <!-- INSTAGRAM FEED SECTION -->
<section class="insta-section" id="insta">
    <div class="insta-header">
        <span class="eyebrow" style="color:var(--sage);">Join the community</span>
        <h2>Follow us on Instagram</h2>
        <a href="https://instagram.com" target="_blank" class="insta-handle">@Softspace_Studio</a>
    </div>

    <div class="insta-grid">
        <div class="insta-item">
            <img src="https://i.pinimg.com/1200x/6c/32/60/6c32605bac5695eb08f9bd6a56d5edfa.jpg" alt="Feed 1" />
            <div class="insta-overlay"><span>Shop the look</span></div>
        </div>
        <div class="insta-item">
            <img src="https://i.pinimg.com/736x/bf/0a/af/bf0aaf47c6881629d198b9ae82d2afda.jpg" alt="Feed 2" />
            <div class="insta-overlay"><span>✦ ✦ ✦</span></div>
        </div>
        <div class="insta-item">
            <img src="https://i.pinimg.com/1200x/9c/ed/22/9ced227a7c4d06ee8e4908629c91790e.jpg" alt="Feed 3" />
            <div class="insta-overlay"><span> Golden Hour</span></div> 
        </div>
        <div class="insta-item">
            <img src="https://i.pinimg.com/736x/9f/a7/25/9fa725550a77a8886aa75135b93783e3.jpg" alt="Feed 4" />
            <div class="insta-overlay"><span>Living Room</span></div>
        </div>
        <div class="insta-item">
            <img src="https://i.pinimg.com/1200x/f8/50/05/f850052038aa46ca1d49bd7923dba73f.jpg" alt="Feed 5" />
            <div class="insta-overlay"><span>Minimalist</span></div>
        </div>
        <div class="insta-item">
            <img src="https://i.pinimg.com/1200x/5e/76/92/5e769209e1884c53a588916f0a8d861c.jpg" alt="Feed 6" />
            <div class="insta-overlay"><span>Inspiration</span></div>
        </div>
    </div>
</section>

        <!-- FOOTER -->
        <footer class="main-footer">
    <div class="footer-container">
        <div class="footer-col">
            <h3 class="footer-logo">Soft Space</h3>
            <p>Minimalist decor for modern souls. Curating peace, one piece at a time.</p>
        </div>
        <div class="footer-col">
            <h4>Explore</h4>
            <a href="#shop">Collection</a> • <a href="Orders.aspx">Orders</a> 
        </div>
        <div class="footer-col">
            <h4>Visit & Connect</h4>
            <p>102 Pastel St, Mumbai • hello@softspace.com • @SoftSpace</p>
        </div>
    </div>
    <div class="footer-bottom"> Handcrafted for you.</div>
</footer>
    </div>
    <script src="js/animation.js"></script>
</asp:Content>