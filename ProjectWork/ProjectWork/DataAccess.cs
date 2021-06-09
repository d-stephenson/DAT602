using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using MySql.Data.MySqlClient;

namespace ProjectWork
{
    class DataAccess
    {
        private static string connectionString
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

        // New User Registration Procedure
        public string NewUserRegistration(string pEmail, string pUsername, string pPassword)
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

            return (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
        }

        // Login Check Credentials Procedure
        public HomeDisplayData LoginCheckCredentials(string pUsername, string pPassword)
        {
            HomeDisplayData theHomeDisplayData = new HomeDisplayData();
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            var paramPassword = new MySqlParameter("@Password", MySqlDbType.Blob);
            paramUsername.Value = pUsername;
            paramPassword.Value = pPassword;
            paramInput.Add(paramUsername);
            paramInput.Add(paramPassword);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "LoginCheckCredentials(@Username,@Password)", paramInput.ToArray());

            var aMessage = (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
            theHomeDisplayData.message = aMessage;
            Console.WriteLine(aMessage);
            if ((aMessage == "Success") || (aMessage == "You are logged in"))
            {
                theHomeDisplayData.GameCount = (from aResult in aDataSet.Tables[1].AsEnumerable()
                                                select
                                                    new GameCount
                                                    {
                                                        GameID = Convert.ToInt32(aResult.ItemArray[0].ToString()),//Field<int>("GameID"),
                                                        PlayerCount = Convert.ToInt32(aResult.ItemArray[1].ToString())//aResult.Field<int>("PlayerCount"),
                                                    }).ToList();

                theHomeDisplayData.PlayerHighScore = (from aResult in aDataSet.Tables[2].AsEnumerable()
                                                      select
                                                          new PlayerHighScore
                                                          {
                                                              Player = aResult.Field<string>("Player"),
                                                              HighScore = Convert.ToInt32(aResult.ItemArray[1].ToString())//aResult.Field<int>("HighScore"),
                                                          }).ToList();
                theHomeDisplayData.haveData = true;

                return theHomeDisplayData;
            }
            else
            {
                return null;
            }
        }

        // New Game Procedure
        public string NewGame(string pUsername)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            paramUsername.Value = pUsername;
            paramInput.Add(paramUsername);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "NewGame(@Username)", paramInput.ToArray());

            return (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
        }

