using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;

namespace TourismWebApplication
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected string Message = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                string email = Request.Form["email"];
                if (!string.IsNullOrEmpty(email))
                {
                    ProcessForgotPassword(email);
                }
            }
        }

        private void ProcessForgotPassword(string email)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();
                string checkQuery = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
                SqlCommand cmd = new SqlCommand(checkQuery, con);
                cmd.Parameters.AddWithValue("@Email", email);

                int exists = (int)cmd.ExecuteScalar();

                if (exists > 0)
                {
                    string token = Guid.NewGuid().ToString();
                    DateTime expiry = DateTime.Now.AddHours(1);

                    string updateQuery = "UPDATE Users SET ResetToken=@Token, TokenExpiry=@Expiry WHERE Email=@Email";
                    SqlCommand updateCmd = new SqlCommand(updateQuery, con);
                    updateCmd.Parameters.AddWithValue("@Token", token);
                    updateCmd.Parameters.AddWithValue("@Expiry", expiry);
                    updateCmd.Parameters.AddWithValue("@Email", email);
                    updateCmd.ExecuteNonQuery();

                    string resetLink = $"{Request.Url.GetLeftPart(UriPartial.Authority)}/ResetPassword.aspx?token={token}";
                    SendResetEmail(email, resetLink);

                    Message = "Password reset link has been sent to your email.";
                }
                else
                {
                    Message = "Email not found in our records.";
                }
            }
        }

        private void SendResetEmail(string toEmail, string resetLink)
        {
            MailMessage mail = new MailMessage();
            mail.To.Add(toEmail);
            mail.From = new MailAddress("aadityakolhapure28@gmail.com");
            mail.Subject = "Password Reset Request";
            mail.Body = $"Click here to reset your password:\n{resetLink}";
            mail.IsBodyHtml = false;

            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.Credentials = new NetworkCredential("aadityakolhapure28@gmail.com", "hbri wqik ymhh ayjw");
            smtp.EnableSsl = true;
            smtp.Send(mail);
        }
    }
}
