using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Data
{
    public class LogData
    {
        private string connectionString = "Data Source=ADMIN;Initial Catalog=PersonnelManagement;Integrated Security=True";
        public int DataAccountID()
        {
            int accountId = 0;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                string query = "SELECT AccountID FROM AccountRoles WHERE RoleID = 1";
                SqlCommand command = new SqlCommand(query, connection);
                accountId = Convert.ToInt32(command.ExecuteScalar());
            }
            return accountId;
        }
    }
}
