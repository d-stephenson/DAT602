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
                    Console.WriteLine(aDataAccess.NewUserRegistration("ConsoleU_1@appmail.com", "ConsoleU_1", "P@ssword1"));
                    Console.ReadLine();
                    return true;
                case "2":
                    var aHomePage = aDataAccess.LoginCheckCredentials("ConsoleU_1", "P@ssword1");
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
                    Console.WriteLine(aDataAccess.NewGame("ConsoleU_1"));
                    Console.ReadLine();
                    return true;
                case "4":
                    Console.WriteLine(aDataAccess.JoinGame("100003", "1"));
                    Console.ReadLine();
                    return true;
                case "5":
                    var aTileInfo = aDataAccess.MovePlayer("32", "9", "100003"); 
                    Console.WriteLine("Tile Details");
                    foreach (var item in aTileInfo.TileInfo)
                    {
                        Console.WriteLine("This tile colour is: " + item.TileColour);
                        Console.WriteLine("The tile row is: " + item.TileRow.ToString());
                        Console.WriteLine("The tile column is: " + item.TileColumn.ToString());
                    }
                    Console.ReadLine();
                    return true;
                case "6":
                    var aGemSelection = aDataAccess.FindGem("50", "9", "100003");
                    Console.WriteLine("List of gems");
                    foreach (var item in aGemSelection.GemSelection)
                    {
                        Console.WriteLine("This item id is: " + item.ItemID.ToString());
                        Console.WriteLine("This gem type is: " + item.GemType);
                        Console.WriteLine("The points are: " + item.Points.ToString());
                        Console.WriteLine("The game id is: " + item.GameID.ToString());
                        Console.WriteLine("This player id is: " + item.PlayerID.ToString());
                        Console.WriteLine("This play id is: " + item.PlayID.ToString());
                        Console.WriteLine("This tile id is: " + item.TileID.ToString());
                    }
                        Console.ReadLine();
                        return true;
                case "7":
                    Console.WriteLine(aDataAccess.SelectGem("129", "500007", "9", "100003"));
                    Console.ReadLine();
                    return true;
                case "8":
                    var aWinner = aDataAccess.UpdateHS_EG("500007", "9", "100003");
                    Console.WriteLine("And the Winner is...");
                    foreach (var item in aWinner.Winner)
                    {
                        Console.WriteLine("Congratulate: " + item.CharacterName);
                        Console.WriteLine("Their points are: " + item.PlayScore.ToString());
                    }
                    Console.ReadLine();
                    return true;
                case "9":
                    Console.WriteLine(aDataAccess.PlayerLogout("ConsoleU_1"));
                    Console.ReadLine();
                    return true;
                case "10":
                    var aAdminPage = aDataAccess.AdminScreen("Bob");
                    Console.WriteLine("List of games");
                    foreach (var item in aAdminPage.GameCount)
                    {
                        Console.WriteLine("This game id is: " + item.GameID.ToString());
                        Console.WriteLine("This game's player count is: " + item.PlayerCount.ToString());
                    }
                    Console.WriteLine("List of players");
                    foreach (var item in aAdminPage.PlayerHighScore)
                    {
                        Console.WriteLine("This player is: " + item.Player);
                        Console.WriteLine("Their high score is: " + item.HighScore.ToString());
                    }
                    Console.ReadLine();
                    return true;
                case "11":
                    Console.WriteLine(aDataAccess.KillGame("100002", "Bob"));
                    Console.ReadLine();
                    return true;
                case "12":
                    Console.WriteLine(aDataAccess.AddPlayer("Bob", "ConsoleU_2@appmail.com", "ConsoleU_2", "P@ssword1", "1"));
                    Console.ReadLine();
                    return true;
                case "13":
                    Console.WriteLine(aDataAccess.UpdatePlayer("Bob", "10", "ChangeU_2@appmail.com", "ChangeU_2", "P@ssword1", "1", "0", "1", "3", "109"));
                    Console.ReadLine();
                    return true;
                case "14":
                    Console.WriteLine(aDataAccess.DeletePlayer("Bob", "ChangeU_2"));
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


