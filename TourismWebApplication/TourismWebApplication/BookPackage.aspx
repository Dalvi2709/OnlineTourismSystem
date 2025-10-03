<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Book Package</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <script>
        function showTravelerFields() {
            var seats = parseInt(document.getElementById("SeatBooked").value);
            var container = document.getElementById("travelerContainer");
            container.innerHTML = "";

            if (seats <= 1) return;

            for (var i = 2; i <= seats; i++) {
                container.innerHTML += `
                    <div class="border p-3 mb-3">
                        <h5>Traveler ${i - 1}</h5>
                        <div class="mb-2">
                            <label class="form-label">Name</label>
                            <input type="text" class="form-control" id="TravelerName_${i}" name="TravelerName_${i}" required />
                        </div>
                        <div class="mb-2">
                            <label class="form-label">Age</label>
                            <input type="number" class="form-control" id="TravelerAge_${i}" name="TravelerAge_${i}" min="0" required />
                        </div>
                        <div class="mb-2">
                            <label class="form-label">Gender</label>
                            <select class="form-select" id="TravelerGender_${i}" name="TravelerGender_${i}" required>
                                <option value="">Select Gender</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="mb-2">
                            <label class="form-label">Relation</label>
                            <input type="text" class="form-control" id="TravelerRelation_${i}" name="TravelerRelation_${i}" placeholder="Spouse, Child, Friend, etc." />
                        </div>
                    </div>
                `;
            }
        }

        function validateSeats(maxSeats) {
            var seats = parseInt(document.getElementById("SeatBooked").value);
            if (seats < 1 || seats > maxSeats) {
                alert("You can book between 1 and " + maxSeats + " seat(s).");
                document.getElementById("SeatBooked").value = 1;
                showTravelerFields();
                return false;
            }

            for (var i = 2; i <= seats; i++) {
                var tName = document.getElementById("TravelerName_" + i).value.trim();
                var tAge = document.getElementById("TravelerAge_" + i).value.trim();
                var tGender = document.getElementById("TravelerGender_" + i).value;

                if (tName === "" || tAge === "" || tGender === "") {
                    alert("Please fill all traveler details for traveler " + i);
                    return false;
                }
            }
            return true;
        }
    </script>
