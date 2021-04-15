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
        SELECT GameID AS 'Game ID', COUNT(pl.GameID) AS 'Player Count'
        FROM tblPlayer py 
                JOIN tblPlay pl on py.PlayerID = pl.PlayerID
        GROUP BY pl.GameID;   
END //
DELIMITER ;

CALL homeScreen1('John');

DELIMITER //
DROP PROCEDURE IF EXISTS homeScreen2;
CREATE DEFINER = ‘root’@’localhost’ PROCEDURE homeScreen2(
        IN pUsername varchar(10)
    )
SQL SECURITY INVOKER
BEGIN
		SELECT Username AS 'Players', HighScore AS 'High Score' 
        FROM tblPlayer;   
END //
DELIMITER ;

CALL homeScreen2('John');