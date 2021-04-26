-- Seven Dwarfs Gem Hunt Project Transactional SQL Milestone 2

-- --------------------------------------------------------------------------------
-- Database Use
-- --------------------------------------------------------------------------------

USE sdghGameDatabase;
SELECT `user`, `host` FROM mysql.user;

-- --------------------------------------------------------------------------------
-- Login Check Credentials Procedure
-- --------------------------------------------------------------------------------

-- Allows a user to log in to the game, it retrieves the users SALT record and active status, if the 
-- user is already logged in then or an incorrect username or password is entered then an error message
-- is returned 

DELIMITER //
DROP PROCEDURE IF EXISTS loginCheckCredentials;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE loginCheckCredentials(
    IN pUsername varchar(50), 
    IN pPassword BLOB
    )
SQL SECURITY INVOKER
BEGIN
    DECLARE proposedUID int DEFAULT NULL;
    DECLARE retrieveSalt varchar(36) DEFAULT NULL;
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
		pUsername = Username
	INTO currentAS;
     
    IF proposedUID IS NULL THEN -- add and failed logins is less then 5 so can add if failed login = 5 message this account is locked
		UPDATE tblPlayer
        SET FailedLogins = FailedLogins +1, AccountLocked = (FailedLogins +1) > 5, ActiveStatus = (FailedLogins +1) < 1
        WHERE Username = pUsername;
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'You have entered an incorrect Username or Password'; -- Increments the failed logins, if it equals 5 then account is locked
	ELSEIF proposedUID IS NOT NULL AND currentAS = 0 THEN
		UPDATE tblPlayer
        SET ActiveStatus = 1, FailedLogins = 0, AccountLocked = 0
        WHERE Username = pUsername; -- If credentials are correct logs user into account by setting atove status to true
	ELSE 
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'You are already logged in'; -- Conditions are met so user is already logged in
	END IF;
END //
DELIMITER ;

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL loginCheckCredentials('Triy103', 'P@ssword1');

-- --------------------------------------------------------------------------------
-- New User Registration Procedure
-- --------------------------------------------------------------------------------

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

CALL newUserRegistration('trip105@gmail.com', 'Trip105', 'P@ssword1');
SELECT * FROM tblPlayer;

-- --------------------------------------------------------------------------------
-- Home Screen Procedure X 2
-- --------------------------------------------------------------------------------

-- When login is successful the home screen checks the player is active and then displays the following information

DELIMITER //
DROP PROCEDURE IF EXISTS homeScreen1;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE homeScreen1(
    IN pUsername varchar(10)
    )
SQL SECURITY INVOKER
BEGIN
    DECLARE accessScreen1 bit DEFAULT NULL;
  
	SELECT ActiveStatus 
	FROM 
		tblPlayer
	WHERE
		Username = pUsername 
	INTO accessScreen1;

    IF accessScreen1 IS True THEN
        SELECT GameID AS 'Game ID', COUNT(pl.GameID) AS 'Player Count'
        FROM tblPlayer py 
            JOIN tblPlay pl ON py.PlayerID = pl.PlayerID
        GROUP BY pl.GameID;  
	END IF;
END //
DELIMITER ;

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL homeScreen1('John');

-- --------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS homeScreen2;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE homeScreen2(
    IN pUsername varchar(10)
    )
SQL SECURITY INVOKER
BEGIN
    DECLARE accessScreen2 bit DEFAULT NULL;
  
	SELECT ActiveStatus 
	FROM 
		tblPlayer
	WHERE
		Username = pUsername 
	INTO accessScreen2;

    IF accessScreen2 IS True THEN
		SELECT Username AS 'Players', HighScore AS 'High Score' 
		FROM tblPlayer;  
	END IF;
END //
DELIMITER ;

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL homeScreen2('John');

