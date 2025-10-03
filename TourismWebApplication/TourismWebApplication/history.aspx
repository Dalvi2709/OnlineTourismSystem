<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="history.aspx.cs" Inherits="TourismWebApplication.Customer.history" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Tourist - History</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/style.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>


    <style>
/* Smooth Zoom on Hover */
.carousel-item img {
    transition: transform 0.5s ease, filter 0.5s ease;
}
.carousel-item:hover img {
    transform: scale(1.05);
    filter: brightness(1.1);
}

/* Gradient overlay */
.carousel-caption.bg-gradient {
    background: linear-gradient(to top, rgba(0,0,0,0.7), rgba(0,0,0,0));
    max-width: 90%;
    margin-left: 0;
}

/* Text animations */
.animated { opacity: 0; transition: all 0.7s ease-out; }
.carousel-item.active .animated { opacity: 1; }
.fadeInDown { transform: translateY(-30px); }
.carousel-item.active .fadeInDown { transform: translateY(0); transition-delay: 0.3s; }
.fadeInUp { transform: translateY(30px); }
.carousel-item.active .fadeInUp { transform: translateY(0); transition-delay: 0.5s; }

/* Delay classes */
.delay-1 { transition-delay: 0.5s; }
.delay-2 { transition-delay: 0.7s; }

