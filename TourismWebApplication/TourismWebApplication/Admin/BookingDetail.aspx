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

if (!string.IsNullOrEmpty(bookingIdStr) && int.TryParse(bookingIdStr, out int bookingId))
{
    string action = Request.QueryString["action"];

    using (SqlConnection conn = new SqlConnection(connStr))
    {
        conn.Open();

        if (!string.IsNullOrEmpty(action))
        {
            string newStatus = action.ToLower() == "confirm" ? "Confirmed" :
                               action.ToLower() == "cancel" ? "Cancelled" : "";

            if (!string.IsNullOrEmpty(newStatus))
            {
                using (SqlTransaction transaction = conn.BeginTransaction())
                {
                    try
                    {
                        int seatBooked = 0;
                        int packageId = 0;

                        // Fetch booking info
                        using (SqlCommand cmdGet = new SqlCommand(
                            "SELECT PackageID, SeatBooked FROM Bookings WHERE BookingID=@BookingID",
                            conn, transaction))
                        {
                            cmdGet.Parameters.AddWithValue("@BookingID", bookingId);
                            using (SqlDataReader reader = cmdGet.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    seatBooked = Convert.ToInt32(reader["SeatBooked"]);
                                    packageId = Convert.ToInt32(reader["PackageID"]);
                                }
                            }
                        }

                        if (packageId > 0 && seatBooked > 0)
                        {
                            if (newStatus == "Cancelled")
                            {
                                // Restore available slots
                                using (SqlCommand cmdPackage = new SqlCommand(
                                    "UPDATE Packages SET AvailableSlots = AvailableSlots + @SeatBooked WHERE PackageID=@PackageID",
                                    conn, transaction))
                                {
                                    cmdPackage.Parameters.AddWithValue("@SeatBooked", seatBooked);
                                    cmdPackage.Parameters.AddWithValue("@PackageID", packageId);
                                    cmdPackage.ExecuteNonQuery();
                                }
                            }
                            else if (newStatus == "Confirmed")
                            {
                                // Reduce available slots
                                using (SqlCommand cmdPackage = new SqlCommand(
                                    "UPDATE Packages SET AvailableSlots = AvailableSlots - @SeatBooked WHERE PackageID=@PackageID AND AvailableSlots >= @SeatBooked",
                                    conn, transaction))
                                {
                                    cmdPackage.Parameters.AddWithValue("@SeatBooked", seatBooked);
                                    cmdPackage.Parameters.AddWithValue("@PackageID", packageId);
                                    int rowsAffected = cmdPackage.ExecuteNonQuery();

                                    if (rowsAffected == 0)
                                    {
                                        throw new Exception("Not enough available slots to confirm booking.");
                                    }
                                }
                            }
                        }

                        // Update booking status
                        using (SqlCommand cmdUpdate = new SqlCommand(
                            "UPDATE Bookings SET Status=@Status WHERE BookingID=@BookingID",
                            conn, transaction))
                        {
                            cmdUpdate.Parameters.AddWithValue("@Status", newStatus);
                            cmdUpdate.Parameters.AddWithValue("@BookingID", bookingId);
                            cmdUpdate.ExecuteNonQuery();
                        }

                        transaction.Commit();
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        Response.Write("<div class='alert alert-danger'>Error: " + ex.Message + "</div>");
                    }
                }
            }
        }

        // ---------------- FETCH BOOKING DETAILS ----------------
        using (SqlCommand cmd = new SqlCommand(@"
            SELECT b.BookingID, b.BookingDate, b.TravelDate, b.Status, b.PaymentStatus,
                   b.SeatBooked, u.Name AS UserName, u.Email AS UserEmail, u.Phone AS UserPhone,
                   p.Title AS PackageTitle, p.Location, p.Price, p.StartDate, p.EndDate, p.HotelName, p.HotelAddress
            FROM Bookings b
            INNER JOIN Users u ON b.UserID = u.UserID
            INNER JOIN Packages p ON b.PackageID = p.PackageID
            WHERE b.BookingID=@BookingID", conn))
        {
            cmd.Parameters.AddWithValue("@BookingID", bookingId);
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
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

<!-- ---------------- BOOKING DETAILS CARD ---------------- -->
<div class="card shadow-sm mb-4">
    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
        <h4 class="mb-0"><i class="fa-solid fa-ticket"></i> Booking Details (ID: <%= bookingId %>)</h4>
        <div>
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
                    <span class="badge <%= status.ToLower() == "pending" ? "bg-warning text-dark" : status.ToLower() == "confirmed" ? "bg-success" : "bg-danger" %>">
                        <%= status %>
                    </span>
                </p>
                <p><i class="fa-solid fa-credit-card"></i> <strong>Payment Status:</strong>
                    <span class="badge <%= paymentStatus.ToLower() == "paid" ? "bg-success" : paymentStatus.ToLower() == "unpaid" ? "bg-warning text-dark" : "bg-danger" %>">
                        <%= paymentStatus %>
                    </span>
                </p>
            </div>
        </div>
    </div>
</div>

<%
                }
            }
        }

        // ---------------- TRAVELERS CARD ----------------
        using (SqlCommand cmdTravel = new SqlCommand(
            "SELECT Name, Age, Gender, Relation FROM Travelers WHERE BookingID=@BookingID", conn))
        {
            cmdTravel.Parameters.AddWithValue("@BookingID", bookingId);
            using (SqlDataReader travelReader = cmdTravel.ExecuteReader())
            {
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
                <tr><td colspan="4" class="text-center">No travelers added.</td></tr>
                <%
                }
                else
                {
                    while (travelReader.Read())
                    {
                %>
                <tr>
                    <td><%= travelReader["Name"].ToString() %></td>
                    <td><%= travelReader["Age"] != DBNull.Value ? travelReader["Age"].ToString() : "-" %></td>
                    <td><%= travelReader["Gender"].ToString() %></td>
                    <td><%= travelReader["Relation"].ToString() %></td>
                </tr>
                <%
                    }
                }
                %>
            </tbody>
        </table>
    </div>
</div>
<%
            }
        }
    }
}
else
{
%>
<div class="alert alert-danger"><i class="fa-solid fa-triangle-exclamation"></i> Invalid Booking ID</div>
<%
}
%>
</div>

</asp:Content>
