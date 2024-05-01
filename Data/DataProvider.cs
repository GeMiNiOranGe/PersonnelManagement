using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Data {
    internal class DataProvider {
        private const string CONNECTION_STRING = @"Data Source=.;Initial Catalog=PersonnelManagement;Integrated Security=True";

        #region Singleton Design Pattern
        private static DataProvider instance;

        public static DataProvider Instance {
            // The null-coalescing operators
            get => instance ?? (instance = new DataProvider());
            private set => instance = value;
        }

        private DataProvider() { }
        #endregion

        public SqlConnection CreateConnection() {
            var connection = new SqlConnection(CONNECTION_STRING);
            return connection;
        }
        public SqlCommand CreateCommand(string query) {
            SqlConnection connection = CreateConnection();
            var command = new SqlCommand(query, connection);
            return command;
        }

        public void OpenConnection(SqlConnection connection) {
            var state = connection.State;
            if (state == ConnectionState.Closed || state == ConnectionState.Broken) {
                try {
                    connection.Open();
                }
                catch (SqlException ex) {
                    throw ex;
                }
            }
        }

        public void CloseConnection(SqlConnection connection) {
            if (connection == null) {
                return;
            }
            try {
                connection.Close();
            }
            catch (SqlException ex) {
                throw ex;
            }
        }

        public DataTable ExecuteQuery(string query) {
            var dataTable = new DataTable();
            using (SqlCommand command = CreateCommand(query)) {
                using (var dataAdapter = new SqlDataAdapter(command)) {
                    try {
                        dataAdapter.Fill(dataTable);
                    }
                    catch (SqlException ex) {
                        throw ex;
                    }
                }
            }
            return dataTable;
        }

        /*public int ExecuteNonQuery(string query)
        {
            int iData = 0;
            using (var sqlConnection = GetConnection())
            {
                OpenConnection(sqlConnection);
                var sqlCommand = new SqlCommand(query, sqlConnection);

                // Execute CRUD
                try { iData = sqlCommand.ExecuteNonQuery(); }
                catch (SqlException ex) { throw ex; }

                iData = sqlCommand.ExecuteNonQuery();
                CloseConnection(sqlConnection);
            }
            return iData;
        }*/
        public int ExecuteNonQuery(string query, object[] parameters = null) {
            int numberOfRowsAffected = 0;
            using (SqlCommand command = CreateCommand(query)) {
                if (parameters != null) {
                    string[] listParam = query.Split(' ');
                    int i = 0;
                    foreach (string item in listParam) {
                        if (item.Contains('@')) {
                            command.Parameters.AddWithValue(item, parameters[i]);
                            i++;
                        }
                    }
                }

                OpenConnection(command.Connection);
                numberOfRowsAffected = command.ExecuteNonQuery();
                CloseConnection(command.Connection);
            }
            return numberOfRowsAffected;
        }

        /// <summary>
        ///     Executes the query, and returns the first column of the first row in the result
        ///     set returned by the query. Additional columns or rows are ignored.
        /// </summary>
        /// <param name="query">query script.</param>
        /// <returns>
        ///     The first column of the first row in the result set, or a null reference (Nothing
        ///     in Visual Basic) if the result set is empty. Returns a maximum of 2033 characters.
        /// </returns>
        public object ExecuteScalar(string query) {
            object objData = 0;
            using (SqlConnection connection = CreateConnection()) {
                OpenConnection(connection);
                var sqlCommand = new SqlCommand(query, connection);

                // Get data 
                try {
                    objData = sqlCommand.ExecuteScalar();
                }
                catch (SqlException ex) {
                    throw ex;
                }

                CloseConnection(connection);
            }
            return objData;
        }

        public void ExecuteReader(string strQuery, out SqlDataReader dataReader) {
            throw new NotImplementedException();
            /*
            using (var sqlConnection = CreateConnection()) {
                OpenConnection(sqlConnection);
                var sqlCommand = new SqlCommand(strQuery, sqlConnection);
                try {
                    dataReader = sqlCommand.ExecuteReader();
                }
                catch (SqlException ex) {
                    throw ex;
                }
                CloseConnection(sqlConnection);
            }
            */
        }

        public DataTable ExecuteProcedure(string procedureName, (string name, SqlDbType type, int size, object value)[] parameters) {
            var dataTable = new DataTable();
            using (SqlCommand command = CreateCommand(procedureName)) {
                command.CommandType = CommandType.StoredProcedure;

                foreach (var (name, type, size, value) in parameters) {
                    var parameter = new SqlParameter() {
                        ParameterName = name,
                        SqlDbType = type,
                        Size = size,
                        Value = value
                    };
                    command.Parameters.Add(parameter);
                }

                using (var dataAdapter = new SqlDataAdapter(command)) {
                    try {
                        dataAdapter.Fill(dataTable);
                    }
                    catch (SqlException ex) {
                        throw ex;
                    }
                }
            }
            return dataTable;
        }
    }
}
