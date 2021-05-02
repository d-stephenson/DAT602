-- Seven Dwarfs Gem Hunt Project Transactional SQL Milestone 2

-- --------------------------------------------------------------------------------
-- Database Use
-- --------------------------------------------------------------------------------

USE sdghGameDatabase;
SELECT `user`, `host` FROM mysql.user;

CREATE USER IF NOT EXISTS 'databaseAdmin'@'localhost' IDENTIFIED BY '007';
CREATE USER IF NOT EXISTS 'databaseAccess'@'localhost' IDENTIFIED BY 'MP';

SHOW GRANTS FOR 'databaseAdmin'@'localhost';
SHOW GRANTS FOR 'databaseAccess'@'localhost';

GRANT SELECT, UPDATE, DELETE, INSERT
ON sdghGameDatabase.tblPlayer
TO 'databaseAdmin'@'localhost';

GRANT SELECT
ON sdghGameDatabase.tblPlayer
TO 'databaseAccess'@'localhost';

-- ----------------------------------------------------------------------------------
-- Call Create, Insert Procedures
-- ----------------------------------------------------------------------------------

CALL CreateTables;
CALL InsertTables;

-- --------------------------------------------------------------------------------
-- New User Registration Procedure
-- --------------------------------------------------------------------------------

-- The database contains a constraint that only allows unique values to be allocated to Email and Username, should 
-- a new user attempt to register with either value found to exist the procedure will not run. Otherwise, the procedure 
-- requires a user to enter an email, username and password, the remaining fields are created as the defaults, the 
-- procedure gives new players the ability to register an account.

DELIMITER //
DROP PROCEDURE IF EXISTS newUserRegistration;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE newUserRegistration(
    IN pEmail varchar(50), 
    IN pUsername varchar(10),
    IN pPassword BLOB
    )
SQL SECURITY INVOKER
BEGIN
	DECLARE newSalt varchar(36);
	
	SELECT UUID() INTO newSalt;
	
	INSERT INTO tblPlayer(Email, Username, `Password`, Salt) 
	VALUES (pEmail, pUsername, AES_ENCRYPT(CONCAT(newSalt, pPassword), 'Game_Key_To_Encrypt'), newSalt);
END //
DELIMITER ;

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL newUserRegistration('NewUser_1@gmail.com', 'NewUser_1', 'P@ssword1'); -- Run test with these login credentials

-- Add these users so there are enough players to make a full game
CALL newUserRegistration('NewUser_2@gmail.com', 'NewUser_2', 'P@ssword1');
CALL newUserRegistration('NewUser_3@gmail.com', 'NewUser_3', 'P@ssword1');
CALL newUserRegistration('NewUser_4@gmail.com', 'NewUser_4', 'P@ssword1');
CALL newUserRegistration('NewUser_5@gmail.com', 'NewUser_5', 'P@ssword1');
CALL newUserRegistration('NewUser_6@gmail.com', 'NewUser_6', 'P@ssword1');
CALL newUserRegistration('NewUser_7@gmail.com', 'NewUser_7', 'P@ssword1');

-- Run test to check user has been added to database
SELECT * FROM tblPlayer WHERE Username = 'NewUser_1'; 

