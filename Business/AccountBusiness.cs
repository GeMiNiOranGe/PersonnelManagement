using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using System.Security.Authentication;

using Business.Utilities;
using Business.Security;
using Data;
using DTO;

namespace Business
{
    public class AccountBusiness
    {
        private Data.AccountData accountData;

        public AccountBusiness()
        {
            accountData = new Data.AccountData();
        }

        public void Login(string username, string password, out int result, out int roleID, out string name)
        {
            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@USERNAME", SqlDbType.VarChar) { Value = username },
                new SqlParameter("@PASSWORD", SqlDbType.VarChar) { Value = password },
                new SqlParameter("@KETQUA", SqlDbType.Int) { Direction = ParameterDirection.Output },
                new SqlParameter("@ROLEID", SqlDbType.Int) { Direction = ParameterDirection.Output },
                new SqlParameter("@NAME", SqlDbType.VarChar, -1) { Direction = ParameterDirection.Output }
            };

            DataTable dataTable = accountData.ExecuteStoredProcedure("spLogin", parameters);

            // Lấy kết quả đăng nhập, roleID và name từ kết quả trả về của stored procedure
            result = Convert.ToInt32(parameters[2].Value);
            roleID = parameters[3].Value == DBNull.Value ? 0 : Convert.ToInt32(parameters[3].Value);
            name = parameters[4].Value.ToString();
        }

        public LoginStatus GetLoginStatus(string accountName, string password)
        {
            Account account = AccountData.Instance.GetAccountDetails(accountName);

            var isSamePassword = false;

            if (account != null)
            {
                string castSalt = DefaultConverter.GetString(account.Salt);
                string saltedPassword = string.Concat(password, castSalt);
                isSamePassword = Hasher.VerifyMessage(saltedPassword, account.Password, HashAlgorithmType.Sha256);
            }

            bool isValid = account != null && isSamePassword;

            if (string.IsNullOrEmpty(accountName) || string.IsNullOrEmpty(password))
            {
                return LoginStatus.InvalidInput;
            }
            if (isValid)
            {
                return LoginStatus.Success;
            }
            if (!isValid)
            {
                return LoginStatus.InvalidAccount;
            }
            return LoginStatus.OtherError;
        }
    }
}
