using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using DTO;

namespace Data
{
    public class AccountData
    {
        private string connectionString = Config.connectionString;

        public DataTable ExecuteStoredProcedure(string storedProcedureName, SqlParameter[] parameters)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand(storedProcedureName, connection);
                command.CommandType = CommandType.StoredProcedure;

                if (parameters != null)
                {
                    command.Parameters.AddRange(parameters);
                }

                DataTable dataTable = new DataTable();
                dataTable.Load(command.ExecuteReader());
                return dataTable;
            }
        }

        public Account GetAccountDetails(string accountName) {
            Account account = null;
            var procedureName = "usp_GetAccountDetails";
            var parameters = new SqlParameter[] {
                new SqlParameter() {
                    ParameterName = "AccountName",
                    SqlDbType = SqlDbType.VarChar,
                    Size = 50,
                    Value = accountName
                }
            };

            DataTable dataTable = DataProvider.Instance.ExecuteProcedure(procedureName, parameters);
            if (dataTable.Rows.Count > 0) {
                DataRow row = dataTable.Rows[0];

                account = new Account() {
                    AccountId = Convert.ToInt32(row["AccountId"]),
                    Username = row["Username"].ToString(),
                    Password = row["Password"] as byte[],
                    Salt = row["Salt"] as byte[],
                    EmployeeId = row["EmployeeId"].ToString()
                };
            }

            return account;
        }
    }
}
