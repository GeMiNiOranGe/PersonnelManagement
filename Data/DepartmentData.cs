using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Data
{
    public class DepartmentData
    {
        public DataTable GetDepartments()
        {
            DataTable dataTable = new DataTable();

            using (SqlConnection connection = new SqlConnection(Config.connectionString))
            {
                string query = "SELECT DepartmentID FROM Departments";

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
        public DataTable getAllDepartments()
        {
            DataTable dataTable = new DataTable();

            using (SqlConnection connection = new SqlConnection(Config.connectionString))
            {
                string query = "SELECT DepartmentID, DepartmentName, ISNULL(ManagerID, 'NULL') AS ManagerID FROM Departments";

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
    }
}
