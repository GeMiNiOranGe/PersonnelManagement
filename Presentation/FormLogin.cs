using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using Business;
using DTO;

namespace Presentation {
    public partial class FormLogin : Form {
        public FormLogin() {
            InitializeComponent();
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
    }
}