-- --------------------------------------------------------------------------------
-- New Game Procedure
-- --------------------------------------------------------------------------------

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
	DECLARE newGameId int DEFAULT NULL;
    DECLARE excludeHomeTile int DEFAULT NULL;
    DECLARE lastTile int DEFAULT NULL;

	SELECT ItemID FROM tblItem ORDER BY ItemID LIMIT 1 INTO firstItem;
	SELECT MAX(ItemID) from tblItem INTO lastItem;
	SELECT BoardType FROM tblBoard LIMIT 1 INTO chosenBoardType; -- This statement would be updated is player could choose from multiple board types
	SELECT CharacterName FROM tblCharacter WHERE CharacterName = 'Doc' INTO firstCharacter;
    SELECT TileID FROM tblTile LIMIT 1, 1 INTO excludeHomeTile;
    SELECT MAX(TileID) from tblBoardTile WHERE BoardType = chosenBoardType INTO lastItem;

    INSERT INTO tblGame(BoardType, CharacterTurn)
    VALUES (chosenBoardType, firstCharacter);
    
    SET newGameId = LAST_INSERT_ID();

	IF newGameId > 0 THEN
		INSERT INTO tblPlay(PlayerID, CharacterName, GameID)
		VALUES ((SELECT PlayerID FROM tblPlayer WHERE Username = pUsername), firstCharacter, newGameId);
    END IF;  

    WHILE firstItem < lastItem DO 
        INSERT INTO tblItemGame(ItemID, GameID, TileID)
        VALUES (firstItem, newGameId, (SELECT FLOOR(RAND()*(lastTile-excludeHomeTile+1)+excludeHomeTile)));

        SET firstItem = firstItem + 1;
    END WHILE;
END //
DELIMITER ;

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL newGame('John');
SELECT * from tblItemGame ORDER BY GameID DESC;

-- --------------------------------------------------------------------------------
-- Join Game Procedure
-- --------------------------------------------------------------------------------

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
		CharacterName NOT IN (SELECT CharacterName FROM tblPlay WHERE GameID = pGameID) ORDER BY RAND() LIMIT 1
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
	END IF;
END //
DELIMITER ;

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL joinGame(100001, 8);
SELECT * FROM tblPlay WHERE GameID = 100001;

-- --------------------------------------------------------------------------------
-- Player Moves Procedure
-- --------------------------------------------------------------------------------

-- Moves player to a new tile if the tile is plus or minus one, from the players current tile position 
-- in a game instance, the play table records the current players position

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
        emptyTile IS NOT NULL AND
        currentTurn = (SELECT CharacterName FROM tblPlay WHERE PlayerID = pPlayerID) THEN                        
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

CALL movePlayer(76, 1, 100001);
SELECT * FROM tblPlay WHERE GameID = 100001;
SELECT * FROM tblGame WHERE GameID = 100001;

-- --------------------------------------------------------------------------------
-- Find Gem Procedure
-- --------------------------------------------------------------------------------

-- Finds all the gems located on a tile in a game instance that the player has selected

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
        SELECT ig.ItemID, ge.GemType, Points, pl.GameID, pl.PlayerID, pl.PlayID
        FROM    
            tblPlay pl
            JOIN tblItemGame ig ON pl.TileID = ig.TileID AND pl.GameID = ig.GameID
            JOIN tblItem it ON ig.ItemID = it.ItemID
            JOIN tblGem ge ON it.GemType = ge.GemType  
        WHERE   
            PlayerID = pPlayerID AND pl.GameID = pGameID AND pl.TileID = pTileID;
END //
DELIMITER ;

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL findGem(80, 4, 100001);
SELECT * FROM selectOneGem;

-- --------------------------------------------------------------------------------
-- Select Gem & Update Turn Procedure
-- --------------------------------------------------------------------------------

-- Player selects one of the items from the temporary table relating to the game instance and assigns the 
-- item to the players play instance and removes the item from the tile, the next turn is updated in the 
-- Game instance and the points are added to the players play instance total

