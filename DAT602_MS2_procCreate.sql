-- Seven Dwarfs Gem Hunt Project Transactional SQL Milestone 2
-- Create Procedures

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Database Use
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

USE sdghGameDatabase;
SELECT `user`, `host` FROM mysql.user;

CREATE USER IF NOT EXISTS 'superAdmin'@'localhost' IDENTIFIED BY 'P@ssword1';
CREATE USER IF NOT EXISTS 'databaseAdmin'@'localhost' IDENTIFIED BY 'P@ssword1';
CREATE USER IF NOT EXISTS 'databaseAccess'@'localhost' IDENTIFIED BY 'P@ssword1';

FLUSH PRIVILEGES;

GRANT ALL PRIVILEGES
ON sdghGameDatabase
TO 'superAdmin'@'localhost' WITH GRANT OPTION;

GRANT CREATE, DROP, SELECT, UPDATE, DELETE, INSERT
ON sdghGameDatabase.tblPlayer
TO 'databaseAdmin'@'localhost';

GRANT EXECUTE 
ON PROCEDURE newUserRegistration
TO 'databaseAdmin'@'localhost';

GRANT SELECT
ON sdghGameDatabase.tblPlayer
TO 'databaseAccess'@'localhost';

SHOW GRANTS FOR 'superAdmin'@'localhost';
SHOW GRANTS FOR 'databaseAdmin'@'localhost';
SHOW GRANTS FOR 'databaseAccess'@'localhost';
SHOW GRANTS FOR 'root'@'localhost';

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Call Create, Insert Procedures from DAT601_MS1_game.sql
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	-- Re-run CreateTables and InsertTables from DAT601_MS1_game.sql as changes have been made to facilitate these procedures

	CALL CreateTables;
	ALTER TABLE tblPlayer ENCRYPTION='Y'; -- Encrypt Player table
	CALL InsertTables;
	
    -- Check table is encrypted
	SELECT TABLE_SCHEMA, TABLE_NAME, CREATE_OPTIONS 
    FROM INFORMATION_SCHEMA.TABLES
	WHERE CREATE_OPTIONS LIKE '%ENCRYPTION%';

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- New User Registration Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- The database contains a constraint that only allows unique values to be allocated to Email and Username, should 
-- a new user attempt to register with either value found to exist the procedure will not run. Otherwise, the procedure 
-- requires a user to enter an email, username and password, the remaining fields are created as the defaults, the 
-- procedure gives new players the ability to register an account.

DELIMITER //
DROP PROCEDURE IF EXISTS newUserRegistration;
CREATE DEFINER = 'databaseAdmin'@'localhost' PROCEDURE newUserRegistration(
		IN pEmail varchar(50), 
		IN pUsername varchar(10),
		IN pPassword BLOB
    )
SQL SECURITY DEFINER

BEGIN
	DECLARE newSalt varchar(36);
	
	SELECT UUID() INTO newSalt;
	
	INSERT INTO tblPlayer(Email, Username, `Password`, Salt) 
	VALUES (pEmail, pUsername, AES_ENCRYPT(CONCAT(newSalt, pPassword), 'Game_Key_To_Encrypt'), newSalt);
END //
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Login Check Credentials Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- This procedure allows a user to log in to the game, it retrieves the users salt record to ensure the password is 
-- passed correctly and the users active status to ensure they are not already logged in. If the user is logged in 
-- their details are displayed and a message is passed stating their active status. If an incorrect username or password 
-- is entered and an error message is returned. 

DELIMITER //
DROP PROCEDURE IF EXISTS loginCheckCredentials;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE loginCheckCredentials(
		IN pUsername varchar(50), 
		IN pPassword BLOB
    )
SQL SECURITY INVOKER

