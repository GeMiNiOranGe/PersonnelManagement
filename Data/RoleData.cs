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


        public void GrantRole(int roleID, int roleIDAdd, int permissionID, string name, string columnName)
        {
            DataTable rolePermissions = GetRolePermissions();
            DataRow[] existingPermissions = rolePermissions.Select($"RoleID = {roleIDAdd} AND PermissionID = {permissionID} AND Name = '{name}'");

            if (existingPermissions.Length > 0)
            {
                DataRow row = existingPermissions[0];
                string currentColumnName = row["ColumnName"].ToString();

                if (!string.IsNullOrEmpty(columnName))
                {
                    if (string.IsNullOrEmpty(currentColumnName))
                    {
                        currentColumnName = columnName;
                    }
                    else
                    {
                        currentColumnName = $"{currentColumnName},{columnName}";
                    }

                    // Update the existing row with the new ColumnName
                    using (SqlConnection connection = new SqlConnection(Config.connectionString))
                    {
                        connection.Open();
                        using (SqlCommand command = new SqlCommand("UPDATE RolePermissions SET ColumnName = @ColumnName WHERE RoleID = @RoleIDAdd AND PermissionID = @PermissionID AND Name = @Name", connection))
                        {
                            command.Parameters.AddWithValue("@ColumnName", currentColumnName);
                            command.Parameters.AddWithValue("@RoleIDAdd", roleIDAdd);
                            command.Parameters.AddWithValue("@PermissionID", permissionID);
                            command.Parameters.AddWithValue("@Name", name);
                            command.ExecuteNonQuery();
                        }
                    }
                }
            }
            else
            {
                // Call the stored procedure to insert a new permission
                using (SqlConnection connection = new SqlConnection(Config.connectionString))
                {
                    connection.Open();
                    using (SqlCommand command = new SqlCommand("GrantRole", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("@RoleID", roleID);
                        command.Parameters.AddWithValue("@RoleIDAdd", roleIDAdd);
                        command.Parameters.AddWithValue("@PermissionID", permissionID);
                        command.Parameters.AddWithValue("@Name", name);
                        command.Parameters.AddWithValue("@ColumnName", string.IsNullOrWhiteSpace(columnName) ? (object)DBNull.Value : columnName);

                        command.ExecuteNonQuery();
                    }
                }
            }
        }
        public void UpdateRolePermission(int roleID, int roleIDAdd,int permissionID, string columnName)
        {
            using (SqlConnection connection = new SqlConnection(Config.connectionString))
            {
                SqlCommand command = new SqlCommand("UpdateRolePermission", connection);
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.AddWithValue("@RoleID", roleID);
                command.Parameters.AddWithValue("@RoleIDAdd", roleIDAdd);
                command.Parameters.AddWithValue("@PermissionID", permissionID);
                command.Parameters.AddWithValue("@ColumnName", columnName);

                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Error: " + ex.Message);
                }
            }

        }
        private bool RoleExists(int roleID, SqlConnection connection)
        {
            string query = "SELECT COUNT(*) FROM RolePermissions WHERE RoleID = @RoleID";
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@RoleID", roleID);
                int count = (int)command.ExecuteScalar();
                return count > 0;
            }
        }

        private string GetExistingColumns(int roleID, SqlConnection connection)
        {
            string query = "SELECT ColumnName FROM RolePermissions WHERE RoleID = @RoleID";
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@RoleID", roleID);
                string existingColumns = command.ExecuteScalar() as string;
                return existingColumns;
            }
        }

    }
}
