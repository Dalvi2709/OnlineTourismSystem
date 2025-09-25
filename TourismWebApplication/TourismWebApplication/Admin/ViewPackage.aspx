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
        <div class='alert alert-danger'><i class="bi bi-exclamation-triangle-fill me-2"></i>Invalid Package ID.</div>
        <%
            }
            else
            {
                string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    SqlCommand cmd = new SqlCommand("SELECT * FROM Packages WHERE PackageID=@PackageID", conn);
                    cmd.Parameters.AddWithValue("@PackageID", pkgId);
                    SqlDataReader reader = cmd.ExecuteReader();

                    string title = "", price = "", location = "", description = "", audience = "", hotelName = "", hotelAddress = "", mapUrl = "", startDate = "", endDate = "", sourceDest = "", image = "";
                    DateTime endDt = DateTime.Now;

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
                        endDt = Convert.ToDateTime(reader["EndDate"]);
                        endDate = endDt.ToString("dd-MMM-yyyy");
                        sourceDest = reader["SourceDestination"].ToString();
                        image = string.IsNullOrEmpty(reader["ImageUrl"].ToString()) ? "/assets/no-image.jpg" : reader["ImageUrl"].ToString();
                    }
                    else
                    {
        %>
        <div class='alert alert-warning'><i class="bi bi-exclamation-circle-fill me-2"></i>Package not found.</div>
        <%
            }
            reader.Close();


        %>

        <div class="card shadow-lg mb-4">
            <div class="row g-0">
                <div class="col-md-5">
                    <img src="<%= image %>" class="img-fluid rounded-start" style="height: 100%; object-fit: cover;" alt="<%= title %>">
                </div>
                <div class="col-md-7">
                    <div class="card-body">
                        <h2 class="card-title text-primary fw-bold mb-2"><i class="bi bi-box-seam me-2"></i><%= title %></h2>

                        <span class="badge <%= endDt < DateTime.Now ? "bg-danger" : "bg-success" %> mb-3">
                            <%= endDt < DateTime.Now ? "Expired" : "Active" %>
                        </span>

                        <div class="mb-2"><i class="bi bi-cash-stack text-success me-1"></i><strong>Price:</strong> ₹<%= price %></div>
                        <div class="mb-2"><i class="bi bi-geo-alt-fill text-danger me-1"></i><strong>Location:</strong> <%= location %></div>
                        <div class="mb-2"><i class="bi bi-calendar-event text-warning me-1"></i><strong>Start Date:</strong> <%= startDate %> &nbsp; | &nbsp; <strong>End Date:</strong> <%= endDate %></div>
                        <div class="mb-2"><i class="bi bi-people-fill text-info me-1"></i><strong>Audience:</strong> <%= audience %></div>
                        <div class="mb-2"><i class="bi bi-card-text text-secondary me-1"></i><strong>Description:</strong> <%= string.IsNullOrEmpty(description) ? "No description available." : description %></div>
                        <div class="mb-2"><i class="bi bi-house-door-fill text-primary me-1"></i><strong>Hotel:</strong> <%= hotelName %>, <%= hotelAddress %></div>
                        <div class="mb-2"><i class="bi bi-arrow-left-right text-secondary me-1"></i><strong>Source / Destination:</strong> <%= sourceDest %></div>
                        <div class="mb-3">
                            <i class="bi bi-map-fill text-danger me-1"></i><strong>Map:</strong>
                            <% if (!string.IsNullOrEmpty(mapUrl))
                                { %>
                            <a href="<%= mapUrl %>" target="_blank" class="text-decoration-none">View on Google Maps</a>
                            <% }
                                else
                                { %> N/A <% } %>
                        </div>

                        <a href="Packages.aspx" class="btn btn-secondary mt-2"><i class="bi bi-arrow-left-circle me-1"></i>Back to Packages</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow-lg p-4 mb-4">
            <h4 class="mb-3 text-primary"><i class="bi bi-people-fill me-2"></i>Assigned Staff</h4>
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
            <div class="table-responsive">
                <table class="table table-bordered table-striped align-middle">
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
                            <td><i class="bi bi-person-circle me-1"></i><%= staffReader["Name"] %></td>
                            <td><%= staffReader["Email"] %></td>
                            <td><%= staffReader["Phone"] %></td>
                            <td><span class="badge bg-info text-dark"><%= staffReader["Role"] %></span></td>
                            <td><span class="badge bg-success"><%= staffReader["AssignedRole"] %></span></td>
                            <td><%= Convert.ToDateTime(staffReader["AssignedDate"]).ToString("dd-MMM-yyyy") %></td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <%
                }
                else
                {
                    Response.Write("<p class='text-muted'><i class='bi bi-exclamation-circle me-1'></i>No staff assigned to this package.</p>");
                }
                staffReader.Close();
            %>
        </div>

        <div class="card shadow-lg p-4 mb-5">
            <h4 class="mb-3 text-primary"><i class="bi bi-journal-bookmark-fill me-2"></i>Bookings</h4>
            <%
                SqlCommand bookingCmd = new SqlCommand(@"
                SELECT b.BookingID, u.Name AS UserName, b.TravelDate, b.Status, b.PaymentStatus
                FROM Bookings b
                INNER JOIN Users u ON b.UserID = u.UserID
                WHERE b.PackageID = @PackageID
                ORDER BY b.BookingDate DESC", conn);

                bookingCmd.Parameters.AddWithValue("@PackageID", pkgId);
                SqlDataReader bookingReader = bookingCmd.ExecuteReader();

                if (bookingReader.HasRows)
                {
            %>
            <div class="table-responsive">
                <table class="table table-bordered table-striped align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>Booking ID</th>
                            <th>User</th>
                            <th>Travel Date</th>
                            <th>Status</th>
                            <th>Payment Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            while (bookingReader.Read())
                            {
                                DateTime travelDate = Convert.ToDateTime(bookingReader["TravelDate"]);
                        %>
                        <tr>
                            <td><%= bookingReader["BookingID"] %></td>
                            <td><i class="bi bi-person-fill me-1"></i><%= bookingReader["UserName"] %></td>
                            <td><%= travelDate.ToString("dd-MMM-yyyy") %></td>
                            <td>
                                <span class="badge <%= bookingReader["Status"].ToString() == "Confirmed" ? "bg-success" : bookingReader["Status"].ToString() == "Pending" ? "bg-warning text-dark" : "bg-danger" %>">
                                    <%= bookingReader["Status"] %>
                                </span>
                            </td>
                            <td>
                                <span class="badge <%= bookingReader["PaymentStatus"].ToString() == "Paid" ? "bg-success" : bookingReader["PaymentStatus"].ToString() == "Unpaid" ? "bg-warning text-dark" : "bg-danger" %>">
                                    <%= bookingReader["PaymentStatus"] %>
                                </span>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
            <%
                }
                else
                {
                    Response.Write("<p class='text-muted'><i class='bi bi-exclamation-circle me-1'></i>No bookings for this package yet.</p>");
                }
                bookingReader.Close();
            %>
        </div>

        <%
                }
            }%>
    </div>

</asp:Content>