BEGIN
	DECLARE retrieveSalt varchar(36) DEFAULT NULL;
	DECLARE proposedUID int DEFAULT NULL;
	DECLARE currentAS bit DEFAULT NULL;
          
    SELECT Salt
    FROM tblPlayer
	WHERE
		Username = pUsername
	INTO retrieveSalt; -- Retrieves the users SALT record 
    
	SELECT PlayerID
	FROM tblPlayer
	WHERE
		AES_ENCRYPT(CONCAT(retrieveSalt, pPassword), 'Game_Key_To_Encrypt') = `Password` 
        AND pUsername = Username
	INTO proposedUID; -- Retrieves the users Username and Password

	SELECT ActiveStatus
	FROM tblPlayer
	WHERE
		Username = pUsername
	INTO currentAS;
    
    IF proposedUID IS NULL AND currentAS = 0 THEN 
		UPDATE tblPlayer
		SET FailedLogins = FailedLogins +1, AccountLocked = (FailedLogins +1) > 5, ActiveStatus = (FailedLogins +1) < 1
        WHERE 
			Username = pUsername;
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'You have entered an incorrect Username or Password, after 5 failed attempts your account will be locked'; 
        -- Increments the failed logins, if it equals 5 then account is locked
	ELSEIF proposedUID IS NOT NULL AND currentAS = 0 THEN
		UPDATE tblPlayer
        SET ActiveStatus = 1, FailedLogins = 0, AccountLocked = 0
        WHERE 
			Username = pUsername; 
		-- If credentials are correct user is logged into account by setting active status to true
	ELSE 
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'You are already logged in'; 
        -- Conditions are met so user is already logged in
	END IF;
END //
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Home Screen Display Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Two select statements make up the procedure and have been designed with thought given to the end GUI, should a 
-- login attempt be successful, which is further check by selecting the active status of the user, then the relevant 
-- information as described in the storyboarding is displayed. 

DELIMITER //
DROP PROCEDURE IF EXISTS homeScreen;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE homeScreen(
		IN pUsername varchar(10)
    )
SQL SECURITY INVOKER

BEGIN
    DECLARE accessScreen bit DEFAULT NULL;
  
	SELECT ActiveStatus 
	FROM tblPlayer
	WHERE
		Username = pUsername 
	INTO accessScreen;

    IF accessScreen IS TRUE THEN
        SELECT GameID AS 'Game ID', COUNT(pl.GameID) AS 'Player Count'
        FROM tblPlayer py 
            JOIN tblPlay pl ON py.PlayerID = pl.PlayerID
        GROUP BY pl.GameID;  
        
		SELECT Username AS 'Player', HighScore AS 'High Score' 
		FROM tblPlayer;  
	END IF;
END //
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- New Game Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- The new game procedure must create a new game in the game, which includes an autoincrement ID, a new play instance 
-- for the player that creates the new game and a new item list associated with the game in the item/game table. The 
-- play table and item/game table must pull in the newly created game ID, this is achieved by declaring the new game ID 
-- with the LAST_INSERT_ID() function. Finally, the items are allocated to tiles within the game, this is done randomly 
-- so each game is different to the last.

DELIMITER //
DROP PROCEDURE IF EXISTS newGame;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE newGame(
        IN pUsername varchar(10)
    )
SQL SECURITY INVOKER

