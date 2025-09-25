<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Packages.aspx.cs" Inherits="TourismWebApplication.Admin.Packages" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .card:hover {
            transform: translateY(-5px);
            transition: all 0.3s ease-in-out;
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }

        .badge-expired {
            position: absolute;
            top: 10px;
            left: 10px;
            background-color: #dc3545;
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .card-img-top {
            transition: transform 0.3s ease;
        }

            .card-img-top:hover {
                transform: scale(1.05);
            }
    </style>

    <div class="row g-4">
        <%
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT PackageID, Title, Price, Location, ImageUrl, StartDate, EndDate, Description FROM Packages ORDER BY PackageID DESC", conn);
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    string pkgId = reader["PackageID"].ToString();
                    string title = reader["Title"].ToString();
                    string price = reader["Price"].ToString();
                    string location = reader["Location"].ToString();

                    string image = reader["ImageUrl"] != DBNull.Value ? reader["ImageUrl"].ToString().Trim() : "";
                    if (string.IsNullOrEmpty(image) || !image.StartsWith("http"))
                    {
                        image = "~/assets/tourist.jpeg";
                    }

                    DateTime endDateObj = Convert.ToDateTime(reader["EndDate"]);
                    string startDate = Convert.ToDateTime(reader["StartDate"]).ToString("dd-MMM-yyyy");
                    string endDate = endDateObj.ToString("dd-MMM-yyyy");
                    string desc = reader["Description"].ToString();
                    bool isExpired = endDateObj < DateTime.Now;
        %>
        <div class="col-md-4">
            <div class="card shadow-lg border-0 rounded-3 overflow-hidden position-relative h-100">

                <% if (isExpired)
                    { %>
                <span class="badge-expired">Expired</span>
                <% } %>

                <img src="<%= image %>" class="card-img-top" alt="<%= title %>" style="height: 220px; width: 100%; object-fit: cover;">

                <div class="d-flex text-center border-top border-bottom bg-light">
                    <div class="flex-fill py-2">
                        <i class="bi bi-geo-alt-fill text-success"></i>
                        <small class="ms-1"><%= location %></small>
                    </div>
                    <div class="flex-fill py-2 border-start border-end">
                        <i class="bi bi-calendar-event-fill text-success"></i>
                        <small class="ms-1"><%= startDate %></small>
                    </div>
                    <div class="flex-fill py-2">
                        <i class="bi bi-calendar-event text-success"></i>
                        <small class="ms-1"><%= endDate %></small>
                    </div>
                </div>

                <div class="card-body text-center">
                    <h5 class="fw-bold text-success mb-1">₹<%= price %></h5>
                    <div class="mb-2 text-warning">
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star"></i>
                    </div>
                    <p class="text-muted small"><%= string.IsNullOrEmpty(desc) ? "No description available." : (desc.Length > 80 ? desc.Substring(0, 80) + "..." : desc) %></p>

                    <div class="d-flex justify-content-center gap-2 flex-wrap">
                        <a href="EditPackage.aspx?PackageID=<%= pkgId %>" class="btn btn-sm btn-outline-primary rounded-pill px-3">
                            <i class="bi bi-pencil me-1"></i>Edit
                        </a>
                        <a href="DeletePackage.aspx?PackageID=<%= pkgId %>"
                            onclick="return confirm('Are you sure you want to delete this package?');"
                            class="btn btn-sm btn-outline-danger rounded-pill px-3">
                            <i class="bi bi-trash me-1"></i>Delete
                        </a>
                        <a href="ViewPackage.aspx?PackageID=<%= pkgId %>" class="btn btn-sm btn-success rounded-pill px-3">
                            <i class="bi bi-eye me-1"></i>View
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <%
                }
                reader.Close();
            }
        %>
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
</asp:Content>
