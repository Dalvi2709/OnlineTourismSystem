<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddUsersLogic.aspx.cs" Inherits="TourismWebApplication.Admin.AddUsersLogic" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add User Logic</title>
</head>
<body>
    <%
        try
        {
            string name = Request.Form["name"];
            string email = Request.Form["email"];
            string password = Request.Form["password"];
            string role = Request.Form["role"];
            string phone = Request.Form["phone"];

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(role) || string.IsNullOrEmpty(phone))
            {
                // Redirect if any field is empty
                Response.Redirect("AddUsers.aspx?msg=Please%20fill%20all%20fields&type=error");
            }

            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "INSERT INTO Users (Name, Email, PasswordHash, Role, Phone, IsActive) VALUES (@Name, @Email, @Password, @Role, @Phone, 1)";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password); // Consider hashing for production
                    cmd.Parameters.AddWithValue("@Role", role);
                    cmd.Parameters.AddWithValue("@Phone", phone ?? (object)DBNull.Value);

                    con.Open();
                    int rows = cmd.ExecuteNonQuery();

                    if (rows > 0)
                    {
                        Response.Redirect("AddUsers.aspx?msg=User%20Added%20Successfully&type=success",false);
                        Context.ApplicationInstance.CompleteRequest();
                    }
                    else
                    {
                        Response.Redirect("AddUsers.aspx?msg=Failed%20to%20add%20user&type=error",false);
                        Context.ApplicationInstance.CompleteRequest();
                    }
                }
            }
        }
        catch (SqlException ex)
        {
            // Handle SQL errors
            Response.Redirect("AddUsers.aspx?msg=Data Already exist!!" +"&type=error",false);
            Context.ApplicationInstance.CompleteRequest();
        }
        catch (Exception ex)
        {
            // Handle other errors
            Response.Redirect("AddUsers.aspx?msg=Error:%20" + Server.UrlEncode(ex.Message) + "&type=error",false);
            Context.ApplicationInstance.CompleteRequest();
        }
    %>
</body>
</html>
