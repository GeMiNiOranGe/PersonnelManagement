using Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business
{
    public class LogBusiness
    {
        private Data.LogData logData;

        public LogBusiness()
        {
            logData = new Data.LogData();

        }
        public void ExecuteQueryWithLog()
        {
            int accountId = logData.DataAccountID();
        }
    }
}