BEGIN
	DECLARE firstItem int DEFAULT NULL;
	DECLARE lastItem int DEFAULT NULL;
	DECLARE chosenBoardType varchar(20) DEFAULT NULL; -- More boards may be added in the future so player would want to select board type
	DECLARE firstCharacter varchar(10) DEFAULT NULL;
    DECLARE excludeHomeTile int DEFAULT NULL;
    DECLARE lastTile int DEFAULT NULL;
	DECLARE newGameId int DEFAULT NULL;
    
	SELECT ItemID 
    FROM tblItem 
		ORDER BY ItemID LIMIT 1 
    INTO firstItem;
    
	SELECT MAX(ItemID) 
    FROM tblItem 
    INTO lastItem;
    
	SELECT BoardType 
    FROM tblBoard LIMIT 1 
    INTO chosenBoardType; -- This statement would be updated is player could choose from multiple board types
    
	SELECT CharacterName 
    FROM tblCharacter 
    WHERE 
		CharacterName = 'Doc' 
	INTO firstCharacter;
    
    SELECT TileID 
    FROM tblTile LIMIT 1, 1 
    INTO excludeHomeTile;
    
    SELECT MAX(TileID) 
    FROM tblBoardTile 
    WHERE 
		BoardType = chosenBoardType 
	INTO lastTile;

    INSERT INTO tblGame(BoardType, CharacterTurn)
    VALUES (chosenBoardType, firstCharacter);
    
	SET newGameId = LAST_INSERT_ID();

	IF newGameId > 0 THEN
		INSERT INTO tblPlay(PlayerID, CharacterName, GameID)
		VALUES ((SELECT PlayerID 
				 FROM tblPlayer 
                 WHERE 
					Username = pUsername), firstCharacter, newGameId);
    END IF;  

    WHILE firstItem <= lastItem DO 
        INSERT INTO tblItemGame(ItemID, GameID, TileID)
        VALUES (firstItem, newGameId, (SELECT FLOOR(RAND()*(lastTile-excludeHomeTile+1)+excludeHomeTile)));

        SET firstItem = firstItem + 1;
    END WHILE;
END //
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Join Game Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- When a player joins a new game, the next available character is selected, a play instance is created that is 
-- assigned to the game with the character and the player ID. If all seven dwarf characters are playing in the game, 
-- then an error message is displayed.

DELIMITER //
DROP PROCEDURE IF EXISTS joinGame;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE joinGame(
        IN pGameID int,
        IN pPlayerID int
    )
SQL SECURITY INVOKER

BEGIN
    DECLARE selectedCharacter varchar(10) DEFAULT NULL;
	DECLARE selectedUser int DEFAULT NULL;

	SELECT CharacterName
	FROM tblCharacter 
	WHERE 
		CharacterName NOT IN (SELECT CharacterName 
							  FROM tblPlay 
                              WHERE 
								GameID = pGameID) LIMIT 1
	INTO selectedCharacter;
    
	SELECT PlayerID
	FROM tblPlayer
	WHERE 
		PlayerID NOT IN (SELECT PlayerID 
						 FROM tblPlay 
                         WHERE 
							GameID = pGameID) 
                            AND PlayerID = pPlayerID
	INTO selectedUser;
                          
    IF selectedCharacter IS NOT NULL AND selectedUser IS NOT NULL THEN -- Prevents more then Character count of 7 joining a game and prevents update from happening if player re-joining the game                      
		INSERT INTO tblPlay(PlayerID, CharacterName, GameID)
		VALUES (selectedUser, selectedCharacter, pGameID);
		SELECT * 
        FROM tblPlay 
        WHERE 
			GameID = pGameID;
	ELSEIF selectedCharacter IS NOT NULL AND selectedUser IS NULL THEN
		SELECT * 
        FROM tblPlay 
        WHERE 
			GameID = pGameID;
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'You are back in the game';
	ELSE 
		SELECT * 
        FROM tblPlay 
        WHERE 
			GameID = pGameID;
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'All seven dwarfs are playing this game';
	END IF;
END //
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Player Moves Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- The procedure moves a player to a new tile if the tile is plus or minus one from the player's current tile position 
-- in a game instance, the play table records the current player's position. If a player is already on the tile, except 
-- for the home tile, then the player cannot move to it and an error message is displayed. Likewise, if a player selects 
-- a tile that is not plus or minus one adjacent from the current tile an error message is displayed. 

DELIMITER //
DROP PROCEDURE IF EXISTS movePlayer;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE movePlayer(
        IN pTileID int,
        IN pPlayerID int,
        IN pGameID int
    )
SQL SECURITY INVOKER

