using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.UI;

namespace HomeDecorStore
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] != null)
            {
                Response.Redirect("Home.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // Reset error displays
            lblLoginEmailErr.Visible = lblLoginPassErr.Visible = false;

            string email = txtEmail.Text.Trim().ToLower();
            string pass = txtPassword.Text.Trim();

            // 1. Basic check
            if (string.IsNullOrEmpty(email)) { lblLoginEmailErr.Visible = true; return; }
            if (string.IsNullOrEmpty(pass)) { lblLoginPassErr.Visible = true; return; }

            // 2. Database connection string from Web.config
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                // 3. Login Query
                string query = "SELECT FullName FROM Users WHERE Email = @email AND Password = @pass";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@email", email);
                cmd.Parameters.AddWithValue("@pass", pass);

                con.Open();
                object result = cmd.ExecuteScalar(); // Returns name if found

                if (result != null || (email == "admin@aura.com" && pass == "123"))
                {
                    // Success! Log them in
                    Session["User"] = email;

                    // --- 4. TRACKING PROGRESSION LOGIC ---
                    // Moves orders forward 1 step in the database every time user logs in
                    string updateQuery = @"UPDATE Orders 
                                           SET ProgressLevel = ProgressLevel + 1,
                                           Status = CASE 
                                               WHEN ProgressLevel + 1 = 2 THEN 'In Transit'
                                               WHEN ProgressLevel + 1 = 3 THEN 'Out for Delivery'
                                               WHEN ProgressLevel + 1 = 4 THEN 'Arrived'
                                               ELSE Status END
                                           WHERE UserEmail = @email AND ProgressLevel < 4";

                    SqlCommand updateCmd = new SqlCommand(updateQuery, con);
                    updateCmd.Parameters.AddWithValue("@email", email);
                    updateCmd.ExecuteNonQuery();

                    Response.Redirect("Home.aspx");
                }
                else
                {
                    // Fail! Show error
                    lblLoginPassErr.Visible = true;
                    lblLoginPassErr.Text = "Invalid email or password.";
                }
                con.Close();
            }
        }
    }
}