<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="TourismWebApplication.ForgotPassword" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password</title>

    <!-- Bootstrap 5 -->
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
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .card-header {
            background-color: #86b817;
            color: white;
            font-size: 1.4rem;
            font-weight: 600;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
            text-align: center;
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
            box-shadow: 0 0 5px rgba(134,184,23,0.5);
        }

        .message {
            text-align: center;
            margin-top: 10px;
            font-weight: 500;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server" method="post" action="ForgotPassword.aspx">
        <div class="card p-4" style="width: 380px;">
            <div class="card-header">
                Forgot Password
            </div>
            <div class="card-body">
                <p class="text-muted text-center mb-3">
                    Enter your registered email address. We’ll send you a reset link.
                </p>

                <div class="mb-3">
                    <label for="email" class="form-label fw-semibold">Email Address</label>
                    <input type="email" name="email" id="email"
                        class="form-control" placeholder="example@email.com" required />
                </div>

                <button type="submit" class="btn btn-custom w-100 py-2">
                    Send Reset Link
                </button>

                <div class="d-grid mt-2">
                    <a href="index.aspx" class="btn btn-outline-secondary">Back to Home</a>
                </div>

                <% if (!string.IsNullOrEmpty(Message))
                    { %>
                <p class="message text-success"><%= Message %></p>
                <% } %>
            </div>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
