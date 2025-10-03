<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="contact.aspx.cs" Inherits="TourismWebApplication.conatctus1" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>Contact Page</title>
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
                    <a href="service.aspx" class="nav-item nav-link">Services</a>
                    <a href="package.aspx" class="nav-item nav-link">Packages</a>
                    <a href="history.aspx" class="nav-item nav-link">History</a>
                    <a href="contact.aspx" class="nav-item nav-link active">Contact</a>
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
                        <h1 class="display-3 text-white mb-3 animated slideInDown">Contact Us</h1>
                        <p class="fs-4 text-light mb-4 animated fadeInUp">Your Travel Queries, Our Expert Answers.</p>
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


    <!-- Contact Start -->
    <div class="container-xxl py-5">
        <div class="container">
            <div class="text-center wow fadeInUp" data-wow-delay="0.1s">
                <h6 class="section-title bg-white text-center text-primary px-3">Contact Us</h6>
                <h1 class="mb-5">Contact For Any Query</h1>
            </div>
            <div class="row g-4">
                <div class="col-lg-4 col-md-6 wow fadeInUp" data-wow-delay="0.1s">
                    <h5>Get In Touch</h5>
                    <p class="mb-4">“We Listen, We Plan, You Travel!”</p>
                    <div class="d-flex align-items-center mb-4">
                        <div class="d-flex align-items-center justify-content-center flex-shrink-0 bg-primary" style="width: 50px; height: 50px;">
                            <i class="fa fa-map-marker-alt text-white"></i>
                        </div>
                        <div class="ms-3">
                            <h5 class="text-primary">Office</h5>
                            <p class="mb-0">Shivaji Nagar, Pune, Maharashtra</p>
                        </div>
                    </div>
                    <div class="d-flex align-items-center mb-4">
                        <div class="d-flex align-items-center justify-content-center flex-shrink-0 bg-primary" style="width: 50px; height: 50px;">
                            <i class="fa fa-phone-alt text-white"></i>
                        </div>
                        <div class="ms-3">
                            <h5 class="text-primary">Mobile</h5>
                            <p class="mb-0">+91 9191919191</p>
                        </div>
                    </div>
                    <div class="d-flex align-items-center">
                        <div class="d-flex align-items-center justify-content-center flex-shrink-0 bg-primary" style="width: 50px; height: 50px;">
                            <i class="fa fa-envelope-open text-white"></i>
                        </div>
                        <div class="ms-3">
                            <h5 class="text-primary">Email</h5>
                            <p class="mb-0">ikagailife86@example.com</p>
                        </div>
                    </div>
                </div>
                <!-- <div class="col-lg-4 col-md-6 wow fadeInUp" data-wow-delay="0.3s">
                    <iframe class="position-relative rounded w-100 h-100"
                        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3001156.4288297426!2d-78.01371936852176!3d42.72876761954724!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x4ccc4bf0f123a5a9%3A0xddcfc6c1de189567!2sNew%20York%2C%20USA!5e0!3m2!1sen!2sbd!4v1603794290143!5m2!1sen!2sbd"
                        frameborder="0" style="min-height: 300px; border:0;" allowfullscreen="" aria-hidden="false"
                        tabindex="0"></iframe>
                </div>--->
                <div class="col-lg-4 col-md-6 wow fadeInUp" data-wow-delay="0.3s">
                    <iframe class="position-relative rounded w-100 h-100"
                        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3782.906026926324!2d73.85674381523177!3d18.52043098740148!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3bc2bf2f9e3f5b69%3A0x7e3d6194f6b3d98f!2sPune%2C%20Maharashtra%2C%20India!5e0!3m2!1sen!2sin!4v1696245699999!5m2!1sen!2sin"
                        frameborder="0" style="min-height: 300px; border: 0;" allowfullscreen="" aria-hidden="false"
                        tabindex="0"></iframe>
                </div>

                <div class="col-lg-4 col-md-12 wow fadeInUp" data-wow-delay="0.5s">


                    <!--start-->
                    <form id="contactForm" method="POST">
                        <div class="container py-5">
                            <h2 class="mb-4 text-center">Contact Us</h2>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <input type="text" name="name" id="name" class="form-control" placeholder="Your Name" required>
                                </div>
                                <div class="col-md-6">
                                    <input type="email" name="email" id="email" class="form-control" placeholder="Your Email" required>
                                </div>
                                <div class="col-12">
                                    <input type="text" name="subject" id="subject" class="form-control" placeholder="Subject" required>
                                </div>
                                <div class="col-12">
                                    <textarea name="message" id="message" class="form-control" placeholder="Message" style="height: 100px" required></textarea>
                                </div>
                                <div class="col-12">
                                    <button type="submit" class="btn btn-primary w-100 py-2">Send Message</button>
                                </div>
                            </div>

                            <!-- Hidden fields required by FormSubmit -->
                            <input type="hidden" name="_captcha" value="false">
                            <input type="hidden" name="_template" value="table">
                        </div>
                    </form>

                    <!-- JS Script -->
                    <script>
                        document.getElementById("contactForm").addEventListener("submit", function (event) {
                            event.preventDefault(); // stop normal form submit

                            fetch("https://formsubmit.co/ikagailife86@gmail.com", {
                                method: "POST",
                                body: new FormData(this)
                            })
                                .then(response => {
                                    if (response.ok) {
                                        alert("✅ Sent Successfully!");
                                        this.reset(); // clear form fields
                                    } else {
                                        alert("❌ Something went wrong!");
                                    }
                                })
                                .catch(error => {
                                    alert("⚠️ Error: " + error.message);
                                });
                        });
                    </script>



                    <!--end-->


                </div>
            </div>
        </div>
    </div>
    <!-- Contact End -->

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
