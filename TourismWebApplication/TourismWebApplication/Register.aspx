<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="TourismWebApplication.Register" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <title>Registration Form</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }

        .register-container {
            max-width: 500px;
            margin: 60px auto;
            background: #fff;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }

        .form-control:focus {
            border-color: #86b817;
            box-shadow: 0 0 0 0.2rem rgba(134,184,23,0.25);
        }

        .btn-custom {
            background-color: #86b817;
            border: none;
            color: white;
            font-weight: 500;
            transition: all 0.3s ease-in-out;
        }

        .btn-custom:hover {
            background-color: #6c9e14;
            transform: scale(1.02);
        }

        .error {
            color: red;
            font-size: 0.9rem;
            display: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="register-container">
            <h3 class="text-center mb-4" style="color: #86b817;">Create an Account</h3>

            <form id="registerForm" method="post" action="RegisterLogic.aspx">
                <div class="mb-3">
                    <label for="name" class="form-label">Full Name</label>
                    <input type="text" name="name" id="name" class="form-control" required />
                    <span class="error" id="nameError">Name is required</span>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">Email Address</label>
                    <input type="email" name="email" id="email" class="form-control" required />
                    <span class="error" id="emailError">Enter a valid email</span>
                </div>

                <div class="mb-3">
                    <label for="phone" class="form-label">Phone Number</label>
                    <input type="text" name="phone" id="phone" class="form-control" maxlength="10" required />
                    <span class="error" id="phoneError">Enter a valid 10-digit phone number</span>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" name="password" id="password" class="form-control" required />
                </div>

                <div class="mb-3">
                    <label for="confirm" class="form-label">Confirm Password</label>
                    <input type="password" name="confirm" id="confirm" class="form-control" required />
                    <span class="error" id="confirmError">Passwords do not match</span>
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-custom">Register</button>
                </div>
                <div class="d-grid mt-2">
                    <a href="index.aspx" class="btn btn-outline-secondary">Back to Home</a>
                </div>
            </form>

            <div class="text-center mt-4">
                <span class="me-2">Already have an account?</span>
                <a href="Login.aspx" style="color: #86b817; font-weight: 600; text-decoration: none;">Login</a>
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

    <% if (!string.IsNullOrEmpty(msg)) { %>
        <div class="alert <%= alertClass %> alert-dismissible fade show position-fixed bottom-0 end-0 m-3 z-25" 
             role="alert" style="min-width: 250px;">
            <%= msg %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <script>
        document.getElementById("registerForm").addEventListener("submit", function (e) {
            let isValid = true;

            // Full Name
            let name = document.getElementById("name").value.trim();
            if (name === "") {
                document.getElementById("nameError").style.display = "block";
                isValid = false;
            } else {
                document.getElementById("nameError").style.display = "none";
            }

            // Email
            let email = document.getElementById("email").value.trim();
            let emailPattern = /^[^ ]+@[^ ]+\.[a-z]{2,3}$/;
            if (!email.match(emailPattern)) {
                document.getElementById("emailError").style.display = "block";
                isValid = false;
            } else {
                document.getElementById("emailError").style.display = "none";
            }

            // Phone
            let phone = document.getElementById("phone").value.trim();
            if (phone.length !== 10 || isNaN(phone)) {
                document.getElementById("phoneError").style.display = "block";
                isValid = false;
            } else {
                document.getElementById("phoneError").style.display = "none";
            }

            // Password match
            let password = document.getElementById("password").value;
            let confirm = document.getElementById("confirm").value;
            if (password !== confirm) {
                document.getElementById("confirmError").style.display = "block";
                isValid = false;
            } else {
                document.getElementById("confirmError").style.display = "none";
            }

            // Stop form submission if invalid
            if (!isValid) e.preventDefault();
        });
    </script>
</body>
</html>
