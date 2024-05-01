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

            Account account = AccountBusiness.Instance.GetAccountDetails("tranvantoan", "toan@123");
            
            txtAccountId.Text = account.AccountId.ToString();
            txtUsername.Text = account.Username;
            txtPassword.Text = BitConverter.ToString(account.Password);
            txtSalt.Text = BitConverter.ToString(account.Salt);
            txtEmployeeId.Text = account.EmployeeId.ToString();
        }
    }
}
