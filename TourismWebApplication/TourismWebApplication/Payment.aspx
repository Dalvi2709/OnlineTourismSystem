<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Payment - Tourism Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    
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
    
    <style>
        .payment-card {
            max-width: 700px;
            margin: 50px auto;
        }
        .payment-method {
            cursor: pointer;
            transition: all 0.3s;
            border: 2px solid #dee2e6;
        }
        .payment-method:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .payment-method.selected {
            border: 3px solid #0d6efd;
            background-color: #e7f1ff;
        }
        .card-input {
            font-family: 'Courier New', monospace;
        }
    </style>
</head>
<body class="bg-light">

<%
    string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
    string bookingId = Request.QueryString["bookingId"];
    string userId = Session["UserID"] != null ? Session["UserID"].ToString() : null;

    if (userId == null)
    {
%>
    <!-- Login Required Card -->
    <div class="container py-5">
        <div class="card border-warning mb-3 shadow-sm text-center mx-auto" style="max-width: 500px;">
            <div class="card-header bg-warning text-dark">
                ⚠️ Login Required
            </div>
            <div class="card-body">
                <p class="card-text">You need to login to make a payment.</p>
                <a href="Login.aspx" class="btn btn-warning">Login Now</a>
            </div>
            <div class="d-grid mt-2">
                <a href="index.aspx" class="btn btn-outline-secondary">Back to Home</a>
            </div>
        </div>
    </div>
<%
        return;
    }

    if (string.IsNullOrEmpty(bookingId))
    {
%>
    <!-- Invalid Booking ID -->
    <div class="container py-5">
        <div class="card border-warning mb-3 shadow-sm text-center mx-auto" style="max-width: 500px;">
            <div class="card-header bg-warning text-dark">
                ⚠️ Invalid Booking
            </div>
            <div class="card-body">
                <p class="card-text">No booking ID provided.</p>
                <a href="history.aspx" class="btn btn-warning">View My Bookings</a>
            </div>
        </div>
    </div>
<%
        return;
    }

    decimal totalAmount = 0;
    string packageTitle = "";
    int seatBooked = 0;
    string bookingStatus = "";
    string paymentStatus = "";
    bool isValidBooking = false;

    using (SqlConnection conn = new SqlConnection(connStr))
    {
        conn.Open();

        // Fetch booking details
        string query = @"SELECT b.BookingID, b.SeatBooked, b.Status, b.PaymentStatus, 
                               p.Title, p.Price
                        FROM Bookings b
                        INNER JOIN Packages p ON b.PackageID = p.PackageID
                        WHERE b.BookingID = @BookingID AND b.UserID = @UserID";

        SqlCommand cmd = new SqlCommand(query, conn);
        cmd.Parameters.AddWithValue("@BookingID", bookingId);
        cmd.Parameters.AddWithValue("@UserID", userId);

        using (SqlDataReader reader = cmd.ExecuteReader())
        {
            if (reader.Read())
            {
                isValidBooking = true;
                packageTitle = reader["Title"].ToString();
                seatBooked = Convert.ToInt32(reader["SeatBooked"]);
                decimal pricePerSeat = Convert.ToDecimal(reader["Price"]);
                totalAmount = pricePerSeat * seatBooked;
                bookingStatus = reader["Status"].ToString();
                paymentStatus = reader["PaymentStatus"].ToString();
            }
        }

        if (!isValidBooking)
        {
%>
    <!-- Booking Not Found Card -->
    <div class="container py-5">
        <div class="card border-danger mb-3 shadow-sm text-center mx-auto" style="max-width: 500px;">
            <div class="card-header bg-danger text-white">
                ⚠️ Booking Not Found
            </div>
            <div class="card-body">
                <p class="card-text">The booking you are trying to pay for does not exist or doesn't belong to you.</p>
                <a href="history.aspx" class="btn btn-danger">View My Bookings</a>
            </div>
        </div>
    </div>
<%
            return;
        }

        // Check if already paid
        if (paymentStatus == "Paid")
        {
%>
    <div class="container py-5">
        <div class="card border-success mb-3 shadow-sm text-center mx-auto" style="max-width: 500px;">
            <div class="card-header bg-success text-white">
                ✅ Already Paid
            </div>
            <div class="card-body">
                <p class="card-text">This booking has already been paid for.</p>
                <a href="history.aspx" class="btn btn-success me-2">View My Bookings</a>
                <a href="index.aspx" class="btn btn-outline-success">Back to Home</a>
            </div>
        </div>
    </div>
<%
            return;
        }

        // Process Payment
        if (Request.HttpMethod == "POST")
        {
            string paymentMethod = Request.Form["paymentMethod"];
            
            if (string.IsNullOrEmpty(paymentMethod))
            {
%>
    <div class="container py-5">
        <div class="card border-danger mb-3 shadow-sm text-center mx-auto" style="max-width: 500px;">
            <div class="card-header bg-danger text-white">
                ❌ Payment Failed
            </div>
            <div class="card-body">
                <p class="card-text">Please select a payment method.</p>
                <a href="Payment.aspx?bookingId=<%= bookingId %>" class="btn btn-danger">Try Again</a>
            </div>
        </div>
    </div>
<%
                return;
            }

            string status = "Succeeded"; // Simulate successful payment

            try
            {
                // Insert payment record
                string insertPayment = @"INSERT INTO Payments (BookingID, Amount, PaymentMethod, PaymentDate, Status)
                                       VALUES (@BookingID, @Amount, @PaymentMethod, GETDATE(), @Status)";
                SqlCommand payCmd = new SqlCommand(insertPayment, conn);
                payCmd.Parameters.AddWithValue("@BookingID", bookingId);
                payCmd.Parameters.AddWithValue("@Amount", totalAmount);
                payCmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod);
                payCmd.Parameters.AddWithValue("@Status", status);
                payCmd.ExecuteNonQuery();

                // Update booking status
                string updateBooking = @"UPDATE Bookings 
                                       SET PaymentStatus = 'Paid', Status = 'Confirmed'
                                       WHERE BookingID = @BookingID";
                SqlCommand updateCmd = new SqlCommand(updateBooking, conn);
                updateCmd.Parameters.AddWithValue("@BookingID", bookingId);
                updateCmd.ExecuteNonQuery();
%>
    <!-- Success Card -->
    <div class="container py-5">
        <div class="card border-success mb-3 shadow-sm text-center mx-auto payment-card">
            <div class="card-header bg-success text-white">
                <h4><i class="fas fa-check-circle"></i> Payment Successful</h4>
            </div>
            <div class="card-body">
                <div class="text-center mb-4">
                    <i class="fas fa-check-circle text-success" style="font-size: 80px;"></i>
                </div>
                <div class="alert alert-success">
                    <strong>Payment Confirmed!</strong> Your booking has been confirmed.
                </div>
                <table class="table table-borderless">
                    <tr>
                        <td><strong>Package:</strong></td>
                        <td><%= packageTitle %></td>
                    </tr>
                    <tr>
                        <td><strong>Seats Booked:</strong></td>
                        <td><%= seatBooked %></td>
                    </tr>
                    <tr>
                        <td><strong>Amount Paid:</strong></td>
                        <td><span class="text-success fs-5 fw-bold">₹<%= totalAmount.ToString("N2") %></span></td>
                    </tr>
                    <tr>
                        <td><strong>Payment Method:</strong></td>
                        <td><%= paymentMethod %></td>
                    </tr>
                    <tr>
                        <td><strong>Booking Status:</strong></td>
                        <td><span class="badge bg-success">Confirmed</span></td>
                    </tr>
                </table>
                <div class="text-center mt-4">
                    <a href="history.aspx" class="btn btn-success me-2">
                        <i class="fas fa-history"></i> View My Bookings
                    </a>
                    <a href="index.aspx" class="btn btn-outline-success">
                        <i class="fas fa-home"></i> Back to Home
                    </a>
                </div>
            </div>
        </div>
    </div>
<%
                return;
            }
            catch (SqlException ex)
            {
%>
    <!-- SQL Error Card -->
    <div class="container py-5">
        <div class="card border-danger mb-3 shadow-sm text-center mx-auto" style="max-width: 500px;">
            <div class="card-header bg-danger text-white">
                ❌ Payment Failed
            </div>
            <div class="card-body">
                <p class="card-text">Error: <%= ex.Message %></p>
                <a href="Payment.aspx?bookingId=<%= bookingId %>" class="btn btn-danger">Try Again</a>
            </div>
        </div>
    </div>
<%
                return;
            }
        }
    }
