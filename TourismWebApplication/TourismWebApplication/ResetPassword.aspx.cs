using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace TourismWebApplication
{
    public partial class ResetPassword : System.Web.UI.Page
    {
        protected string Message = "";
        protected string Token = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                string t = Request.Form["token"];
                string newPass = Request.Form["newPassword"];
                ResetUserPassword(t, newPass);
            }
            else
            {
                Token = Request.QueryString["token"];
            }
        }

        private void ResetUserPassword(string token, string newPass)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                string query = "SELECT Email FROM Users WHERE ResetToken=@Token AND TokenExpiry > GETDATE()";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Token", token);
                var email = cmd.ExecuteScalar() as string;

                if (email != null)
                {
                    string update = "UPDATE Users SET PasswordHash=@Password, ResetToken=NULL, TokenExpiry=NULL WHERE Email=@Email";
                    SqlCommand updateCmd = new SqlCommand(update, con);
                    updateCmd.Parameters.AddWithValue("@Password", newPass);
                    updateCmd.Parameters.AddWithValue("@Email", email);
                    updateCmd.ExecuteNonQuery();

                    Message = "Password reset successfully!";
                    Response.Redirect("Index.aspx");
                }
                else
                {
                    Message = "Invalid or expired token.";
                }
            }
        }
    }
}
