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
                    LoadPopularPackages(); // Optional for guest view
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
                        p.Title AS PackageTitle,
                        p.Location, 
                        b.BookingDate, 
                        b.TravelDate, 
                        b.Status, 
                        b.PaymentStatus, 
                        ISNULL(p.ImageUrl, '~/images/default-package.jpg') AS PackageImage
                    FROM Bookings b
                    INNER JOIN Packages p ON b.PackageID = p.PackageID
                    INNER JOIN Users u ON b.UserID = u.UserID
                    WHERE u.Email = @Email
                    ORDER BY b.BookingDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", userEmail);

                    try
                    {
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        rptHistory.DataSource = dt;
                        rptHistory.DataBind();

                        lblMessage.Text = dt.Rows.Count == 0
                            ? "You have no previous bookings."
                            : "Here’s your booking history:";
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = "Error loading booking history. Please try again later.";
                        // Optional: log error (e.g., using Elmah or custom logger)
                        System.Diagnostics.Debug.WriteLine(ex.Message);
                    }
                }
            }
        }

        private void LoadPopularPackages()
        {
            // Optional: Load top 3 or 5 most booked packages for guest view
            // Example:
            /*
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT TOP 3 Title, ImageUrl FROM Packages ORDER BY NEWID()"; // random 3
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptPopular.DataSource = dt;
                rptPopular.DataBind();
            }
            */
        }
    }
}