BEGIN
	DECLARE currentTurn varchar(10) DEFAULT NULL;
	DECLARE availableTile int DEFAULT NULL;
    DECLARE ifPlayerOnTileAreTheyActive bit DEFAULT NULL;
	DECLARE currentTileRow tinyint DEFAULT NULL;
	DECLARE currentTileColumn tinyint DEFAULT NULL;
	DECLARE newTileRow tinyint DEFAULT NULL;
	DECLARE newTileColumn tinyint DEFAULT NULL;
    
	SELECT CharacterTurn -- Checks the character turn for the game
	FROM tblGame
	WHERE 
		GameID = pGameID 
	INTO currentTurn;
    
	SELECT TileID -- Checks if a tile is empty and available
	FROM tblTile
	WHERE 
		TileID NOT IN (SELECT TileID 
					   FROM tblPlay 
                       WHERE 
							GameID = pGameID) 
							AND TileID = pTileID
							AND HomeTile = FALSE 
	INTO availableTile; 
    
	SELECT ActiveStatus -- Checks the active status if a player is on the tile selected
    FROM tblPlayer pl
		JOIN tblPlay py ON pl.PlayerID = py.PlayerID
	WHERE 
		py.TileID = pTileID
		AND GameID = pGameID
    INTO ifPlayerOnTileAreTheyActive; -- This allows player to move to a tile with another player located but the active status is 0

    SELECT TileRow -- The current player tile row
    FROM tblTile ti 
        JOIN tblPlay pl ON ti.TileID = pl.TileID
	WHERE 
		PlayerID = pPlayerID 
        AND GameID = pGameID
	INTO currentTileRow;
    
	SELECT TileColumn -- The current player tile column
    FROM tblTile ti 
        JOIN tblPlay pl ON ti.TileID = pl.TileID
	WHERE 
		PlayerID = pPlayerID 
        AND GameID = pGameID
	INTO currentTileColumn;
        
	SELECT TileRow -- The selected tile row
    FROM tblTile
	WHERE 
		TileID = pTileID
	INTO newTileRow;
    
	SELECT TileColumn -- The selected tile column
    FROM tblTile
	WHERE 
		TileID = pTileID
	INTO newTileColumn;
    
    IF ((newTileRow = currentTileRow OR newTileRow = currentTileRow + 1 OR newTileRow = currentTileRow - 1) 
		AND (newTileColumn = currentTileColumn OR newTileColumn = currentTileColumn + 1 OR newTileColumn = currentTileColumn - 1)) 
        AND (availableTile IS NOT NULL OR ifPlayerOnTileAreTheyActive = 0 OR pTileID = 001) 
        AND (currentTurn = (SELECT CharacterName 
							FROM tblPlay 
							WHERE 
								PlayerID = pPlayerID 
								AND GameID = pGameID)) THEN  
		UPDATE tblPlay
		SET TileID = pTileID
		WHERE 
			PlayerID = pPlayerID 
            AND GameID = pGameID;
            
		SELECT TileColour, TileRow, TileColumn 
		FROM tblCharacter ch 
			JOIN tblPlay pl ON ch.CharacterName = pl.CharacterName
			JOIN tblTile ti ON pl.TileID = ti.TileID
		WHERE 
			PlayerID = pPlayerID;
	ELSE
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'You cannot move to this tile';
	END IF;
END //
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Find Gem Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- When a player lands on a tile this procedure will run, it displays all the items on that tile so that one can be 
-- selected by the player.

DELIMITER // 
DROP PROCEDURE IF EXISTS findGem;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE findGem(
        IN pTileID int,
        IN pPlayerID int,
        IN pGameID int
    )
SQL SECURITY INVOKER

