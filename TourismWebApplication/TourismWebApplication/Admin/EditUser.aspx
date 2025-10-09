<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EditUser.aspx.cs" Inherits="TourismWebApplication.Admin.EditUser" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                <h5><i class="bi bi-pencil-fill me-2"></i>Edit User</h5>
            </div>
            <div class="card-body">
                <%
                    string userId = Request.QueryString["UserID"];
                    string name = "", email = "", phone = "", password = "";

                    if (!string.IsNullOrEmpty(userId))
                    {
                        string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
                        using (SqlConnection conn = new SqlConnection(connStr))
                        {
                            conn.Open();
                            SqlCommand cmd = new SqlCommand("SELECT Name, Email, Phone, PasswordHash FROM Users WHERE UserID=@UserID", conn);
                            cmd.Parameters.AddWithValue("@UserID", userId);
                            SqlDataReader reader = cmd.ExecuteReader();
                            if (reader.Read())
                            {
                                name = reader["Name"].ToString();
                                email = reader["Email"].ToString();
                                phone = reader["Phone"].ToString();
                                password = reader["PasswordHash"].ToString();
                            }
                            reader.Close();
                        }
                    }
                %>

                <form method="post" action="EditUserLogic.aspx?UserID=<%= userId %>">
                    <input type="hidden" name="UserID" value="<%= userId %>" />

                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" name="Name" class="form-control" value="<%= name %>" required />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="Email" class="form-control" value="<%= email %>" required readonly/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phone</label>
                        <input type="text" name="Phone" class="form-control" value="<%= phone %>" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="text" name="Password" class="form-control" value="<%= password %>" />
                    </div>

                    <button type="submit" class="btn btn-primary">Update User</button>
                    <a href="Users.aspx" class="btn btn-secondary">Cancel</a>
                </form>

                
            </div>
        </div>
    </div>

</asp:Content>

