<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Logout.aspx.cs" Inherits="TourismWebApplication.Customer.Logout" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Logout</title>
</head>
<body>
    <%
        Session.Clear();
        Session.Abandon();
        Response.Redirect("index.aspx?msg=Logout%20Successfully&type=success");
        
        %>
</body>
</html>
