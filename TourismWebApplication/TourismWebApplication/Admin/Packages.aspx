<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Packages.aspx.cs" Inherits="TourismWebApplication.Admin.Packages" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

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

                    string startDate = Convert.ToDateTime(reader["StartDate"]).ToString("dd-MMM-yyyy");
                    string endDate = Convert.ToDateTime(reader["EndDate"]).ToString("dd-MMM-yyyy");
                    string desc = reader["Description"].ToString();
        %>
        <div class="col-md-4">
            <div class="card shadow-lg border-0 rounded-3 overflow-hidden h-100">

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

                <!-- Body -->
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

                    <!-- Buttons -->
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

</asp:Content>
