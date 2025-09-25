<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddUsersLogic.aspx.cs" Inherits="TourismWebApplication.Admin.AddUsersLogic" %>


<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <%

        string name = Request.Form["name"];
        string email = Request.Form["email"];
        string password = Request.Form["password"];
        string role = Request.Form["role"];
        string phone = Request.Form["phone"];


        string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
        using (SqlConnection con = new SqlConnection(connStr))
        {
            string query = "INSERT INTO Users (Name, Email, PasswordHash, Role, Phone, IsActive) VALUES (@Name, @Email, @Password, @Role, @Phone, 1)";
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Password", password);
                cmd.Parameters.AddWithValue("@Role", role);
                cmd.Parameters.AddWithValue("@Phone", phone ?? (object)DBNull.Value);

                con.Open();
                int rows = cmd.ExecuteNonQuery();

                if (rows > 0)
                {
                    Response.Redirect("AddUsers.aspx?msg=User%20Added%20Successfully&type=success");
                }
                else
                {
                    Response.Redirect("AddUsers.aspx?msg=User%20Added%20Successfully&type=success");
                }
            }
        }


    %>
</body>
</html>
