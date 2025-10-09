<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add Package Logic</title>
</head>
<body>
<%
    string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;

    using (SqlConnection con = new SqlConnection(connStr))
    {
        con.Open();
        SqlTransaction trans = con.BeginTransaction();

        try
        {
            // Retrieve form fields safely (avoid null reference errors)
            string title = Request.Form["title"] ?? "";
            string desc = Request.Form["description"] ?? "";
            string location = Request.Form["location"] ?? "";
            string audience = Request.Form["audience"] ?? "";
            string slots = Request.Form["availableslots"] ?? "0";
            string price = Request.Form["price"] ?? "0";
            string startdate = Request.Form["startdate"] ?? DateTime.Today.ToString();
            string enddate = Request.Form["enddate"] ?? DateTime.Today.ToString();
            string imageurl = Request.Form["imageurl"] ?? "";
            string sourcedestination = Request.Form["sourcedestination"] ?? "";
            

            // Type conversions with fallback defaults
            DateTime sDate, eDate;
            DateTime.TryParse(startdate, out sDate);
            DateTime.TryParse(enddate, out eDate);

            int availableSlotsInt;
            int.TryParse(slots, out availableSlotsInt);

            decimal priceDecimal;
            decimal.TryParse(price, out priceDecimal);

            // SQL Insert for Package
            SqlCommand cmd = new SqlCommand(@"
                INSERT INTO Packages 
                    (Title, Description, Location, Audience, AvailableSlots, Price, StartDate, EndDate, ImageUrl, 
                      SourceDestination)
                OUTPUT INSERTED.PackageID
                VALUES 
                    (@Title, @Description, @Location, @Audience, @AvailableSlots, @Price, @StartDate, @EndDate, @ImageUrl, 
                     @SourceDestination)", con, trans);

            // Add parameters safely
            cmd.Parameters.AddWithValue("@Title", title);
            cmd.Parameters.AddWithValue("@Description", (object)desc ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@Location", (object)location ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@Audience", (object)audience ?? DBNull.Value);
            cmd.Parameters.AddWithValue("@AvailableSlots", availableSlotsInt);
            cmd.Parameters.AddWithValue("@Price", priceDecimal);
            cmd.Parameters.AddWithValue("@StartDate", sDate);
            cmd.Parameters.AddWithValue("@EndDate", eDate);
            cmd.Parameters.AddWithValue("@ImageUrl", (object)imageurl ?? DBNull.Value);

            cmd.Parameters.AddWithValue("@SourceDestination", (object)sourcedestination ?? DBNull.Value);

            long packageId = Convert.ToInt64(cmd.ExecuteScalar());

            string[] selectedStaff = Request.Form.GetValues("staff");
            string[] allowedRoles = { "Guide", "Manager", "Driver", "Support", "Other" };

            if (selectedStaff != null)
            {
                foreach (string sid in selectedStaff)
                {
                    string role = Request.Form["role_" + sid] ?? "Other";

                    if (Array.IndexOf(allowedRoles, role) == -1)
                        role = "Other";

                    SqlCommand staffCmd = new SqlCommand(@"
                        INSERT INTO PackageStaff (PackageID, StaffID, AssignedRole)
                        VALUES (@PackageID, @StaffID, @Role)", con, trans);

                    staffCmd.Parameters.AddWithValue("@PackageID", packageId);
                    staffCmd.Parameters.AddWithValue("@StaffID", Convert.ToInt64(sid));
                    staffCmd.Parameters.AddWithValue("@Role", role);

                    staffCmd.ExecuteNonQuery();
                }
            }

            trans.Commit();

            Response.Redirect("Packages.aspx?msg=Package Added Successfully&type=success", false);
        }
        catch (Exception ex)
        {
            try
            {
                trans.Rollback();
            }
            catch { /* ignore rollback errors */ }

            // Log the detailed error to a file for debugging (optional)
            string logPath = Server.MapPath("~/App_Data/ErrorLog.txt");
            System.IO.File.AppendAllText(logPath, 
                $"[{DateTime.Now}] Error while adding package: {ex.Message}\n{ex.StackTrace}\n\n");

            Response.Write("<script>alert('Something went wrong while adding the package. Please try again later.');</script>");
        }
    }
%>
</body>
</html>
