<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditStaffLogic.aspx.cs" Inherits="TourismWebApplication.Admin.EditStaffLogic" %>

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
            SqlCommand cmd = new SqlCommand("UPDATE Staff SET Name=@Name, Email=@Email, Phone=@Phone, ROle=@Role WHERE StaffID=@StaffID", conn);
            cmd.Parameters.AddWithValue("@Name", Request.Params["Name"]);
            cmd.Parameters.AddWithValue("@Email", Request.Params["Email"]);
            cmd.Parameters.AddWithValue("@Phone", Request.Params["Phone"]);
            cmd.Parameters.AddWithValue("@Role", Request.Params["Role"]);
            long userId;
            cmd.Parameters.AddWithValue("@StaffID", Request.QueryString["StaffID"]);
            cmd.ExecuteNonQuery();
        }
        Response.Redirect("Staff.aspx?msg=Staff updated successfully&type=success");

    %>
</body>
</html>
