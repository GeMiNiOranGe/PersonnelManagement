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
        public int ExecuteStoredProcedure(string storedProcedureName, SqlParameter[] parameters)
        {
            using (SqlConnection connection = new SqlConnection(Config.connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand(storedProcedureName, connection);
                command.CommandType = CommandType.StoredProcedure;

                if (parameters != null)
                {
                    command.Parameters.AddRange(parameters);
                }

                return command.ExecuteNonQuery();
            }
        }

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
        public void updateEmployee(int roleID, string valueList, string employeeID)
        {
            using (SqlConnection connection = new SqlConnection(Config.connectionString))
            {
                connection.Open();
                using (SqlCommand command = new SqlCommand("usp_UpdateEmployee", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@RoleID", roleID);
                    command.Parameters.AddWithValue("@ValueList", valueList);
                    command.Parameters.AddWithValue("@EmployeeID", employeeID);
                    command.ExecuteNonQuery();
                }
            }
        }
    }
}
