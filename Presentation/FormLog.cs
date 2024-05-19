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
    public partial class FormLog : Form
    {
        private LogBusiness logBusiness;
        public FormLog()
        {
            InitializeComponent();
            logBusiness.ExecuteQueryWithLog();
        }
    }
}
