<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

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
            string title = Request.Form["title"];
            string desc = Request.Form["description"];
            string location = Request.Form["location"];
            string audience = Request.Form["audience"];
            string slots = Request.Form["availableslots"];
            string price = Request.Form["price"];
            string startdate = Request.Form["startdate"];
            string enddate = Request.Form["enddate"];
            string imageurl = Request.Form["imageurl"];
            string hotelname = Request.Form["hotelname"];
            string hoteladdress = Request.Form["hoteladdress"];
            string hotelimageurl = Request.Form["hotelimageurl"];
            string sourcedestination = Request.Form["sourcedestination"];
            string mapurl = Request.Form["mapurl"];

            DateTime sDate, eDate;
            if (!DateTime.TryParse(startdate, out sDate)) sDate = DateTime.Today;
            if (!DateTime.TryParse(enddate, out eDate)) eDate = DateTime.Today;

            int availableSlotsInt;
            int.TryParse(slots, out availableSlotsInt);

            decimal priceDecimal;
            decimal.TryParse(price, out priceDecimal);

            SqlCommand cmd = new SqlCommand(@"
                INSERT INTO Packages 
                    (Title, Description, Location, Audience, AvailableSlots, Price, StartDate, EndDate, ImageUrl, 
                     HotelName, HotelAddress, HotelImageUrl, SourceDestination, MapUrl)
                OUTPUT INSERTED.PackageID
                VALUES 
                    (@Title, @Description, @Location, @Audience, @AvailableSlots, @Price, @StartDate, @EndDate, @ImageUrl, 
                     @HotelName, @HotelAddress, @HotelImageUrl, @SourceDestination, @MapUrl)", con, trans);

            cmd.Parameters.AddWithValue("@Title", title);
            cmd.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(desc) ? (object)DBNull.Value : desc);
            cmd.Parameters.AddWithValue("@Location", location);
            cmd.Parameters.AddWithValue("@Audience", string.IsNullOrEmpty(audience) ? (object)DBNull.Value : audience);
            cmd.Parameters.AddWithValue("@AvailableSlots", availableSlotsInt);
            cmd.Parameters.AddWithValue("@Price", priceDecimal);
            cmd.Parameters.AddWithValue("@StartDate", sDate);
            cmd.Parameters.AddWithValue("@EndDate", eDate);
            cmd.Parameters.AddWithValue("@ImageUrl", string.IsNullOrEmpty(imageurl) ? (object)DBNull.Value : imageurl);
            cmd.Parameters.AddWithValue("@HotelName", string.IsNullOrEmpty(hotelname) ? (object)DBNull.Value : hotelname);
            cmd.Parameters.AddWithValue("@HotelAddress", string.IsNullOrEmpty(hoteladdress) ? (object)DBNull.Value : hoteladdress);
            cmd.Parameters.AddWithValue("@HotelImageUrl", string.IsNullOrEmpty(hotelimageurl) ? (object)DBNull.Value : hotelimageurl);
            cmd.Parameters.AddWithValue("@SourceDestination", string.IsNullOrEmpty(sourcedestination) ? (object)DBNull.Value : sourcedestination);
            cmd.Parameters.AddWithValue("@MapUrl", string.IsNullOrEmpty(mapurl) ? (object)DBNull.Value : mapurl);

            long packageId = Convert.ToInt64(cmd.ExecuteScalar());

            string[] selectedStaff = Request.Form.GetValues("staff");
            string[] allowedRoles = { "Guide", "Manager", "Driver", "Support", "Other" };

            if (selectedStaff != null)
            {
                foreach (string sid in selectedStaff)
                {
                    string role = Request.Form["role_" + sid];

                    if (string.IsNullOrEmpty(role) || Array.IndexOf(allowedRoles, role) == -1)
                    {
                        role = "Other";
                    }

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

            trans.Rollback();
            Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
        }
    }
%>
</body>
</html>
