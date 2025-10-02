using System;
using System.Data.SqlClient;
using System.Configuration;

namespace TourismWebApplication
{
    public partial class about : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindTeam();
            }
        }

        private void BindTeam()
        {
            string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT StaffID, Name, Email, Phone, Role FROM Staff WHERE IsActive = 1";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    rptTeam.DataSource = dr;
                    rptTeam.DataBind();
                }
            }
        }
    }
}
