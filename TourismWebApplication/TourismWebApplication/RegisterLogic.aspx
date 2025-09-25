<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegisterLogic.aspx.cs" Inherits="TourismWebApplication.RegisterLogic" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <%
        String name = Request.Params["name"];
        String email = Request.Params["email"];
        String phone = Request.Params["phone"];
        String password = Request.Params["password"];
        String r = "Customer";

       
        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString))
        {
            con.Open();

            SqlCommand cmd = new SqlCommand(@"INSERT INTO Users (Name, Email, PasswordHash, Role, Phone) VALUES (@name, @email, @password, @role, @phone)", con);

            cmd.Parameters.AddWithValue("@name", name);
            cmd.Parameters.AddWithValue("@email", email);
            cmd.Parameters.AddWithValue("@password", password);
            cmd.Parameters.AddWithValue("@role", r);
            cmd.Parameters.AddWithValue("@phone", phone);

            int rows = cmd.ExecuteNonQuery();

            if (rows > 0)
            {
                Response.Redirect("Login.aspx?msg=Register%20Successfully&type=success");
            }
            else
            {
                Response.Redirect("Register.aspx?msg=Register%20Unsuccessfully&type=error");
            }
        }
    %>
</body>
</html>
