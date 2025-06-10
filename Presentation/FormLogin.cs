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

using DTO;

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

        private void BtnSignIn_Click(object sender, EventArgs e) {
            LoginStatus loginStatus = LoginStatus.None;
            try {
                loginStatus = AccountBusiness.Instance.GetLoginStatus(txtAccountName.Text, txtPassword.Text);
            }
            catch (Exception ex) {
                MessageBox.Show(ex.Message);
            }

            switch (loginStatus) {
            case LoginStatus.Success:
                var formDashboard = new FormDashboard() {
                    RootForm = this
                };
                formDashboard.Show();
                Hide();
                break;
            case LoginStatus.InvalidInput:
                lblError.Text = "Tên tài khoản và mật khẩu không được để trống!";
                break;
            case LoginStatus.InvalidAccount:
                lblError.Text = "Tên tài khoản hoặc mật khẩu sai!";
                break;
            case LoginStatus.OtherError:
                lblError.Text = "Đã xảy ra lỗi trong quá trình đăng nhập!";
                break;
            }
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
                if (cbRemember.Checked)
                {
                    Properties.Settings.Default.Username = username;
                    Properties.Settings.Default.Password = password;
                    Properties.Settings.Default.Save();
                }
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
            if (!string.IsNullOrEmpty(Properties.Settings.Default.Username))
            {
                txtUsername.Text = Properties.Settings.Default.Username;
                txtPassword.Text = Properties.Settings.Default.Password;
            }
        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void cbRemember_CheckedChanged(object sender, EventArgs e)
        {

        }
    }
}