BEGIN
	DROP TEMPORARY TABLE IF EXISTS selectOneGem;
	CREATE TEMPORARY TABLE selectOneGem AS
		SELECT ig.ItemID, ge.GemType, Points, pl.GameID, pl.PlayerID, pl.PlayID, pl.TileID
		FROM tblPlay pl
			JOIN tblItemGame ig ON pl.TileID = ig.TileID 
				AND pl.GameID = ig.GameID
			JOIN tblItem it ON ig.ItemID = it.ItemID
			JOIN tblGem ge ON it.GemType = ge.GemType  
		WHERE   
			pl.TileID = pTileID 
            AND PlayerID = pPlayerID 
            AND pl.GameID = pGameID;
			
		IF (SELECT COUNT(ItemID) 
			FROM tblItemGame 
			WHERE TileID = pTileID 
            AND GameID = pGameID) > 0 THEN
				SELECT * 
                FROM selectOneGem;
		ELSE 
			SIGNAL SQLSTATE '02000'
			SET MESSAGE_TEXT = 'Sorry, there are no Gems on this tile';	
		END IF;
END //
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Select Gem & Update Turn Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- The player can select one of the items from the temporary table relating to the game instance, this selection will 
-- update the play ID of that game to the players play instance and removes the item from the tile by updating the 
-- column to NULL. The next turn is updated in the game table instance and the points are added to the players play 
-- instance total.

DELIMITER // 
DROP PROCEDURE IF EXISTS selectGem;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE selectGem(
        IN pItemID int,
        IN pPlayID int,
        IN pPlayerID int,
        IN pGameID int
    )
SQL SECURITY INVOKER

BEGIN
	DECLARE gemPoints tinyint DEFAULT NULL;
    DECLARE nextTurn varchar(10) DEFAULT NULL;
		
	SELECT Points 
    FROM selectOneGem
	WHERE 
		ItemID = pItemID
	INTO gemPoints;
    
    SELECT CharacterName 
    FROM tblPlay 
	WHERE 
		PlayID = (SELECT MIN(PlayID) 
				  FROM tblPlay 
                  WHERE 
						PlayID > pPlayID 
						AND GameID = pGameID) 
	INTO nextTurn; 
    
	IF pItemID IS NOT NULL THEN     
		UPDATE tblItemGame
		SET TileID = NULL, PlayID = pPlayID
		WHERE 
			ItemID = pItemID 
            AND GameID = pGameID;

		UPDATE tblPlay
		SET PlayScore = PlayScore + gemPoints
		WHERE 
			PlayID = pPlayID;
	END IF;

	IF nextTurn IS NOT NULL THEN
		UPDATE tblGame
		SET CharacterTurn = nextTurn
		WHERE 
			GameID = pGameID;
	ELSEIF nextTurn IS NULL THEN
		UPDATE tblGame
		SET CharacterTurn = 'Doc'
		WHERE 
			GameID = pGameID;
	END IF;
END //
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Update High Score & End Game Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- This procedure leads on from the preceding procedure and checks if the added points to the play instance total is 
-- now higher than the player's high score, if it is the player's high score is updated. The procedure then looks to 
-- determine if that item selection ends the game by identifying if there are any more items left to collect, if not 
-- then it selects the player with the highest score as the winner and updates character turn in the game table to NULL, 
-- effectively ending the game as no more turns can occur.

DELIMITER //
DROP PROCEDURE IF EXISTS updateHS_EG;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE updateHS_EG(
        IN pPlayID int,
        IN pPlayerID int,
        IN pGameID int
    )
SQL SECURITY INVOKER

