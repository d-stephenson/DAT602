-- Seven Dwarfs Gem Hunt Project Transactional SQL Milestone 2

----------------------------------------------------------------------------------
-- Database Use
----------------------------------------------------------------------------------

USE sdghGameDatabase;
SELECT `user`, `host` FROM mysql.user;

----------------------------------------------------------------------------------
-- Login Check Credentials Procedure
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS loginCheckCredentials;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE loginCheckCredentials(
    IN pUsername varchar(50), 
    IN pPassword varchar(15)
    )
SQL SECURITY INVOKER
BEGIN
    DECLARE proposedUID int DEFAULT NULL;
  
	SELECT PlayerID 
	FROM 
		tblPlayer
	WHERE
		Username = pUsername AND 
		`Password` = pPassword
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

    SELECT * FROM tblPlayer WHERE Username = pUsername;
     
END //
DELIMITER ;

CALL loginCheckCredentials('Sunny', 'P@ssword12');

----------------------------------------------------------------------------------
-- New User Registration Procedure
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS newUserRegistration;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE newUserRegistration(
    IN pEmail varchar(50), 
    IN pUsername varchar(10),
    IN pPassword varchar(15)
    )
SQL SECURITY INVOKER
BEGIN
    INSERT INTO tblPlayer(Email, Username, `Password`) 
    VALUES (pEmail, pUsername, pPassword);
        
    SELECT * FROM tblPlayer WHERE Email = pEmail AND Username = pUsername;
END //
DELIMITER ;

CALL newUserRegistration('luppin999@gmail.com', 'LupFl999', 'P@ssword1');

----------------------------------------------------------------------------------
-- Home Screen Procedure X 2
----------------------------------------------------------------------------------

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

CALL homeScreen1('John');

----------------------------------------------------------------------------------

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

CALL homeScreen2('John');

----------------------------------------------------------------------------------
-- Create New Game Procedure
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS newGame;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE newGame(
        IN pUsername varchar(10)
    )
SQL SECURITY INVOKER
BEGIN
    DECLARE newGameId int DEFAULT NULL;
    DECLARE takeItemId int DEFAULT 101;

    INSERT INTO tblGame(BoardType, CharacterTurn)
    VALUES ('9 X 9 Sq', 'Doc');
    
    SET newGameId = LAST_INSERT_ID();

	IF newGameId >0 THEN
		INSERT INTO tblPlay(PlayerID, CharacterName, GameID)
		VALUES ((SELECT PlayerID FROM tblPlayer WHERE Username = pUsername), 'Doc', newGameId);
    END IF;  

    WHILE takeItemId <171 DO 
        INSERT INTO tblItemGame(ItemID, GameID, TileID)
        VALUES (takeItemId, newGameId, (SELECT FLOOR(RAND()*(081-001+1)+001))); 

        SET takeItemId = takeItemId + 1;
    END WHILE;
END //
DELIMITER ;

CALL newGame('John');

----------------------------------------------------------------------------------
-- Create Join Game Procedure
----------------------------------------------------------------------------------

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

CALL joinGame(100002, 8);
 
----------------------------------------------------------------------------------
-- Create Player Moves Procedure
----------------------------------------------------------------------------------

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
  	DECLARE nextTurn varchar(10) DEFAULT NULL;  
    
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
    
	SELECT CharacterName
	FROM 
		tblPlay 
	WHERE 
		GameID = 100001 LIMIT 1, 1 -- does not move to next player???
	INTO nextTurn;
    
    IF ((newTileRow = currentTileRow OR newTileRow = currentTileRow + 1 OR newTileRow = currentTileRow - 1) AND 
		(newTileColumn = currentTileColumn OR newTileColumn = currentTileColumn + 1 OR newTileColumn = currentTileColumn - 1)) AND
        emptyTile IS NOT NULL AND
        currentTurn = (SELECT CharacterName FROM tblPlay WHERE PlayerID = pPlayerID) THEN                        
			UPDATE tblPlay
			SET TileID = pTileID
			WHERE PlayerID = pPlayerID AND GameID = pGameID;
            
            UPDATE tblGame
            SET CharacterTurn = nextTurn
            WHERE GameID = pGameID;
	ELSE
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = `'You can't move to this tile'`;
	END IF;
END //
DELIMITER ;

CALL movePlayer(75, 1, 100001);
select * from tblPlay where gameid = 100001;
select * from tblGame where gameid = 100001;