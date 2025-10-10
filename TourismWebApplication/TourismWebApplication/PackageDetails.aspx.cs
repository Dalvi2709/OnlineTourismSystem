using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Runtime.Remoting.Messaging;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TourismWebApplication
{
    public partial class PackageDetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    int packageId;
                    if (int.TryParse(Request.QueryString["id"], out packageId))
                    {
                        LoadPackageDetails(packageId);
                        LoadAssignedStaff(packageId);
                    }
                    else
                    {
                        lblMessage.Text = "Invalid PackageID.";
                        lblMessage.Visible = true;
                    }
                }
                else
                {
                    lblMessage.Text = "No PackageID specified.";
                    lblMessage.Visible = true;
                }
            }
        }

        private void LoadPackageDetails(int packageId)
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"SELECT PackageID, Title, Description, Location, Price, AvailableSlots, 
                         ImageUrl, Audience, HotelName, HotelAddress, 
                         MapUrl, StartDate, EndDate, SourceDestination
                         FROM Packages
                         WHERE PackageID = @PackageID";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@PackageID", packageId);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    pnlPackage.Visible = true;

                    lblTitle.Text = reader["Title"].ToString();
                    lblPrice.Text = reader["Price"].ToString();
                    lblLocation.Text = reader["Location"].ToString();
                    lblDescription.Text = reader["Description"].ToString();
                    lblAudience.Text = reader["Audience"].ToString();
                    lblSlots.Text = reader["AvailableSlots"].ToString();

                    DateTime startDate = Convert.ToDateTime(reader["StartDate"]);
                    DateTime endDate = Convert.ToDateTime(reader["EndDate"]);
                    lblStartDate.Text = startDate.ToString("dd-MMM-yyyy");
                    lblEndDate.Text = endDate.ToString("dd-MMM-yyyy");


                    string imgUrl = reader["ImageUrl"].ToString();
                    imgPackage.ImageUrl = string.IsNullOrEmpty(imgUrl) ? "/assets/no-image.jpg" : imgUrl;

                    
                    // Source/Destination
                    lblSourceDest.Text = reader["SourceDestination"].ToString();

                    

                    // Status badge
                    lblStatus.Attributes["class"] = endDate < DateTime.Now ? "badge bg-danger mb-3" : "badge bg-success mb-3";
                    lblStatus.InnerText = endDate < DateTime.Now ? "Expired" : "Active";
                }
                else
                {
                    lblMessage.Text = "Invalid PackageID.";
                    lblMessage.Visible = true;
                }
            }
        }
        private void LoadAssignedStaff(int packageId)
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"SELECT s.Name, s.Role, s.Email, s.Phone, 
                                ps.AssignedRole, ps.AssignedDate
                         FROM PackageStaff ps
                         INNER JOIN Staff s ON ps.StaffID = s.StaffID
                         WHERE ps.PackageID = @PackageID";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@PackageID", packageId);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.HasRows)
                {
                    rptStaff.DataSource = reader;
                    rptStaff.DataBind();
                    lblNoStaff.Visible = false;
                }
                else
                {
                    lblNoStaff.Text = "<i class='bi bi-exclamation-circle me-1'></i>No staff assigned to this package.";
                    lblNoStaff.Visible = true;
                }

                reader.Close();
            }
        }


    }
}
