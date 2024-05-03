using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Security.Authentication;
using System.Text;
using System.Threading.Tasks;

using Business.Utilities;
using Business.Security;
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

        public LoginStatus GetLoginStatus(string accountName, string password) {
            Account account = AccountData.Instance.GetAccountDetails(accountName);

            byte[] hashedPassword = null;

            if (account != null) {
                string castedSalt = DefaultConverter.GetString(account.Salt);
                string saltedPassword = password + castedSalt;
                hashedPassword = Hasher.ComputeHash(saltedPassword, HashAlgorithmType.Sha256);
            }

            bool isValid = account != null && account.Password.SequenceEqual(hashedPassword);

            if (string.IsNullOrEmpty(accountName) || string.IsNullOrEmpty(password)) {
                return LoginStatus.InvalidInput;
            }
            if (isValid) {
                return LoginStatus.Success;
            }
            if (!isValid) {
                return LoginStatus.InvalidAccount;
            }
            return LoginStatus.OtherError;
        }
    }
}
