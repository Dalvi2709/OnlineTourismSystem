<%@ Page Title="Add Package" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h2 class="mb-3">Add New Package</h2>

        <form id="addPackageForm" method="post" action="AddPackageLogic.aspx" onsubmit="return validateForm();">
            <div class="mb-2">
                <label>Title</label>
                <input type="text" name="title" class="form-control" required />
            </div>

            <div class="mb-2">
                <label>Description</label>
                <textarea name="description" id="description" class="form-control" rows="3" required></textarea>
                <div class="text-danger small mt-1" id="descError"></div>
            </div>

            <div class="mb-2">
                <label>Location</label>
                <input type="text" name="location" class="form-control" required />
            </div>

            <div class="mb-2">
                <label>Audience</label>
                <input type="text" name="audience" class="form-control" />
            </div>

            <div class="mb-2">
                <label>Available Slots</label>
                <input type="number" name="availableslots" class="form-control" min="0" required />
            </div>

            <div class="mb-2">
                <label>Price</label>
                <input type="number" step="0.01" name="price" class="form-control" required min="0" />
            </div>

            <div class="row">
                <div class="col-md-6 mb-2">
                    <label>Start Date</label>
                    <input type="date" name="startdate" id="startdate" class="form-control" required />
                    <div class="text-danger small mt-1" id="startDateError"></div>
                </div>
                <div class="col-md-6 mb-2">
                    <label>End Date</label>
                    <input type="date" name="enddate" id="enddate" class="form-control" required />
                    <div class="text-danger small mt-1" id="dateError"></div>
                </div>
            </div>

            <div class="mb-2">
                <label>Image URL</label>
                <input type="text" name="imageurl" class="form-control" />
            </div>

            <div class="mb-2">
                <label>Source / Destination</label>
                <input type="text" name="sourcedestination" class="form-control" />
            </div>

            <h5 class="mt-4">Assign Staff</h5>
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Select</th>
                        <th>Staff Name</th>
                        <th>Role</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
                        using (SqlConnection con = new SqlConnection(connStr))
                        {
                            con.Open();
                            SqlCommand cmd = new SqlCommand("SELECT StaffID, Name, Role FROM Staff WHERE IsActive=1", con);
                            SqlDataReader reader = cmd.ExecuteReader();
                            while (reader.Read())
                            {
                                string sid = reader["StaffID"].ToString();
                                string sname = reader["Name"].ToString();
                                string srole = reader["Role"].ToString();
                    %>
                    <tr>
                        <td>
                            <input type="checkbox" name="staff" value="<%= sid %>" />
                        </td>
                        <td><%= sname %></td>
                        <td>
                            <input type="text" name="role_<%= sid %>" value="<%= srole %>" class="form-control" placeholder="Role (e.g. Guide)" />
                        </td>
                    </tr>
                    <%
                            }
                            reader.Close();
                        }
                    %>
                </tbody>
            </table>

            <button type="submit" class="btn btn-success w-100">Save Package</button>
        </form>
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
    <div class="alert <%= alertClass %> alert-dismissible fade show position-fixed bottom-0 end-0 m-3"
         role="alert" style="min-width: 250px;">
        <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <script>
        function validateForm() {
            const desc = document.getElementById("description").value.trim();
            const startDate = document.getElementById("startdate").value;
            const endDate = document.getElementById("enddate").value;

            const descError = document.getElementById("descError");
            const startDateError = document.getElementById("startDateError");
            const dateError = document.getElementById("dateError");

            descError.innerText = "";
            startDateError.innerText = "";
            dateError.innerText = "";

            let isValid = true;

            if (desc.length < 10) {
                descError.innerText = "Description must be at least 10 characters long.";
                isValid = false;
            }

            if (startDate) {
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                const sDate = new Date(startDate);

                if (sDate < today) {
                    startDateError.innerText = "Start date cannot be earlier than today.";
                    isValid = false;
                }
            }

            if (startDate && endDate) {
                const sDate = new Date(startDate);
                const eDate = new Date(endDate);
                if (eDate < sDate) {
                    dateError.innerText = "End date cannot be earlier than start date.";
                    isValid = false;
                }
            }

            return isValid;
        }
    </script>
</asp:Content>
