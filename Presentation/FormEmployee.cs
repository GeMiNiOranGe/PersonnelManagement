using Business;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
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
        private void cbMale_CheckedChanged(object sender, EventArgs e)
        {
            if (cbMale.Checked)
            {
                cbFemale.Checked = false;
            }
        }

        private void cbFemale_CheckedChanged(object sender, EventArgs e)
        {
            if (cbFemale.Checked)
            {
                cbMale.Checked = false;
            }
        }
        private void dtgvEmployee_CellClick(object sender, DataGridViewCellEventArgs e)
        {
        if (e.RowIndex >= 0)
        {
            DataGridViewRow row = dtgvEmployee.Rows[e.RowIndex];

            txtID.Text = row.Cells["EmployeeID"].Value?.ToString() ?? string.Empty;
            txtName.Text = row.Cells["FullName"].Value?.ToString() ?? string.Empty;
            txtPhone.Text = row.Cells["PhoneNumber"].Value?.ToString() ?? string.Empty;
            txtSalary.Text = row.Cells["Salary"].Value?.ToString() ?? string.Empty;
            txtAllowance.Text = row.Cells["Allowance"].Value?.ToString() ?? string.Empty;
            txtTax.Text = row.Cells["TaxCode"].Value?.ToString() ?? string.Empty;
            cbbDepartment.Text = row.Cells["DepartmentID"].Value?.ToString() ?? string.Empty;
            dtpkDOB.Text = row.Cells["DateOfBirth"].Value?.ToString() ?? string.Empty;

            bool isFemale = Convert.ToBoolean(row.Cells["Gender"].Value??string.Empty);
            cbFemale.Checked = isFemale;
            cbMale.Checked = !isFemale;
        }
    }
        private void cbbDepartment_SelectedIndexChanged(object sender, EventArgs e)
        {
                
        }
        private void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (dtgvEmployee.Rows.Count > 0)
                {
                    string employeeID = txtID.Text;
                    string fullName = txtName.Text;
                    string phoneNumber = txtPhone.Text;
                    string salary = txtSalary.Text;
                    string allowance = txtAllowance.Text;
                    string taxCode = txtTax.Text;
                    string departmentID = cbbDepartment.Text?.ToString() ?? string.Empty;
                    string dateOfBirth = dtpkDOB.Value.ToString("yyyy-MM-dd");
                    string gender = cbMale.Checked ? "0" : "1";
                    string valueList = $"{fullName},{gender},{dateOfBirth},{phoneNumber},{salary},{allowance},{taxCode},{departmentID}";
                    bool result = employeeBSS.updateEmployee(_roleID, valueList, employeeID);
                    if (result)
                    {
                        MessageBox.Show("Updated!", "Inform", MessageBoxButtons.OK, MessageBoxIcon.Information);
                        LoadEmployeeData();
                    }
                    else
                    {
                        MessageBox.Show("Updated Unsuccessfully!", "Inform", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        LoadEmployeeData();
                    }
                }
            }
            catch (SqlException ex) // Catch specific SQL exceptions
            {
                if (ex.Number == 50000) // Check if custom error number
                {
                    MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
                else
                {
                    MessageBox.Show("An error occurred: " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("An error occurred: " + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
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
           
            if (roleID==3 || roleID==5 || roleID==7) 
            {
                dtgvEmployee.Columns["Salary"].Visible = false;
                dtgvEmployee.Columns["Allowance"].Visible = false;
              
            } else
            {
                dtgvEmployee.Columns["Salary"].Visible = true;
                dtgvEmployee.Columns["Allowance"].Visible = true;
              

            }
            
            
           
        }



        #endregion

        
    }
}
