<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="TourismWebApplication.ResetPassword" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        body {
            background-color: #f8f9fa;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        .card-header {
            background-color: #86b817;
            color: white;
            font-size: 1.4rem;
            font-weight: 600;
            text-align: center;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
            padding: 15px 0;
        }

        .btn-custom {
            background-color: #86b817;
            color: white;
            font-weight: 500;
        }

        .btn-custom:hover {
            background-color: #76a215;
            color: #fff;
        }

        .form-control:focus {
            border-color: #86b817;
            box-shadow: 0 0 5px rgba(134, 184, 23, 0.5);
        }

        .message {
            text-align: center;
            margin-top: 10px;
            font-weight: 500;
        }

        .password-feedback {
            font-size: 0.9rem;
            color: #dc3545;
            margin-top: 5px;
        }

        .password-feedback.valid {
            color: #28a745;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server" method="post" action="ResetPassword.aspx" onsubmit="return validateForm()">
        <div class="card p-4" style="width: 380px;">
            <div class="card-header">
                Reset Password
            </div>
            <div class="card-body">
                <p class="text-muted text-center mb-3">
                    Enter your new password below to reset your account access.
                </p>

                <!-- Hidden token for verification -->
                <input type="hidden" name="token" value="<%= Token %>" />

                <div class="mb-3">
                    <label for="newPassword" class="form-label fw-semibold">New Password</label>
                    <input type="password" name="newPassword" id="newPassword"
                           class="form-control" placeholder="Enter new password" required
                           oninput="checkPasswordStrength()" />
                    <div id="passwordFeedback" class="password-feedback"></div>
                </div>

                <div class="mb-3">
                    <label for="confirmPassword" class="form-label fw-semibold">Confirm Password</label>
                    <input type="password" name="confirmPassword" id="confirmPassword"
                           class="form-control" placeholder="Confirm new password" required />
                    <div id="confirmFeedback" class="password-feedback"></div>
                </div>

                <button type="submit" class="btn btn-custom w-100 py-2">
                    Reset Password
                </button>

                <% if (!string.IsNullOrEmpty(Message)) { %>
                    <p class="message text-success"><%= Message %></p>
                <% } %>
            </div>
        </div>
    </form>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Client-side validation script -->
    <script>
        function checkPasswordStrength() {
            const password = document.getElementById("newPassword").value;
            const feedback = document.getElementById("passwordFeedback");

            if (password === "") {
                feedback.textContent = "";
                feedback.classList.remove("valid");
                return;
            }

            
        }

        function validateForm() {
            const password = document.getElementById("newPassword").value;
            const confirmPassword = document.getElementById("confirmPassword").value;
            const feedback = document.getElementById("passwordFeedback");
            const confirmFeedback = document.getElementById("confirmFeedback");


            if (password !== confirmPassword) {
                confirmFeedback.textContent = "Passwords do not match!";
                return false;
            }

            confirmFeedback.textContent = "";
            return true;
        }
    </script>
</body>
</html>
