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
    public partial class FormLogin : Form
    {
        private AccountBusiness accountBusiness;
        public int roleID {  get; private set; }
        public FormLogin()
        {
            InitializeComponent();
            accountBusiness = new AccountBusiness();
        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text;
            string password = txtPassword.Text;
            int result;
            int roleID;
            string name;

            accountBusiness.Login(username, password, out result, out roleID, out name);

            if (result == 1)
            {
                MessageBox.Show($"Đăng nhập thành công! RoleID:{roleID}", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
                this.roleID= roleID;
                FormMenu fmn=new FormMenu(roleID);
                fmn.Show();
               
            }
            else
            {
                MessageBox.Show("Đăng nhập không thành công!", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void FormLogin_Load(object sender, EventArgs e)
        {

        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }
    }
}
