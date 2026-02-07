using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace HomeDecorStore
{
    public partial class Home : System.Web.UI.Page
    {
        public class Product
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public string Price { get; set; }
            public string ImageUrl { get; set; }
            public string Description { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                rptProducts.DataSource = GetProducts();
                rptProducts.DataBind();
            }

            // Centralized Login Check
            if (Session["User"] != null)
            {
                btnOrders.Visible = true;
                btnLogoutHome.Visible = true;
            }
            else
            {
                btnOrders.Visible = false;
                btnLogoutHome.Visible = false;
            }
        }

        protected void btnLogoutHome_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Home.aspx");
        }

        private DataTable GetProducts()
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Products", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int prodId = Convert.ToInt32(e.CommandArgument);

            // 1. Get the data from the database
            DataTable dt = GetProducts();

            // 2. Find the specific row where Id matches
            // We use .Select() which is the standard way for DataTables
            DataRow[] rows = dt.Select("Id = " + prodId);

            if (rows.Length > 0)
            {
                DataRow prod = rows[0]; // Take the first matching row

                // ALWAYS store the current selection in ViewState (Now grabbing from DataRow)
                ViewState["SelectedProdName"] = prod["Name"].ToString();
                ViewState["SelectedProdPrice"] = prod["Price"].ToString();
                ViewState["SelectedProdImage"] = prod["ImageUrl"].ToString();
                ViewState["SelectedProdDesc"] = prod["Description"].ToString();

                if (e.CommandName == "ViewDetails")
                {
                    // Fill the labels from the DataRow
                    lblProdName.Text = prod["Name"].ToString();
                    litDesc.Text = prod["Description"].ToString();
                    lblPrice.Text = prod["Price"].ToString();
                    imgModal.ImageUrl = prod["ImageUrl"].ToString();

                    pnlDetails.Visible = true;
                }
                else if (e.CommandName == "OrderNow")
                {
                    CheckLoginAndOrder();
                }
            }
        }

        private void CheckLoginAndOrder()
        {
            if (Session["User"] == null)
            {
                Response.Redirect("Register.aspx");
            }
            else
            {
                pnlDetails.Visible = false;
                pnlAddress.Visible = true;
            }
        }

        protected void btnOrderFromModal_Click(object sender, EventArgs e)
        {
            CheckLoginAndOrder();
        }

        protected void btnFinalConfirm_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtAddress.Text))
            {
                lblAddressError.Visible = true;
                lblAddressError.Text = "Address cannot be empty!";
                return;
            }

            if (Orders.GlobalOrderDatabase == null)
                Orders.GlobalOrderDatabase = new List<Orders.OrderItem>();

            // GRAB FROM VIEWSTATE (Much more reliable than labels)
            Orders.GlobalOrderDatabase.Add(new Orders.OrderItem
            {
                OrderId = "AUR-" + (Orders.GlobalOrderDatabase.Count + 101).ToString(),
                ProductName = ViewState["SelectedProdName"].ToString(),
                ImageUrl = ViewState["SelectedProdImage"].ToString(),
                Price = ViewState["SelectedProdPrice"].ToString(),
                OrderDate = DateTime.Now,
                Status = "Placed",
                ProgressLevel = 1,
                UserEmail = Session["User"].ToString()
            });

            pnlAddress.Visible = false;
            txtAddress.Text = "";
            lblAddressError.Visible = false;

            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Order placed successfully! ✨');", true);
        }

        // 1. Logic for Address -> Payment
        protected void btnToPayment_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtAddress.Text) || txtAddress.Text.Trim().Length < 10)
            {
                lblAddressError.Visible = true;
                lblAddressError.Text = "Please enter a valid delivery address.";
                return;
            }

            // Prepare payment popup
            lblFinalPrice.Text = ViewState["SelectedProdPrice"].ToString();
            pnlAddress.Visible = false;
            pnlPayment.Visible = true;
        }

        // 2. Logic for Final Payment & Order Placement
        // 1. Toggle between Card and COD inputs
        protected void rblPaymentMethod_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rblPaymentMethod.SelectedValue == "COD")
            {
                pnlCardDetails.Visible = false;
                pnlCODInfo.Visible = true;
                btnPayNow.Text = "Confirm Order (COD)";
            }
            else
            {
                pnlCardDetails.Visible = true;
                pnlCODInfo.Visible = false;
                btnPayNow.Text = "Pay & Place Order";
            }
        }

        // 2. Modified Final Order Logic
        protected void btnPayNow_Click(object sender, EventArgs e)
        {
            // 1. Validation for Card (Keep your existing code)
            if (rblPaymentMethod.SelectedValue == "Card")
            {
                if (txtCardNum.Text.Length < 12 || txtCVV.Text.Length < 3)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Please enter valid card details for this demo.');", true);
                    return;
                }
            }

            // 2. Prepare Database Connection
            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;

            using (System.Data.SqlClient.SqlConnection con = new System.Data.SqlClient.SqlConnection(connStr))
            {
                // 3. Define the Insert Query
                string query = @"INSERT INTO Orders (OrderId, ProductName, ImageUrl, Price, Status, ProgressLevel, UserEmail) 
                        VALUES (@oid, @name, @img, @price, @status, @level, @uemail)";

                System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(query, con);

                // 4. Generate a random Order ID for the look
                string newOrderId = "AUR-" + new Random().Next(1000, 9999).ToString();

                // 5. Determine the status based on payment method
                string orderStatus = (rblPaymentMethod.SelectedValue == "COD") ? "Placed (COD)" : "Paid & Placed";

                // 6. Add Parameters from ViewState and Session
                cmd.Parameters.AddWithValue("@oid", newOrderId);
                cmd.Parameters.AddWithValue("@name", ViewState["SelectedProdName"]);
                cmd.Parameters.AddWithValue("@img", ViewState["SelectedProdImage"]);
                cmd.Parameters.AddWithValue("@price", ViewState["SelectedProdPrice"]);
                cmd.Parameters.AddWithValue("@status", orderStatus);
                cmd.Parameters.AddWithValue("@level", 1); // Start at level 1
                cmd.Parameters.AddWithValue("@uemail", Session["User"].ToString());

                // 7. Execute the command
                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }

            // 8. Reset UI and close the Payment Modal
            pnlPayment.Visible = false;
            txtAddress.Text = "";
            txtCardNum.Text = "";
            txtExpiry.Text = "";
            txtCVV.Text = "";
            lblAddressError.Visible = false;

            // 9. Show Success Message
            string msg = (rblPaymentMethod.SelectedValue == "COD") ? "Order Placed! Please keep cash ready." : "Payment Successful! Order placed successfully.";
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('{msg} ✨');", true);
        }

        // 3. Update the General Close button to handle all 3 panels
        protected void btnClose_Click(object sender, EventArgs e)
        {
            pnlDetails.Visible = false;
            pnlAddress.Visible = false;
            pnlPayment.Visible = false;
        }
    }
}