-- --------------------------------------------------------------------------------
-- Login Check Credentials Procedure
-- --------------------------------------------------------------------------------

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
    FROM 
		tblPlayer
	WHERE
		Username = pUsername
	INTO retrieveSalt; -- Retrieves the users SALT record 
    
	SELECT PlayerID
	FROM 
		tblPlayer
	WHERE
		AES_ENCRYPT(CONCAT(retrieveSalt, pPassword), 'Game_Key_To_Encrypt') = `Password` AND pUsername = Username
	INTO proposedUID; -- Retrieves the users Username and Password

	SELECT ActiveStatus
	FROM 
		tblPlayer
	WHERE
		Username = pUsername
	INTO currentAS;
    
    IF proposedUID IS NULL AND currentAS = 0 THEN 
		UPDATE tblPlayer
		SET FailedLogins = FailedLogins +1, AccountLocked = (FailedLogins +1) > 5, ActiveStatus = (FailedLogins +1) < 1
        WHERE Username = pUsername;
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'You have entered an incorrect Username or Password, after 5 failed attempts your account will be locked'; -- Increments the failed logins, if it equals 5 then account is locked
	ELSEIF proposedUID IS NOT NULL AND currentAS = 0 THEN
		UPDATE tblPlayer
        SET ActiveStatus = 1, FailedLogins = 0, AccountLocked = 0
        WHERE Username = pUsername; -- If credentials are correct user is logged into account by setting active status to true
		SELECT PlayerID, Username, Email, HighScore, AccountAdmin FROM tblPlayer WHERE Username = pUsername;
	ELSE 
		SELECT PlayerID, Username, Email, HighScore, AccountAdmin FROM tblPlayer WHERE Username = pUsername;
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'You are already logged in'; -- Conditions are met so user is already logged in
	END IF;

END //
DELIMITER ;

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

-- Login test is based on credentials entered in registration
CALL loginCheckCredentials('NewUser_1', '@ssword1'); -- First test to see login attempt increment
CALL loginCheckCredentials('NewUser_1', '@ssword1'); -- Second test to see login attempt increment
CALL loginCheckCredentials('NewUser_1', '@ssword1'); -- Third test to see login attempt increment
CALL loginCheckCredentials('NewUser_1', '@ssword1'); -- Fourth test to see login attempt increment
CALL loginCheckCredentials('NewUser_1', '@ssword1'); -- Fifth test to see login attempt increment and account locked to true
CALL loginCheckCredentials('NewUser_1', 'P@ssword1'); -- Sixth test to see correct login attempt
CALL loginCheckCredentials('NewUser_1', 'P@ssword1'); -- Seventh test to check error message as user already logged in or test against first test

-- Login remaining new players
CALL loginCheckCredentials('NewUser_2', 'P@ssword1');
CALL loginCheckCredentials('NewUser_3', 'P@ssword1');
CALL loginCheckCredentials('NewUser_4', 'P@ssword1');
CALL loginCheckCredentials('NewUser_5', 'P@ssword1');
CALL loginCheckCredentials('NewUser_6', 'P@ssword1');
CALL loginCheckCredentials('NewUser_7', 'P@ssword1');

-- --------------------------------------------------------------------------------
-- Home Screen Display Procedure
-- --------------------------------------------------------------------------------

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
	FROM 
		tblPlayer
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

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL homeScreen('NewUser_1');

-- --------------------------------------------------------------------------------
-- New Game Procedure
-- --------------------------------------------------------------------------------

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
    
	SELECT ItemID FROM tblItem ORDER BY ItemID LIMIT 1 INTO firstItem;
	SELECT MAX(ItemID) from tblItem INTO lastItem;
	SELECT BoardType FROM tblBoard LIMIT 1 INTO chosenBoardType; -- This statement would be updated is player could choose from multiple board types
	SELECT CharacterName FROM tblCharacter WHERE CharacterName = 'Doc' INTO firstCharacter;
    SELECT TileID FROM tblTile LIMIT 1, 1 INTO excludeHomeTile;
    SELECT MAX(TileID) from tblBoardTile WHERE BoardType = chosenBoardType INTO lastTile;

    INSERT INTO tblGame(BoardType, CharacterTurn)
    VALUES (chosenBoardType, firstCharacter);
    
	SET newGameId = LAST_INSERT_ID();

	IF newGameId > 0 THEN
		INSERT INTO tblPlay(PlayerID, CharacterName, GameID)
		VALUES ((SELECT PlayerID FROM tblPlayer WHERE Username = pUsername), firstCharacter, newGameId);
    END IF;  

    WHILE firstItem <= lastItem DO 
        INSERT INTO tblItemGame(ItemID, GameID, TileID)
        VALUES (firstItem, newGameId, (SELECT FLOOR(RAND()*(lastTile-excludeHomeTile+1)+excludeHomeTile)));

        SET firstItem = firstItem + 1;
    END WHILE;
