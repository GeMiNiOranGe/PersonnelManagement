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
    public partial class FormEmployee : Form
    {
        private EmployeeBusiness employeeBSS;
        private DepartmentBusiness departmentBusiness;
        private int _roleID;
        public FormEmployee(int roleID)
        {
            InitializeComponent();
            _roleID = roleID;
            employeeBSS = new EmployeeBusiness();
            departmentBusiness = new DepartmentBusiness();
            LoadEmployeeData();
            loadDepartment();
            checkPermission(_roleID);
        }
        private void FormEmployee_Load(object sender, EventArgs e)
        {

        }
        #region Event
        private void groupBox1_Enter(object sender, EventArgs e)
            {
                
            }
            private void dtgvEmployee_CellClick(object sender, DataGridViewCellEventArgs e)
            {
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = dtgvEmployee.Rows[e.RowIndex];

                txtID.Text = row.Cells["EmployeeID"].Value.ToString();
                txtName.Text = row.Cells["FullName"].Value.ToString();
                txtPhone.Text = row.Cells["PhoneNumber"].Value.ToString();
                txtSalary.Text = row.Cells["Salary"].Value.ToString();
                txtAllowance.Text = row.Cells["Allowance"].Value.ToString();
                txtTax.Text = row.Cells["TaxCode"].Value.ToString();
                cbbDepartment.Text = row.Cells["DepartmentID"].Value.ToString();
                dtpkDOB.Text = row.Cells["DateOfBirth"].Value.ToString();

                // Thiết lập gender từ dấu tích trong DataGridView
                bool isFemale = Convert.ToBoolean(row.Cells["Gender"].Value);
                cbFemale.Checked = isFemale;
                cbMale.Checked = !isFemale;
            }
        }
            private void cbbDepartment_SelectedIndexChanged(object sender, EventArgs e)
            {
                
            }

        #endregion

        #region Function
        private void DisplayEmployees(DataTable dt)
        {
              dtgvEmployee.DataSource = dt;
        }   
        private void LoadEmployeeData()
        {
            try
            {
                DataTable dt = employeeBSS.GetEmployeesByRoleID(_roleID);
                if (dt == null || dt.Columns.Count == 0)
                {
                    MessageBox.Show("No data returned from the database.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }

                DisplayEmployees(dt);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error occurred : " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
        private void loadDepartment()
        {
            try
            {
                DataTable dt = departmentBusiness.GetDepartments();

                foreach (DataRow row in dt.Rows)
                {
                    cbbDepartment.Items.Add(row["DepartmentID"].ToString());
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error occurred: " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
        private void checkPermission(int roleID)
        {
            if(roleID==3 || roleID==5 || roleID==7) 
            {
                dtgvEmployee.Columns["Salary"].Visible = false;
                dtgvEmployee.Columns["Allowance"].Visible = false;
            }
        }

        #endregion

       
    }
}
