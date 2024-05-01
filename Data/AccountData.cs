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

        public DataTable GetAccountDetails(string username, byte[] password) {
            DataTable dataTable = DataProvider.Instance.ExecuteProcedure(
                "usp_GetAccountDetails",
                new (string, SqlDbType, int, object)[] {
                    ("@Username", SqlDbType.VarChar, 50, (object)username),
                    ("@Password", SqlDbType.VarBinary, DatabaseConstants.MAX_SIZE, (object)password)
                }
            );
            return dataTable;
        }
    }
}
