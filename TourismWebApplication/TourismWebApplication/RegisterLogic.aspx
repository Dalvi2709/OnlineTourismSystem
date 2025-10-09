<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegisterLogic.aspx.cs" Inherits="TourismWebApplication.RegisterLogic" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Registration Logic</title>
</head>
<body>
    <%
        string name = Request.Params["name"];
        string email = Request.Params["email"];
        string phone = Request.Params["phone"];
        string password = Request.Params["password"];
        string role = "Customer";


        if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
        {
            Response.Redirect("Register.aspx?msg=Please%20fill%20all%20required%20fields&type=warning");
            return;
        }

        SqlConnection con = null;
        try
        {
            con = new SqlConnection(ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString);
            con.Open();

            SqlCommand cmd = new SqlCommand(@"
                INSERT INTO Users (Name, Email, PasswordHash, Role, Phone) 
                VALUES (@name, @Email, @Password, @Role, @Phone)", con);

            cmd.Parameters.AddWithValue("@Name", name);
            cmd.Parameters.AddWithValue("@Email", email);
            cmd.Parameters.AddWithValue("@Password", password);
            cmd.Parameters.AddWithValue("@Role", role);
            cmd.Parameters.AddWithValue("@Phone", phone);

            int rows = cmd.ExecuteNonQuery();

            if (rows > 0)
            {
                Response.Redirect("Login.aspx?msg=Registered%20Successfully&type=success", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            else
            {
                Response.Redirect("Register.aspx?msg=Registration%20Failed&type=error", false);
                Context.ApplicationInstance.CompleteRequest();
                //Then throws a ThreadAbortException internally to immediately stop the current page execution.

                //So when your catch (Exception ex) block catches it, it thinks it's a real error and shows:

                //Unexpected Error: Thread was being aborted.
            }
        }
        catch (SqlException ex)
        {
            string err = Server.UrlEncode("Data Already Exist!!" );
            Response.Redirect("Register.aspx?msg=" + err + "&type=error", false);
            Context.ApplicationInstance.CompleteRequest();
        }
        catch (Exception ex)
        {
            string err = Server.UrlEncode("Unexpected Error: " + ex.Message);
            Response.Redirect("Register.aspx?msg=" + err + "&type=error", false);
            Context.ApplicationInstance.CompleteRequest();
        }

    %>
</body>
</html>


<!--

🧠 1️⃣ Response.Redirect(url, false)

The second argument false means “do not end the current thread.”

ASP.NET will still send the redirect response (302 Found) to the browser.

But it won’t throw the ThreadAbortException.

Execution continues after this line — unless you stop it yourself (which we do next).

🧠 2️⃣ Context.ApplicationInstance.CompleteRequest()

This tells ASP.NET:
👉 “Stop processing the current page right here and skip to the EndRequest event.”

It gracefully stops the request without aborting the thread.

No exceptions, no unnecessary overhead.  -->
