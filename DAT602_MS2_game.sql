-- Seven Dwarfs Gem Hunt Project Transactional SQL Milestone 2

-- --------------------------------------------------------------------------------
-- Database Use
-- --------------------------------------------------------------------------------

USE sdghGameDatabase;
SELECT `user`, `host` FROM mysql.user;

-- --------------------------------------------------------------------------------
-- Login Check Credentials Procedure
-- --------------------------------------------------------------------------------

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
    
    SELECT Salt
    FROM 
		tblPlayer
	WHERE
		Username = pUsername
	INTO retrieveSalt;
  
	SELECT PlayerID
	FROM 
		tblPlayer
	WHERE
		Username = pUsername AND 
		`Password` = AES_DECRYPT(CONCAT(retrieveSalt, pPassword), 'Game_Key_To_Encrypt')
	INTO proposedUID;
     
    IF proposedUID IS NULL THEN
		UPDATE tblPlayer
        SET FailedLogins = FailedLogins +1, AccountLocked = (FailedLogins +1) > 5, ActiveStatus = (FailedLogins +1) < 1
        WHERE Username = pUsername; 
	ELSEIF proposedUID IS NOT NULL THEN
		UPDATE tblPlayer
        SET ActiveStatus = 1, FailedLogins = 0, AccountLocked = 0
        WHERE Username = pUsername; 
	END IF;
END //
DELIMITER ;
-- needs a fail message if username, email or password is not found

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------
CALL loginCheckCredentials('LupFl848', 'P@ssword1');

select * from tblPlayer where username = 'LupFl848';

-- SELECT AES_DECRYPT('John', (CONCAT('dsaf5165fdg46fg4sg6-54sdfg5', 'P@ssword1'), 'Game_Key_To_Encrypt')) 

-- Test
-- SELECT ownerId, ownerPassword FROM 01_tblCompany WHERE ownerId = 'owner001' AND ownerPassword = AES_ENCRYPT('password123', UNHEX(SHA2('privateKey',512)));
-- SELECT SHA1(UNHEX(SHA1("password")));
-- SELECT AES_DECRYPT(AES_ENCRYPT('LupFl818','P@ssword1'), 'P@srd1') 
-- AES_DECRYPT(CONCAT('a7ef5e84-a499-11eb-9762-2b24369f7e99', 'P@ssword1'), 'Game_Key_To_Encrypt')
-- SELECT AES_DECRYPT((CONCAT('643b1194-a49c-11eb-9762-2b24369f7e99', 'P@ssword1'), 'Game_Key_To_Encrypt'), (CONCAT('643b1194-a49c-11eb-9762-2b24369f7e99', 'P@ssword1'), 'Game_Key_To_Encrypt'))
-- `Password` = AES_DECRYPT(AES_ENCRYPT(pUsername, (CONCAT(Salt, pPassword), 'Game_Key_To_Encrypt')), (AES_ENCRYPT(CONCAT(Salt, pPassword), 'Game_Key_To_Encrypt')))

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
    
    SELECT * FROM tblPlayer WHERE Email = pEmail AND Username = pUsername;
END //
DELIMITER ;
-- needs a fail message if username or email is not unique

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------
CALL newUserRegistration('luppin848@gmail.com', 'LupFl848', 'P@ssword1');

-- --------------------------------------------------------------------------------
-- Home Screen Procedure X 2
-- --------------------------------------------------------------------------------

-- When login is successul the home screen checks the player is active and then displays the following information

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
-- Create New Game Procedure
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

	SELECT ItemID FROM tblItem ORDER BY ItemID LIMIT 1 INTO firstItem;
	SELECT MAX(ItemID) from tblItem INTO lastItem;
	SELECT BoardType FROM tblBoard LIMIT 1 INTO chosenBoardType; -- This statement would be updated is player could choose from multiple board types
	SELECT CharacterName FROM tblCharacter WHERE CharacterName = 'Doc' INTO firstCharacter;

    INSERT INTO tblGame(BoardType, CharacterTurn)
    VALUES (chosenBoardType, firstCharacter);
    
    SET newGameId = LAST_INSERT_ID();

	IF newGameId > 0 THEN
		INSERT INTO tblPlay(PlayerID, CharacterName, GameID)
		VALUES ((SELECT PlayerID FROM tblPlayer WHERE Username = pUsername), firstCharacter, newGameId);
    END IF;  

    WHILE firstItem < lastItem DO 
        INSERT INTO tblItemGame(ItemID, GameID, TileID)
        VALUES (firstItem, newGameId, (SELECT FLOOR(RAND()*(081-001+1)+001))); 

        SET firstItem = firstItem + 1;
    END WHILE;
END //
DELIMITER ;
-- Need to exclude home tile from receiving items

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL newGame('John');
select * from tblGame

-- --------------------------------------------------------------------------------
-- Create Join Game Procedure
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
                            
    IF selectedCharacter IS NOT NULL THEN                        
		INSERT INTO tblPlay(PlayerID, CharacterName, GameID)
		VALUES (selectedUser, selectedCharacter, pGameID);
	END IF;
END //
DELIMITER ;

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL joinGame(100002, 8);
 
-- --------------------------------------------------------------------------------
-- Create Player Moves Procedure
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
		TileID NOT IN (SELECT TileID FROM tblPlay WHERE GameID = pGameID) AND TileID = pTileID
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
	ELSE
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'You cannot move to this tile';
	END IF;
END //
DELIMITER ;
-- Need to allow multiple users on home tile?
-- need to update the colour of the tile to match the player 

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL movePlayer(1, 4, 100001);

-- --------------------------------------------------------------------------------
-- Create Find Gem Procedure
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
-- need to add if else No gems are found message

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL findGem(80, 4, 100001);
SELECT * FROM selectOneGem;

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

-- Checks if the added points to the play instance is now higher then the players highscore, if it is
-- the players highscore is updated

DELIMITER //
DROP PROCEDURE IF EXISTS updateHS;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE updateHS(
        IN pItemID int,
        IN pPlayID int,
        IN pGameID int,
        IN pPlayerID int
    )
SQL SECURITY INVOKER
BEGIN
 	DECLARE playerPS int DEFAULT NULL;
    DECLARE playerHS int DEFAULT NULL;
  		
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

	IF playerPS > playerHS THEN 
		UPDATE tblPlayer
		SET Highscore = playerPS
		WHERE PlayerID = pPlayerID; 
	END IF;
    
END //
DELIMITER ;

-- TEST PROCEDURE DATA 
-- --------------------------------------------------------------------------------

CALL updateHS(166, 500002, 100001, 4);