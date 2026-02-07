using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text.RegularExpressions; // Required for validation
using System.Web.UI;

namespace HomeDecorStore
{
    public partial class Register : System.Web.UI.Page
    {
        [Serializable]
        public class UserAccount
        {
            public string Name { get; set; }
            public string Email { get; set; }
            public string Password { get; set; }
        }

        public static List<UserAccount> UserRegistry = new List<UserAccount>();

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            // 1. Reset all error labels to hidden
            lblNameErr.Visible = lblEmailErr.Visible = lblPhoneErr.Visible = lblPassErr.Visible = false;

            bool isValid = true;

            // 2. Validate Name (Letters only, 3-30 chars)
            if (!Regex.IsMatch(txtName.Text.Trim(), @"^[a-zA-Z\s]{3,30}$"))
            {
                lblNameErr.Visible = true;
                isValid = false;
            }

            // 3. Validate Email
            if (!Regex.IsMatch(txtEmail.Text.Trim(), @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
            {
                lblEmailErr.Visible = true;
                isValid = false;
            }

            // 4. Validate Phone (Exactly 10 digits)
            if (!Regex.IsMatch(txtPhone.Text.Trim(), @"^[0-9]{10}$"))
            {
                lblPhoneErr.Visible = true;
                isValid = false;
            }

            // 5. Validate Password (Min 6 chars, at least one number)
            if (txtPass.Text.Length < 6 || !txtPass.Text.Any(char.IsDigit))
            {
                lblPassErr.Text = "Min 6 chars + 1 number";
                lblPassErr.Visible = true;
                isValid = false;
            }

            // 6. Check Password Match
            if (txtPass.Text != txtConfirmPass.Text)
            {
                lblPassErr.Text = "Passwords do not match!";
                lblPassErr.Visible = true;
                isValid = false;
            }

           
            if (isValid)
            {
                string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string q = "INSERT INTO Users (FullName, Email, Password, Phone) VALUES (@n, @e, @p, @ph)";
                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@n", txtName.Text.Trim());
                    cmd.Parameters.AddWithValue("@e", txtEmail.Text.Trim().ToLower());
                    cmd.Parameters.AddWithValue("@p", txtPass.Text);
                    cmd.Parameters.AddWithValue("@ph", txtPhone.Text.Trim());
                    con.Open();
                    cmd.ExecuteNonQuery();
                }
                Session["User"] = txtEmail.Text.Trim().ToLower();
                Response.Redirect("Home.aspx");
            }
        }
    
    }
}