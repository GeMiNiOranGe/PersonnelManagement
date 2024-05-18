using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business
{
   public class EmployeeBusiness
    {
        private EmployeeData empData;
        public EmployeeBusiness() { 
            empData = new EmployeeData();
        }

        public DataTable GetEmployeesByRoleID(int roleID)
        {
            return empData.getEmployeeByRoleID(roleID);
        }
    }
}
