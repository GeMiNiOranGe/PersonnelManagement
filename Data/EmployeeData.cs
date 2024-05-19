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
        public bool updateEmployee(int roleID, string valueList, string employeeID)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(Config.connectionString))
                {
                    connection.Open();

                    SqlCommand command = new SqlCommand("dbo.usp_UpdateEmployee", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@RoleID", roleID);
                    command.Parameters.AddWithValue("@ValueList", valueList);
                    command.Parameters.AddWithValue("@EmployeeID", employeeID);

                    command.ExecuteNonQuery();

                    return true;
                }
            }
            catch (SqlException ex)
            {
                // Xử lý các ngoại lệ SQL
                throw new Exception("SQL Error: " + ex.Message);
            }
            catch (Exception ex)
            {
                // Xử lý các ngoại lệ khác
                throw new Exception("Error: " + ex.Message);
            }
        }
    
        public bool deleteEmployee(int roleID, string employeeID)
        {
            using (SqlConnection connection = new SqlConnection(Config.connectionString))
            {
                try
                {
                    using (SqlCommand command = new SqlCommand("spDeleteEmployee", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@RoleID", roleID);
                        command.Parameters.AddWithValue("@EmployeeID", employeeID);

                        connection.Open();
                        int rowsAffected = command.ExecuteNonQuery();
                        return rowsAffected > 0;
                    }
                }
                catch (Exception ex)
                {
              
                    throw new Exception("An error occurred while deleting the employee.", ex);
                }
            }
        }
        public void InsertEmployee(string employeeId, string fullname, bool? gender, DateTime? dateOfBirth, string phoneNumber, string salary, string allowance, string taxCode, string departmentId)
        {
            using (SqlConnection conn = new SqlConnection(Config.connectionString))
            {
                using (SqlCommand cmd = new SqlCommand("spInsertEmployeeFull", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@EmployeeId", (object)employeeId ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Fullname", fullname);
                    cmd.Parameters.AddWithValue("@Gender", (object)gender ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@DateOfBirth", (object)dateOfBirth ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@PhoneNumber", (object)phoneNumber ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Salary", salary);
                    cmd.Parameters.AddWithValue("@Allowance", allowance);
                    cmd.Parameters.AddWithValue("@TaxCode", (object)taxCode ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@DepartmentId", departmentId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}
