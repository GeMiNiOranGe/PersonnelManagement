using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Data
{
   public class RoleData
    {
        public DataTable getRoleID()
        {
            DataTable dataTable = new DataTable();
            using (SqlConnection connection = new SqlConnection(Config.connectionString))
            {
                string query = "SELECT RoleID FROM Roles";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    connection.Open();
                    using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    {
                        adapter.Fill(dataTable);
                    }
                }
            }
            return dataTable;
        }
        public DataTable getPermissionsID()
        {
            DataTable dataTable = new DataTable();
            using (SqlConnection connection = new SqlConnection(Config.connectionString))
            {
                string query = "SELECT PermissionID FROM Permissions";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    connection.Open();
                    using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    {
                        adapter.Fill(dataTable);
                    }
                }
            }
            return dataTable;
        }
        public DataTable GetRolePermissions()
        {
            DataTable dataTable = new DataTable();

            using (SqlConnection connection = new SqlConnection(Config.connectionString))
            {
                string query = "SELECT * FROM RolePermissions";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    connection.Open();

                    using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    {
                        adapter.Fill(dataTable);
                    }
                }
            }

            return dataTable;
        }

        public bool GrantRole(int roleID, int roleIDAdd, int permissionID, string name, string columnName)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(Config.connectionString))
                {
                    connection.Open();
                    SqlCommand command = new SqlCommand("GrantRole", connection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@RoleID", roleID);
                    command.Parameters.AddWithValue("@RoleIDAdd", roleIDAdd);
                    command.Parameters.AddWithValue("@PermissionID", permissionID);
                    command.Parameters.AddWithValue("@Name", name);
                    command.Parameters.AddWithValue("@ColumnName", columnName);
                    int rowsAffected = command.ExecuteNonQuery();
                    return rowsAffected > 0;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error in GrantRole method: " + ex.Message);
                return false;
            }
        }

    }
}
