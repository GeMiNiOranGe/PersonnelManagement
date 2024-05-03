using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using DTO;

namespace Data {
    public class AccountData {
        #region Singleton Design Pattern
        private static AccountData instance;

        public static AccountData Instance {
            // The null-coalescing operators
            get => instance ?? (instance = new AccountData());
            private set => instance = value;
        }

        private AccountData() { }
        #endregion

        public Account GetAccountDetails(string accountName) {
            var procedureName = "usp_GetAccountDetails";
            var parameters = new (string, SqlDbType, int, object)[] {
                ("@AccountName", SqlDbType.VarChar, 50, accountName)
            };

            DataTable dataTable = DataProvider.Instance.ExecuteProcedure(procedureName, parameters);

            Account account = null;
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
