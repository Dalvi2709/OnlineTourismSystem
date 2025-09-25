<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditUserLogic.aspx.cs" Inherits="TourismWebApplication.Admin.EditUserLogic" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <%

        string con = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(con))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("UPDATE Users SET Name=@Name, Email=@Email, Phone=@Phone, PasswordHash=@Password WHERE UserID=@UserID", conn);
            cmd.Parameters.AddWithValue("@Name", Request.Params["Name"]);
            cmd.Parameters.AddWithValue("@Email", Request.Params["Email"]);
            cmd.Parameters.AddWithValue("@Phone", Request.Params["Phone"]);
            cmd.Parameters.AddWithValue("@Password", Request.Params["Password"]);
            long userId;
            cmd.Parameters.AddWithValue("@UserID", Request.QueryString["userId"]);
            cmd.ExecuteNonQuery();
        }
        Response.Redirect("Users.aspx?msg=User updated successfully&type=success");

    %>
</body>
</html>
