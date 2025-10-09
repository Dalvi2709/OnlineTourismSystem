<%@ Page Title="Add Staff" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AddStaff.aspx.cs" Inherits="TourismWebApplication.Admin.AddStaff" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-5">
        <div class="card shadow p-4">
            <h3 class="mb-4"><i class="bi bi-person-plus-fill me-2"></i>Add New Staff</h3>

            <!-- Staff Form -->
            <form id="staffForm" method="post" action="AddStaffLogic.aspx" onsubmit="return validateStaffForm()">
                <div class="mb-3">
                    <label class="form-label">Name</label>
                    <input type="text" id="name" name="name" class="form-control" />
                    <div id="nameError" class="text-danger mt-1" style="display:none;"></div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" id="email" name="email" class="form-control" />
                    <div id="emailError" class="text-danger mt-1" style="display:none;"></div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Phone</label>
                    <input type="text" id="phone" name="phone" class="form-control" />
                    <div id="phoneError" class="text-danger mt-1" style="display:none;"></div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Role</label>
                    <select id="role" name="role" class="form-select">
                        <option value="">-- Select Role --</option>
                        <option value="Guide">Guide</option>
                        <option value="Driver">Driver</option>
                        <option value="Manager">Manager</option>
                        <option value="Support">Support</option>
                    </select>
                    <div id="roleError" class="text-danger mt-1" style="display:none;"></div>
                </div>

                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-save me-1"></i> Add Staff
                </button>
                <a href="Staff.aspx" class="btn btn-secondary">
                    <i class="bi bi-arrow-left"></i> Cancel
                </a>
            </form>
        </div>
    </div>

    <script>
        function validateStaffForm() {
            // Reset all error messages
            document.getElementById("nameError").style.display = "none";
            document.getElementById("emailError").style.display = "none";
            document.getElementById("phoneError").style.display = "none";
            document.getElementById("roleError").style.display = "none";

            var isValid = true;

            var name = document.getElementById("name").value.trim();
            var email = document.getElementById("email").value.trim();
            var phone = document.getElementById("phone").value.trim();
            var role = document.getElementById("role").value;

            // Name validation
            if (name === "") {
                var nameError = document.getElementById("nameError");
                nameError.innerText = "Please enter the Name.";
                nameError.style.display = "block";
                isValid = false;
            }

            // Email validation
            if (email === "") {
                var emailError = document.getElementById("emailError");
                emailError.innerText = "Please enter the Email.";
                emailError.style.display = "block";
                isValid = false;
            } else {
                var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailPattern.test(email)) {
                    var emailError = document.getElementById("emailError");
                    emailError.innerText = "Please enter a valid Email.";
                    emailError.style.display = "block";
                    isValid = false;
                }
            }

            // Phone validation
            if (phone === "") {
                var phoneError = document.getElementById("phoneError");
                phoneError.innerText = "Please enter the Phone number.";
                phoneError.style.display = "block";
                isValid = false;
            } else {
                var phonePattern = /^[0-9]{10}$/;
                if (!phonePattern.test(phone)) {
                    var phoneError = document.getElementById("phoneError");
                    phoneError.innerText = "Please enter a valid 10-digit Phone number.";
                    phoneError.style.display = "block";
                    isValid = false;
                }
            }

            // Role validation
            if (role === "") {
                var roleError = document.getElementById("roleError");
                roleError.innerText = "Please select a Role.";
                roleError.style.display = "block";
                isValid = false;
            }

            return isValid;
        }
    </script>

    <!-- Toast Notification -->
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
</asp:Content>