        // Join Game Procedure
        public string JoinGame(string pGameID, string pPlayerID)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramGameID = new MySqlParameter("@GameID", MySqlDbType.Int16);
            var paramPlayerID = new MySqlParameter("@PlayerID", MySqlDbType.Int16);
            paramGameID.Value = pGameID;
            paramPlayerID.Value = pPlayerID;
            paramInput.Add(paramGameID);
            paramInput.Add(paramPlayerID);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "JoinGame(@GameID,@PlayerID)", paramInput.ToArray());

            return (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
        }

        // Player Moves Procedure
        public TileDisplayData MovePlayer(string pTileID, string pPlayerID, string pGameID)
        {
            TileDisplayData theTileDisplayData = new TileDisplayData();
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramTileID = new MySqlParameter("@TileID", MySqlDbType.Int16);
            var paramPlayerID = new MySqlParameter("@PlayerID", MySqlDbType.Int16);
            var paramGameID = new MySqlParameter("@GameID", MySqlDbType.Int16);
            paramTileID.Value = pTileID;
            paramPlayerID.Value = pPlayerID;
            paramGameID.Value = pGameID;
            paramInput.Add(paramTileID);
            paramInput.Add(paramPlayerID);
            paramInput.Add(paramGameID);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "MovePlayer(@TileID,@PlayerID,@GameID)", paramInput.ToArray());

            var aMessage = (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
            theTileDisplayData.message = aMessage;
            Console.WriteLine(aMessage);
            if (aMessage == "Your character has moved!!!")
            {
                theTileDisplayData.TileInfo = (from aResult in aDataSet.Tables[1].AsEnumerable()
                                               select
                                                   new TileInfo
                                                   {
                                                       TileColour = aResult.Field<string>("TileColour"),
                                                       TileRow = Convert.ToInt32(aResult.ItemArray[1].ToString()),
                                                       TileColumn = Convert.ToInt32(aResult.ItemArray[2].ToString())
                                                   }).ToList();

                theTileDisplayData.haveTile = true;

                return theTileDisplayData;
            }
            else
            {
                return null;
            }
        }

        // Find Gem Procedure
        public GemDisplayData FindGem(string pTileID, string pPlayerID, string pGameID)
        {
            GemDisplayData theGemDisplayData = new GemDisplayData();
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramTileID = new MySqlParameter("@TileID", MySqlDbType.Int16);
            var paramPlayerID = new MySqlParameter("@PlayerID", MySqlDbType.Int16);
            var paramGameID = new MySqlParameter("@GameID", MySqlDbType.Int16);
            paramTileID.Value = pTileID;
            paramPlayerID.Value = pPlayerID;
            paramGameID.Value = pGameID;
            paramInput.Add(paramTileID);
            paramInput.Add(paramPlayerID);
            paramInput.Add(paramGameID);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "FindGem(@TileID,@PlayerID,@GameID)", paramInput.ToArray());

            var aMessage = (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
            theGemDisplayData.message = aMessage;
            Console.WriteLine(aMessage);
            if (aMessage == "Youve found gems!!!")
            {
                theGemDisplayData.GemSelection = (from aResult in aDataSet.Tables[1].AsEnumerable()
                                                  select
                                                      new GemSelection
                                                      {
                                                          ItemID = Convert.ToInt32(aResult.ItemArray[0].ToString()),
                                                          GemType = aResult.Field<string>("GemType"),
                                                          Points = Convert.ToInt32(aResult.ItemArray[2].ToString()),
                                                          GameID = Convert.ToInt32(aResult.ItemArray[3].ToString()),
                                                          PlayerID = Convert.ToInt32(aResult.ItemArray[4].ToString()),
                                                          PlayID = Convert.ToInt32(aResult.ItemArray[5].ToString()),
                                                          TileID = Convert.ToInt32(aResult.ItemArray[6].ToString())
                                                      }).ToList();
                theGemDisplayData.haveGem = true;

                return theGemDisplayData;
            }
            else
            {
                return null;
            }
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
        public HomeDisplayData AdminScreen(string pUsername)
        {
            HomeDisplayData theAdminDisplayData = new HomeDisplayData();
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            paramUsername.Value = pUsername;
            paramInput.Add(paramUsername);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "AdminScreen(@Username)", paramInput.ToArray());

            var aMessage = (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
            theAdminDisplayData.message = aMessage;
            Console.WriteLine(aMessage);
            if (aMessage == "You are logged into the admin console")
            {
                theAdminDisplayData.GameCount = (from aResult in aDataSet.Tables[1].AsEnumerable()
                                                 select
                                                     new GameCount
                                                     {
                                                         GameID = Convert.ToInt32(aResult.ItemArray[0].ToString()),
                                                         PlayerCount = Convert.ToInt32(aResult.ItemArray[1].ToString())
                                                     }).ToList();

                theAdminDisplayData.PlayerHighScore = (from aResult in aDataSet.Tables[2].AsEnumerable()
                                                       select
                                                           new PlayerHighScore
                                                           {
                                                               Player = aResult.Field<string>("Player"),
                                                               HighScore = Convert.ToInt32(aResult.ItemArray[1].ToString())
                                                           }).ToList();
                theAdminDisplayData.haveData = true;

                return theAdminDisplayData;
            }
            else
            {
                return null;
            }
        }

        // Admin Kill Game Procedure
        public string KillGame(string pGameID, string pUsername)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramGameID = new MySqlParameter("@GameID", MySqlDbType.Int16);
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            paramGameID.Value = pGameID;
            paramUsername.Value = pUsername;
            paramInput.Add(paramGameID);
            paramInput.Add(paramUsername);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "KillGame(@GameID,@Username)", paramInput.ToArray());

            return (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
        }

        // Admin Add Player Procedure
        public string AddPlayer(string pAdminUsername, string pEmail, string pUsername, string pPassword, string pAccountAdmin)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramAdminUsername = new MySqlParameter("@AdminUsername", MySqlDbType.VarChar, 10);
            var paramEmail = new MySqlParameter("@Email", MySqlDbType.VarChar, 50);
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            var paramPassword = new MySqlParameter("@Password", MySqlDbType.Blob);
            var paramAccountAdmin = new MySqlParameter("@AccountAdmin", MySqlDbType.Bit);
            paramAdminUsername.Value = pAdminUsername;
            paramEmail.Value = pEmail;
            paramUsername.Value = pUsername;
            paramPassword.Value = pPassword;
            paramAccountAdmin.Value = pAccountAdmin;
            paramInput.Add(paramAdminUsername);
            paramInput.Add(paramEmail);
            paramInput.Add(paramUsername);
            paramInput.Add(paramPassword);
            paramInput.Add(paramAccountAdmin);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "AddPlayer(@AdminUsername,@Email,@Username,@Password,@AccountAdmin)", paramInput.ToArray());

            return (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
        }

        // Admin Update Player Procedure
        public string UpdatePlayer(string pAdminUsername, string pPlayerID, string pEmail, string pUsername, string pPassword, string pAccountAdmin, string pAccountLocked, string pActiveStatus, string pFailedLogins, string pHighScore)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramAdminUsername = new MySqlParameter("@AdminUsername", MySqlDbType.VarChar, 10);
            var paramPlayerID = new MySqlParameter("@PlayerID", MySqlDbType.Int16);
            var paramEmail = new MySqlParameter("@Email", MySqlDbType.VarChar, 50);
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            var paramPassword = new MySqlParameter("@Password", MySqlDbType.Blob);
            var paramAccountAdmin = new MySqlParameter("@AccountAdmin", MySqlDbType.Bit);
            var paramAccountLocked = new MySqlParameter("@AccountLocked", MySqlDbType.Bit);
            var paramActiveStatus = new MySqlParameter("@ActiveStatus", MySqlDbType.Bit);
            var paramFailedLogins = new MySqlParameter("@FailedLogins", MySqlDbType.Byte);
            var paramHighScore = new MySqlParameter("@HighScore", MySqlDbType.Int16);
            paramAdminUsername.Value = pAdminUsername;
            paramPlayerID.Value = pPlayerID;
            paramEmail.Value = pEmail;
            paramUsername.Value = pUsername;
            paramPassword.Value = pPassword;
            paramAccountAdmin.Value = pAccountAdmin;
            paramAccountLocked.Value = pAccountLocked;
            paramActiveStatus.Value = pActiveStatus;
            paramFailedLogins.Value = pFailedLogins;
            paramHighScore.Value = pHighScore;
            paramInput.Add(paramAdminUsername);
            paramInput.Add(paramPlayerID);
            paramInput.Add(paramEmail);
            paramInput.Add(paramUsername);
            paramInput.Add(paramPassword);
            paramInput.Add(paramAccountAdmin);
            paramInput.Add(paramAccountLocked);
            paramInput.Add(paramActiveStatus);
            paramInput.Add(paramFailedLogins);
            paramInput.Add(paramHighScore);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "UpdatePlayer(@AdminUsername,@PlayerID,@Email,@Username,@Password,@AccountAdmin,@AccountLocked,@ActiveStatus,@FailedLogins,@HighScore)", paramInput.ToArray());

            return (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
        }


        // Admin Delete Player Procedure
        public string DeletePlayer(string pAdminUsername, string pUsername)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramAdminUsername = new MySqlParameter("@AdminUsername", MySqlDbType.VarChar, 10);
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            paramAdminUsername.Value = pAdminUsername;
            paramUsername.Value = pUsername;
            paramInput.Add(paramAdminUsername);
            paramInput.Add(paramUsername);

            var aDataSet = MySqlHelper.ExecuteDataset(DataAccess.mySqlConnection, "DeletePlayer(@AdminUsername,@Username)", paramInput.ToArray());

            return (aDataSet.Tables[0].Rows[0])["MESSAGE"].ToString();
        }
    }
}
