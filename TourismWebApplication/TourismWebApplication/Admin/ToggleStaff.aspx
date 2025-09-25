<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ToggleStaff.aspx.cs" Inherits="TourismWebApplication.Admin.ToggleStaff" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <%
        string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;

        String id = Request.QueryString["StaffID"];
        String action = Request.QueryString["action"];
        String msg = "";
        String type = "error";

        if (!string.IsNullOrEmpty(id) && !string.IsNullOrEmpty(action))
        {
            int userId;
            if (int.TryParse(id, out userId))
            {
                bool newStatus = (action.ToLower() == "activate");

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(
                        "UPDATE Staff SET IsActive=@IsActive WHERE StaffID=@StaffID", conn);
                    cmd.Parameters.AddWithValue("@IsActive", newStatus);
                    cmd.Parameters.AddWithValue("@StaffID", userId);
                    cmd.ExecuteNonQuery();
                }

                msg = newStatus ? "Staff activated successfully" : "Staff deactivated successfully";
                type = "success";
            }
            else
            {
                msg = "Invalid StaffID";
            }
        }
        else
        {
            msg = "Missing parameters";
        }

        Response.Redirect("Staff.aspx?msg=" + Server.UrlEncode(msg) + "&type=" + type);
    %>
</body>
</html>

