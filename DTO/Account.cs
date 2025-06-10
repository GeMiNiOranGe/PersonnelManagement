namespace DTO {
    public class Account {
        private int accountId;
        private string username;
        private byte[] password;
        private byte[] salt;
        private string employeeId;

        public int AccountId {
            get => accountId;
            set => accountId = value;
        }
        public string Username {
            get => username;
            set => username = value;
        }
        public byte[] Password {
            get => password;
            set => password = value;
        }
        public byte[] Salt {
            get => salt;
            set => salt = value;
        }
        public string EmployeeId {
            get => employeeId;
            set => employeeId = value;
        }
    }
}
