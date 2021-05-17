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
            Console.WriteLine("3) Regsiter account");
            Console.WriteLine("4) User login");
            Console.WriteLine("5) Regsiter account");
            Console.WriteLine("6) User login");
            Console.WriteLine("7) Regsiter account");
            Console.WriteLine("8) User login");
            Console.WriteLine("9) Regsiter account");
            Console.WriteLine("10) User login");
            Console.WriteLine("11) Regsiter account");
            Console.WriteLine("12) User login");
            Console.WriteLine("13) Regsiter account");
            Console.WriteLine("14) User login");
            Console.WriteLine("15) Exit");
            Console.Write("\r\nSelect an option: ");

            DataAccess aDataAccess = new DataAccess();
            switch (Console.ReadLine())
            {
                case "1":
                    Console.WriteLine("Message is " + aDataAccess.newUserRegistration("test7@gmail.com", "Test7", "P@ssword1"));
                    return true;
                case "2":
                    Console.WriteLine("Message is " + aDataAccess.loginCheckCredentials("Test7", "P@ssword1")); 
                    return true;
                case "3":
                    Console.WriteLine("Message is " + aDataAccess.newGame("NewUser_1"));
                    return true;
                case "4":
                    Console.WriteLine("Message is " + aDataAccess.joinGame("100003", "10"));
                    return true;
                case "5":
                    Console.WriteLine("Message is " + aDataAccess.playerMoves("2", "9", "100003"));
                    return true;
                case "6":
                    Console.WriteLine("Message is " + aDataAccess.findGem("34", "9", "100003"));
                    return true;
                case "7":
                    Console.WriteLine("Message is " + aDataAccess.gemTurn("129", "500007", "9", "100003"));
                    return true;
                case "8":
                    Console.WriteLine("Message is " + aDataAccess.scoreEnd("500007", "9", "100003"));
                    return true;
                case "9":
                    Console.WriteLine("Message is " + aDataAccess.playerLogout("NewUser_1"));
                    return true;
                case "10":
                    Console.WriteLine("Message is " + aDataAccess.enterAdmin("NewUser_1"));
                    return true;
                case "11":
                    Console.WriteLine("Message is " + aDataAccess.killGame("100003", "NewUser_1"));
                    return true;
                case "12":
                    Console.WriteLine("Message is " + aDataAccess.addPlayer("NewUser_1", "NewUser_8@gmail.com", "NewUser_8", "P@ssword1", "1"));
                    return true;
                case "13":
                    Console.WriteLine("Message is " + aDataAccess.updatePlayer("NewUser_1", "16", "NewUser_8@gmail.com", "NewUser_8", "P@ssword1", "1", "0", "1", "3", "456"));
                    return true;
                case "14":
                    Console.WriteLine("Message is " + aDataAccess.deletePlayer("NewUser_8", "NewUser_1"));
                    return true;
                case "15":
                    return false;
                default:
                    return true;
            }
        }

    }
}


