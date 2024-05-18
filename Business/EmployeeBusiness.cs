using Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
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
        public bool updateEmployee(int roleID, string valueList, string employeeID)
        {
            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@RoleID", SqlDbType.Int) { Value = roleID },
                new SqlParameter("@ValueList", SqlDbType.NVarChar) { Value = valueList },
                new SqlParameter("@EmployeeID", SqlDbType.VarChar) { Value = employeeID }
            };

            int kq = empData.ExecuteStoredProcedure("usp_UpdateEmployee", parameters);
            return kq > 0;
        }
    }
}
