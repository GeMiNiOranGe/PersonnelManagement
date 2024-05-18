using Business;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Presentation
{
    public partial class FormDepartment : Form
    {
        private DepartmentBusiness departmentBusiness;
        public FormDepartment()
        {
            InitializeComponent();
            departmentBusiness = new DepartmentBusiness();
            loadDepartments();
        }

        private void FormDepartment_Load(object sender, EventArgs e)
        {

        }

        private void dtgvDepartment_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
        private void loadDepartments()
        {
            DataTable dt = departmentBusiness.GetAllDepartments();
            try
            {
               
                if (dt == null || dt.Columns.Count == 0)
                {
                    MessageBox.Show("No data returned from the database.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }

               dtgvDepartment.DataSource = dt;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error occurred : " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}
