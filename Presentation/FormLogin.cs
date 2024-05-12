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
            string roleName;

            accountBusiness.Login(username, password, out result, out roleName);

            if (result == 1)
            {
                MessageBox.Show($"Đăng nhập thành công! Role của bạn là: {roleName}", "Thông báo", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            else
            {
                MessageBox.Show("Đăng nhập không thành công! Vui lòng kiểm tra lại tên đăng nhập và mật khẩu.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}
