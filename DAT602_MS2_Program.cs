using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using MySql.Data.MySqlClient;

namespace DAT602_ConsoleApp
{
    class Program
    {
        static void Main(string[] args)
        {
           



            bool showMenu = true;
            while (showMenu)
            {
                showMenu = MainMenu();
            }
        }

        private static bool MainMenu()
        {
            Console.Clear();
            Console.WriteLine("Choose an option:");
            Console.WriteLine("1) Regsiter account");
            Console.WriteLine("2) User login");
            Console.WriteLine("3) Exit");
            Console.Write("\r\nSelect an option: ");



            DataAccess aDataAccess = new DataAccess();
            switch (Console.ReadLine())
            {
                case "1":
                    Console.WriteLine("Message is " + aDataAccess.newUserRegistration("test4@gmail.com", "Test4", "P@ssword1"));
                    return true;
                case "2":
                    Console.WriteLine("Message is " + aDataAccess.loginCheckCredentials("Test4", "P@ssword1")); 
                    return true;
                case "3":
                    return false;
                default:
                    return true;
            }
        }

    }
}
