<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="EditPackage.aspx.cs" Inherits="TourismWebApplication.Admin.EditPackage" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-5">
        <div class="card shadow p-4">
            <h3 class="mb-4">Edit Package</h3>

            <form method="post" action="EitPackageLogic.aspx?PackageID=<%= Request.QueryString["PackageID"] %>">
                <%
                    string pkgId = Request.QueryString["PackageID"];
                    if(!string.IsNullOrEmpty(pkgId))
                    {
                        string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
                        using(SqlConnection conn = new SqlConnection(connStr))
                        {
                            conn.Open();
                            SqlCommand cmd = new SqlCommand("SELECT * FROM Packages WHERE PackageID=@PackageID", conn);
                            cmd.Parameters.AddWithValue("@PackageID", pkgId);
                            SqlDataReader reader = cmd.ExecuteReader();
                            if(reader.Read())
                            {
                                string title = reader["Title"].ToString();
                                string price = reader["Price"].ToString();
                                string location = reader["Location"].ToString();
                                string description = reader["Description"].ToString();
                                string audience = reader["Audience"].ToString();
                                string hotelName = reader["HotelName"].ToString();
                                string hotelAddress = reader["HotelAddress"].ToString();
                                string mapUrl = reader["MapUrl"].ToString();
                                string startDate = Convert.ToDateTime(reader["StartDate"]).ToString("yyyy-MM-dd");
                                string endDate = Convert.ToDateTime(reader["EndDate"]).ToString("yyyy-MM-dd");
                                string sourceDest = reader["SourceDestination"].ToString();
                                string image = reader["ImageUrl"].ToString();
                %>

                <!-- Package Details -->
                <div class="mb-3">
                    <label class="form-label">Title</label>
                    <input type="text" name="title" class="form-control" value="<%= title %>" required />
                </div>

                <div class="mb-3">
                    <label class="form-label">Price (₹)</label>
                    <input type="number" step="0.01" name="price" class="form-control" value="<%= price %>" required />
                </div>

                <div class="mb-3">
                    <label class="form-label">Location</label>
                    <input type="text" name="location" class="form-control" value="<%= location %>" required />
                </div>

                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" rows="3"><%= description %></textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">Audience</label>
                    <input type="text" name="audience" class="form-control" value="<%= audience %>" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Hotel Name</label>
                    <input type="text" name="hotelName" class="form-control" value="<%= hotelName %>" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Hotel Address</label>
                    <input type="text" name="hotelAddress" class="form-control" value="<%= hotelAddress %>" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Map URL</label>
                    <input type="text" name="mapUrl" class="form-control" value="<%= mapUrl %>" />
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Start Date</label>
                        <input type="date" name="startDate" class="form-control" value="<%= startDate %>" required />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">End Date</label>
                        <input type="date" name="endDate" class="form-control" value="<%= endDate %>" required />
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Source / Destination</label>
                    <input type="text" name="sourceDest" class="form-control" value="<%= sourceDest %>" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Image URL</label>
                    <input type="text" name="imageUrl" class="form-control" value="<%= image %>" />
                </div>

                <!-- Staff Management -->
                <div class="card shadow-sm p-3 mb-3">
                    <h5 class="mb-3 text-primary">Assigned Staff</h5>
                    <%
                        SqlCommand staffCmd = new SqlCommand(@"
                            SELECT ps.PackageStaffID, s.StaffID, s.Name, s.Email, s.Phone, s.Role, ps.AssignedRole
                            FROM PackageStaff ps
                            INNER JOIN Staff s ON ps.StaffID = s.StaffID
                            WHERE ps.PackageID=@PackageID", conn);

                        staffCmd.Parameters.AddWithValue("@PackageID", pkgId);
                        SqlDataReader staffReader = staffCmd.ExecuteReader();

                        if(staffReader.HasRows)
                        {
                    %>
                    <table class="table table-bordered table-striped">
                        <thead class="table-light">
                            <tr>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Staff Role</th>
                                <th>Assigned Role</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            while(staffReader.Read())
                            {
                        %>
                            <tr>
                                <td><%= staffReader["Name"] %></td>
                                <td><%= staffReader["Email"] %></td>
                                <td><%= staffReader["Phone"] %></td>
                                <td><%= staffReader["Role"] %></td>
                                <td>
                                    <input type="text" class="form-control" name="assignedRole_<%= staffReader["PackageStaffID"] %>" value="<%= staffReader["AssignedRole"] %>" />
                                </td>
                                <td>
                                    <a href="RemoveStaffFromPackage.aspx?PackageStaffID=<%= staffReader["PackageStaffID"] %>&PackageID=<%= pkgId %>" class="btn btn-sm btn-danger">
                                        Remove
                                    </a>
                                </td>
                            </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                    <%
                        }
                        staffReader.Close();
                    %>

                    <div class="mt-3">
                        <label class="form-label">Add Staff</label>
                        <select class="form-select mb-2" name="newStaffID">
                            <option value="">Select Staff</option>
                            <%
                                SqlCommand staffListCmd = new SqlCommand("SELECT StaffID, Name, Role FROM Staff WHERE StaffID NOT IN (SELECT StaffID FROM PackageStaff WHERE PackageID=@PackageID)", conn);
                                staffListCmd.Parameters.AddWithValue("@PackageID", pkgId);
                                SqlDataReader staffListReader = staffListCmd.ExecuteReader();
                                while(staffListReader.Read())
                                {
                            %>
                                <option value="<%= staffListReader["StaffID"] %>"><%= staffListReader["Name"] %> (<%= staffListReader["Role"] %>)</option>
                            <%
                                }
                                staffListReader.Close();
                            %>
                        </select>
                        <input type="text" class="form-control" name="newAssignedRole" placeholder="Assigned Role for New Staff" />
                    </div>
                </div>

                <button type="submit" class="btn btn-primary">Update Package</button>
                <a href="Packages.aspx" class="btn btn-secondary">Cancel</a>

                <%
                            }
                            reader.Close();
                        }
                    }
                %>
            </form>
        </div>
    </div>
</asp:Content>

