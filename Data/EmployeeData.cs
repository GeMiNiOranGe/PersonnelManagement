using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Data
{
    public class EmployeeData
    {
       
        public DataTable getEmployeeByRoleID(int roleID)
        {
            DataTable dataTable = new DataTable();
                using (SqlConnection conn = new SqlConnection(Config.connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("spSelectEmployees", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@RoleID", roleID);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(dataTable);
                    }
                }
            return dataTable;
        }
    }
}
