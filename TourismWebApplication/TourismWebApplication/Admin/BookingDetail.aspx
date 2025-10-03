<%@ Page Title="Booking Details" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="BookingDetail.aspx.cs" Inherits="TourismWebApplication.Admin.BookingDetail" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

<div class="container mt-4">

<%
    string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
    string bookingIdStr = Request.QueryString["id"];

    if (!string.IsNullOrEmpty(bookingIdStr))
    {
        int bookingId;
        if (int.TryParse(bookingIdStr, out bookingId))
        {
            string action = Request.QueryString["action"];
            if (!string.IsNullOrEmpty(action))
            {
                string newStatus = action.ToLower() == "confirm" ? "Confirmed" :
                                   action.ToLower() == "cancel" ? "Cancelled" : "";

                if (!string.IsNullOrEmpty(newStatus))
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string updateQuery = "UPDATE Bookings SET Status=@Status WHERE BookingID=@BookingID";
                        SqlCommand cmd = new SqlCommand(updateQuery, conn);
                        cmd.Parameters.AddWithValue("@Status", newStatus);
                        cmd.Parameters.AddWithValue("@BookingID", bookingId);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }






            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT b.BookingID, b.BookingDate, b.TravelDate, b.Status, b.PaymentStatus,
                           u.Name AS UserName, u.Email AS UserEmail, u.Phone AS UserPhone,
                           p.Title AS PackageTitle, p.Location, p.Price, p.StartDate, p.EndDate, p.HotelName, p.HotelAddress
                    FROM Bookings b
                    INNER JOIN Users u ON b.UserID = u.UserID
                    INNER JOIN Packages p ON b.PackageID = p.PackageID
                    WHERE b.BookingID=@BookingID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@BookingID", bookingId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    string userName = reader["UserName"].ToString();
                    string userEmail = reader["UserEmail"].ToString();
                    string userPhone = reader["UserPhone"].ToString();
                    string packageTitle = reader["PackageTitle"].ToString();
                    string location = reader["Location"].ToString();
                    decimal price = reader["Price"] != DBNull.Value ? (decimal)reader["Price"] : 0;
                    string status = reader["Status"].ToString();
                    string paymentStatus = reader["PaymentStatus"].ToString();
                    string bookingDate = reader["BookingDate"] != DBNull.Value ? Convert.ToDateTime(reader["BookingDate"]).ToString("dd-MMM-yyyy HH:mm") : "-";
                    string travelDate = reader["TravelDate"] != DBNull.Value ? Convert.ToDateTime(reader["TravelDate"]).ToString("dd-MMM-yyyy") : "-";
                    string startDate = reader["StartDate"] != DBNull.Value ? Convert.ToDateTime(reader["StartDate"]).ToString("dd-MMM-yyyy") : "-";
                    string endDate = reader["EndDate"] != DBNull.Value ? Convert.ToDateTime(reader["EndDate"]).ToString("dd-MMM-yyyy") : "-";
                    string hotelName = reader["HotelName"].ToString();
                    string hotelAddress = reader["HotelAddress"].ToString();
%>

<div class="card shadow-sm mb-4">
    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
        <h4 class="mb-0"><i class="fa-solid fa-ticket"></i> Booking Details (ID: <%= bookingId %>)</h4>
        <div>
            <%%>
            <%
                if (status.ToLower() == "pending")
                {
            %>
                <a href="BookingDetail.aspx?id=<%= bookingId %>&action=confirm" class="btn btn-success btn-sm me-1"><i class="fa-solid fa-check"></i> Confirm</a>
                <a href="BookingDetail.aspx?id=<%= bookingId %>&action=cancel" class="btn btn-warning btn-sm"><i class="fa-solid fa-ban"></i> Cancel</a>
            <%
                }
                else if (status.ToLower() == "confirmed")
                {
            %>
                <a href="BookingDetail.aspx?id=<%= bookingId %>&action=cancel" class="btn btn-warning btn-sm"><i class="fa-solid fa-ban"></i> Cancel</a>
            <%
                }
                else
                {
            %>
                <span class="badge bg-secondary">No actions available</span>
            <%
                }
            %>
        </div>
    </div>
    <div class="card-body">
        <div class="row mb-3">
            <div class="col-md-6">
                <h5>User Info</h5>
                <p><i class="fa-solid fa-user"></i> <strong>Name:</strong> <%= userName %></p>
                <p><i class="fa-solid fa-envelope"></i> <strong>Email:</strong> <%= userEmail %></p>
                <p><i class="fa-solid fa-phone"></i> <strong>Phone:</strong> <%= userPhone %></p>
            </div>
            <div class="col-md-6">
                <h5>Package Info</h5>
                <p><i class="fa-solid fa-box"></i> <strong>Title:</strong> <%= packageTitle %></p>
                <p><i class="fa-solid fa-map-location-dot"></i> <strong>Location:</strong> <%= location %></p>
                <p><i class="fa-solid fa-hotel"></i> <strong>Hotel:</strong> <%= hotelName %>, <%= hotelAddress %></p>
                <p><i class="fa-solid fa-money-bill-wave"></i> <strong>Price:</strong> ₹<%= price %></p>
            </div>
        </div>
        <div class="row mb-3">
            <div class="col-md-6">
                <p><i class="fa-solid fa-calendar-check"></i> <strong>Booking Date:</strong> <%= bookingDate %></p>
                <p><i class="fa-solid fa-plane-departure"></i> <strong>Travel Date:</strong> <%= travelDate %></p>
            </div>
            <div class="col-md-6">
                <p><i class="fa-solid fa-calendar-days"></i> <strong>Package Start/End:</strong> <%= startDate %> - <%= endDate %></p>
                <p><i class="fa-solid fa-circle-info"></i> <strong>Status:</strong> 
                    <% if (status.ToLower() == "pending")
                        { %>
                        <span class="badge bg-warning text-dark"><%= status %></span>
                    <% }
                        else if (status.ToLower() == "confirmed")
                        { %>
                        <span class="badge bg-success"><%= status %></span>
                    <% }
                        else
                        { %>
                        <span class="badge bg-danger"><%= status %></span>
                    <% } %>
                </p>
                <p><i class="fa-solid fa-credit-card"></i> <strong>Payment Status:</strong> 
                    <% if (paymentStatus.ToLower() == "paid")
                        { %>
                        <span class="badge bg-success"><%= paymentStatus %></span>
                    <% }
                        else if (paymentStatus.ToLower() == "unpaid")
                        { %>
                        <span class="badge bg-warning text-dark"><%= paymentStatus %></span>
                    <% }
                        else
                        { %>
                        <span class="badge bg-danger"><%= paymentStatus %></span>
                    <% } %>
                </p>
            </div>
        </div>
    </div>
</div>

<%
        }
        reader.Close();
    }


    using (SqlConnection conn = new SqlConnection(connStr))
    {
        string travelQuery = @"SELECT Name, Age, Gender, Relation
                                       FROM Travelers
                                       WHERE BookingID=@BookingID";
        SqlCommand cmdTravel = new SqlCommand(travelQuery, conn);
        cmdTravel.Parameters.AddWithValue("@BookingID", bookingId);
        conn.Open();
        SqlDataReader travelReader = cmdTravel.ExecuteReader();
%>

<div class="card shadow-sm mb-4">
    <div class="card-header bg-secondary text-white">
        <h5><i class="fa-solid fa-users"></i> Travelers</h5>
    </div>
    <div class="card-body">
        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
                    <th><i class="fa-solid fa-user"></i> Name</th>
                    <th><i class="fa-solid fa-calendar"></i> Age</th>
                    <th><i class="fa-solid fa-venus-mars"></i> Gender</th>
                    <th><i class="fa-solid fa-people-roof"></i> Relation</th>
                </tr>
            </thead>
            <tbody>
<%
    if (!travelReader.HasRows)
    {
%>
                <tr>
                    <td colspan="4" class="text-center">No travelers added.</td>
                </tr>
<%
    }
    else
    {
        while (travelReader.Read())
        {
            string tName = travelReader["Name"].ToString();
            string tAge = travelReader["Age"] != DBNull.Value ? travelReader["Age"].ToString() : "-";
            string tGender = travelReader["Gender"].ToString();
            string tRelation = travelReader["Relation"].ToString();
%>
                <tr>
                    <td><%= tName %></td>
                    <td><%= tAge %></td>
                    <td><%= tGender %></td>
                    <td><%= tRelation %></td>
                </tr>
<%
        }
    }
    travelReader.Close();
%>
            </tbody>
        </table>
    </div>
</div>

<%
        }
    }
    else
    {
%>
    <div class="alert alert-danger"><i class="fa-solid fa-triangle-exclamation"></i> Invalid Booking ID</div>
<%
        }
    }
    else
    {
%>
    <div class="alert alert-danger"><i class="fa-solid fa-triangle-exclamation"></i> Booking ID not provided</div>
<%
        }
    
%>

</div>
</asp:Content>
