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
                    Console.WriteLine(aDataAccess.NewUserRegistration("NewUser_9@gmail.com", "NewUser_9", "P@ssword1"));
                    Console.ReadLine();
                    return true;
                case "2":
                    var aHomePage = aDataAccess.LoginCheckCredentials("NewUser_9", "P@ssword1");
                    Console.WriteLine("List of games");
                    foreach (var item in aHomePage.GameCount)
                    {
                        Console.WriteLine("This game id is: " + item.GameID.ToString());
                        Console.WriteLine("This game's player count is: " + item.PlayerCount.ToString());
                    }
                    Console.WriteLine("List of players");
                    foreach (var item in aHomePage.PlayerHighScore)
                    {
                        Console.WriteLine("This player is: " + item.Player);
                        Console.WriteLine("Their high score is: " + item.HighScore.ToString());
                    }
                    Console.ReadLine();
                    return true;
                case "3":
                    Console.WriteLine(aDataAccess.NewGame("NewUser_9"));
                    Console.ReadLine();
                    return true;
                case "4":
                    Console.WriteLine(aDataAccess.JoinGame("100003", "16"));
                    Console.ReadLine();
                    return true;
                case "5":
                    Console.WriteLine(aDataAccess.MovePlayer("78", "16", "100003"));
                    Console.ReadLine();
                    return true;
                case "6":
                    Console.WriteLine(aDataAccess.FindGem("78", "16", "100003"));
                    Console.ReadLine();
                    return true; 
                case "7":
                    Console.WriteLine(aDataAccess.GemTurn("129", "500014", "16", "100003"));
                    Console.ReadLine();
                    return true;
                case "8":
                    Console.WriteLine(aDataAccess.ScoreEnd("500014", "16", "100003"));
                    Console.ReadLine(); 
                    return true;
                case "9":
                    Console.WriteLine(aDataAccess.PlayerLogout("NewUser_9"));
                    Console.ReadLine();
                    return true;
                case "10":
                    Console.WriteLine(aDataAccess.EnterAdmin("NewUser_2"));
                    Console.ReadLine();
                    return true;
                case "11":
                    Console.WriteLine(aDataAccess.KillGame("100002", "NewUser_2"));
                    Console.ReadLine();
                    return true;
                case "12":
                    Console.WriteLine(aDataAccess.AddPlayer("NewUser_2", "NewUser_10@gmail.com", "NewUser_10", "P@ssword1", "1"));
                    Console.ReadLine();
                    return true;
                case "13":
                    Console.WriteLine(aDataAccess.UpdatePlayer("NewUser_2", "16", "NewUser_8@yahoo.com", "NewUser_8", "P@ssword1", "1", "0", "1", "3", "109"));
                    Console.ReadLine();
                    return true;
                case "14":
                    Console.WriteLine(aDataAccess.DeletePlayer("NewUser_2", "NewUser_5"));
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


