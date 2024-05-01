using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Security.Authentication;
using System.Text;
using System.Threading.Tasks;

using Data;
using DTO;

namespace Business {
    public class AccountBusiness {
        #region Singleton Design Pattern
        private static AccountBusiness instance;

        public static AccountBusiness Instance {
            // The null-coalescing operators
            get => instance ?? (instance = new AccountBusiness());
            private set => instance = value;
        }

        private AccountBusiness() { }
        #endregion

        byte[] ObjectToByteArray(object obj) {
            if (obj == null) {
                return null;
            }

            var bf = new BinaryFormatter();
            using (var ms = new MemoryStream()) {
                bf.Serialize(ms, obj);
                return ms.ToArray();
            }
        }

        public Account GetAccountDetails(string username, string password) {
            byte[] hashedPassword = Security.Hasher.ComputeHash(password, HashAlgorithmType.Sha1);

            DataTable dataTable = AccountData.Instance.GetAccountDetails(username, hashedPassword);

            DataRow row = dataTable.Rows[0];

            Account account = new Account() {
                AccountId = Convert.ToInt32(row["AccountId"]),
                Username = row["Username"].ToString(),
                Password = ObjectToByteArray(row["Password"]),
                Salt = ObjectToByteArray(row["Salt"]),
                EmployeeId = row["EmployeeId"].ToString()
            };

            return account;
        }
    }
}