/* Rounded shadow */
.carousel-item .rounded { border-radius: 15px; }

        /* Status Badges */
        .badge-status { font-size: 0.9rem; padding: 0.4em 0.6em; }
        .badge-Pending { background-color: #ffc107; color: #fff; }
        .badge-Confirmed { background-color: #28a745; color: #fff; }
        .badge-Cancelled { background-color: #dc3545; color: #fff; }
        .badge-Unpaid { background-color: #dc3545; color: #fff; }
        .badge-Paid { background-color: #28a745; color: #fff; }
        .badge-Refunded { background-color: #17a2b8; color: #fff; }
    </style>
</head>
<body>
    <form id="form1" runat="server">

    <!-- Spinner Start -->
    <div id="spinner" class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
        <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
            <span class="sr-only">Loading...</span>
        </div>
    </div>
    <!-- Spinner End -->

    <!-- Navbar & Hero Start -->
    <div class="container-fluid position-relative p-0">
        <!-- Navbar -->
        <nav class="navbar navbar-expand-lg navbar-light px-4 px-lg-5 py-3 py-lg-0">
            <a href="index.aspx" class="navbar-brand p-0">
                <h1 class="text-primary m-0"><i class="fa fa-map-marker-alt me-3"></i>Tourist</h1>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                <span class="fa fa-bars"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarCollapse">
                <div class="navbar-nav ms-auto py-0">
                    <a href="index.aspx" class="nav-item nav-link">Home</a>
                    <a href="about.aspx" class="nav-item nav-link">About</a>
                    <a href="service.aspx" class="nav-item nav-link">Services</a>
                    <a href="package.aspx" class="nav-item nav-link">Packages</a>
                    <a href="history.aspx" class="nav-item nav-link active">History</a>
                    <a href="contact.aspx" class="nav-item nav-link">Contact</a>
                </div>

                <% if (Session["UserEmail"] == null) { %>
                    <a href="Register.aspx" class="btn btn-primary py-2 px-4">Register</a>
                    <a href="Login.aspx" class="btn btn-primary py-2 px-4 mx-2">Login</a>
                <% } else { %>
                    <div class="dropdown">
                        <a class="btn btn-primary dropdown-toggle" data-bs-toggle="dropdown">
                            <i class="fa fa-user"></i><%: Session["name"] %>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="Profile.aspx">Profile Management</a></li>
                            <li><a class="dropdown-item" href="Logout.aspx">Logout</a></li>
                        </ul>
                    </div>
                <% } %>
            </div>
        </nav>

        <!-- Hero -->
  <div class="container-fluid bg-primary py-5 mb-5 hero-header">
    <div class="container py-5">
        <div class="row justify-content-center py-5">
            <div class="col-lg-10 pt-lg-5 mt-lg-5 text-center">
                <!-- Animated Title -->
                <h1 class="display-3 text-white animate__animated animate__slideInDown">
                    History
                </h1>
                <!-- Animated Subtitle -->
                <h4 class="text-white animate__animated animate__fadeInUp animate__delay-1s">
                    Makes travel planning smarter, easier, and more enjoyable.
                </h4>
            </div>
        </div>
    </div>
</div>

    <!-- Navbar & Hero End -->

    <!-- History Content -->
    <div class="container py-5">

        <!-- Logged Out Users -->
  <asp:Panel ID="pnlNotLoggedIn" runat="server" Visible="false">
    <h3 class="text-center text-primary mb-5">Explore Our Popular Tours</h3>

    <div id="carouselTours" class="carousel slide carousel-fade" data-bs-ride="carousel">
        <div class="carousel-inner">

            <div class="carousel-item active">
                <div class="position-relative overflow-hidden rounded shadow-lg">
                    <img src="./assets/templeslider.jpg" class="d-block w-100" style="height: 400px; object-fit: cover;" alt="Temple Tour">
                    <div class="carousel-caption d-flex flex-column justify-content-end text-start p-4 bg-gradient rounded">
                        <h2 class="animated fadeInDown">Temple Tour</h2>
                        <p class="animated fadeInUp delay-1">Discover historic temples and spiritual sites.</p>
                        <a href="package.aspx" class="btn btn-primary btn-sm animated fadeInUp delay-2">View Packages</a>
                    </div>
                </div>
            </div>

            <div class="carousel-item">
                <div class="position-relative overflow-hidden rounded shadow-lg">
                    <img src="./assets/image1.jpg" class="d-block w-100" style="height: 400px; object-fit: cover;" alt="Hiking Adventure">
                    <div class="carousel-caption d-flex flex-column justify-content-end text-start p-4 bg-gradient rounded">
                        <h2 class="animated fadeInDown">Hiking Adventure</h2>
                        <p class="animated fadeInUp delay-1">Experience nature like never before.</p>
                        <a href="package.aspx" class="btn btn-primary btn-sm animated fadeInUp delay-2">View Packages</a>
                    </div>
                </div>
            </div>

            <div class="carousel-item">
                <div class="position-relative overflow-hidden rounded shadow-lg">
                    <img src="./assets/museumslider.jpg" class="d-block w-100" style="height: 400px; object-fit: cover;" alt="Museum Tour">
                    <div class="carousel-caption d-flex flex-column justify-content-end text-start p-4 bg-gradient rounded">
                        <h2 class="animated fadeInDown">Museum Tour</h2>
                        <p class="animated fadeInUp delay-1">Explore culture and history up close.</p>
                        <a href="package.aspx" class="btn btn-primary btn-sm animated fadeInUp delay-2">View Packages</a>
                    </div>
                </div>
            </div>

        </div>

        <!-- Controls -->
        <button class="carousel-control-prev" type="button" data-bs-target="#carouselTours" data-bs-slide="prev">
            <span class="carousel-control-prev-icon bg-dark rounded-circle p-3" aria-hidden="true"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#carouselTours" data-bs-slide="next">
            <span class="carousel-control-next-icon bg-dark rounded-circle p-3" aria-hidden="true"></span>
            <span class="visually-hidden">Next</span>
        </button>

        <!-- Indicators -->
        <div class="carousel-indicators mt-3">
            <button type="button" data-bs-target="#carouselTours" data-bs-slide-to="0" class="active"></button>
            <button type="button" data-bs-target="#carouselTours" data-bs-slide-to="1"></button>
            <button type="button" data-bs-target="#carouselTours" data-bs-slide-to="2"></button>
        </div>
    </div>
</asp:Panel>


        <!-- Logged In Users -->
        <asp:Panel ID="pnlLoggedIn" runat="server" Visible="false">
            <asp:Label ID="lblMessage" runat="server" CssClass="text-primary mb-4 d-block"></asp:Label>
            <div class="row">
                <asp:Repeater ID="rptHistory" runat="server">
                    <ItemTemplate>
                        <div class="col-md-4 mb-4">
                            <div class="card card-history h-100">
                                <img src='<%# Eval("PackageImage") %>' class="card-img-top" alt="Package Image" style="height: 200px; object-fit: cover;" />
                                <div class="card-body">
                                    <h5 class="card-title"><%# Eval("Title") %></h5>
                                    <p class="card-text"><strong>Location:</strong> <%# Eval("Location") %></p>
                                    <p class="card-text"><strong>Booking Date:</strong> <%# Eval("BookingDate", "{0:yyyy-MM-dd}") %></p>
                                    <p class="card-text"><strong>Travel Date:</strong> <%# Eval("TravelDate", "{0:yyyy-MM-dd}") %></p>
                                </div>
                                <div class="card-footer d-flex justify-content-between">
                                    <span class='badge badge-status badge-<%# Eval("Status") %>'><%# Eval("Status") %></span>
                                    <span class='badge badge-status badge-<%# Eval("PaymentStatus") %>'><%# Eval("PaymentStatus") %></span>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </asp:Panel>
    </div>

    <!-- Footer (unchanged) -->
    <div class="container-fluid bg-dark text-light footer pt-5 mt-5">
        <!-- Footer content unchanged -->
    </div>

    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/main.js"></script>
    </form>
</body>
</html>
