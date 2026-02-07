using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HomeDecorStore
{
    public partial class Orders : System.Web.UI.Page
    {
        [Serializable]
        public class OrderItem
        {
            public string OrderId { get; set; }
            public string ProductName { get; set; }
            public string ImageUrl { get; set; }
            public DateTime OrderDate { get; set; }
            public string Price { get; set; }
            public string Status { get; set; }
            public int ProgressLevel { get; set; } // 1:Placed, 2:Transit, 3:Delivery, 4:Arrived
            public string UserEmail { get; set; }
        }

        // STATIC LIST: Acts as our permanent fake database
        public static List<OrderItem> GlobalOrderDatabase = new List<OrderItem>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserOrders();
            }
        }

        private void LoadUserOrders()
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string q = "SELECT * FROM Orders WHERE UserEmail = @e ORDER BY Id DESC";
                SqlCommand cmd = new SqlCommand(q, con);
                cmd.Parameters.AddWithValue("@e", Session["User"]);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    pnlEmpty.Visible = false; pnlOrders.Visible = true;
                    rptOrders.DataSource = dt; rptOrders.DataBind();
                }
                else
                {
                    pnlEmpty.Visible = true; pnlOrders.Visible = false;
                }
            }
        }

        protected void rptOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Track")
            {
                string orderId = e.CommandArgument.ToString();
                string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;

                using (System.Data.SqlClient.SqlConnection con = new System.Data.SqlClient.SqlConnection(connStr))
                {
                    // 1. Fetch the specific order details from the Database
                    string query = "SELECT OrderId, Status, ProgressLevel FROM Orders WHERE OrderId = @oid";
                    System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@oid", orderId);

                    con.Open();
                    System.Data.SqlClient.SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        // 2. Fill the labels
                        lblTrackId.Text = dr["OrderId"].ToString();
                        lblCurrentStatus.Text = dr["Status"].ToString();
                        int lv = Convert.ToInt32(dr["ProgressLevel"]);

                        // 3. Reset all step classes to default
                        step1.Attributes["class"] = "v-step";
                        step2.Attributes["class"] = "v-step";
                        step3.Attributes["class"] = "v-step";
                        step4.Attributes["class"] = "v-step";

                        // 4. Apply 'active' based on the Database ProgressLevel
                        if (lv >= 1) step1.Attributes["class"] += " active";
                        if (lv >= 2) step2.Attributes["class"] += " active";
                        if (lv >= 3) step3.Attributes["class"] += " active";
                        if (lv >= 4) step4.Attributes["class"] += " active";

                        // 5. Update the line fill width
                        string[] widths = { "0%", "5%", "33%", "66%", "100%" };
                        barFill.Style["width"] = widths[lv];

                        // 6. SHOW THE MODAL
                        pnlTrack.Visible = true;
                    }
                    con.Close();
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("Home.aspx");
        }

        protected void btnClose_Click(object sender, EventArgs e)
        {
            pnlTrack.Visible = false;
        }
    }
}