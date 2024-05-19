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
using System.Xml.Linq;

namespace Presentation
{
    public partial class FormGrantRole : Form
    {
        private RoleBussiness roleBussiness;
        private int _roleID;
        public FormGrantRole(int roleID)
        {
            InitializeComponent();
            roleBussiness = new RoleBussiness();
            loadData();
            loadRoleID();
            loadPermissionID();
            LoadColumnNames();
            _roleID = roleID;
        }


        #region Function
        private void loadData()
        {
            DataTable dataTable = roleBussiness.GetRolePermissions();
            try
            {
                if (dataTable == null || dataTable.Columns.Count == 0)
                {
                    MessageBox.Show("No data returned from the database.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
                dtgvGrant.DataSource = dataTable;

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
        private void loadRoleID()
        {
            DataTable role= roleBussiness.GetRoles();
            cbRoleID.DataSource = role;
            cbRoleID.DisplayMember = "RoleID";
        }
        private void  loadPermissionID()
        {
            DataTable Permission = roleBussiness.GetPermission();
            cbPermission.DataSource = Permission;
            cbPermission.DisplayMember = "PermissionID";
        }
        private void LoadColumnNames()
        {
            cbColumnName.Items.Clear();
            cbColumnName.Items.Add("EmployeeID");
            cbColumnName.Items.Add("Gender");
            cbColumnName.Items.Add("DateOfBirth");
            cbColumnName.Items.Add("PhoneNumber");
            cbColumnName.Items.Add("Salary");
            cbColumnName.Items.Add("Allowance");
            cbColumnName.Items.Add("TaxCode");
            cbColumnName.Items.Add("DepartmentID");
        }
        private string GenerateColumnNameParameter()
        {
            string selectedColumn = cbColumnName.Text?.ToString();
            if (selectedColumn == "Salary" || selectedColumn == "Allowance" || selectedColumn== "EmployeeID" || selectedColumn== "Gender"|| 
                selectedColumn== "DateOfBirth" || selectedColumn=="PhoneNumber" || selectedColumn=="TaxCode" || selectedColumn=="DepartmentID")
            {
                return selectedColumn;
            }
            return "NULL";
        }
        #endregion

        #region Event
        private void dtgvGrant_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if(dtgvGrant.Rows.Count > 0)
            {
                DataGridViewRow row = dtgvGrant.Rows[e.RowIndex];

                cbRoleID.Text= row.Cells["RoleID"].Value?.ToString() ?? string.Empty;
                cbPermission.Text= row.Cells["PermissionID"].Value?.ToString() ?? string.Empty;
                tbName.Text= row.Cells["Name"].Value?.ToString() ?? string.Empty;

            }
        }

        private void cbPermission_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void cbRoleID_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        private void FormGrantRole_Load(object sender, EventArgs e)
        {

        }
        #endregion

        private void cbColumnName_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void btnPermiss_Click(object sender, EventArgs e)
        {
            try
            {
                int roleId = _roleID;
                int roleIDAdd = Convert.ToInt32(cbRoleID.Text); 
                int permissionId = Convert.ToInt32(cbPermission.Text);
                string name = tbName.Text;
                string columnName = GenerateColumnNameParameter();

               bool checkGrantRole= roleBussiness.GrantRole(roleId, roleIDAdd, permissionId, name, columnName);
                if (checkGrantRole)
                {
                    MessageBox.Show("Role granted successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    loadData();
                } else
                {
                    MessageBox.Show("Role granted unsuccessfully!", "UnSuccess", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }

             
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
    
    }
}
