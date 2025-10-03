using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TourismWebApplication
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string msg = Request.QueryString["msg"];
                string type = Request.QueryString["type"];

                if (!string.IsNullOrEmpty(msg))
                {
                    string script = $"Swal.fire('{msg}', '', '{type}');";
                    ClientScript.RegisterStartupScript(this.GetType(), "popup", script, true);
                }

                BindTopPackages();
            }
        }

        private void BindTopPackages()
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                // TOP 3 based on Price (highest first)
                string query = @"SELECT TOP 3 PackageID, ImageUrl, Location,
                 DATEDIFF(DAY, StartDate, EndDate) AS DurationDays, Title,
                 Price, Description, AvailableSlots
                 FROM Packages
                 WHERE StartDate > GETDATE()
                 ORDER BY Price DESC";


                // Or ORDER BY StartDate DESC for latest

                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                rptTopPackages.DataSource = rdr;
                rptTopPackages.DataBind();
            }
        }
    }
}