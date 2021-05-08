using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using MySql.Data.MySqlClient;

namespace ProjectWork
{
    public class paramProcedure
    {
        String connectionString = "Server=localhost;Port=3306;Database=sdghGameDatabase;Uid=root;password=53211;";
        MySqlConnection mySqlConnection = new MySqlConnection(connectionString);

        // New User Registration Procedure
        private static DataSet newUserRegistration(string pEmail, string pUsername, string pPassword)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramEmail = new MySqlParameter("@Email", MySqlDbType.VarChar, 50);
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            var paramPassword = new MySqlParameter("@Password", MySqlDbType.BLOB);
            paramEmail.Value = pEmail;
            paramUsername.Value = pUsername;
            paramPassword.Value = pPassword;
            paramInput.Add(paramEmail);
            paramInput.Add(paramUsername);
            paramInput.Add(paramPassword);

            var aDataSet = MySqlHelper.ExecuteDataset(mySqlConnection, "newUserRegistration(@Email,@Username,@Password)", paramInput.ToArray());

            return aDataSet;
        }

        // Login Check Credentials Procedure
        private static DataSet loginCheckCredentials(string pUsername, string pPassword)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            var paramPassword = new MySqlParameter("@Password", MySqlDbType.BLOB);
            paramUsername.Value = pUsername;
            paramPassword.Value = pPassword;
            paramInput.Add(paramUsername);
            paramInput.Add(paramPassword);

            var aDataSet = MySqlHelper.ExecuteDataset(mySqlConnection, "loginCheckCredentials(@Username,@Password)", paramInput.ToArray());

            return aDataSet;
        }

        // Home Screen Display Procedure
        private static DataSet homeScreenDisplay(string pUsername)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            paramUsername.Value = pUsername;
            paramInput.Add(paramUsername);

            var aDataSet = MySqlHelper.ExecuteDataset(mySqlConnection, "homeScreenDisplay(@Username)", paramInput.ToArray());

            return aDataSet;
        }
    }
}




namespace ProjectWork
{
    class Program
    {
        static void Main(string[] args)
        {
            // New User Registration Procedure
            DataSet Registration = newUserRegistration("test1@gmail.com", "TestOne", "P@ssword1");
            foreach (DataRow aRow in Registration.Tables[0].Rows)
            {
                Console.WriteLine("Registration Status = " + aRow["Message"]);
            }

            // Login Check Credentials Procedure
            DataSet Login = loginCheckCredentials("TestOne", "P@ssword1");
            foreach (DataRow aRow in Login.Tables[0].Rows)
            {
                Console.WriteLine("Login Status = " + aRow["Message"]);

            // Home Screen Display Procedure
            DataSet Home = loginCheckCredentials("TestOne");
            foreach (DataRow aRow in Home.Tables[0].Rows)
            {
                Console.WriteLine("Home Screen Status = " + aRow["Message"]);
            }
        }
    }
}
