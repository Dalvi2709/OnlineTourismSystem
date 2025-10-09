<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PackageDetails.aspx.cs" Inherits="TourismWebApplication.PackageDetails" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>Package Details</title>
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
                    <a href="package.aspx" class="nav-item nav-link active">Packages</a>
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
                        <h1 class="display-3 text-white mb-3 animated slideInDown">Enjoy Your Vacation With Us</h1>
                        <p class="fs-4 text-light mb-4 animated fadeInUp">Discover amazing places, adventures, and memories waiting for you</p>
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

    <!-- PackageDetails Start -->

    <div class="container mt-5">
        <asp:Panel ID="pnlPackage" runat="server" Visible="false">
            <div class="card shadow-lg mb-4">
                <div class="row g-0">
                    <!-- Package Image -->
                    <div class="col-md-5">
                        <asp:Image ID="imgPackage" runat="server" CssClass="img-fluid rounded-start"
                            AlternateText="Package Image" Style="height: 100%; object-fit: cover;" />
                    </div>

                    <!-- Package Details -->
                    <div class="col-md-7">
                        <div class="card-body">
                            <h2 class="card-title text-primary fw-bold mb-2">
                                <i class="bi bi-box-seam me-2"></i>
                                <asp:Label ID="lblTitle" runat="server" />
                            </h2>
                            <span id="lblStatus" runat="server"></span>

                            <div class="mb-2"><i class="bi bi-cash-stack text-success me-1"></i><strong>Price:</strong> ₹<asp:Label ID="lblPrice" runat="server" /></div>
                            <div class="mb-2">
                                <i class="bi bi-geo-alt-fill text-danger me-1"></i><strong>Location:</strong>
                                <asp:Label ID="lblLocation" runat="server" />
                            </div>
                            <div class="mb-2">
                                <i class="bi bi-calendar-event text-warning me-1"></i><strong>Start Date:</strong>
                                <asp:Label ID="lblStartDate" runat="server" />
                                &nbsp; | &nbsp; <strong>End Date:</strong>
                                <asp:Label ID="lblEndDate" runat="server" />
                            </div>
                            <div class="mb-2">
                                <i class="bi bi-people-fill text-info me-1"></i><strong>Audience:</strong>
                                <asp:Label ID="lblAudience" runat="server" />
                            </div>
                            <div class="mb-2">
                                <i class="bi bi-box2-heart text-danger me-1"></i><strong>Available Slots:</strong>
                                <asp:Label ID="lblSlots" runat="server" />
                            </div>
                            <div class="mb-2">
                                <i class="bi bi-card-text text-secondary me-1"></i><strong>Description:</strong>
                                <asp:Label ID="lblDescription" runat="server" />
                            </div>
                            <div class="mb-2">
                                <i class="bi bi-arrow-left-right text-secondary me-1"></i><strong>Source / Destination:</strong>
                                <asp:Label ID="lblSourceDest" runat="server" />
                            </div>
                            <a href="package.aspx" class="btn btn-secondary mt-2"><i class="bi bi-arrow-left-circle me-1"></i>Back to Packages</a>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>

        <asp:Label ID="lblMessage" runat="server" CssClass="alert alert-danger" Visible="false"></asp:Label>
    </div>

    <!-- Package Staff Details -->
    <div class="card shadow-lg p-4 mb-4">
        <h4 class="mb-3 text-primary">
            <i class="bi bi-people-fill me-2"></i>Assigned Staff
        </h4>

        <asp:Repeater ID="rptStaff" runat="server">
            <HeaderTemplate>
                <div class="table-responsive">
                    <table class="table table-bordered table-striped align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Staff Role</th>
                                <th>Assigned Role</th>
                                <th>Assigned Date</th>
                            </tr>
                        </thead>
                        <tbody>
            </HeaderTemplate>

            <ItemTemplate>
                <tr>
                    <td><i class="bi bi-person-circle me-1"></i><%# Eval("Name") %></td>
                    <td><%# Eval("Email") %></td>
                    <td><%# Eval("Phone") %></td>
                    <td><span class="badge bg-info text-dark"><%# Eval("Role") %></span></td>
                    <td><span class="badge bg-success"><%# Eval("AssignedRole") %></span></td>
                    <td><%# Eval("AssignedDate", "{0:dd-MMM-yyyy}") %></td>
                </tr>
            </ItemTemplate>

            <FooterTemplate>
                </tbody>
                </table>
            </div>
            </FooterTemplate>
        </asp:Repeater>

        <asp:Label ID="lblNoStaff" runat="server" CssClass="text-muted" Visible="false" />
    </div>

    <!-- PackageDetails End -->

    <!-- Footer Start -->
    <div class="container-fluid bg-dark text-light footer pt-5 mt-5 wow fadeIn" data-wow-delay="0.1s">
        <div class="container py-5">
            <div class="row g-5">
                <div class="col-lg-3 col-md-6">
                    <h4 class="text-white mb-3">Company</h4>
                    <a class="btn btn-link" href="">About Us</a>
                    <a class="btn btn-link" href="">Contact Us</a>
                    <a class="btn btn-link" href="">Privacy Policy</a>
                    <a class="btn btn-link" href="">Terms & Condition</a>
                    <a class="btn btn-link" href="">FAQs & Help</a>
                </div>
                <div class="col-lg-3 col-md-6">
                    <h4 class="text-white mb-3">Contact</h4>
                    <p class="mb-2"><i class="fa fa-map-marker-alt me-3"></i>123 Street, New York, USA</p>
                    <p class="mb-2"><i class="fa fa-phone-alt me-3"></i>+012 345 67890</p>
                    <p class="mb-2"><i class="fa fa-envelope me-3"></i>info@example.com</p>
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
                            <img class="img-fluid bg-light p-1" src="img/package-1.jpg" alt="">
                        </div>
                        <div class="col-4">
                            <img class="img-fluid bg-light p-1" src="img/package-2.jpg" alt="">
                        </div>
                        <div class="col-4">
                            <img class="img-fluid bg-light p-1" src="img/package-3.jpg" alt="">
                        </div>
                        <div class="col-4">
                            <img class="img-fluid bg-light p-1" src="img/package-2.jpg" alt="">
                        </div>
                        <div class="col-4">
                            <img class="img-fluid bg-light p-1" src="img/package-3.jpg" alt="">
                        </div>
                        <div class="col-4">
                            <img class="img-fluid bg-light p-1" src="img/package-1.jpg" alt="">
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <h4 class="text-white mb-3">Newsletter</h4>
                    <p>Dolor amet sit justo amet elitr clita ipsum elitr est.</p>
                    <div class="position-relative mx-auto" style="max-width: 400px;">
                        <input class="form-control border-primary w-100 py-3 ps-4 pe-5" type="text" placeholder="Your email">
                        <button type="button" class="btn btn-primary py-2 position-absolute top-0 end-0 mt-2 me-2">SignUp</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="container">
            <div class="copyright">
                <div class="row">
                    <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
                        &copy; <a class="border-bottom" href="#">Your Site Name</a>, All Right Reserved.

                        <!--/*** This template is free as long as you keep the footer author’s credit link/attribution link/backlink. If you'd like to use the template without the footer author’s credit link/attribution link/backlink, you can purchase the Credit Removal License from "https://htmlcodex.com/credit-removal". Thank you for your support. ***/-->
                        Designed By <a class="border-bottom" href="https://htmlcodex.com">HTML Codex</a>
                    </div>
                    <div class="col-md-6 text-center text-md-end">
                        <div class="footer-menu">
                            <a href="">Home</a>
                            <a href="">Cookies</a>
                            <a href="">Help</a>
                            <a href="">FQAs</a>
                        </div>
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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- alert will be Auto-dismiss after a few seconds -->
    <script>
        setTimeout(function () {
            const alert = document.querySelector('.alert');
            if (alert) {
                alert.classList.remove('show');
                alert.classList.add('hide');
            }
        }, 5000); // 5000ms = 5 seconds
    </script>

</body>

</html>