DELIMITER // 
DROP PROCEDURE IF EXISTS selectGem;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE selectGem(
        IN pItemID int,
        IN pPlayID int,
        IN pGameID int,
        IN pPlayerID int
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
		PlayID = (select min(PlayID) from tblPlay where PlayID > pPlayID AND GameID = pGameID) INTO nextTurn;
    
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

CALL selectGem(166, 500002, 100001, 4);

-- --------------------------------------------------------------------------------

						-- Test procedure 

						update tblitemgame set tileid = 80, playid = null where itemid = 166;

						select * FROM tblItemGame where itemID = 166; 
						select * from tblPlay where gameid = 100001;
						select * from tblPlayer where playerid = 4;
						select * from tblGame where gameid = 100001;

						-- DECLARE startTurn varchar(10) DEFAULT NULL;
						-- SELECT CharacterName FROM tblPlay WHERE PlayID = (select min(PlayID) from tblPlay where PlayID < 500001 AND GameID = 100001) INTO nextTurn;

-- --------------------------------------------------------------------------------
-- Update Highscore & End Game Procedure
-- --------------------------------------------------------------------------------

-- Checks if the added points to the play instance is now higher then the players highscore, if it is
-- the players highscore is updated. Identifies if any more items left to collect, then selects player 
-- with the highest score as winner and updates character turn in game to NULL 

DELIMITER //
DROP PROCEDURE IF EXISTS updateHS;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE updateHS(
        IN pPlayID int,
        IN pGameID int,
        IN pPlayerID int
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
        
        SELECT CharacterName 
        FROM 
			tblCharacter ch 
				JOIN tblPlay pl ON ch.CharacterName = pl.CharacterName
		WHERE (SELECT MAX(PlayScore) FROM tblPlay WHERE GameID = pGameID);
	END IF;
END //
DELIMITER ;

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL updateHS(500002, 100001, 4);

-- --------------------------------------------------------------------------------
-- Player Logout Procedure
-- --------------------------------------------------------------------------------

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

CALL playerLogout('Trip103');

-- --------------------------------------------------------------------------------
-- Enter Admin Procedure X 2
-- --------------------------------------------------------------------------------

-- When login is successful the home screen checks the player is active and then displays the following information

DELIMITER //
DROP PROCEDURE IF EXISTS adminScreen1;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE adminScreen1(
    IN pUsername varchar(10)
    )
SQL SECURITY INVOKER
BEGIN
    DECLARE accessAdmin1 bit DEFAULT NULL;
  
	SELECT AccountAdmin
	FROM 
		tblPlayer
	WHERE
		Username = pUsername 
	INTO accessAdmin1;

    IF accessAdmin1 IS True THEN
        SELECT GameID AS 'Game ID', COUNT(pl.GameID) AS 'Player Count'
        FROM tblPlayer py 
            JOIN tblPlay pl ON py.PlayerID = pl.PlayerID
        GROUP BY pl.GameID;  
	ELSE
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'You are not an admin user';
	END IF;
END //
DELIMITER ;

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL adminScreen1('Trip103');

-- --------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS adminScreen2;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE adminScreen2(
    IN pUsername varchar(10)
    )
SQL SECURITY INVOKER
BEGIN
    DECLARE accessAdmin2 bit DEFAULT NULL;
  
	SELECT AccountAdmin
	FROM 
		tblPlayer
	WHERE
		Username = pUsername 
	INTO accessAdmin2;

    IF accessAdmin2 IS True THEN
		SELECT Username AS 'Players', HighScore AS 'High Score' 
		FROM tblPlayer;  
	ELSE
		SIGNAL SQLSTATE '02000'
		SET MESSAGE_TEXT = 'You are not an admin user';
	END IF;
END //
DELIMITER ;

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL adminScreen2('John');

-- --------------------------------------------------------------------------------
-- Admin Kill Game Procedure
-- --------------------------------------------------------------------------------

-- Deletes a game and all the play instances and item instances associated with that game 

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

CALL killGame(100002, 'John');

-- --------------------------------------------------------------------------------
-- Admin Add Player Procedure
-- --------------------------------------------------------------------------------

-- Adds a player, many of the inputs are set to default and no need to alter for this procedure 
-- over and above the new registration procedure, expect for admin status as it may be useful

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

    IF checkAdmin IS True THEN
		INSERT INTO tblPlayer(Email, Username, `Password`, Salt, AccountAdmin) 
		VALUES (pEmail, pUsername, AES_ENCRYPT(CONCAT(newSalt, pPassword), 'Game_Key_To_Encrypt'), newSalt, pAccountAdmin);
	END IF;
END //
DELIMITER ;     

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL addPlayer('John', 'treetop@gmail.com', 'Treetop987', 'P@ssword1', 1);

-- --------------------------------------------------------------------------------
-- Admin Update Player Procedure
-- --------------------------------------------------------------------------------

-- Updates all information pertaining to an exisitng player

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

CALL updatePlayer('John', 9, 'treetop987_2@gmail.com', 'John145', 'P@ssword1', 0, 0, 1, 3, 456);

-- --------------------------------------------------------------------------------
-- Admin Delete Player Procedure
-- --------------------------------------------------------------------------------

-- Delete all information pertaining to a player and their play instances

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
		DELETE py
        FROM tblPlay py
			JOIN tblPlayer pl ON py.PlayerID = pl.PlayerID
		WHERE Username = pUsername;
        
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

CALL deletePlayer('John', 'Bob');
select * from tblPlayer where username = 'Bob';
select * from tblPlay where PlayerID = 1;
