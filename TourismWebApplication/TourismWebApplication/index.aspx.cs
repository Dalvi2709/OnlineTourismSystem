using System;
using System.Collections.Generic;
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
            }
        }
    }
}