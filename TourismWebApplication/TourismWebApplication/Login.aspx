<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TourismWebApplication.Login" %>


<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .login-container {
            max-width: 400px;
            margin: 80px auto;
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

        .forgot-link {
            font-size: 0.9rem;
            float: right;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="login-container">
            <h3 class="text-center mb-4" style="color: #86b817;">Login</h3>
            <form id="loginForm" method="post" action="LoginLogic.aspx">

                <div class="mb-3">
                    <label for="email" class="form-label">Email Address</label>
                    <input type="email" name="email" id="email" class="form-control" required />
                    <span class="error" id="emailError">Enter a valid email</span>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" name="password" id="password" class="form-control" required />
                    <span class="error" id="passwordError">Password is required</span>

                </div>
                <!--
                <div class="mb-3 form-check">
                    <input type="checkbox" class="form-check-input" id="remember" name="remember" />
                    <label class="form-check-label" for="remember">Remember Me</label>
                </div>
                      -->
                <div class="d-grid">
                    <button type="submit" class="btn btn-custom">Login</button>
                </div>

                <div class="d-grid">
                    <a href="ForgotPassword.aspx" class="forgot-link">Forgot Password?</a>

                </div>
                <div class="d-grid mt-2">
                    <a href="index.aspx" class="btn btn-outline-secondary">Back to Home</a>
                </div>
            </form>

            <div class="text-center mt-4">
                <span class="me-2">Don't have an account?</span>
                <a href="Register.aspx"
                    style="color: #86b817; font-weight: 600; text-decoration: none;">Register
                </a>
            </div>
        </div>
    </div>

    <%
        string msg = Request.QueryString["msg"];
        string type = Request.QueryString["type"];
        string alertClass = "";
        if (!string.IsNullOrEmpty(type))
        {
            if (type == "success") { alertClass = "alert-success"; }
            else if (type == "error") { alertClass = "alert-danger"; }
        }
    %>

    <% if (!string.IsNullOrEmpty(msg))
        { %>
    <div class="alert <%= alertClass %> alert-dismissible fade show position-fixed bottom-0 end-0 m-3 z-25" role="alert" style="min-width: 250px;">
        <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>

    <script>
        document.getElementById("loginForm").addEventListener("submit", function (e) {
            let isValid = true;

            let email = document.getElementById("email").value.trim();
            let emailPattern = /^[^ ]+@[^ ]+\.[a-z]{2,3}$/;
            if (!email.match(emailPattern)) {
                document.getElementById("emailError").style.display = "block";
                isValid = false;
            } else {
                document.getElementById("emailError").style.display = "none";
            }

            let password = document.getElementById("password").value;
            if (password === "") {
                document.getElementById("passwordError").style.display = "block";
                isValid = false;
            } else {
                document.getElementById("passwordError").style.display = "none";
            }

            if (!isValid) {
                e.preventDefault();
            }
        });
    </script>
</body>
</html>

