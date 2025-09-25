<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ToggleUsers.aspx.cs" Inherits="TourismWebApplication.Admin.TOggleUsers" %>

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

        String id = Request.QueryString["UserId"];
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
                        "UPDATE Users SET IsActive=@IsActive WHERE UserID=@UserID", conn);
                    cmd.Parameters.AddWithValue("@IsActive", newStatus);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.ExecuteNonQuery();
                }

                msg = newStatus ? "User activated successfully" : "User deactivated successfully";
                type = "success";
            }
            else
            {
                msg = "Invalid UserID";
            }
        }
        else
        {
            msg = "Missing parameters";
        }

        Response.Redirect("Users.aspx?msg=" + Server.UrlEncode(msg) + "&type=" + type);
    %>
</body>
</html>
