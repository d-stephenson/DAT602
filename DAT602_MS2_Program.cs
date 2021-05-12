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
            DataSet Home = homeScreenDisplay("TestOne");
            foreach (DataRow aRow in Home.Tables[0].Rows)
            {
                Console.WriteLine("Home Screen Status = " + aRow["Message"]);

            // New Game Procedure
            DataSet Game = newGame("TestOne");
            foreach (DataRow aRow in Game.Tables[0].Rows)
            {
                Console.WriteLine("New Game Status = " + aRow["Message"]);
            }
            
            // Join Game Procedure
            DataSet Join = joinGame("100001", "1");
            foreach (DataRow aRow in Join.Tables[0].Rows)
            {
                Console.WriteLine("Join Game Status = " + aRow["Message"]);
            }

            // Move Game Procedure
            DataSet Move = moveGame("050", "1", "100001");
            foreach (DataRow aRow in Move.Tables[0].Rows)
            {
                Console.WriteLine("Move Game Status = " + aRow["Message"]);
            }

            // Find Game Procedure
            DataSet Find = findGem("050", "1", "100001");
            foreach (DataRow aRow in Find.Tables[0].Rows)
            {
                Console.WriteLine("Find Gem Status = " + aRow["Message"]);
            }

            // Select Gem & Update Turn Procedure
            DataSet Turn = gemTurn("155", "500001", "1", "100001");
            foreach (DataRow aRow in Turn.Tables[0].Rows)
            {
                Console.WriteLine("Player Turn Status = " + aRow["Message"]);
            }

            // Update High Score & End Game Procedure
            DataSet End = scoreEnd("500001", "1", "100001");
            foreach (DataRow aRow in End.Tables[0].Rows)
            {
                Console.WriteLine("End Game Status = " + aRow["Message"]);
            }

            // Player Logout Procedure
            DataSet Logout = playerLogout("TestOne");
            foreach (DataRow aRow in Logout.Tables[0].Rows)
            {
                Console.WriteLine("Logout Status = " + aRow["Message"]);
            }

            // Enter Admin Screen Procedure 
            DataSet Enter = enterAdmin("TestOne");
            foreach (DataRow aRow in Enter.Tables[0].Rows)
            {
                Console.WriteLine("Admin Status = " + aRow["Message"]);
            }

            // Admin Kill Game Procedure
            DataSet Kill = killGame("100001", "TestOne");
            foreach (DataRow aRow in Kill.Tables[0].Rows)
            {
                Console.WriteLine("Kill Game Status = " + aRow["Message"]);
            }

            // Admin Add Player Procedure
            DataSet Add = addPlayer("Bob", "test2@gmail.com", "TestTwo", "P@ssword1", "1");
            foreach (DataRow aRow in Add.Tables[0].Rows)
            {
                Console.WriteLine("Add Player Status = " + aRow["Message"]);
            }

            // Admin Update Player Procedure
            DataSet Update = updatePlayer("Bob", "17", "test2@gmail.com", "TestTwo", "P@ssword1", "0", "1", "0", "3", "99");
            foreach (DataRow aRow in Update.Tables[0].Rows)
            {
                Console.WriteLine("Update Player Status = " + aRow["Message"]);
            }

            // Admin Delete Player Procedure
            DataSet Delete = deletePlayer("Bob", "TestTwo");
            foreach (DataRow aRow in Delete.Tables[0].Rows)
            {
                Console.WriteLine("Delete Player Status = " + aRow["Message"]);
            }
        }
    }
}