</head>
<body class="bg-light">

    <div class="container py-5">
        <h2 class="text-center text-primary mb-4">Book Your Package</h2>

        <%
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
            string packageId = Request.QueryString["id"];
            string userId = Session["UserID"] != null ? Session["UserID"].ToString() : null;

            if (userId == null)
            {
        %>
        <div class="alert alert-danger">
            ⚠️ Please <a href="Login.aspx">Login</a> to book a package.
        </div>
        <%
            }
            else if (!string.IsNullOrEmpty(packageId))
            {
                DateTime travelDate = DateTime.Now;
                int availableSlots = 0;
                string packageTitle = "";

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string getPackageQuery = "SELECT StartDate, AvailableSlots, Title FROM Packages WHERE PackageID=@PackageID";
                    SqlCommand getDateCmd = new SqlCommand(getPackageQuery, conn);
                    getDateCmd.Parameters.AddWithValue("@PackageID", packageId);

                    using (SqlDataReader reader = getDateCmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            travelDate = Convert.ToDateTime(reader["StartDate"]);
                            availableSlots = Convert.ToInt32(reader["AvailableSlots"]);
                            packageTitle = reader["Title"].ToString();
                        }
                        else
                        {
        %>
        <div class="alert alert-warning">⚠️ Package not found.</div>
        <%
                    return;
                }
            }

            if (Request.HttpMethod == "POST")
            {
                int seatBooked = int.Parse(Request.Form["SeatBooked"]);

                if (seatBooked < 1 || seatBooked > availableSlots)
                {
        %>
        <div class="alert alert-danger">
            ❌ You can book between 1 and <%= availableSlots %> seat(s).
        </div>
        <%
            }
            else
            {
                try
                {

                    string insertQuery = @"INSERT INTO Bookings(UserID, PackageID, TravelDate, SeatBooked, Status, PaymentStatus)
                                                   VALUES(@UserID, @PackageID, @TravelDate, @SeatBooked, 'Pending', 'Unpaid');
                                                   SELECT SCOPE_IDENTITY();";
                    SqlCommand cmd = new SqlCommand(insertQuery, conn);
                    cmd.Parameters.AddWithValue("@UserID", userId);
                    cmd.Parameters.AddWithValue("@PackageID", packageId);
                    cmd.Parameters.AddWithValue("@TravelDate", travelDate);
                    cmd.Parameters.AddWithValue("@SeatBooked", seatBooked);

                    long bookingId = Convert.ToInt64(cmd.ExecuteScalar());

                    if (bookingId > 0 && seatBooked > 1)
                    {
                        for (int i = 2; i <= seatBooked; i++)
                        {
                            string tName = Request.Form["TravelerName_" + i];
                            string tAge = Request.Form["TravelerAge_" + i];
                            string tGender = Request.Form["TravelerGender_" + i];
                            string tRelation = Request.Form["TravelerRelation_" + i];

                            string travelerQuery = @"INSERT INTO Travelers(BookingID, Name, Age, Gender, Relation)
                                                             VALUES(@BookingID, @Name, @Age, @Gender, @Relation)";
                            SqlCommand travelerCmd = new SqlCommand(travelerQuery, conn);
                            travelerCmd.Parameters.AddWithValue("@BookingID", bookingId);
                            travelerCmd.Parameters.AddWithValue("@Name", tName);
                            travelerCmd.Parameters.AddWithValue("@Age", int.Parse(tAge));
                            travelerCmd.Parameters.AddWithValue("@Gender", tGender);
                            travelerCmd.Parameters.AddWithValue("@Relation", string.IsNullOrEmpty(tRelation) ? DBNull.Value : (object)tRelation);

                            travelerCmd.ExecuteNonQuery();
                        }
                    }

                    string updateSlotsQuery = "UPDATE Packages SET AvailableSlots = AvailableSlots - @SeatBooked WHERE PackageID=@PackageID";
                    SqlCommand updateCmd = new SqlCommand(updateSlotsQuery, conn);
                    updateCmd.Parameters.AddWithValue("@SeatBooked", seatBooked);
                    updateCmd.Parameters.AddWithValue("@PackageID", packageId);
                    updateCmd.ExecuteNonQuery();
        %>
        <div class="alert alert-success">
            ✅ Booking Successful for <strong><%= packageTitle %></strong>! You booked <%= seatBooked %> seat(s).
                                <a href="history.aspx">View My Bookings</a>
        </div>
        <div class="d-grid mt-2">
            <a href="index.aspx" class="btn btn-outline-secondary">Back to Home</a>
        </div>
        <%
            }
            catch (SqlException ex)
            {
        %>
        <div class="alert alert-danger">
            ❌ Booking failed: <%= ex.Message %>
        </div>
        <%
                        }
                    }
                }
            }
        %>




        <form method="post" class="card p-4 shadow-sm" onsubmit="return validateSeats(<%= availableSlots %>)">
            <div class="mb-3">
                <label class="form-label">Package</label>
                <input type="text" class="form-control" value="<%= packageTitle %>" readonly />
            </div>
            <div class="mb-3">
                <label class="form-label">Travel Date</label>
                <input type="text" class="form-control" value="<%= travelDate.ToString("yyyy-MM-dd") %>" readonly />
            </div>
            <div class="mb-3">
                <label class="form-label">Number of Seats</label>
                <input type="number" id="SeatBooked" name="SeatBooked" class="form-control" min="1" max="<%= availableSlots %>" value="1" required
                    onchange="showTravelerFields()" />
                <small class="text-muted">Available Seats: <%= availableSlots %></small>
            </div>


            <div id="travelerContainer"></div>

            <button type="submit" class="btn btn-primary w-100">Book Now</button>
        </form>

        <script>
            showTravelerFields();
        </script>

        <%
            }
            else
            {
        %>
        <div class="alert alert-warning">⚠️ Invalid Package ID.</div>
        <%
            }
        %>
    </div>

</body>
</html>
