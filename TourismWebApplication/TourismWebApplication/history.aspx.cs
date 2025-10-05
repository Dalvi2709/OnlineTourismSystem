using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace TourismWebApplication.Customer
{
    public partial class history : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserEmail"] != null)
                {
                    pnlNotLoggedIn.Visible = false;
                    pnlLoggedIn.Visible = true;
                    LoadUserHistory(Session["UserEmail"].ToString());
                }
                else
                {
                    pnlNotLoggedIn.Visible = true;
                    pnlLoggedIn.Visible = false;
                    LoadPopularPackages(); // Optional dynamic content for guests
                }
            }
        }

        private void LoadUserHistory(string userEmail)
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        b.BookingID, 
                        p.Title, 
                        p.Location, 
                        b.BookingDate, 
                        b.TravelDate, 
                        b.Status, 
                        b.PaymentStatus, 
                        p.ImageUrl AS PackageImage
                    FROM Bookings b
                    INNER JOIN Packages p ON b.PackageID = p.PackageID
                    INNER JOIN Users u ON b.UserID = u.UserID
                    WHERE u.Email = @Email
                    ORDER BY b.BookingDate DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Email", userEmail);

                DataTable dt = new DataTable();
                try
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);

                    rptHistory.DataSource = dt;
                    rptHistory.DataBind();

                    lblMessage.Text = dt.Rows.Count == 0
                        ? "No bookings found in your history."
                        : "Showing your personal booking history.";
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error loading history: " + ex.Message;
                }
            }
        }

        private void LoadPopularPackages()
        {
            // Optional: populate images for guests dynamically from Packages table
            // For simplicity, we are using static images in pnlNotLoggedIn
        }
    }
}
