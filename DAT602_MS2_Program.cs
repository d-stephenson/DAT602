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
            Console.WriteLine("3) Create a new game");
            Console.WriteLine("4) Join a game");
            Console.WriteLine("5) Move a player");
            Console.WriteLine("6) Find a gem");
            Console.WriteLine("7) Select a gem");
            Console.WriteLine("8) Update turn");
            Console.WriteLine("9) Logout of game");
            Console.WriteLine("10) Enter admin area");
            Console.WriteLine("11) Kill a game");
            Console.WriteLine("12) Add a new player");
            Console.WriteLine("13) Update a players details");
            Console.WriteLine("14) Delete a player");
            Console.WriteLine("15) Exit");
            Console.Write("\r\nSelect an option: ");

            DataAccess aDataAccess = new DataAccess();

            switch (Console.ReadLine())
            {
                case "1":
                    Console.WriteLine(aDataAccess.newUserRegistration("NewUser_1@gmail.com", "NewUser_1", "P@ssword1"));
                    Console.ReadLine();
                    return true;
                case "2":
                    var aHomePage = aDataAccess.loginCheckCredentials("NewUser_1", "P@ssword1");
                    Console.WriteLine(aDataAccess.loginCheckCredentials("NewUser_1", "P@ssword1"));
                    //foreach (var aHomePage in aDataAccess.HomeScreenDisplay())
                    //{
                    //    Console.WriteLine(aHomePage.HomeDisplayData);
                    //}
                    Console.ReadLine();
                    return true;
                case "3":
                    Console.WriteLine(aDataAccess.newGame("NewUser_1"));
                    Console.ReadLine();
                    return true;
                case "4":
                    Console.WriteLine(aDataAccess.joinGame("100003", "9"));
                    Console.ReadLine();
                    return true;
                case "5":
                    Console.WriteLine(aDataAccess.playerMoves("34", "9", "100003"));
                    Console.ReadLine();
                    return true;
                case "6":
                    Console.WriteLine(aDataAccess.findGem("34", "9", "100003"));
                    Console.ReadLine();
                    return true; 
                case "7":
                    Console.WriteLine(aDataAccess.gemTurn("129", "500007", "9", "100003"));
                    Console.ReadLine();
                    return true;
                case "8":
                    Console.WriteLine(aDataAccess.scoreEnd("500007", "9", "100003"));
                    Console.ReadLine();
                    return true;
                case "9":
                    Console.WriteLine(aDataAccess.playerLogout("NewUser_1"));
                    Console.ReadLine();
                    return true;
                case "10":
                    Console.WriteLine(aDataAccess.enterAdmin("NewUser_1"));
                    Console.ReadLine();
                    return true;
                case "11":
                    Console.WriteLine(aDataAccess.killGame("100003", "NewUser_1"));
                    Console.ReadLine();
                    return true;
                case "12":
                    Console.WriteLine(aDataAccess.addPlayer("NewUser_1", "NewUser_8@gmail.com", "NewUser_8", "P@ssword1", "1"));
                    Console.ReadLine();
                    return true;
                case "13":
                    Console.WriteLine(aDataAccess.updatePlayer("NewUser_1", "16", "NewUser_8@gmail.com", "NewUser_8", "P@ssword1", "1", "0", "1", "3", "456"));
                    Console.ReadLine();
                    return true;
                case "14":
                    Console.WriteLine(aDataAccess.deletePlayer("NewUser_2", "NewUser_4"));
                    Console.ReadLine();
                    return true;
                case "15":
                    return false;
                default:
                    return true;
            }
        }
    }
}


