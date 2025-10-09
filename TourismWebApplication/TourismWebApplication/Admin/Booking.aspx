<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Booking.aspx.cs" Inherits="TourismWebApplication.Admin.Booking" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Data" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-4">
        <h2>Manage Bookings</h2>
        <%
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
            string action = Request.QueryString["action"];
            string bookingIdStr = Request.QueryString["id"];

            if (!string.IsNullOrEmpty(action) && !string.IsNullOrEmpty(bookingIdStr))
            {
                int bookingId = Convert.ToInt32(bookingIdStr);
                string newStatus = "";


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

            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT b.BookingID, u.Name AS UserName, p.Title AS PackageTitle, 
                             b.SeatBooked, b.BookingDate, b.Status, b.PaymentStatus
                             FROM Bookings b
                             INNER JOIN Users u ON b.UserID = u.UserID
                             INNER JOIN Packages p ON b.PackageID = p.PackageID
                             ORDER BY b.BookingDate DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                da.Fill(dt);
            }
        %>

        <table class="table table-bordered table-hover mt-3">
            <thead class="table-dark">
                <tr>
                    <th>Sr No.</th>
                    <th>User</th>
                    <th>Package</th>
                    <th>Seats</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Payment Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    int i = 1;
                    foreach (DataRow row in dt.Rows)
                    {
                        int id = Convert.ToInt32(row["BookingID"]);
                        string user = row["UserName"].ToString();
                        string package = row["PackageTitle"].ToString();
                        string seats = row["SeatBooked"].ToString();
                        string date = Convert.ToDateTime(row["BookingDate"]).ToString("dd-MMM-yyyy HH:mm");
                        string status = row["Status"].ToString();
                        string paymentStatus = row["PaymentStatus"].ToString();
                %>
                <tr>
                    <td><%= i++ %></td>
                    <td><%= user %></td>
                    <td><%= package %></td>
                    <td><%= seats %></td>
                    <td><%= date %></td>
                    <td><%= status %></td>
                    <td><%= paymentStatus %></td>
                    <td>
                      

                        <a href="BookingDetail.aspx?id=<%= id %>" class="btn btn-primary btn-sm">Details</a>

                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

</asp:Content>