BEGIN
 	DECLARE playerPS int DEFAULT NULL;
    DECLARE playerHS int DEFAULT NULL;
    DECLARE tileCount int DEFAULT NULL;
  		
	SELECT PlayScore
    FROM tblPlay
	WHERE 
		PlayID = pPlayID
	INTO playerPS;
	
    SELECT HighScore
    FROM tblPlayer py
		JOIN tblPlay pl ON py.PlayerID = pl.PlayerID
	WHERE 
		py.PlayerID = pPlayerID
	INTO playerHS;
    
    SELECT COUNT(TileID) 
    FROM tblItemGame
	WHERE 
		GameID = pGameID
	INTO tileCount;

	IF playerPS > playerHS THEN 
		UPDATE tblPlayer
		SET Highscore = playerPS
		WHERE 
			PlayerID = pPlayerID; 
	END IF;
    
    IF tileCount = 0 THEN 
		UPDATE tblGame
        SET CharacterTurn = NULL
        WHERE 
			GameID = pGameID;
        
        SELECT pl.CharacterName, pl.PlayScore 
        FROM tblPlay pl
				JOIN tblCharacter ch ON pl.CharacterName = ch.CharacterName 
		WHERE (SELECT MAX(PlayScore) 
			   FROM tblPlay) 
			   AND GameID = pGameID;
	END IF;
END //
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Player Logout Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- The logout procedure updates the players active status to false, meaning that if they want to access the game again 
-- the login procedure will check the active status and request login credentials.

DELIMITER //
DROP PROCEDURE IF EXISTS playerLogout;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE playerLogout(
        IN pUsername varchar(10)
    )
SQL SECURITY INVOKER

BEGIN
	UPDATE tblPlayer 
    SET ActiveStatus = 0
    WHERE Username = pUsername;
END //
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Enter Admin Screen Procedure 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- When admin access is requested the procedure checks if the player has admin privileges, if successful the home 
-- screen displays the relevant information that an admin would require. If the player is not an admin an error message 
-- is returned.

DELIMITER //
DROP PROCEDURE IF EXISTS adminScreen;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE adminScreen(
		IN pUsername varchar(10)
    )
SQL SECURITY INVOKER
BEGIN
    DECLARE accessAdmin bit DEFAULT NULL;
  
	SELECT AccountAdmin
	FROM tblPlayer
	WHERE
		Username = pUsername 
	INTO accessAdmin;

    IF accessAdmin IS TRUE THEN
        SELECT GameID AS 'Game ID', COUNT(pl.GameID) AS 'Player Count'
        FROM tblPlayer py 
            JOIN tblPlay pl ON py.PlayerID = pl.PlayerID
        GROUP BY pl.GameID;  
        
		SELECT Username AS 'Player', HighScore AS 'High Score' 
		FROM tblPlayer;  
	ELSE
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'You are not an admin user';
	END IF;
END //
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Admin Kill Game Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- The procedure carried out an additional check to ensure the user has admin privilege and then deletes a game and all 
-- the play instances and item/game instances associated with that game. 

DELIMITER //
DROP PROCEDURE IF EXISTS killGame;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE killGame(
		IN pGameID int,
		IN pUsername varchar(10)	
    )
SQL SECURITY INVOKER

BEGIN
    DECLARE checkAdmin bit DEFAULT NULL;
  
	SELECT AccountAdmin
	FROM tblPlayer
	WHERE
		Username = pUsername 
	INTO checkAdmin;

    IF checkAdmin IS True THEN
		DELETE FROM tblItemGame
		WHERE GameID = pGameID;
		
		DELETE FROM tblPlay
		WHERE GameID = pGameID;
		
		DELETE FROM tblGame
		WHERE GameID = pGameID;

		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'This game has been killed by Admin';
	END IF;
END //
DELIMITER ;   

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Admin Add Player Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- An admin can use this procedure to add a player, many of the inputs are set to default and as such, there is no need
-- to alter these manually for this procedure as is the case with the new registration procedure. The only feature 
-- included is for manual input of admin status as it may be useful for admin to allocate admins at this stage, further
-- changes can be made in the update player procedure.

DELIMITER //
DROP PROCEDURE IF EXISTS addPlayer;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE addPlayer(
		IN pAdminUsername varchar(10),
		IN pEmail varchar(50), 
		IN pUsername varchar(10),
		IN pPassword BLOB,
		IN pAccountAdmin bit	
    )
