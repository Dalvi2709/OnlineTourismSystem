<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="GetStaffByRole.aspx.cs" Inherits="TourismWebApplication.Admin.GetStaffByRole" %>

   <%@ Import Namespace="System.Data.SqlClient" %>
   <%@ Import Namespace="System.Configuration" %>
   <%@ Import Namespace="System.Web.Script.Serialization" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <%
        Response.ContentType = "application/json";
        string role = Request.QueryString["role"];
        var staffList = new System.Collections.Generic.List<object>();

        string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connStr))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand("SELECT StaffID, Name FROM Staff WHERE Role=@Role", conn);
            cmd.Parameters.AddWithValue("@Role", role);
            SqlDataReader dr = cmd.ExecuteReader();
            while (dr.Read())
            {
                staffList.Add(new { StaffID = dr["StaffID"], Name = dr["Name"] });
            }
        }

        var js = new System.Web.Script.Serialization.JavaScriptSerializer();
        Response.Write(js.Serialize(staffList));
        Response.End();
    %>
</asp:Content>
