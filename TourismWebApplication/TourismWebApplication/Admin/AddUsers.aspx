<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AddUsers.aspx.cs" Inherits="TourismWebApplication.Admin.AddUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<div class="container mt-5">
    <div class="card shadow p-4">
        <h3 class="mb-4">Add New User</h3>

        <!-- User Form -->
        <form id="userForm" method="post" action="AddUsersLogic.aspx" onsubmit="return validateForm();">
            <div class="mb-3">
                <label class="form-label">Name</label>
                <input type="text" id="name" name="name" class="form-control" />
                <div class="text-danger mt-1" id="nameError"></div>
            </div>

            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" id="email" name="email" class="form-control" />
                <div class="text-danger mt-1" id="emailError"></div>
            </div>

            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="password" id="password" name="password" class="form-control" />
                <div class="text-danger mt-1" id="passwordError"></div>
            </div>

            <div class="mb-3">
                <label class="form-label">Role</label>
                <select id="role" name="role" class="form-select">
                    <option value="">Select Role</option>
                    <option value="Customer">Customer</option>
                    <option value="Admin">Admin</option>
                </select>
                <div class="text-danger mt-1" id="roleError"></div>
            </div>

            <div class="mb-3">
                <label class="form-label">Phone</label>
                <input type="text" id="phone" name="phone" class="form-control" />
                <div class="text-danger mt-1" id="phoneError"></div>
            </div>

            <button type="submit" class="btn btn-primary">Add User</button>
        </form>
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
 <% if (!string.IsNullOrEmpty(msg))
     { %>
 <div class="alert <%= alertClass %> alert-dismissible fade show position-fixed bottom-0 end-0 m-3 z-25" role="alert" style="min-width: 250px;">
     <%= msg %>
     <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
 </div>
 <% } %>

<script>
function validateForm() {
    let isValid = true;

    // Clear previous errors
    document.getElementById('nameError').innerText = '';
    document.getElementById('emailError').innerText = '';
    document.getElementById('passwordError').innerText = '';
    document.getElementById('roleError').innerText = '';
    document.getElementById('phoneError').innerText = '';

    // Name validation
    let name = document.getElementById('name').value.trim();
    if(name === '') {
        document.getElementById('nameError').innerText = 'Name is required';
        isValid = false;
    }

    // Email validation
    let email = document.getElementById('email').value.trim();
    let emailPattern = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
    if(email === '') {
        document.getElementById('emailError').innerText = 'Email is required';
        isValid = false;
    } else if(!emailPattern.test(email)) {
        document.getElementById('emailError').innerText = 'Invalid email format';
        isValid = false;
    }

    // Password validation
    let password = document.getElementById('password').value.trim();
    if(password === '') {
        document.getElementById('passwordError').innerText = 'Password is required';
        isValid = false;
    }

    // Role validation
    let role = document.getElementById('role').value;
    if(role === '') {
        document.getElementById('roleError').innerText = 'Please select a role';
        isValid = false;
    }

    // Phone validation
    let phone = document.getElementById('phone').value.trim();
    let phonePattern = /^\d{10}$/;
    if(phone === '') {
        document.getElementById('phoneError').innerText = 'Phone is required';
        isValid = false;
    } else if(!phonePattern.test(phone)) {
        document.getElementById('phoneError').innerText = 'Phone must be 10 digits';
        isValid = false;
    }

    return isValid;
}
</script>

</asp:Content>