END //
DELIMITER ;

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL newGame('NewUser_1'); -- Run test with new player starting a game

-- Test new game has been created in the following tables and a play instance for the player
SELECT * from tblGame ORDER BY GameID DESC; 
SELECT * FROM tblItemGame ORDER BY GameID DESC; 
SELECT * FROM tblPlay ORDER BY GameID DESC;

-- --------------------------------------------------------------------------------
-- Join Game Procedure
-- --------------------------------------------------------------------------------

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
	FROM 
		tblCharacter 
	WHERE 
		CharacterName NOT IN (SELECT CharacterName FROM tblPlay WHERE GameID = 100003) LIMIT 1
	INTO selectedCharacter;
    
	SELECT PlayerID
	FROM 
		tblPlayer
	WHERE 
		PlayerID NOT IN (SELECT PlayerID FROM tblPlay WHERE GameID = pGameID) AND PlayerID = pPlayerID
	INTO selectedUser;
                            
    IF selectedCharacter IS NOT NULL THEN -- Prevent more then Character count of 7 joining a game                       
		INSERT INTO tblPlay(PlayerID, CharacterName, GameID)
		VALUES (selectedUser, selectedCharacter, pGameID);
	ELSEIF selectedCharacter IS NULL THEN
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'All seven dwarfs are playing this game';
	END IF;
END //
DELIMITER ;

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

SELECT * FROM tblPlay ORDER BY PlayerID DESC; -- Find a PlayerID and GameID to join player to game
CALL joinGame(100003, 10); -- Test join game procedure

-- Add remaining players 
CALL joinGame(100003, 11);
CALL joinGame(100003, 12);
CALL joinGame(100003, 13);
CALL joinGame(100003, 14);
CALL joinGame(100003, 15);

-- Test player has been added to game and has the next character
SELECT * FROM tblPlay WHERE GameID = 100003; 

-- Test no more players can joing a game
CALL joinGame(100003, 2);
SELECT * FROM tblPlay WHERE GameID = 100003; -- Test player has not been added to game

-- --------------------------------------------------------------------------------
-- Player Moves Procedure
-- --------------------------------------------------------------------------------

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
	DECLARE emptyTile int DEFAULT NULL;
	DECLARE currentTileRow tinyint DEFAULT NULL;
	DECLARE currentTileColumn tinyint DEFAULT NULL;
	DECLARE newTileRow tinyint DEFAULT NULL;
	DECLARE newTileColumn tinyint DEFAULT NULL;
    
	SELECT CharacterTurn
	FROM 
		tblGame
	WHERE 
		GameID = pGameID 
	INTO currentTurn;
	
    SELECT TileID
	FROM 
		tblTile
	WHERE 
		TileID NOT IN (SELECT TileID FROM tblPlay WHERE GameID = pGameID) AND TileID = pTileID AND HomeTile = FALSE
	INTO emptyTile;
    
    SELECT TileRow
    FROM
		tblTile ti 
        JOIN tblPlay pl ON ti.TileID = pl.TileID
	WHERE 
		PlayerID = pPlayerID AND GameID = pGameID
	INTO currentTileRow;
    
	SELECT TileColumn
    FROM
		tblTile ti 
        JOIN tblPlay pl ON ti.TileID = pl.TileID
	WHERE 
		PlayerID = pPlayerID AND GameID = pGameID
	INTO currentTileColumn;
        
	SELECT TileRow 
    FROM
		tblTile
	WHERE 
		TileID = pTileID
	INTO newTileRow;
    
	SELECT TileColumn
    FROM
		tblTile
	WHERE 
		TileID = pTileID
	INTO newTileColumn;
    
    IF ((newTileRow = currentTileRow OR newTileRow = currentTileRow + 1 OR newTileRow = currentTileRow - 1) AND 
		(newTileColumn = currentTileColumn OR newTileColumn = currentTileColumn + 1 OR newTileColumn = currentTileColumn - 1)) AND
        (emptyTile IS NOT NULL OR pTileID = 001) AND
        (currentTurn = (SELECT CharacterName FROM tblPlay WHERE PlayerID = pPlayerID AND GameID = pGameID)) THEN  
        
		UPDATE tblPlay
		SET TileID = pTileID
		WHERE PlayerID = pPlayerID AND GameID = pGameID;
            
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

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

