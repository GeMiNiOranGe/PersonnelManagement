using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business
{
    public class AccountBusiness
    {
        private Data.AccountData accountData;

        public AccountBusiness()
        {
            accountData = new Data.AccountData();
        }

        public void Login(string username, string password, out int result, out string roleName)
        {
            SqlParameter[] parameters = new SqlParameter[]
            {
                new SqlParameter("@USERNAME", SqlDbType.VarChar) { Value = username },
                new SqlParameter("@PASSWORD", SqlDbType.VarChar) { Value = password },
                new SqlParameter("@KETQUA", SqlDbType.Int) { Direction = ParameterDirection.Output },
                new SqlParameter("@ROLENAME", SqlDbType.NVarChar, 100) { Direction = ParameterDirection.Output }
            };

            DataTable dataTable = accountData.ExecuteStoredProcedure("spLogin", parameters);

            // Lấy kết quả đăng nhập và role name từ kết quả trả về của stored procedure
            result = Convert.ToInt32(parameters[2].Value);
            roleName = parameters[3].Value.ToString();
        }
    }
}