%>

    <!-- Payment Form -->
    <div class="container py-5">
        <div class="card payment-card shadow">
            <div class="card-header bg-primary text-white text-center">
                <h4><i class="fas fa-credit-card"></i> Complete Your Payment</h4>
            </div>
            <div class="card-body">
                <!-- Booking Summary -->
                <div class="alert alert-info mb-4">
                    <h5 class="alert-heading"><i class="fas fa-info-circle"></i> Booking Summary</h5>
                    <hr>
                    <table class="table table-borderless mb-0">
                        <tr>
                            <td><strong>Package:</strong></td>
                            <td><%= packageTitle %></td>
                        </tr>
                        <tr>
                            <td><strong>Number of Seats:</strong></td>
                            <td><%= seatBooked %></td>
                        </tr>
                        <tr>
                            <td><strong>Total Amount:</strong></td>
                            <td><span class="text-primary fs-4 fw-bold">₹<%= totalAmount.ToString("N2") %></span></td>
                        </tr>
                    </table>
                </div>

                <!-- Payment Form -->
                <form method="post" id="paymentForm">
                    <h5 class="mb-3">Select Payment Method</h5>
                    
                    <div class="row g-3 mb-4">
                        <!-- Card Payment -->
                        <div class="col-md-6">
                            <div class="card payment-method" onclick="selectPayment('Card')">
                                <div class="card-body text-center py-4">
                                    <i class="fas fa-credit-card fa-3x text-primary mb-2"></i>
                                    <h6>Credit/Debit Card</h6>
                                    <input type="radio" name="paymentMethod" value="Card" id="cardRadio" hidden>
                                </div>
                            </div>
                        </div>

                        <!-- UPI Payment -->
                        <div class="col-md-6">
                            <div class="card payment-method" onclick="selectPayment('UPI')">
                                <div class="card-body text-center py-4">
                                    <i class="fas fa-mobile-alt fa-3x text-success mb-2"></i>
                                    <h6>UPI</h6>
                                    <input type="radio" name="paymentMethod" value="UPI" id="upiRadio" hidden>
                                </div>
                            </div>
                        </div>

                        <!-- Net Banking -->
                        <div class="col-md-6">
                            <div class="card payment-method" onclick="selectPayment('NetBanking')">
                                <div class="card-body text-center py-4">
                                    <i class="fas fa-university fa-3x text-info mb-2"></i>
                                    <h6>Net Banking</h6>
                                    <input type="radio" name="paymentMethod" value="NetBanking" id="netbankingRadio" hidden>
                                </div>
                            </div>
                        </div>

                        <!-- Wallet -->
                        <div class="col-md-6">
                            <div class="card payment-method" onclick="selectPayment('Wallet')">
                                <div class="card-body text-center py-4">
                                    <i class="fas fa-wallet fa-3x text-warning mb-2"></i>
                                    <h6>Digital Wallet</h6>
                                    <input type="radio" name="paymentMethod" value="Wallet" id="walletRadio" hidden>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Card Details (shown when Card is selected) -->
                    <div id="cardDetails" style="display: none;">
                        <h6 class="mb-3"><i class="fas fa-credit-card"></i> Enter Card Details</h6>
                        <div class="mb-3">
                            <label class="form-label">Card Number</label>
                            <input type="text" class="form-control card-input" id="cardNumber" 
                                   placeholder="1234 5678 9012 3456" maxlength="19">
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Expiry Date</label>
                                <input type="text" class="form-control card-input" id="expiryDate" 
                                       placeholder="MM/YY" maxlength="5">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">CVV</label>
                                <input type="password" class="form-control card-input" id="cvv" 
                                       placeholder="123" maxlength="3">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Cardholder Name</label>
                            <input type="text" class="form-control" id="cardName" placeholder="John Doe">
                        </div>
                    </div>

                    <!-- UPI Details -->
                    <div id="upiDetails" style="display: none;">
                        <h6 class="mb-3"><i class="fas fa-mobile-alt"></i> Enter UPI ID</h6>
                        <div class="mb-3">
                            <label class="form-label">UPI ID</label>
                            <input type="text" class="form-control" id="upiId" placeholder="yourname@upi">
                            <small class="text-muted">Enter your UPI ID (e.g., 9876543210@paytm)</small>
                        </div>
                    </div>

                    <!-- Net Banking Details -->
                    <div id="netbankingDetails" style="display: none;">
                        <h6 class="mb-3"><i class="fas fa-university"></i> Select Your Bank</h6>
                        <div class="mb-3">
                            <select class="form-select" id="bankName">
                                <option value="">Select Bank</option>
                                <option value="SBI">State Bank of India</option>
                                <option value="HDFC">HDFC Bank</option>
                                <option value="ICICI">ICICI Bank</option>
                                <option value="Axis">Axis Bank</option>
                                <option value="PNB">Punjab National Bank</option>
                                <option value="BOB">Bank of Baroda</option>
                            </select>
                        </div>
                    </div>

                    <!-- Wallet Details -->
                    <div id="walletDetails" style="display: none;">
                        <h6 class="mb-3"><i class="fas fa-wallet"></i> Select Your Wallet</h6>
                        <div class="mb-3">
                            <select class="form-select" id="walletName">
                                <option value="">Select Wallet</option>
                                <option value="Paytm">Paytm</option>
                                <option value="PhonePe">PhonePe</option>
                                <option value="GooglePay">Google Pay</option>
                                <option value="AmazonPay">Amazon Pay</option>
                                <option value="Mobikwik">Mobikwik</option>
                            </select>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <div class="d-grid gap-2 mt-4">
                        <button type="submit" class="btn btn-success btn-lg" id="payButton" disabled>
                            <i class="fas fa-lock"></i> Pay ₹<%= totalAmount.ToString("N2") %>
                        </button>
                        <a href="history.aspx" class="btn btn-outline-secondary">Cancel Payment</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function selectPayment(method) {
            // Remove all selected classes
            document.querySelectorAll('.payment-method').forEach(el => {
                el.classList.remove('selected');
            });

            // Hide all detail sections
            document.getElementById('cardDetails').style.display = 'none';
            document.getElementById('upiDetails').style.display = 'none';
            document.getElementById('netbankingDetails').style.display = 'none';
            document.getElementById('walletDetails').style.display = 'none';

            // Select the clicked method
            const radio = document.getElementById(method.toLowerCase() + 'Radio');
            if (radio) {
                radio.checked = true;
                radio.parentElement.classList.add('selected');
            }

            // Show relevant details
            if (method === 'Card') {
                document.getElementById('cardDetails').style.display = 'block';
            } else if (method === 'UPI') {
                document.getElementById('upiDetails').style.display = 'block';
            } else if (method === 'NetBanking') {
                document.getElementById('netbankingDetails').style.display = 'block';
            } else if (method === 'Wallet') {
                document.getElementById('walletDetails').style.display = 'block';
            }

            // Enable pay button
            document.getElementById('payButton').disabled = false;
        }

        // Format card number with spaces
        document.addEventListener('DOMContentLoaded', function () {
            const cardInput = document.getElementById('cardNumber');
            if (cardInput) {
                cardInput.addEventListener('input', function (e) {
                    let value = e.target.value.replace(/\s/g, '').replace(/\D/g, '');
                    let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value;
                    e.target.value = formattedValue;
                });
            }

            // Format expiry date
            const expiryInput = document.getElementById('expiryDate');
            if (expiryInput) {
                expiryInput.addEventListener('input', function (e) {
                    let value = e.target.value.replace(/\D/g, '');
                    if (value.length >= 2) {
                        value = value.slice(0, 2) + '/' + value.slice(2, 4);
                    }
                    e.target.value = value;
                });
            }

            // CVV only numbers
            const cvvInput = document.getElementById('cvv');
            if (cvvInput) {
                cvvInput.addEventListener('input', function (e) {
                    e.target.value = e.target.value.replace(/\D/g, '');
                });
            }
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>