-- Do the following checks first 
SELECT * FROM tblGame WHERE GameID = 100003; -- Confirm that next character turn is character Doc 
SELECT * FROM tblPlay WHERE GameID = 100003; -- Confirm playerID and tileID location for Doc, should be playerID 9 and tileID 1

CALL movePlayer(2, 9, 100003); -- Test procedure player cannot move to this tile
CALL movePlayer(34, 9, 100003); -- Displays tile colour and new tile row and column

-- Re-run tblPlay select query to confirm player is on a new tile location
SELECT * FROM tblPlay WHERE GameID = 100003; 

-- --------------------------------------------------------------------------------
-- Find Gem Procedure
-- --------------------------------------------------------------------------------

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
			FROM    
				tblPlay pl
				JOIN tblItemGame ig ON pl.TileID = ig.TileID AND pl.GameID = ig.GameID
				JOIN tblItem it ON ig.ItemID = it.ItemID
				JOIN tblGem ge ON it.GemType = ge.GemType  
			WHERE   
				pl.TileID = pTileID AND PlayerID = pPlayerID AND pl.GameID = pGameID;
			
IF (SELECT COUNT(ItemID) FROM tblItemGame WHERE TileID = pTileID AND GameID = pGameID) > 0 THEN

			SELECT * FROM selectOneGem;
	ELSE 
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'Sorry, there are no Gems on this tile';	
	END IF;
END //
DELIMITER ;

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL findGem(34, 9, 100003); -- Test procedure and check that gem or gems are listed against correct game, player, play instance and tile location
-- IMPORTANT: RECORD THE ITEM ID & PLAY ID FROM THE TEMPORARY TABLE FOR INSERTION IN Select Gem & Update Turn PROCEDURE AND Update Highscore & End Game PROCEDURE
-- If the error message is displayed stating there are no items on the tile, next next move procedure below will hopefully have items on the tile, 
-- if not you may have to move more players or re-run the create table and insert into procedures and start again

-- --------------------------------------------------------------------------------
-- Select Gem & Update Turn Procedure
-- --------------------------------------------------------------------------------

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
    FROM
		selectOneGem
	WHERE 
		ItemID = pItemID
	INTO gemPoints;
    
    SELECT CharacterName 
    FROM 
		tblPlay 
	WHERE 
		PlayID = (SELECT MIN(PlayID) FROM tblPlay WHERE PlayID > pPlayID AND GameID = pGameID) INTO nextTurn; 
    
	IF pItemID IS NOT NULL THEN     
		UPDATE tblItemGame
		SET TileID = NULL, PlayID = pPlayID
		WHERE ItemID = pItemID AND GameID = pGameID;

		UPDATE tblPlay
		SET PlayScore = PlayScore + gemPoints
		WHERE PlayID = pPlayID;
	END IF;

	IF nextTurn IS NOT NULL THEN
		UPDATE tblGame
		SET CharacterTurn = nextTurn
		WHERE GameID = pGameID;
	ELSEIF nextTurn IS NULL THEN
		UPDATE tblGame
		SET CharacterTurn = 'Doc'
		WHERE GameID = pGameID;
	END IF;
