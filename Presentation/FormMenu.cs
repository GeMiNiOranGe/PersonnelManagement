using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Presentation
{
    public partial class FormMenu : Form
    {
        private int _roleID;
        public FormMenu(int roleID)
        {
            InitializeComponent();
            _roleID = roleID;
            lbRole.Text ="RoleID: "+roleID.ToString();
        }

        private void picLogout_Click(object sender, EventArgs e)
        {
            DialogResult result = MessageBox.Show("Do you want to Log out?", "Confirm", MessageBoxButtons.OKCancel);
            if (result == DialogResult.OK)
            {
                this.Close(); 
                FormLogin loginForm = new FormLogin();
                loginForm.Show();
            }

        }

        private void btnEmployee_Click(object sender, EventArgs e)
        {
           
           
            FormEmployee employee = new FormEmployee(_roleID);
            employee.TopLevel = false;
            employee.Dock = DockStyle.Fill;
            employee.FormBorderStyle = FormBorderStyle.None;
            pnMenu.Controls.Add(employee);
            employee.Show();
        }

      
    }
}
