<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Staff.aspx.cs" Inherits="TourismWebApplication.Admin.Staff" %>

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

        /* Search bar style */
        .search-box {
            max-width: 350px;
        }
    </style>

    <div class="container-fluid mt-4">
        <h3 class="mb-4"><i class="bi bi-people-fill me-2"></i>Manage Staff</h3>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <a href="AddStaff.aspx" class="btn btn-success shadow-sm">
                <i class="bi bi-person-plus-fill me-1"></i>Add New Staff
            </a>

            <div class="search-box">
                <input type="text" id="searchInput" class="form-control shadow-sm" placeholder="Search staff... (Name, Email, Phone)">
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-body">
                <div class="scrollable-table">
                    <table id="staffTable" class="table table-modern table-striped table-bordered align-middle">
                        <thead>
                            <tr>
                                <th><i class="bi bi-hash"></i>Staff ID</th>
                                <th><i class="bi bi-person-fill"></i>Name</th>


                                <th><i class="bi bi-envelope-fill"></i>Email</th>
                                <th><i class="bi bi-telephone-fill"></i>Phone</th>
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
                                    SqlCommand cmd = new SqlCommand("SELECT StaffID, Name, Email, Phone, IsActive FROM Staff ORDER BY StaffID ASC", conn);
                                    SqlDataReader reader = cmd.ExecuteReader();
                                    while (reader.Read())
                                    {
                                        int staffId = Convert.ToInt32(reader["StaffID"]);
                                        string name = reader["Name"].ToString();
                                        string email = reader["Email"].ToString();
                                        string phone = reader["Phone"].ToString();
                                        bool isActive = Convert.ToBoolean(reader["IsActive"]);
                            %>
                            <tr>
                                <td><%= staffId %></td>
                                <td><%= name %></td>
                                <td><%= email %></td>
                                <td><%= phone %></td>
                                <td>





                                    <% if (isActive) { %>
                                    <span class="badge bg-success"><i class="bi bi-check-circle"></i>Active</span>
                                    <% } else { %>
                                    <span class="badge bg-danger"><i class="bi bi-x-circle"></i>Inactive</span>
                                    <% } %>
                                </td>
                                <td>
                                    <a href="EditStaff.aspx?StaffID=<%= staffId %>" class="btn btn-primary btn-sm action-btn">
                                        <i class="bi bi-pencil-fill"></i>
                                    </a>
                                    <% if (isActive) { %>
                                    <a href="ToggleStaff.aspx?StaffID=<%= staffId %>&action=deactivate" class="btn btn-danger btn-sm action-btn">
                                        <i class="bi bi-person-dash-fill"></i>
                                    </a>
                                    <% } else { %>
                                    <a href="ToggleStaff.aspx?StaffID=<%= staffId %>&action=activate" class="btn btn-success btn-sm action-btn">
                                        <i class="bi bi-person-check-fill"></i>
                                    </a>
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                    } 
                                    reader.Close();
                                }
                            %>
                        </tbody>
                    </table>






                </div>
            </div>
        </div>
    </div>

    <!-- Search Script -->
    <script>
        document.getElementById("searchInput").addEventListener("keyup", function () {
            let filter = this.value.toLowerCase();
            let rows = document.querySelectorAll("#staffTable tbody tr");

            rows.forEach(row => {
                let text = row.innerText.toLowerCase();
                row.style.display = text.includes(filter) ? "" : "none";
            });
        });
    </script>

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
    <% if (!string.IsNullOrEmpty(msg)) { %>
    <div class="alert <%= alertClass %> alert-dismissible fade show position-fixed bottom-0 end-0 m-3 z-25" role="alert" style="min-width: 250px;">
        <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>
</asp:Content>
