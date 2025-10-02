using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;

namespace TourismWebApplication.Customer
{

    public partial class Profile : System.Web.UI.Page

    {
        string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserEmail"] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                LoadUserData();
            }
        }

        private void LoadUserData()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT Name, Email, Phone FROM Users WHERE Email=@Email";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Email", Session["UserEmail"].ToString());
                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    txtName.Text = dr["Name"].ToString();
                    txtEmail.Text = dr["Email"].ToString();
                    txtPhone.Text = dr["Phone"].ToString();
                }
            }
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (txtPassword.Text != "" && txtPassword.Text != txtConfirmPassword.Text)
            {
                lblMessage.CssClass = "text-danger";
                lblMessage.Text = "Passwords do not match!";
                return;
            }

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query;

                // If password field is filled, update password as well
                if (!string.IsNullOrEmpty(txtPassword.Text))
                {
                    query = "UPDATE Users SET Name=@Name, Phone=@Phone, PasswordHash=@Password WHERE Email=@Email";
                }
                else
                {
                    query = "UPDATE Users SET Name=@Name, Phone=@Phone WHERE Email=@Email";
                }

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Name", txtName.Text);
                cmd.Parameters.AddWithValue("@Phone", txtPhone.Text);
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text);

                if (!string.IsNullOrEmpty(txtPassword.Text))
                {
                    // Storing as plain text (⚠️ not secure, just for demo as you requested)
                    cmd.Parameters.AddWithValue("@Password", txtPassword.Text);
                }

                con.Open();
                int rows = cmd.ExecuteNonQuery();

                if (rows > 0)
                {
                    lblMessage.CssClass = "text-success";
                    lblMessage.Text = "Profile updated successfully!";
                }
                else
                {
                    lblMessage.CssClass = "text-danger";
                    lblMessage.Text = "Error updating profile.";
                }
            }
        }
    }
}