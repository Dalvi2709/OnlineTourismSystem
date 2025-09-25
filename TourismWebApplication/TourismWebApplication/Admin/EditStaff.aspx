<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EditStaff.aspx.cs" Inherits="TourismWebApplication.Admin.EditStaff" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-4">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                <h5><i class="bi bi-pencil-fill me-2"></i>Edit Staff</h5>
            </div>
            <div class="card-body">
                <%
                    string staffId = Request.QueryString["StaffID"];
                    string name = "", email = "", phone = "", role = "";

                    if (!string.IsNullOrEmpty(staffId))
                    {
                        string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
                        using (SqlConnection conn = new SqlConnection(connStr))
                        {
                            conn.Open();
                            SqlCommand cmd = new SqlCommand("SELECT Name, Email, Phone, Role FROM Staff WHERE StaffID=@StaffID", conn);
                            cmd.Parameters.AddWithValue("@StaffID", staffId);
                            SqlDataReader reader = cmd.ExecuteReader();
                            if (reader.Read())
                            {
                                name = reader["Name"].ToString();
                                email = reader["Email"].ToString();
                                phone = reader["Phone"].ToString();
                                role = reader["Role"].ToString();
                            }
                            reader.Close();
                        }
                    }
                %>

                <form method="post" action="EditStaffLogic.aspx?StaffID=<%= staffId %>">
                    <input type="hidden" name="StaffID" value="<%= staffId %>" />

                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <input type="text" name="Name" class="form-control" value="<%= name %>" required />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" name="Email" class="form-control" value="<%= email %>" required />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Phone</label>
                        <input type="text" name="Phone" class="form-control" value="<%= phone %>" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Role</label>
                        <select name="Role" class="form-control" required>
                            <option value="">-- Select Role --</option>
                            <option value="Guide" <%= role == "Guide" ? "selected" : "" %>>Guide</option>
                            <option value="Manager" <%= role == "Manager" ? "selected" : "" %>>Manager</option>
                            <option value="Driver" <%= role == "Driver" ? "selected" : "" %>>Driver</option>
                            <option value="Support" <%= role == "Support" ? "selected" : "" %>>Support</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary">Update Staff</button>
                    <a href="Staff.aspx" class="btn btn-secondary">Cancel</a>
                </form>

            </div>
        </div>
    </div>

</asp:Content>
