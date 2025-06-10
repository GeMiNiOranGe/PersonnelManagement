using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Presentation {
    public partial class FormDashboard : Form {
        private Form rootForm;

        public FormDashboard() {
            InitializeComponent();
        }

        public Form RootForm {
            get => rootForm;
            set => rootForm = value;
        }

        private void BtnLogout_Click(object sender, EventArgs e) {
            rootForm.Show();
            Close();
        }

        private void BtnExit_Click(object sender, EventArgs e) {
            string text = "Bạn có chắc muốn thoát không?";
            string caption = "Thông báo";
            MessageBoxButtons buttons = MessageBoxButtons.YesNo;
            MessageBoxIcon icon = MessageBoxIcon.Question;

            DialogResult dialogResulth = MessageBox.Show(text, caption, buttons, icon);
            if (dialogResulth == DialogResult.Yes) {
                Application.Exit();
            }
        }
    }
}
