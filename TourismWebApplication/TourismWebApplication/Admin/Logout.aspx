<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Logout.aspx.cs" Inherits="TourismWebApplication.Admin.Logout" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <%
        Session["UserEmail"] = null;
        Session["name"] = null;
        Session["Role"] = null;
        Session["phone"] = null;
        Session["UserId"] = null;

        Response.Redirect("~/Login.aspx?msg=Logout%20Successful&type=success");
    %>
</body>
</html>
