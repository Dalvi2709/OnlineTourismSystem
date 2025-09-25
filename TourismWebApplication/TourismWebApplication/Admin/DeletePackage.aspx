<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DeletePackage.aspx.cs" Inherits="TourismWebApplication.Admin.DeletePackage" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <% 
        string pkgId = Request.QueryString["PackageID"];

        if (string.IsNullOrEmpty(pkgId))
        {
            Response.Redirect("Packages.aspx?msg=Invalid%20Package%20ID&type=error");
            return;
        }

        string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();

            SqlCommand deleteStaffCmd = new SqlCommand("DELETE FROM PackageStaff WHERE PackageID=@PackageID", conn);
            deleteStaffCmd.Parameters.AddWithValue("@PackageID", pkgId);
            deleteStaffCmd.ExecuteNonQuery();

            SqlCommand deleteBookingsCmd = new SqlCommand("DELETE FROM Bookings WHERE PackageID=@PackageID", conn);
            deleteBookingsCmd.Parameters.AddWithValue("@PackageID", pkgId);
            deleteBookingsCmd.ExecuteNonQuery();

            // Delete the package
            SqlCommand cmd = new SqlCommand("DELETE FROM Packages WHERE PackageID=@PackageID", conn);
            cmd.Parameters.AddWithValue("@PackageID", pkgId);
            int rows = cmd.ExecuteNonQuery();

            if (rows > 0)
                Response.Redirect("Packages.aspx?msg=Package%20Deleted%20Successfully&type=success");
            else
                Response.Redirect("Packages.aspx?msg=Package%20Not%20Found&type=error");
        }
    %>
</body>
</html>
