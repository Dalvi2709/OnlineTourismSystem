using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;


    namespace TourismWebApplication.Admin
    {
        public partial class EditPackage : System.Web.UI.Page
        {
            protected void Page_Load(object sender, EventArgs e)
            {
                string pkgId = Request.QueryString["PackageID"];
                if (string.IsNullOrEmpty(pkgId))
                {
                    Response.Redirect("Packages.aspx?msg=Invalid%20PackageID&type=error");
                    return;
                }

                string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // 1. Update Package Details
                    string title = Request.Form["title"];
                    string price = Request.Form["price"];
                    string location = Request.Form["location"];
                    string description = Request.Form["description"];
                    string audience = Request.Form["audience"];
                    string hotelName = Request.Form["hotelName"];
                    string hotelAddress = Request.Form["hotelAddress"];
                    string mapUrl = Request.Form["mapUrl"];
                    string startDate = Request.Form["startDate"];
                    string endDate = Request.Form["endDate"];
                    string sourceDest = Request.Form["sourceDest"];
                    string imageUrl = Request.Form["imageUrl"];

                    string updatePkgQuery = @"
                    UPDATE Packages
                    SET Title=@Title, Price=@Price, Location=@Location, Description=@Description, Audience=@Audience,
                        HotelName=@HotelName, HotelAddress=@HotelAddress, MapUrl=@MapUrl,
                        StartDate=@StartDate, EndDate=@EndDate, SourceDestination=@SourceDest, ImageUrl=@ImageUrl
                    WHERE PackageID=@PackageID";

                    using (SqlCommand cmd = new SqlCommand(updatePkgQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@Price", price);
                        cmd.Parameters.AddWithValue("@Location", location);
                        cmd.Parameters.AddWithValue("@Description", description ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@Audience", audience ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@HotelName", hotelName ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@HotelAddress", hotelAddress ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@MapUrl", mapUrl ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@StartDate", startDate);
                        cmd.Parameters.AddWithValue("@EndDate", endDate);
                        cmd.Parameters.AddWithValue("@SourceDest", sourceDest ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@ImageUrl", imageUrl ?? (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@PackageID", pkgId);

                        cmd.ExecuteNonQuery();
                    }

                    // 2. Update Assigned Roles for Existing Staff
                    SqlCommand getStaffCmd = new SqlCommand("SELECT PackageStaffID FROM PackageStaff WHERE PackageID=@PackageID", conn);
                    getStaffCmd.Parameters.AddWithValue("@PackageID", pkgId);
                    SqlDataReader staffReader = getStaffCmd.ExecuteReader();
                    while (staffReader.Read())
                    {
                        string psId = staffReader["PackageStaffID"].ToString();
                        string assignedRole = Request.Form["assignedRole_" + psId];
                        if (!string.IsNullOrEmpty(assignedRole))
                        {
                            SqlCommand updateRoleCmd = new SqlCommand("UPDATE PackageStaff SET AssignedRole=@AssignedRole WHERE PackageStaffID=@PSID", conn);
                            updateRoleCmd.Parameters.AddWithValue("@AssignedRole", assignedRole);
                            updateRoleCmd.Parameters.AddWithValue("@PSID", psId);
                            updateRoleCmd.ExecuteNonQuery();
                        }
                    }
                    staffReader.Close();

                    // 3. Add New Staff if selected
                    string newStaffID = Request.Form["newStaffID"];
                    string newAssignedRole = Request.Form["newAssignedRole"];

                    if (!string.IsNullOrEmpty(newStaffID) && !string.IsNullOrEmpty(newAssignedRole))
                    {
                        SqlCommand insertStaffCmd = new SqlCommand(
                            "INSERT INTO PackageStaff (PackageID, StaffID, AssignedRole, AssignedDate) VALUES (@PackageID, @StaffID, @AssignedRole, @AssignedDate)",
                            conn);
                        insertStaffCmd.Parameters.AddWithValue("@PackageID", pkgId);
                        insertStaffCmd.Parameters.AddWithValue("@StaffID", newStaffID);
                        insertStaffCmd.Parameters.AddWithValue("@AssignedRole", newAssignedRole);
                        insertStaffCmd.Parameters.AddWithValue("@AssignedDate", DateTime.Now);
                        insertStaffCmd.ExecuteNonQuery();
                    }

                    conn.Close();
                }

                Response.Redirect("Package.aspx?PackageID=" + pkgId + "&msg=Package%20Updated%20Successfully&type=success");
            }
        }
    }

