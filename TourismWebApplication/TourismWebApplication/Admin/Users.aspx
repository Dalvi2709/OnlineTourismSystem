<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="TourismWebApplication.Admin.Users" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        .table-modern th {
            background-color: #343a40;
            color: #fff;
        }

        .table-modern tbody tr:hover {
            background-color: #f1f1f1;
        }

        .action-btn {
            margin-right: 5px;
        }
    </style>

    <!-- Page HTML -->
    <div class="container-fluid mt-4">
        <h3 class="mb-4"><i class="bi bi-people-fill me-2"></i>Manage Users</h3>

        <div class="mb-3">
            <a href="AddUsers.aspx" class="btn btn-success shadow-sm"><i class="bi bi-person-plus-fill me-1"></i>Add New User</a>
        </div>

        <div class="card shadow-sm">
            <div class="card-body">
                <div class="scrollable-table">
                    <table class="table table-modern table-striped table-bordered align-middle">
                        <thead>
                            <tr>
                                <th><i class="bi bi-hash"></i>User ID</th>
                                <th><i class="bi bi-person-fill"></i>Name</th>
                                <th><i class="bi bi-envelope-fill"></i>Email</th>
                                <th><i class="bi bi-telephone-fill"></i>Phone</th>
                                <th><i class="bi bi-shield-lock-fill"></i>Password</th>
                                <th><i class="bi bi-toggle-on"></i>Status</th>
                                <th><i class="bi bi-gear-fill"></i>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
                                using (SqlConnection conn = new SqlConnection(connStr))
                                {
                                    conn.Open();
                                    SqlCommand cmd = new SqlCommand("SELECT UserID, Name, Email, Phone, PasswordHash, IsActive FROM Users WHERE Role = 'Customer' ORDER BY UserID DESC", conn);
                                    SqlDataReader reader = cmd.ExecuteReader();
                                    while (reader.Read())
                                    {
                                        int userId = Convert.ToInt32(reader["UserID"]);
                                        string name = reader["Name"].ToString();
                                        string email = reader["Email"].ToString();
                                        string phone = reader["Phone"].ToString();
                                        string password = reader["PasswordHash"].ToString();
                                        bool isActive = Convert.ToBoolean(reader["IsActive"]);
                            %>
                            <tr>
                                <td><%= userId %></td>
                                <td><%= name %></td>
                                <td><%= email %></td>
                                <td><%= phone %></td>
                                <td><%= password %></td>
                                <td>
                                    <% if (isActive)
                                    { %>
                                    <span class="badge bg-success"><i class="bi bi-check-circle"></i>Active</span>
                                    <% }
                                    else
                                    { %>
                                    <span class="badge bg-danger"><i class="bi bi-x-circle"></i>Inactive</span>
                                    <% } %>
                                </td>
                                <td>
                                    <a href="EditUser.aspx?UserID=<%= userId %>"
                                        class="btn btn-primary btn-sm action-btn">
                                        <i class="bi bi-pencil-fill"></i>
                                    </a>

                                    <% if (isActive)
                                    { %>
                                    <a href="ToggleUsers.aspx?UserID=<%= userId %>&action=deactivate" class="btn btn-danger btn-sm action-btn">
                                        <i class="bi bi-person-dash-fill"></i>
                                    </a>
                                    <% }
                                    else
                                    { %>
                                    <a href="ToggleUsers.aspx?UserID=<%= userId %>&action=activate" class="btn btn-success btn-sm action-btn">
                                        <i class="bi bi-person-check-fill"></i>
                                    </a>
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                    } // while
                                    reader.Close();
                                } // using
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>


    <!-- Toast Alert -->
    <%
        string msg = Request.QueryString["msg"];
        string type = Request.QueryString["type"];
        string alertClass = "";
        if (!string.IsNullOrEmpty(type))
        {
            if (type == "success") alertClass = "alert-success";
            else if (type == "error") alertClass = "alert-danger";
        }
    %>
    <% if (!string.IsNullOrEmpty(msg))
        { %>
    <div class="alert <%= alertClass %> alert-dismissible fade show position-fixed bottom-0 end-0 m-3 z-25" role="alert" style="min-width: 250px;">
        <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>
</asp:Content>
