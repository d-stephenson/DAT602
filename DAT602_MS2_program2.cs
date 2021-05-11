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
        String connectionString = "Server=localhost;Port=3306;Database=sdghGameDatabase;Uid=databaseAdmin@localhost;password=P@ssword1;";
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

        // New Game Procedure
        private static DataSet newGame(string pUsername)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            paramUsername.Value = pUsername;
            paramInput.Add(paramUsername);

            var aDataSet = MySqlHelper.ExecuteDataset(mySqlConnection, "newGame(@Username)", paramInput.ToArray());

            return aDataSet;
        }
                
        // Join Game Procedure
        private static DataSet joinGame(string pGameID, string pPlayerID)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramGameID = new MySqlParameter("@GameID", MySqlDbType.Int);
            var paramPlayerID = new MySqlParameter("@PlayerID", MySqlDbType.Int);
            paramGameID.Value = pGameID;
            paramPlayerID.Value = pPlayerID;
            paramInput.Add(paramGameID);
            paramInput.Add(paramPlayerID);

            var aDataSet = MySqlHelper.ExecuteDataset(mySqlConnection, "joinGame(@GameID,@PlayerID)", paramInput.ToArray());

            return aDataSet;
        }
                        
        // Move Game Procedure
        private static DataSet moveGame(string pTileID, string pPlayerID, string pGameID)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramTileID = new MySqlParameter("@TileID", MySqlDbType.Int);
            var paramPlayerID = new MySqlParameter("@PlayerID", MySqlDbType.Int);
            var paramGameID = new MySqlParameter("@GameID", MySqlDbType.Int);
            paramTileID.Value = pTileID;
            paramPlayerID.Value = pPlayerID;
            paramGameID.Value = pGameID;
            paramInput.Add(paramTileID);
            paramInput.Add(paramPlayerID);
            paramInput.Add(paramGameID);

            var aDataSet = MySqlHelper.ExecuteDataset(mySqlConnection, "moveGame(@TileID,@PlayerID,@GameID)", paramInput.ToArray());

            return aDataSet;
        }
                        
        // Find Gem Procedure
        private static DataSet findGem(string pTileID, string pPlayerID, string pGameID)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramTileID = new MySqlParameter("@TileID", MySqlDbType.Int);
            var paramPlayerID = new MySqlParameter("@PlayerID", MySqlDbType.Int);
            var paramGameID = new MySqlParameter("@GameID", MySqlDbType.Int);
            paramTileID.Value = pTileID;
            paramPlayerID.Value = pPlayerID;
            paramGameID.Value = pGameID;
            paramInput.Add(paramTileID);
            paramInput.Add(paramPlayerID);
            paramInput.Add(paramGameID);

            var aDataSet = MySqlHelper.ExecuteDataset(mySqlConnection, "findGem(@TileID,@PlayerID,@GameID)", paramInput.ToArray());

            return aDataSet;
        }
                        
        // Select Gem & Update Turn Procedure
        private static DataSet gemTurn(string pItemID, string pPlayID, string pPlayerID, string pGameID)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramItemID = new MySqlParameter("@ItemID", MySqlDbType.Int);
            var paramPlayID = new MySqlParameter("@PlayID", MySqlDbType.Int);
            var paramPlayerID = new MySqlParameter("@PlayerID", MySqlDbType.Int);
            var paramGameID = new MySqlParameter("@GameID", MySqlDbType.Int);
            paramItemID.Value = pItemID;
            paramPlayID.Value = pPlayID;
            paramPlayerID.Value = pPlayerID;
            paramGameID.Value = pGameID;
            paramInput.Add(paramItemID);
            paramInput.Add(paramPlayID);
            paramInput.Add(paramPlayerID);
            paramInput.Add(paramGameID);

            var aDataSet = MySqlHelper.ExecuteDataset(mySqlConnection, "gemTurn(@ItemID,@PlayID,@PlayerID,@GameID)", paramInput.ToArray());

            return aDataSet;
        }
                        
        // Update High Score & End Game Procedure
        private static DataSet scoreEnd(string pPlayID, string pPlayerID, string pGameID)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramPlayID = new MySqlParameter("@PlayID", MySqlDbType.Int);
            var paramPlayerID = new MySqlParameter("@PlayerID", MySqlDbType.Int);
            var paramGameID = new MySqlParameter("@GameID", MySqlDbType.Int);
            paramPlayID.Value = pPlayID;
            paramPlayerID.Value = pPlayerID;
            paramGameID.Value = pGameID;
            paramInput.Add(paramPlayID);
            paramInput.Add(paramPlayerID);
            paramInput.Add(paramGameID);

            var aDataSet = MySqlHelper.ExecuteDataset(mySqlConnection, "scoreEnd(@PlayID,@PlayerID,@GameID)", paramInput.ToArray());

            return aDataSet;
        }
                        
        // Player Logout Procedure
        private static DataSet playerLogout(string pUsername)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramPlayID = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            paramUsername.Value = pUsername;
            paramInput.Add(paramUsername);

            var aDataSet = MySqlHelper.ExecuteDataset(mySqlConnection, "playerLogout(@Username)", paramInput.ToArray());

            return aDataSet;
        }
                        
        // Enter Admin Screen Procedure 
        private static DataSet enterAdmin(string pUsername)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramPlayID = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            paramUsername.Value = pUsername;
            paramInput.Add(paramUsername);

            var aDataSet = MySqlHelper.ExecuteDataset(mySqlConnection, "enterAdmin(@Username)", paramInput.ToArray());

            return aDataSet;
        }
                        
        // Admin Kill Game Procedure
        private static DataSet killGame(string pGameID, string pUsername)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramGameID = new MySqlParameter("@GameID", MySqlDbType.Int);
            var paramPlayID = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            paramGameID.Value = pGameID;
            paramUsername.Value = pUsername;
            paramInput.Add(paramGameID);
            paramInput.Add(paramUsername);

            var aDataSet = MySqlHelper.ExecuteDataset(mySqlConnection, "killGame(@GameID,@Username)", paramInput.ToArray());

            return aDataSet;
        }
                        
        // Admin Add Player Procedure
        private static DataSet addPlayer(string pAdminUsername, string pEmail, string pUsername, string pPassword, string pAccountAdmin)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramAdminUsername = new MySqlParameter("@AdminUsername", MySqlDbType.VarChar, 10);
            var paramEmail = new MySqlParameter("@Email", MySqlDbType.VarChar, 50);
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            var paramPassword = new MySqlParameter("@Password", MySqlDbType.BLOB);
            var paramAccountAdmin = new MySqlParameter("@AccountAdmin", MySqlDbType.bit);
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

            var aDataSet = MySqlHelper.ExecuteDataset(mySqlConnection, "addPlayer(@AdminUsername,@Email,@Username,@Password,@AccountAdmin)", paramInput.ToArray());

            return aDataSet;
        }
                        
        // Admin Update Player Procedure
        private static DataSet updatePlayer(string pAdminUsername, string PlayerID, string pEmail, string pUsername, string pPassword, string pAccountAdmin, string pAccountLocked, string pActiveStatus, string pFailedLogins, string pHighScore)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramAdminUsername = new MySqlParameter("@AdminUsername", MySqlDbType.VarChar, 10);
            var paramPlayerID = new MySqlParameter("@PlayerID", MySqlDbType.int);
            var paramEmail = new MySqlParameter("@Email", MySqlDbType.VarChar, 50);
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            var paramPassword = new MySqlParameter("@Password", MySqlDbType.BLOB);
            var paramAccountAdmin = new MySqlParameter("@AccountAdmin", MySqlDbType.bit);
            var paramAccountLocked = new MySqlParameter("@AccountLocked", MySqlDbType.bit);
            var paramActiveStatus = new MySqlParameter("@ActiveStatus", MySqlDbType.bit);
            var paramFailedLogins = new MySqlParameter("@FailedLogins", MySqlDbType.tinyint);
            var paramHighScore = new MySqlParameter("@HighScore", MySqlDbType.int);
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

            var aDataSet = MySqlHelper.ExecuteDataset(mySqlConnection, "updatePlayer(@AdminUsername,@PlayerID,@Email,@Username,@Password,@AccountAdmin,@AccountLocked,@ActiveStatus,@FailedLogins,@HighScore)", paramInput.ToArray());

            return aDataSet;
        }

                        
        // Admin Delete Player Procedure
        private static DataSet deletePlayer(string pAdminUsername, string pUsername)
        {
            List<MySqlParameter> paramInput = new List<MySqlParameter>();
            var paramAdminUsername = new MySqlParameter("@AdminUsername", MySqlDbType.VarChar, 10);
            var paramUsername = new MySqlParameter("@Username", MySqlDbType.VarChar, 10);
            paramAdminUsername.Value = pAdminUsername;
            paramUsername.Value = pUsername;   
            paramInput.Add(paramAdminUsername);
            paramInput.Add(paramUsername);

            var aDataSet = MySqlHelper.ExecuteDataset(mySqlConnection, "deletePlayer(@AdminUsername,@Username)", paramInput.ToArray());

            return aDataSet;
        }
    }
}
