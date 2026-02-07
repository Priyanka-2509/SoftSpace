<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Orders.aspx.cs" Inherits="HomeDecorStore.Orders" MasterPageFile="~/Site.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="Css/Orders.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

  <div class="orders-page-container">
        <!-- HEADER SECTION -->
        <div class="orders-header">
            <div class="header-left">
                <h1>Your Gallery</h1>
                <p>Track the journey of your curated pieces.</p>
            </div>
            <asp:Button ID="btnLogout" runat="server" Text="Log Out" CssClass="btn-logout-premium" OnClick="btnLogout_Click" />
        </div>

        <asp:UpdatePanel ID="UP_Orders" runat="server">
            <ContentTemplate>

                <!-- EMPTY STATE -->
                <asp:Panel ID="pnlEmpty" runat="server" CssClass="empty-order-state">
                    <div class="empty-icon">✦</div>
                    <h2>Your sanctuary is waiting</h2>
                    <p>You haven't placed any orders yet.</p>
                    <a href="Home.aspx" class="btn-shop-link">Discover Collection</a>
                </asp:Panel>

                <!-- ORDERS LIST -->
                <asp:Panel ID="pnlOrders" runat="server" Visible="false" CssClass="orders-list">
                    <asp:Repeater ID="rptOrders" runat="server" OnItemCommand="rptOrders_ItemCommand">
                        <ItemTemplate>
                            <div class="order-card-premium">
                                <div class="order-main-info">
                                    <div class="order-img-box">
                                        <img src='<%# Eval("ImageUrl") %>' alt="Product" />
                                    </div>
                                    <div class="order-details-text">
                                        <span class="order-id-tag"><%# Eval("OrderId") %></span>
                                        <h3><%# Eval("ProductName") %></h3>
                                        <p class="order-date">Ordered on <%# Eval("OrderDate", "{0:dd MMM yyyy}") %></p>
                                    </div>
                                </div>
                                <div class="order-meta-info">
                                    <div class="price-box">
                                        <label>TOTAL</label>
                                        <span>₹<%# Eval("Price") %></span>
                                    </div>
                                    <div class="status-box">
                                        <label>STATUS</label>
                                        <span class="status-pill"><%# Eval("Status") %></span>
                                    </div>
                                    <asp:Button runat="server" Text="Track Journey" CssClass="btn-track-order" 
                                        CommandName="Track" CommandArgument='<%# Eval("OrderId") %>' />
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>

                <!-- DYNAMIC TRACKING MODAL -->
                <asp:Panel ID="pnlTrack" runat="server" Visible="false" CssClass="modal-overlay">
                    <div class="modal-box tracking-minimal">
                        <asp:LinkButton runat="server" OnClick="btnClose_Click" CssClass="close-x">&times;</asp:LinkButton>
                        
                        <span class="eyebrow" style="color:var(--sage); display:block; margin-bottom:10px;">Logistics Portal</span>
                        <h2 class="modal-title">Order Status</h2>
                        <p class="awb-text">ID: <asp:Label ID="lblTrackId" runat="server" /></p>

                        <div class="tracker-visual">
                            <div class="v-line"></div>
                            <!-- Bar Fill -->
                            <div id="barFill" runat="server" class="v-line-fill"></div> 

                            <div class="v-steps">
                                <div id="step1" runat="server" class="v-step">
                                    <div class="v-node">✦</div>
                                    <span class="v-label">Placed</span>
                                </div>
                                <div id="step2" runat="server" class="v-step">
                                    <div class="v-node">✦</div>
                                    <span class="v-label">In Transit</span>
                                </div>
                                <div id="step3" runat="server" class="v-step">
                                    <div class="v-node">✦</div>
                                    <span class="v-label">Delivery</span>
                                </div>
                                <div id="step4" runat="server" class="v-step">
                                    <div class="v-node">✦</div>
                                    <span class="v-label">Arrived</span>
                                </div>
                            </div>
                        </div>

                        <div class="track-info-grid">
                            <div class="info-item">
                                <label>Current Status</label>
                                <asp:Label ID="lblCurrentStatus" runat="server" Font-Bold="true" style="color:var(--sage);" />
                            </div>
                            <div class="info-item">
                                <label>Est. Arrival</label>
                                <span>Jan 15, 2025</span>
                            </div>
                        </div>

                        <asp:Button runat="server" Text="Dismiss" CssClass="btn-dismiss" OnClick="btnClose_Click" style="width:100%; margin-top:10px;" />
                    </div>
                </asp:Panel>

            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>