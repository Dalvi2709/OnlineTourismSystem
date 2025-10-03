<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginLogic.aspx.cs" Inherits="TourismWebApplication.LoginLogic" %>


<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login Logic</title>
</head>
<body>
    <%
        string email = Request.Params["email"];
        string password = Request.Params["password"];

        using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString))
        {
            con.Open();
            SqlCommand cmd = new SqlCommand("SELECT * FROM Users WHERE Email=@Email AND PasswordHash=@Password AND IsActive=1", con);
            cmd.Parameters.AddWithValue("@Email", email);
            cmd.Parameters.AddWithValue("@Password", password);

            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.HasRows)
            {
                reader.Read();
                Session["UserId"] = reader["UserID"];

                Session["UserEmail"] = reader["Email"].ToString();
                Session["name"] = reader["Name"].ToString();
                Session["Role"] = reader["Role"].ToString();
                Session["phone"] = reader["Phone"].ToString();

                if (reader["Role"].ToString() == "Admin")
                {
                    Response.Redirect("Admin/Dashboard.aspx?msg=Login%20Successfully&type=success");

                }
                else
                {
                    Response.Redirect("index.aspx?msg=Login%20Successfully&type=success");
                }

            }
            else
            {
                Response.Redirect("Login.aspx?msg=Invalid%20Email%20or%20Password&type=error");
            }
        }

    %>
</body>
</html>

