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
    public partial class packages : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindPackages();
            }
        }

        private void BindPackages()
        {
            string cs = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"SELECT PackageID, ImageUrl, Location,
                                 DATEDIFF(DAY, StartDate, EndDate) AS DurationDays,Title,
                                 Price, Description, AvailableSlots
                                 FROM Packages";

                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                rptPackages.DataSource = rdr;
                rptPackages.DataBind();
            }

        }
    }
}