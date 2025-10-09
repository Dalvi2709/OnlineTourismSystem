<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddStaffLogic.aspx.cs" Inherits="TourismWebApplication.Admin.AddStaffLogic" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <%
        try
        {
            string name = Request.Form["name"];
            string email = Request.Form["email"];
            string role = Request.Form["role"];
            string phone = Request.Form["phone"];

            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "INSERT INTO Staff (Name, Email, Role, Phone, IsActive) VALUES (@Name, @Email, @Role, @Phone, 1)";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Role", role);
                    cmd.Parameters.AddWithValue("@Phone", string.IsNullOrEmpty(phone) ? (object)DBNull.Value : phone);

                    con.Open();
                    int rows = cmd.ExecuteNonQuery();

                    if (rows > 0)
                    {
                        Response.Redirect("Staff.aspx?msg=Staff%20Added%20Successfully&type=success");
                    }
                    else
                    {
                        Response.Redirect("AddStaff.aspx?msg=Failed%20to%20Add%20Staff&type=error");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            // Log the exception if needed
            // For now, just redirect with error message
            string errorMsg = Server.UrlEncode("Error: " + ex.Message);
            Response.Redirect("AddStaff.aspx?msg=" + errorMsg + "&type=error");
        }
    %>
</body>
</html>
