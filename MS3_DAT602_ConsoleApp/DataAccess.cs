using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using MySql.Data.MySqlClient;

namespace ProjectWork
{
    public class DataAccess
    {
        public static string connectionString
        {
            get { return "Server=localhost;Port=3306;Database=sdghGameDatabase;Uid=root;password=P@ssword1"; }

        }

        private static MySqlConnection _mySqlConnection = null;
        public static MySqlConnection mySqlConnection
        {
            get
            {
                if (_mySqlConnection == null)
                {
                    _mySqlConnection = new MySqlConnection(connectionString);
                }

                return _mySqlConnection;

            }
        }

        public static string validatedUsername = "";
        public static string loginStatus = "";
        public static string registrationStatus = "";
        public static string addStatus = "";
        public static string upStatus = "";
        public static string adminStatus = "";
        public static string joinStatus = "";
        public static string currentGame = "";
        public static string playerMove = "";
        public static string positionNow = "";

        // New User Registration Procedure
        public void NewUserRegistration(string pEmail, string pUsername, string pPassword)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramEmail = new MySqlParameter("@Email", MySqlDbType.VarChar, 50);
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            var paramPassword = new MySqlParameter("@Password", MySqlDbType.Blob);
            paramEmail.Value = pEmail;
            paramUsername.Value = pUsername;
            paramPassword.Value = pPassword;
            paramInput.Add(paramEmail);
            paramInput.Add(paramUsername);
            paramInput.Add(paramPassword);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "NewUserRegistration(@Email,@Username,@Password)", paramInput.ToArray());
            //return (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();

            if (((aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString() == "Your account is created, let the games begin!!!"))
            {
                DataAccess.registrationStatus = "New Account";
            }
            else
            {
                DataAccess.registrationStatus = "Failed";
            }
        }