SQL SECURITY INVOKER

BEGIN
    DECLARE checkAdmin bit DEFAULT NULL;
	DECLARE newSalt varchar(36);
  
	SELECT AccountAdmin
	FROM tblPlayer
	WHERE
		Username = pAdminUsername 
	INTO checkAdmin;
    
	SELECT UUID() INTO newSalt;

    IF checkAdmin IS TRUE THEN
		INSERT INTO tblPlayer(Email, Username, `Password`, Salt, AccountAdmin) 
		VALUES (pEmail, pUsername, AES_ENCRYPT(CONCAT(newSalt, pPassword), 'Game_Key_To_Encrypt'), newSalt, pAccountAdmin);
	END IF;
END //
DELIMITER ;     

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Admin Update Player Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- The procedure allows an admin user to update all information pertaining to an existing player.

DELIMITER //
DROP PROCEDURE IF EXISTS updatePlayer;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE updatePlayer(
		IN pAdminUsername varchar(10),
		IN pPlayerID int,
		IN pEmail varchar(50), 
		IN pUsername varchar(10),
		IN pPassword BLOB,
		IN pAccountAdmin bit,
		IN pAccountLocked bit,
		IN pActiveStatus bit,
		IN pFailedLogins tinyint,
		IN pHighScore int 	
    )
SQL SECURITY INVOKER

BEGIN
    DECLARE checkAdmin bit DEFAULT NULL;
	DECLARE newSalt varchar(36);
  
	SELECT AccountAdmin
	FROM tblPlayer
	WHERE
		Username = pAdminUsername 
	INTO checkAdmin;
    
	SELECT UUID() INTO newSalt;

    IF EXISTS (SELECT PlayerID 
			   FROM tblPlayer 
               WHERE 
					PlayerID = pPlayerID) 
					AND checkAdmin IS TRUE THEN
		UPDATE tblPlayer
		SET Email = pEmail, 
			Username = pUsername, 
			`Password` = AES_ENCRYPT(CONCAT(newSalt, pPassword), 'Game_Key_To_Encrypt'),  
			Salt = newSalt,
			AccountAdmin = pAccountAdmin, 
			AccountLocked = pAccountLocked, 
			ActiveStatus = pActiveStatus, 
			FailedLogins = pFailedLogins, 
			HighScore = pHighScore
		WHERE 
			PlayerID = pPlayerID;
	ELSEIF EXISTS (SELECT PlayerID 
				   FROM tblPlayer 
                   WHERE 
						PlayerID = pPlayerID) 
                        AND checkAdmin IS FALSE THEN
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'You are not an admin user';
	ELSE 
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'There is no account with this PlayerID';
	END IF;
END //
DELIMITER ;     

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Admin Delete Player Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- The procedure allows an admin user to delete all information pertaining to an existing player. The procedure deletes 
-- the player record, the play instances associated with the player and any association with item records in the 
-- item/game table.

DELIMITER //
DROP PROCEDURE IF EXISTS deletePlayer;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE deletePlayer(
		IN pAdminUsername varchar(10),
		IN pUsername varchar(10)	
    )
SQL SECURITY INVOKER

BEGIN
    DECLARE checkAdmin bit DEFAULT NULL;
  
	SELECT AccountAdmin
	FROM tblPlayer
	WHERE
		Username = pAdminUsername 
	INTO checkAdmin;

    IF EXISTS (SELECT Username 
			   FROM tblPlayer 
               WHERE Username = pUsername) 
               AND checkAdmin IS TRUE THEN 
		DELETE FROM tblPlayer 
		WHERE Username = pUsername;
	ELSEIF EXISTS (SELECT Username 
				   FROM tblPlayer 
                   WHERE Username = pUsername) 
                   AND checkAdmin IS FALSE THEN
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'You are not an admin user';
	ELSE 
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'There is no account with this Username';
	END IF;
END //
DELIMITER ;     
