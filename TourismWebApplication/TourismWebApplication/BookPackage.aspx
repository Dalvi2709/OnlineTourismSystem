<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Book Package</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script>
        function showTravelerFields() {
            var seats = parseInt(document.getElementById("SeatBooked").value);
            var container = document.getElementById("travelerContainer");
            container.innerHTML = "";

            if (seats <= 1) return;

            for (var i = 2; i <= seats; i++) {
                container.innerHTML += `
                    <div class="border p-3 mb-3 rounded shadow-sm">
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
                    alert("Please fill all traveler details for traveler " + (i - 1));
                    return false;
                }
            }
            return true;
        }
    </script>

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600&family=Nunito:wght@600;700;800&display=swap" rel="stylesheet">

    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="lib/animate/animate.min.css" rel="stylesheet">
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />

    <!-- Customized Bootstrap Stylesheet -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Template Stylesheet -->
    <link href="css/style.css" rel="stylesheet">
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
        <!-- Login Required Card -->
        <div class="card border-warning mb-3 shadow-sm text-center mx-auto" style="max-width: 500px;">
            <div class="card-header bg-warning text-dark">
                ⚠️ Login Required
            </div>
            <div class="card-body">
                <p class="card-text">You need to login to book a package.</p>
                <a href="Login.aspx" class="btn btn-warning">Login Now</a>
            </div>
            <div class="d-grid mt-2">
                <a href="index.aspx" class="btn btn-outline-secondary">Back to Home</a>
            </div>
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
        <!-- Package Not Found Card -->
        <div class="card border-danger mb-3 shadow-sm text-center mx-auto" style="max-width: 500px;">
            <div class="card-header bg-danger text-white">
                ⚠️ Package Not Found
            </div>
            <div class="card-body">
                <p class="card-text">The package you are trying to book does not exist.</p>
                <a href="index.aspx" class="btn btn-danger">Back to Home</a>
            </div>
        </div>
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
        <!-- Seat Limit Card -->
        <div class="card border-danger mb-3 shadow-sm text-center mx-auto" style="max-width: 500px;">
            <div class="card-header bg-danger text-white">
                ❌ Booking Error
            </div>
            <div class="card-body">
                <p class="card-text">You can book between 1 and <strong><%= availableSlots %></strong> seat(s).</p>
                <a href="index.aspx" class="btn btn-danger">Back to Home</a>
            </div>
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
        <!-- Success Card -->
        <div class="card border-success mb-3 shadow-sm text-center mx-auto" style="max-width: 500px;">
            <div class="card-header bg-success text-white">
                ✅ Booking Successful
            </div>
            <div class="card-body">
                <p class="card-text">
                    You have successfully booked <strong><%= seatBooked %></strong> seat(s) for <strong><%= packageTitle %></strong>.
                </p>
                <a href="history.aspx" class="btn btn-success me-2">View My Bookings</a>
                <a href="index.aspx" class="btn btn-outline-success">Back to Home</a>
            </div>
        </div>
        <%
            }
            catch (SqlException ex)
            {
        %>
        <!-- SQL Error Card -->
        <div class="card border-danger mb-3 shadow-sm text-center mx-auto" style="max-width: 500px;">
            <div class="card-header bg-danger text-white">
                ❌ Booking Failed
            </div>
            <div class="card-body">
                <p class="card-text">Error: <%= ex.Message %></p>
                <a href="index.aspx" class="btn btn-danger">Back to Home</a>
            </div>
        </div>
        <%
                        }
                    }
                }
            }
        %>

        <!-- Booking Form -->
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
                <input type="number" id="SeatBooked" name="SeatBooked" class="form-control" min="1" max="<%= availableSlots %>" value="1" required onchange="showTravelerFields()" />
                <small class="text-muted">Available Seats: <%= availableSlots %></small>
            </div>

            <div id="travelerContainer"></div>

            <button type="submit" class="btn btn-primary w-100">Book Now</button>
            <div class="d-grid mt-2">
                <a href="index.aspx" class="btn btn-outline-secondary">Back to Home</a>
            </div>
        </form>

        <script>
            showTravelerFields();
        </script>

        <%
            }
            else
            {
        %>
        <!-- Invalid Package ID -->
        <div class="card border-warning mb-3 shadow-sm text-center mx-auto" style="max-width: 500px;">
            <div class="card-header bg-warning text-dark">
                ⚠️ Invalid Package ID
            </div>
            <div class="card-body">
                <p class="card-text">The package ID provided is invalid.</p>
                <a href="index.aspx" class="btn btn-warning">Back to Home</a>
            </div>
        </div>
        <%
            }
        %>
    </div>

</body>
</html>