        // Login Check Credentials Procedure
        public void LoginCheckCredentials(string pUsername, string pPassword)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            var paramPassword = new MySqlParameter("@Password", MySqlDbType.Blob);
            paramUsername.Value = pUsername;
            paramPassword.Value = pPassword;
            paramInput.Add(paramUsername);
            paramInput.Add(paramPassword);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "LoginCheckCredentials(@Username,@Password)", paramInput.ToArray());

            if (((aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString() == "Success") || ((aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString() == "You are logged in"))
            {
                DataAccess.validatedUsername = pUsername;
                DataAccess.loginStatus = "Logged In";
            }
            else if ((aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString() == "You have entered an incorrect Username or Password, after 5 failed attempts your account will be locked")
            {
                DataAccess.loginStatus = "Failed";
            }
            else
            {
                DataAccess.loginStatus = "Failed";
            }
        }

        // HomeDisplay
        public HomeDisplayData HomeScreen()
        {
            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "HomeScreen()");
            HomeDisplayData theHomeDisplayData = new HomeDisplayData()
            {
                GameCount = new List<GameCount>(),
                PlayerHighScore = new List<PlayerHighScore>()
            };

            theHomeDisplayData.haveData = true;

            for (int i = 0; i < aDataSet.Tables[0].Rows.Count; i++)
            {
                theHomeDisplayData.GameCount.Add(new GameCount()
                {
                    GameID = Convert.ToInt32(aDataSet.Tables[0].Rows[i].ItemArray[0]),
                    PlayerCount = Convert.ToInt32(aDataSet.Tables[0].Rows[i].ItemArray[1])
                });
                theHomeDisplayData.PlayerHighScore.Add(new PlayerHighScore()
                {
                    Player = aDataSet.Tables[1].Rows[i].ItemArray[0].ToString(),
                    HighScore = Convert.ToInt32(aDataSet.Tables[1].Rows[i].ItemArray[1])
                });
            }
            return theHomeDisplayData;
        }

        // New Game Procedure
        public string NewGame(string pUsername)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            paramUsername.Value = pUsername;
            paramInput.Add(paramUsername);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "NewGame(@Username)", paramInput.ToArray());

            DataAccess.currentGame = (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
            return (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
        }


        // Join Game Procedure
        public void JoinGame(string pGameID, string pUsername)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramGameID = new MySqlParameter("@GameID", MySqlDbType.Int16);
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            paramGameID.Value = pGameID;
            paramUsername.Value = pUsername;
            paramInput.Add(paramGameID);
            paramInput.Add(paramUsername);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "JoinGame(@GameID,@Username)", paramInput.ToArray());

            if (((aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString() == "Youve joined the game!!!") || ((aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString() == "You are back in the game!!!"))
            {
                DataAccess.joinStatus = "Joined";
            }
            else
            {
                DataAccess.joinStatus = "Failed";
            }
        }

        // Player Moves Procedure
        public void MovePlayer(string pTileID, string pUsername, string pGameID)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramTileID = new MySqlParameter("@TileID", MySqlDbType.Int16);
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            var paramGameID = new MySqlParameter("@GameID", MySqlDbType.Int16);
            paramTileID.Value = pTileID;
            paramUsername.Value = pUsername;
            paramGameID.Value = pGameID;
            paramInput.Add(paramTileID);
            paramInput.Add(paramUsername);
            paramInput.Add(paramGameID);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "MovePlayer(@TileID,@Username,@GameID)", paramInput.ToArray());

            if ((aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString() == "Your character has moved!!!")
            {
                DataAccess.playerMove = "Yes";
            }
            else
            {
                DataAccess.playerMove = "No";
            }
        }

        // Find Gem Procedure
        public GemDisplayData FindGem(string pTileID, string pGameID)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramTileID = new MySqlParameter("@TileID", MySqlDbType.Int16);
            var paramGameID = new MySqlParameter("@GameID", MySqlDbType.Int16);
            paramTileID.Value = pTileID;
            paramGameID.Value = pGameID;
            paramInput.Add(paramTileID);
            paramInput.Add(paramGameID);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "MovePlayer(@TileID,@GameID)", paramInput.ToArray());
            GemDisplayData theGemDisplayData = new GemDisplayData()
            {
                GemSelection = new List<GemSelection>(),
            };

            theGemDisplayData.haveGem = true;

            for (int i = 0; i < aDataSet.Tables[0].Rows.Count; i++)
            {
                theGemDisplayData.GemSelection.Add(new GemSelection()
                {
                    GemType = aDataSet.Tables[1].Rows[i].ItemArray[0].ToString(),
                    Points = Convert.ToInt32(aDataSet.Tables[0].Rows[i].ItemArray[1])
                });
            }
            return theGemDisplayData;
        }

        // Select Gem & Update Turn Procedure
        public string SelectGem(string pItemID, string pPlayID, string pPlayerID, string pGameID)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramItemID = new MySqlParameter("@ItemID", MySqlDbType.Int16);
            var paramPlayID = new MySqlParameter("@PlayID", MySqlDbType.Int16);
            var paramPlayerID = new MySqlParameter("@PlayerID", MySqlDbType.Int16);
            var paramGameID = new MySqlParameter("@GameID", MySqlDbType.Int16);
            paramItemID.Value = pItemID;
            paramPlayID.Value = pPlayID;
            paramPlayerID.Value = pPlayerID;
            paramGameID.Value = pGameID;
            paramInput.Add(paramItemID);
            paramInput.Add(paramPlayID);
            paramInput.Add(paramPlayerID);
            paramInput.Add(paramGameID);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "SelectGem(@ItemID,@PlayID,@PlayerID,@GameID)", paramInput.ToArray());

            return (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
        }

        // Update High Score & End Game Procedure
        public WinnerDisplayData UpdateHS_EG(string pPlayID, string pPlayerID, string pGameID)
        {
            WinnerDisplayData theWinnerDisplayData = new WinnerDisplayData();
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramPlayID = new MySqlParameter("@PlayID", MySqlDbType.Int16);
            var paramPlayerID = new MySqlParameter("@PlayerID", MySqlDbType.Int16);
            var paramGameID = new MySqlParameter("@GameID", MySqlDbType.Int16);
            paramPlayID.Value = pPlayID;
            paramPlayerID.Value = pPlayerID;
            paramGameID.Value = pGameID;
            paramInput.Add(paramPlayID);
            paramInput.Add(paramPlayerID);
            paramInput.Add(paramGameID);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "UpdateHS_EG(@PlayID,@PlayerID,@GameID)", paramInput.ToArray());

            var aMessage = (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
            theWinnerDisplayData.message = aMessage;
            Console.WriteLine(aMessage);
            if (aMessage == "This game is over!!!")
            {
                theWinnerDisplayData.Winner = (from aResult in aDataSet.Tables[1].AsEnumerable()
                                               select
                                                   new Winner
                                                   {
                                                       CharacterName = aResult.Field<string>("CharacterName"),
                                                       PlayScore = Convert.ToInt32(aResult.ItemArray[1].ToString())
                                                   }).ToList();
                theWinnerDisplayData.haveWinner = true;

                return theWinnerDisplayData;
            }
            else
            {
                return null;
            }
        }

        // Player Logout Procedure
        public string PlayerLogout(string pUsername)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            paramUsername.Value = pUsername;
            paramInput.Add(paramUsername);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "PlayerLogout(@Username)", paramInput.ToArray());

            return (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
        }

        // Enter Admin Screen Procedure 
        public void AdminScreen(string pUsername)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            paramUsername.Value = pUsername;
            paramInput.Add(paramUsername);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "AdminScreen(@Username)", paramInput.ToArray());

            if (((aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString() == "You are logged into the admin console"))
            {
                DataAccess.adminStatus = "Success";
            }
            else //if (((aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString() == "Slow down buddy, you are not an admin user"))
            {
                DataAccess.adminStatus = "Failed";
            }
        }

        // Admin Kill Game Procedure
        public void KillGame(string pGameID)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramGameID = new MySqlParameter("@GameID", MySqlDbType.Int16);
            paramGameID.Value = pGameID;
            paramInput.Add(paramGameID);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "KillGame(@GameID)", paramInput.ToArray());
        }

        // Admin Add Player Procedure
        public string AddPlayer(string pEmail, string pUsername, string pPassword, Boolean pAccountAdmin)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramEmail = new MySqlParameter("@Email", MySqlDbType.VarChar, 50);
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            var paramPassword = new MySqlParameter("@Password", MySqlDbType.Blob);
            var paramAccountAdmin = new MySqlParameter("@AccountAdmin", MySqlDbType.Bit);
            paramEmail.Value = pEmail;
            paramUsername.Value = pUsername;
            paramPassword.Value = pPassword;
            paramAccountAdmin.Value = pAccountAdmin;
            paramInput.Add(paramEmail);
            paramInput.Add(paramUsername);
            paramInput.Add(paramPassword);
            paramInput.Add(paramAccountAdmin);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "AddPlayer(@Email,@Username,@Password,@AccountAdmin)", paramInput.ToArray());

            if (((aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString() == "Youve added a new player, yippee!!!"))
            {
                DataAccess.addStatus = "New Account";
            }
            else
            {
                DataAccess.addStatus = "Failed";
            }
            return (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
        }

        // Admin Update Player Procedure
        public string UpdatePlayer(string pEmail, string pUsername, string pPassword, Boolean pAccountAdmin, Boolean pAccountLocked, Boolean pActiveStatus, string pFailedLogins, string pHighScore)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramEmail = new MySqlParameter("@Email", MySqlDbType.VarChar, 50);
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            var paramPassword = new MySqlParameter("@Password", MySqlDbType.Blob);
            var paramAccountAdmin = new MySqlParameter("@AccountAdmin", MySqlDbType.Bit);
            var paramAccountLocked = new MySqlParameter("@AccountLocked", MySqlDbType.Bit);
            var paramActiveStatus = new MySqlParameter("@ActiveStatus", MySqlDbType.Bit);
            var paramFailedLogins = new MySqlParameter("@FailedLogins", MySqlDbType.Byte);
            var paramHighScore = new MySqlParameter("@HighScore", MySqlDbType.Int16);
            paramEmail.Value = pEmail;
            paramUsername.Value = pUsername;
            paramPassword.Value = pPassword;
            paramAccountAdmin.Value = pAccountAdmin;
            paramAccountLocked.Value = pAccountLocked;
            paramActiveStatus.Value = pActiveStatus;
            paramFailedLogins.Value = pFailedLogins;
            paramHighScore.Value = pHighScore;
            paramInput.Add(paramEmail);
            paramInput.Add(paramUsername);
            paramInput.Add(paramPassword);
            paramInput.Add(paramAccountAdmin);
            paramInput.Add(paramAccountLocked);
            paramInput.Add(paramActiveStatus);
            paramInput.Add(paramFailedLogins);
            paramInput.Add(paramHighScore);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "UpdatePlayer(@Email,@Username,@Password,@AccountAdmin,@AccountLocked,@ActiveStatus,@FailedLogins,@HighScore)", paramInput.ToArray());

            if (((aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString() == "Yay! Youve updated the player"))
            {
                DataAccess.upStatus = "Updated Account";
            }
            else
            {
                DataAccess.upStatus = "Failed";
            }
            return (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
        }


        // Admin Delete Player Procedure
        public void DeletePlayer(string pUsername)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            paramUsername.Value = pUsername;
            paramInput.Add(paramUsername);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "DeletePlayer(@Username)", paramInput.ToArray());

            //return (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
        }
    }
}
