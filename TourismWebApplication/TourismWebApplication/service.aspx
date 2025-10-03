<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="service.aspx.cs" Inherits="TourismWebApplication.services1" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>Service Page</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="" name="keywords">
    <meta content="" name="description">

    <!-- Favicon -->
    <link href="img/favicon.ico" rel="icon">

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
        .trip-img {
            border-radius: 20px; /* Curved edges */
            height: 220px; /* Fixed height for uniform display */
            width: 100%; /* Make all images fit column width */
            object-fit: cover; /* Crop image neatly without stretching */
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

            .trip-img:hover {
                transform: scale(1.05); /* Zoom on hover */
                box-shadow: 0px 8px 20px rgba(0,0,0,0.2);
            }

        .trip-card h5 {
            font-weight: 600;
            margin-top: 12px;
        }
    </style>
</head>

<body>
    <!-- Spinner Start -->
    <div id="spinner" class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
        <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
            <span class="sr-only">Loading...</span>
        </div>
    </div>
    <!-- Spinner End -->




    <!-- Navbar & Hero Start -->

    <div class="container-fluid position-relative p-0">
        <nav class="navbar navbar-expand-lg navbar-light px-4 px-lg-5 py-3 py-lg-0">
            <a href="index.aspx" class="navbar-brand p-0">
                <h1 class="text-primary m-0"><i class="fa fa-map-marker-alt me-3"></i>Tourist</h1>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                <span class="fa fa-bars"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarCollapse">
                <div class="navbar-nav ms-auto py-0">
                    <a href="index.aspx" class="nav-item nav-link ">Home</a>
                    <a href="about.aspx" class="nav-item nav-link">About</a>
                    <a href="service.aspx" class="nav-item nav-link active">Services</a>
                    <a href="package.aspx" class="nav-item nav-link">Packages</a>
                    <a href="history.aspx" class="nav-item nav-link">History</a>
                    <a href="contact.aspx" class="nav-item nav-link">Contact</a>
                </div>

                <% if (Session["UserEmail"] == null)
                    { %>
                <a href="Register.aspx" class="btn btn-primary py-2 px-4">Register</a>
                <a href="Login.aspx" class="btn btn-primary py-2 px-4 mx-2">Login</a>
                <% }
                    else
                    { %>
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

        <div class="container-fluid bg-primary py-5 mb-5 hero-header">
            <div class="container py-5">
                <div class="row justify-content-center py-5">
                    <div class="col-lg-10 pt-lg-5 mt-lg-5 text-center">
                        <h1 class="display-3 text-white mb-3 animated slideInDown">Services</h1>
                        <h4 class="text-white">makes travel planning smarter, easier, and more enjoyable.</h4>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div style="position: fixed; bottom: 20px; right: 20px; z-index: 1050;">
        <% 
            string msg = Request.QueryString["msg"];
            string type = Request.QueryString["type"];
            string alertClass = "";

            if (!string.IsNullOrEmpty(type))
            {
                if (type == "success") alertClass = "alert-success";
                else if (type == "error") alertClass = "alert-danger";
                else if (type == "info") alertClass = "alert-info";
                else alertClass = "alert-secondary";
            }

            if (!string.IsNullOrEmpty(msg))
            {
        %>
        <div class="alert <%= alertClass %> alert-dismissible fade show" role="alert" style="min-width: 250px;">
            <%= msg %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% } %>
    </div>


    <!-- Navbar & Hero End -->


    <!-- Service Start -->
    <div class="container-xxl py-5">
        <div class="container">
            <div class="text-center wow fadeInUp" data-wow-delay="0.1s">
                <h6 class="section-title bg-white text-center text-primary px-3">Services</h6>
                <h1 class="mb-5">Our Services</h1>
            </div>
            <div class="row g-4">
                <div class="col-lg-3 col-sm-6 wow fadeInUp" data-wow-delay="0.1s">
                    <div class="service-item rounded pt-3">
                        <div class="p-4">
                            <i class="fa fa-3x fa-check-circle text-primary mb-4"></i>

                            <h5>Easy Booking</h5>
                            <p>Book tours online in just a few clicks with a smooth process</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-sm-6 wow fadeInUp" data-wow-delay="0.3s">
                    <div class="service-item rounded pt-3">
                        <div class="p-4">
                            <i class="fa fa-3x fa-map text-primary mb-4"></i>

                            <h5>All-India Tours</h5>
                            <p>From Kashmir to Kanyakumari- explore every corner of India.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-sm-6 wow fadeInUp" data-wow-delay="0.5s">
                    <div class="service-item rounded pt-3">
                        <div class="p-4">
                            <i class="fa fa-3x fa-user text-primary mb-4"></i>
                            <h5>Travel Guides</h5>
                            <p>Experienced travel guides to make your journey memorable.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-sm-6 wow fadeInUp" data-wow-delay="0.7s">
                    <div class="service-item rounded pt-3">
                        <div class="p-4">
                            <i class="fa fa-3x fa-cog text-primary mb-4"></i>
                            <h5>24/7 Support</h5>
                            <p>Our team is always ready to help you anytime,anywhere.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-sm-6 wow fadeInUp" data-wow-delay="0.1s">
                    <div class="service-item rounded pt-3">
                        <div class="p-4">
                            <i class="fa fa-3x fa-rupee-sign text-primary mb-4"></i>

                            <h5>Affordable Packages</h5>
                            <p>Budget-friendly pricing with no hidden charges.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-sm-6 wow fadeInUp" data-wow-delay="0.3s">
                    <div class="service-item rounded pt-3">
                        <div class="p-4">
                            <i class="fa fa-3x fa-user-friends text-primary mb-4"></i>

                            <h5>Group & Corporate Tours</h5>
                            <p>Special arrangements for families,corporates & school trips.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-sm-6 wow fadeInUp" data-wow-delay="0.5s">
                    <div class="service-item rounded pt-3">
                        <div class="p-4">
                            <i class="fa fa-3x fa-gem text-primary mb-4"></i>

                            <h5>Luxury & Comfort Travel</h5>
                            <p>Premium stays,private cabs & comfortable journeys for a stress-free holiday.</p>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-sm-6 wow fadeInUp" data-wow-delay="0.7s">
                    <div class="service-item rounded pt-3">
                        <div class="p-4">
                            <i class="fa fa-3x fa-utensils text-primary mb-4"></i>

                            <h5>Delicious Meals</h5>
                            <p>Enjoy hygienic and tasty local & continental food during your trip.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Service End -->


    <!-- Testimonial Start -->
    <div class="container-xxl py-5 wow fadeInUp" data-wow-delay="0.1s">
        <div class="container">

            <div class="container-xxl py-5">
                <div class="container text-center">
                    <div class="text-center">
                        <h6 class="section-title bg-white text-center text-primary px-3">Plan your Trip</h6>
                        <h1 class="mb-5">Let Us Plan You a Perfect Holiday!!!</h1>
                    </div>
                    -


    <div class="row g-4 justify-content-center">

        <!-- City -->
        <div class="col-lg-2 col-md-4 col-sm-6">
            <div class="trip-card">
                <img src="./assets/city.jpg" class="img-fluid trip-img" alt="City Tours">
                <h5 class="mt-3">City Tours</h5>
            </div>
        </div>

        <!-- Museum -->
        <div class="col-lg-2 col-md-4 col-sm-6">
            <div class="trip-card">
                <img src="./assets/museum.jpg" class="img-fluid trip-img" alt="Museums">
                <h5 class="mt-3">Museums</h5>
            </div>
        </div>

        <!-- Beaches -->
        <div class="col-lg-2 col-md-4 col-sm-6">
            <div class="trip-card">
                <img src="./assets/beaches.jpg" class="img-fluid trip-img" alt="Beaches">
                <h5 class="mt-3">Beaches</h5>
            </div>
        </div>

        <!-- Hiking -->
        <div class="col-lg-2 col-md-4 col-sm-6">
            <div class="trip-card">
                <img src="./assets/hiking.jpg" class="img-fluid trip-img" alt="Hiking">
                <h5 class="mt-3">Hiking</h5>
            </div>
        </div>

        <!-- Temples -->
        <div class="col-lg-2 col-md-4 col-sm-6">
            <div class="trip-card">
                <img src="./assets/temple.jpg" class="img-fluid trip-img" alt="Temples">
                <h5 class="mt-3">Temples</h5>
            </div>
        </div>

    </div>
                </div>
            </div>
            <!---trip section over-->
        </div>
    </div>
    <!-- Testimonial End -->

    <!-- Footer Start -->
    <div class="container-fluid bg-dark text-light footer pt-5 mt-5 wow fadeIn" data-wow-delay="0.1s">
        <div class="container py-5">
            <div class="row g-5">
                <div class="col-lg-3 col-md-6">
                    <h4 class="text-white mb-3">Company</h4>
                    <a class="btn btn-link" href="about.aspx">About Us</a>
                    <a class="btn btn-link" href="contact.aspx">Contact Us</a>

                </div>
                <div class="col-lg-3 col-md-6">
                    <h4 class="text-white mb-3">Contact</h4>
                    <p class="mb-2"><i class="fa fa-map-marker-alt me-3"></i>ShivajiNagar,Pune,Maharashtra</p>
                    <p class="mb-2"><i class="fa fa-phone-alt me-3"></i>+91 9191919191</p>
                    <p class="mb-2"><i class="fa fa-envelope me-3"></i>ikagailife86@gmail.com</p>
                    <div class="d-flex pt-2">
                        <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-twitter"></i></a>
                        <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-facebook-f"></i></a>
                        <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-youtube"></i></a>
                        <a class="btn btn-outline-light btn-social" href=""><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <h4 class="text-white mb-3">Gallery</h4>
                    <div class="row g-2 pt-2">
                        <div class="col-4">
                            <img class="img-fluid bg-light p-1" src="assets/footer1.jpg" alt="">
                        </div>
                        <div class="col-4">
                            <img class="img-fluid bg-light p-1" src="assets/footer2.jpg" alt="">
                        </div>
                        <div class="col-4">
                            <img class="img-fluid bg-light p-1" src="assets/footer3.jpg" alt="">
                        </div>
                        <div class="col-4">
                            <img class="img-fluid bg-light p-1" src="assets/footer4.jpg" alt="">
                        </div>
                        <div class="col-4">
                            <img class="img-fluid bg-light p-1" src="assets/footer5.jpg" alt="">
                        </div>
                        <div class="col-4">
                            <img class="img-fluid bg-light p-1" src="assets/footer6.jpg" alt="">
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!-- Footer End -->


        <!-- Back to Top -->
        <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>


        <!-- JavaScript Libraries -->
        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="lib/wow/wow.min.js"></script>
        <script src="lib/easing/easing.min.js"></script>
        <script src="lib/waypoints/waypoints.min.js"></script>
        <script src="lib/owlcarousel/owl.carousel.min.js"></script>
        <script src="lib/tempusdominus/js/moment.min.js"></script>
        <script src="lib/tempusdominus/js/moment-timezone.min.js"></script>
        <script src="lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>

        <!-- Template Javascript -->
        <script src="js/main.js"></script>
</body>

</html>