END //
DELIMITER ;

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL selectGem(NULL, 500007, 9, 100003); -- IMPORTANT: Amend the first input to the correct itemID and secong input to the correct playID

-- Do the following checks to confirm procedure success
SELECT * FROM tblPlay WHERE PlayerID = 9; -- Check play score has updated
SELECT * FROM tblGame WHERE GameID = 100003; -- Check character turn has updated in game table
SELECT * FROM tblItemGame WHERE GameID = 100003 AND PlayID = 500007; -- Check that item/game table has updated tile equals NULL and play equals playID

-- If there were no items on the tile move the next character turn from the above select game ID statement
-- Find out which player is the character turn 
SELECT * FROM tblPlay WHERE CharacterName = 'Bashful';
CALL movePlayer(50, 10, 100003); 
CALL findGem(50, 10, 100003);
CALL selectGem(155, 500008, 10, 100003);

-- Now we can do the check, if by chance the above second move yiilded no items find the nect character turn and do it again
SELECT * FROM tblPlay WHERE PlayerID = 10; -- Check play score has updated
SELECT * FROM tblGame WHERE GameID = 100003; -- Check character turn has updated in game table
SELECT * FROM tblItemGame WHERE GameID = 100003 AND PlayID = 500008;

-- --------------------------------------------------------------------------------
-- Update High Score & End Game Procedure
-- --------------------------------------------------------------------------------

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
    FROM
		tblPlay
	WHERE 
		PlayID = pPlayID
	INTO playerPS;
	
    SELECT HighScore
    FROM
		tblPlayer py
			JOIN tblPlay pl ON py.PlayerID = pl.PlayerID
	WHERE 
		py.PlayerID = pPlayerID
	INTO playerHS;
    
    SELECT COUNT(TileID) 
    FROM
		tblItemGame
	WHERE 
		GameID = pGameID
	INTO tileCount;

	IF playerPS > playerHS THEN 
		UPDATE tblPlayer
		SET Highscore = playerPS
		WHERE PlayerID = pPlayerID; 
	END IF;
    
    IF tileCount = 0 THEN 
		UPDATE tblGame
        SET CharacterTurn = NULL
        WHERE GameID = pGameID;
        
        SELECT pl.CharacterName, pl.PlayScore 
        FROM 
			tblPlay pl
				JOIN tblCharacter ch  ON pl.CharacterName = ch.CharacterName 
		WHERE (SELECT MAX(PlayScore) FROM tblPlay) AND GameID = pGameID;
	END IF;
END //
DELIMITER ;

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL updateHS_EG(500008, 10, 100003);

-- Check high score has updated
SELECT * FROM tblPlayer WHERE PlayerID = 10; 

-- Test the end game portion of the procedure
UPDATE tblItemGame SET TileID = NULL, PlayID = 500007 WHERE GameID = 100003; -- Update all tiles to NULL and all play instances to playID
SELECT * FROM tblItemGame WHERE GameID = 100003; -- Test select query to confirm above update

-- IMPORTANT: Amend the ItemID to the correct ID and insert correct tile item was found. Update the item to be back in the game play, re-run above query to check
UPDATE tblItemGame SET TileID = 50, PlayID = NULL WHERE ItemID = 155 AND GameID = 100003; 
CALL selectGem(155, 500008, 10, 100003); -- IMPORTANT: Amend the first input to the correct ItemID. Call selectGem procedure again
CALL updateHS(500008, 10, 100003); -- Call updateHS procedure again
SELECT * FROM tblGame WHERE GameID = 100003; -- Character turn is now set to NULL as game has finished, no more items to collect

-- Re-run select all query from item/game table to confirm tile ID are NULL and play ID relate to play instance
SELECT * FROM tblItemGame WHERE GameID = 100003; 

-- --------------------------------------------------------------------------------
-- Player Logout Procedure
-- --------------------------------------------------------------------------------

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

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL playerLogout('NewUser_1');

