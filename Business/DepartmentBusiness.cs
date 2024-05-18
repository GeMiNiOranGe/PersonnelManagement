using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business
{
    public class DepartmentBusiness
    {
        private DepartmentData departData;
        public DepartmentBusiness()
        {
            departData = new DepartmentData();
        }
        public DataTable GetDepartments()
        {
            return departData.GetDepartments();
        }
    }
}
