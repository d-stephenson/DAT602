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
        private static DataSet newUserRegistration(string pEmail, string pUsername, string pPassword)
        {
            // New User Registration Procedure

            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramEmail = new MySqlParameter("@Email", MySqlDbType.VarChar, 50);
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            var paramPassword = new MySqlParameter("@Password", MySqlDbType.BLOB);
            paramEmail.Value = pEmail;
            paramUsername.Value = pEmail;
            paramPassword.Value = pEmail;
            paramInput.Add(paramEmail);
            paramInput.Add(paramUsername);
            paramInput.Add(paramPassword);

            var aDataSet = MySqlHelper.ExecuteDataset(mySqlConnection, "newUserRegistration(@Email,@Username,@Password)", paramInput.ToArray());

            return aDataSet;
        }
        private static DataSet newUserRegistration(string pEmail, string pUsername, string pPassword)
        {
            // Login Check Credentials Procedure

            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramEmail = new MySqlParameter("@Email", MySqlDbType.VarChar, 50);
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            var paramPassword = new MySqlParameter("@Password", MySqlDbType.BLOB);
            paramEmail.Value = pEmail;
            paramUsername.Value = pEmail;
            paramPassword.Value = pEmail;
            paramInput.Add(paramEmail);
            paramInput.Add(paramUsername);
            paramInput.Add(paramPassword);

            var aDataSet = MySqlHelper.ExecuteDataset(mySqlConnection, "newUserRegistration(@Email,@Username,@Password)", paramInput.ToArray());

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
            DataSet Registration = newUserRegistration("test1@gmail.com", "TestOne", "P@ssword1");
            foreach (DataRow aRow in Registration.Tables[0].Rows)
            {
                Console.WriteLine("Registration Status = " + aRow["Message"]);
            }
        }
    }
}