-- Test active status will be displayed as false
SELECT * FROM tblPlayer WHERE Username = 'NewUser_1'; 

-- --------------------------------------------------------------------------------
-- Enter Admin Screen Procedure 
-- --------------------------------------------------------------------------------

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
	FROM 
		tblPlayer
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

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

UPDATE tblPlayer SET AccountAdmin = 1 WHERE Username = 'NewUser_1'; -- Upgrade new user 1 to admin priviledges 
CALL adminScreen('NewUser_1');

-- --------------------------------------------------------------------------------
-- Admin Kill Game Procedure
-- --------------------------------------------------------------------------------

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
	FROM 
		tblPlayer
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

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL killGame(100003, 'NewUser_1'); -- Warning message will display saying game has been killed

-- Confirm game has been deleted
SELECT * FROM tblGame WHERE GameID = 100003;
SELECT * FROM tblPlay WHERE GameID = 100003;
SELECT * FROM tblItemGAme WHERE GameID = 100003;

-- --------------------------------------------------------------------------------
-- Admin Add Player Procedure
-- --------------------------------------------------------------------------------

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
	FROM 
		tblPlayer
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

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL addPlayer('NewUser_1', 'NewUser_8@gmail.com', 'NewUser_8', 'P@ssword1', 1);

-- Confirm player has been added and has admin privileges
SELECT * FROM tblPlayer WHERE Username = 'NewUser_8'; 

-- --------------------------------------------------------------------------------
-- Admin Update Player Procedure
-- --------------------------------------------------------------------------------

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
	FROM 
		tblPlayer
	WHERE
		Username = pAdminUsername 
	INTO checkAdmin;
    
	SELECT UUID() INTO newSalt;

    IF EXISTS (SELECT PlayerID FROM tblPlayer WHERE PlayerID = pPlayerID) AND checkAdmin IS TRUE THEN
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
		WHERE PlayerID = pPlayerID;
	ELSEIF EXISTS (SELECT PlayerID FROM tblPlayer WHERE PlayerID = pPlayerID) AND checkAdmin IS FALSE THEN
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'You are not an admin user';
	ELSE 
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'There is no account with this PlayerID';
	END IF;
END //
DELIMITER ;     

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL updatePlayer('NewUser_1', 16, 'NewUser_8@gmail.com', 'NewUser_8', 'P@ssword1', 1, 0, 1, 3, 456); -- Admin NewUser_ updates player NewUser_8
SELECT * FROM tblPlayer WHERE Username = 'NewUser_8'; -- Check procedure 

-- --------------------------------------------------------------------------------
-- Admin Delete Player Procedure
-- --------------------------------------------------------------------------------

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
	FROM 
		tblPlayer
	WHERE
		Username = pAdminUsername 
	INTO checkAdmin;

    IF EXISTS (SELECT Username FROM tblPlayer WHERE Username = pUsername) AND checkAdmin IS TRUE THEN 
		DELETE FROM tblPlayer 
		WHERE Username = pUsername;
	ELSEIF EXISTS (SELECT Username FROM tblPlayer WHERE Username = pUsername) AND checkAdmin IS FALSE THEN
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'You are not an admin user';
	ELSE 
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'There is no account with this Username';
	END IF;
END //
DELIMITER ;     

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL deletePlayer('NewUser_8', 'NewUser_1'); -- Delete NewUser_1 

-- Test records removed from relevant tables
SELECT * FROM tblPlayer WHERE Username = 'NewUser_1'; 
SELECT * FROM tblPlay py JOIN tblPlayer pl ON py.PlayerID = pl.PlayerID WHERE Username = 'NewUser_1'; 
SELECT * FROM tblItemGame ig JOIN tblPlay py ON ig.PlayID = py.PlayID JOIN tblPlayer pl ON py.PlayerID = pl.PlayerID WHERE Username = 'NewUser_1'; 