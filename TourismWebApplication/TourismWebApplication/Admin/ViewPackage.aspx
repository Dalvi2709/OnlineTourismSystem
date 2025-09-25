<%@ Page Title="View Package" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ViewPackage.aspx.cs" Inherits="TourismWebApplication.Admin.ViewPackage" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-5">
        <%
            string pkgId = Request.QueryString["PackageID"];
            if (string.IsNullOrEmpty(pkgId))
            {
        %>
        <div class='alert alert-danger'>Invalid Package ID.</div>
        <%
            }
            else
            {
                string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // --- Fetch Package ---
                    SqlCommand cmd = new SqlCommand("SELECT * FROM Packages WHERE PackageID=@PackageID", conn);
                    cmd.Parameters.AddWithValue("@PackageID", pkgId);
                    SqlDataReader reader = cmd.ExecuteReader();

                    string title = "", price = "", location = "", description = "", audience = "", hotelName = "", hotelAddress = "", mapUrl = "", startDate = "", endDate = "", sourceDest = "", image = "";

                    if (reader.Read())
                    {
                        title = reader["Title"].ToString();
                        price = reader["Price"].ToString();
                        location = reader["Location"].ToString();
                        description = reader["Description"].ToString();
                        audience = reader["Audience"].ToString();
                        hotelName = reader["HotelName"].ToString();
                        hotelAddress = reader["HotelAddress"].ToString();
                        mapUrl = reader["MapUrl"].ToString();
                        startDate = Convert.ToDateTime(reader["StartDate"]).ToString("dd-MMM-yyyy");
                        endDate = Convert.ToDateTime(reader["EndDate"]).ToString("dd-MMM-yyyy");
                        sourceDest = reader["SourceDestination"].ToString();
                        image = string.IsNullOrEmpty(reader["ImageUrl"].ToString()) ? "/assets/no-image.jpg" : reader["ImageUrl"].ToString();
                    }
                    else
                    {
        %>
        <div class='alert alert-warning'>Package not found.</div>
        <%
            }
            reader.Close(); // Close first reader before opening second

            // --- Display Package Info ---
        %>

        <div class="card shadow-lg p-4 mb-4">
            <h3 class="mb-3 text-primary"><%= title %></h3>
            <img src="<%= image %>" class="img-fluid rounded mb-3" style="max-height: 400px; object-fit: cover;" alt="<%= title %>">

            <div class="row mb-2">
                <div class="col-md-6"><strong>Price:</strong> ₹<%= price %></div>
                <div class="col-md-6"><strong>Location:</strong> <%= location %></div>
            </div>
            <div class="row mb-2">
                <div class="col-md-6"><strong>Start Date:</strong> <%= startDate %></div>
                <div class="col-md-6"><strong>End Date:</strong> <%= endDate %></div>
            </div>
            <div class="mb-2"><strong>Audience:</strong> <%= audience %></div>
            <div class="mb-2"><strong>Description:</strong> <%= string.IsNullOrEmpty(description) ? "No description available." : description %></div>
            <div class="mb-2"><strong>Hotel Name:</strong> <%= hotelName %></div>
            <div class="mb-2"><strong>Hotel Address:</strong> <%= hotelAddress %></div>
            <div class="mb-2"><strong>Source / Destination:</strong> <%= sourceDest %></div>
            <div class="mb-2">
                <strong>Map:</strong>
                <% if (!string.IsNullOrEmpty(mapUrl))
                    { %>
                <a href="<%= mapUrl %>" target="_blank">View on Google Maps</a>
                <% }
                    else
                    { %>
                N/A
            <% } %>
            </div>
        </div>

        <!-- Package Staff Section -->
        <div class="card shadow-lg p-4 mb-4">
            <h4 class="mb-3 text-primary">Assigned Staff</h4>
            <%
                SqlCommand staffCmd = new SqlCommand(@"
                SELECT s.Name, s.Role, s.Email, s.Phone, ps.AssignedRole, ps.AssignedDate
                FROM PackageStaff ps
                INNER JOIN Staff s ON ps.StaffID = s.StaffID
                WHERE ps.PackageID = @PackageID", conn);

                staffCmd.Parameters.AddWithValue("@PackageID", pkgId);
                SqlDataReader staffReader = staffCmd.ExecuteReader();

                if (staffReader.HasRows)
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
                        <th>Assigned Date</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        while (staffReader.Read())
                        {
                    %>
                    <tr>
                        <td><%= staffReader["Name"] %></td>
                        <td><%= staffReader["Email"] %></td>
                        <td><%= staffReader["Phone"] %></td>
                        <td><%= staffReader["Role"] %></td>
                        <td><%= staffReader["AssignedRole"] %></td>
                        <td><%= Convert.ToDateTime(staffReader["AssignedDate"]).ToString("dd-MMM-yyyy") %></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <%
                }
                else
                {
                    Response.Write("<p class='text-muted'>No staff assigned to this package.</p>");
                }
                staffReader.Close();
            %>
            <a href="Packages.aspx" class="btn btn-secondary mt-3">Back to Packages</a>
        </div>
        <%}
            }%>
    </div>

</asp:Content>
