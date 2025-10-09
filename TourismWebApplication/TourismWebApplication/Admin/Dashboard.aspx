<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="TourismWebApplication.Admin.Dashboard" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        .card-gradient {
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            color: #fff;
            transition: transform 0.2s;
        }

            .card-gradient:hover {
                transform: translateY(-5px);
            }

        .badge-status {
            padding: 0.4em 0.6em;
            font-size: 0.85rem;
            border-radius: 8px;
        }

        .table-modern th {
            background-color: #343a40;
            color: #fff;
        }

        .table-modern tbody tr:hover {
            background-color: #f1f1f1;
        }

        .scrollable-table {
            max-height: 400px;
            overflow-y: auto;
        }

        .icon-large {
            font-size: 1.5rem;
            vertical-align: middle;
            margin-right: 5px;
        }
    </style>

    <div class="container-fluid mt-4">
        <h3 class="mb-4"><i class="bi bi-speedometer2 me-2"></i>Admin Dashboard</h3>
      

        <%
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
            int usersCount = 0, packagesCount = 0, bookingsCount = 0, paymentsCount = 0, travelersCount = 0;
            var bookingIDs = new List<int>();
            var userNames = new List<string>();
            var packageTitles = new List<string>();
            var travelDates = new List<DateTime>();
            var statuses = new List<string>();
            var startDates = new List<DateTime>();
            var endDates = new List<DateTime>();
            var sourceDestinations = new List<string>();
            var travelersPerBooking = new Dictionary<int, List<string>>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                usersCount = (int)new SqlCommand("SELECT COUNT(*) FROM Users", conn).ExecuteScalar();
                packagesCount = (int)new SqlCommand("SELECT COUNT(*) FROM Packages", conn).ExecuteScalar();
                bookingsCount = (int)new SqlCommand("SELECT COUNT(*) FROM Bookings", conn).ExecuteScalar();
                paymentsCount = (int)new SqlCommand("SELECT COUNT(*) FROM Payments", conn).ExecuteScalar();
                travelersCount = (int)new SqlCommand("SELECT COUNT(*) FROM Travelers", conn).ExecuteScalar();

                SqlCommand cmdRecent = new SqlCommand(
                    @"SELECT TOP 5 b.BookingID, u.Name AS UserName, p.Title AS PackageTitle, 
                        b.TravelDate, b.Status, p.StartDate, p.EndDate, p.SourceDestination
                  FROM Bookings b
                  JOIN Users u ON b.UserID = u.UserID
                  JOIN Packages p ON b.PackageID = p.PackageID
                  ORDER BY b.BookingDate DESC", conn);

                SqlDataReader reader = cmdRecent.ExecuteReader();
                while (reader.Read())
                {
                    int bookingId = Convert.ToInt32(reader["BookingID"]);
                    bookingIDs.Add(bookingId);
                    userNames.Add(reader["UserName"].ToString());
                    packageTitles.Add(reader["PackageTitle"].ToString());
                    travelDates.Add(Convert.ToDateTime(reader["TravelDate"]));
                    statuses.Add(reader["Status"].ToString());
                    startDates.Add(Convert.ToDateTime(reader["StartDate"]));
                    endDates.Add(Convert.ToDateTime(reader["EndDate"]));
                    sourceDestinations.Add(reader["SourceDestination"].ToString());
                }
                reader.Close();

                foreach (int bookingId in bookingIDs)
                {
                    SqlCommand cmdTrav = new SqlCommand(
                        "SELECT Name, Relation FROM Travelers WHERE BookingID=@BookingID", conn);
                    cmdTrav.Parameters.AddWithValue("@BookingID", bookingId);
                    SqlDataReader readerTrav = cmdTrav.ExecuteReader();
                    var travList = new List<string>();
                    while (readerTrav.Read())
                    {
                        travList.Add(readerTrav["Name"] + " (" + readerTrav["Relation"] + ")");
                    }
                    travelersPerBooking[bookingId] = travList;
                    readerTrav.Close();
                }
            }
        %>

        <div class="mb-4">
            <a href="Users.aspx" class="btn btn-primary me-2 shadow-sm"><i class="bi bi-people-fill me-1"></i>Users</a>
            <a href="Packages.aspx" class="btn btn-success me-2 shadow-sm"><i class="bi bi-briefcase-fill me-1"></i>Packages</a>
            <a href="Booking.aspx" class="btn btn-warning me-2 shadow-sm"><i class="bi bi-calendar-check-fill me-1"></i>Bookings</a>
            
        </div>

        <div class="row mb-4 g-3">
            <div class="col-md-2">
                <div class="card card-gradient text-center py-3" style="background: linear-gradient(135deg,#6a11cb,#2575fc)">
                    <i class="bi bi-people-fill icon-large"></i>
                    <h6>Users</h6>
                    <h3><%= usersCount %></h3>
                </div>
            </div>
            <div class="col-md-2">
                <div class="card card-gradient text-center py-3" style="background: linear-gradient(135deg,#11998e,#38ef7d)">
                    <i class="bi bi-briefcase-fill icon-large"></i>
                    <h6>Packages</h6>
                    <h3><%= packagesCount %></h3>
                </div>
            </div>
            <div class="col-md-2">
                <div class="card card-gradient text-center py-3" style="background: linear-gradient(135deg,#ff416c,#ff4b2b)">
                    <i class="bi bi-calendar-check-fill icon-large"></i>
                    <h6>Bookings</h6>
                    <h3><%= bookingsCount %></h3>
                </div>
            </div>
           <!-- <div class="col-md-2">
                <div class="card card-gradient text-center py-3" style="background: linear-gradient(135deg,#1e3c72,#2a5298)">
                    <i class="bi bi-credit-card-fill icon-large"></i>
                    <h6>Payments</h6>
                    <h3><%= paymentsCount %></h3>
                </div>
            </div>
            <div class="col-md-2">
                <div class="card card-gradient text-center py-3" style="background: linear-gradient(135deg,#ff7e5f,#feb47b)">
                    <i class="bi bi-person-badge-fill icon-large"></i>
                    <h6>Travelers</h6>
                    <h3><%= travelersCount %></h3>
                </div>
            </div>  -->
        </div>

        <div class="card shadow-sm">
            <div class="card-body">
                <h5 class="card-title mb-3"><i class="bi bi-clock-history me-2"></i>Recent Bookings</h5>
                <div class="scrollable-table">
                    <table class="table table-modern table-striped table-bordered align-middle">
                        <thead>
                            <tr>
                                <th><i class="bi bi-hash"></i>Sr No.</th>
                                <th><i class="bi bi-person-fill"></i>User</th>
                                <th><i class="bi bi-briefcase-fill"></i>Package</th>
                                <th><i class="bi bi-calendar-event"></i>Travel Date</th>
                                <th><i class="bi bi-calendar-range"></i>Duration</th>
                                <th><i class="bi bi-geo-alt-fill"></i>Source/Dest</th>
                                <th><i class="bi bi-info-circle-fill"></i>Status</th>
                               
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                using (SqlConnection conn = new SqlConnection(connStr))
                                {
                                    conn.Open();

                                    // Step 1: Read recent bookings into a list
                                    var bookingsList = new List<Dictionary<string, object>>();
                                    SqlCommand cmdRecent = new SqlCommand(
                                        @"SELECT TOP 5 b.BookingID, u.Name AS UserName, p.Title AS PackageTitle, 
                     b.TravelDate, b.Status, p.StartDate, p.EndDate, p.SourceDestination
              FROM Bookings b
              JOIN Users u ON b.UserID = u.UserID
              JOIN Packages p ON b.PackageID = p.PackageID
              ORDER BY b.BookingDate DESC", conn);

                                    SqlDataReader reader = cmdRecent.ExecuteReader();
                                    while (reader.Read())
                                    {
                                        var booking = new Dictionary<string, object>();
                                        booking["BookingID"] = Convert.ToInt32(reader["BookingID"]);
                                        booking["UserName"] = reader["UserName"].ToString();
                                        booking["PackageTitle"] = reader["PackageTitle"].ToString();
                                        booking["TravelDate"] = Convert.ToDateTime(reader["TravelDate"]);
                                        booking["Status"] = reader["Status"].ToString();
                                        booking["StartDate"] = Convert.ToDateTime(reader["StartDate"]);
                                        booking["EndDate"] = Convert.ToDateTime(reader["EndDate"]);
                                        booking["SourceDest"] = reader["SourceDestination"].ToString();
                                        bookingsList.Add(booking);
                                    }
                                    reader.Close();
                                    int i = 1;

                                    // Step 2: For each booking, fetch travelers
                                    foreach (var booking in bookingsList)
                                    {
                                        int bookingId = (int)booking["BookingID"];
                                        var travelers = new List<string>();

                                        SqlCommand cmdTrav = new SqlCommand(
                                            "SELECT Name, Relation FROM Travelers WHERE BookingID=@BookingID", conn);
                                        cmdTrav.Parameters.AddWithValue("@BookingID", bookingId);

                                        SqlDataReader readerTrav = cmdTrav.ExecuteReader();
                                        while (readerTrav.Read())
                                        {
                                            travelers.Add(readerTrav["Name"] + " (" + readerTrav["Relation"] + ")");
                                        }
                                        readerTrav.Close();
                                        
                                        
                            %>
                            <tr>
                                <td><%= i++ %></td>
                                <td><%= booking["UserName"] %></td>
                                <td><%= booking["PackageTitle"] %></td>
                                <td><%= ((DateTime)booking["TravelDate"]).ToString("yyyy-MM-dd") %></td>
                                <td><%= ((DateTime)booking["StartDate"]).ToString("yyyy-MM-dd") %> to <%= ((DateTime)booking["EndDate"]).ToString("yyyy-MM-dd") %></td>
                                <td><%= booking["SourceDest"] %></td>
                                <td>
                                    <% string status = booking["Status"].ToString();
                                        if (status == "Pending")
                                        { %>
                                    <span class="badge bg-warning badge-status"><i class="bi bi-hourglass-split"></i><%= status %></span>
                                    <% }
                                    else if (status == "Confirmed")
                                    { %>
                                    <span class="badge bg-success badge-status"><i class="bi bi-check-circle"></i><%= status %></span>
                                    <% }
                                    else
                                    { %>
                                    <span class="badge bg-danger badge-status"><i class="bi bi-x-circle"></i><%= status %></span>
                                    <% } %>
                                </td>
                               <!-- <td>
                                    <% foreach (var t in travelers)
                                    { %>
                                    <i class="bi bi-person-lines-fill"></i><%= t %><br />
                                    <%  } %>
                                </td> -->
                            </tr>
                           
                            <%
                                    } // end foreach
                                   
                                } // end using
                            %>
                        </tbody>

                    </table>
                </div>
            </div>
        </div>

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
    </div>




</asp:Content>
