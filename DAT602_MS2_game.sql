-- Seven Dwarfs Gem Hunt Project Transactional SQL Milestone 2

----------------------------------------------------------------------------------
-- Database Use
----------------------------------------------------------------------------------

USE sdghGameDatabase;

----------------------------------------------------------------------------------
-- Login Check Credentials Procedure
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS loginCheckCredentials;
CREATE PROCEDURE loginCheckCredentials(
        IN pUsername varchar(50), 
        IN pPassword varchar(15)
    )
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
     
END //
DELIMITER ;

CALL loginCheckCredentials('Sunny', 'P@ssword1');
SELECT * FROM tblPlayer;

----------------------------------------------------------------------------------
-- New User Registration Procedure
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS newUserRegistration;
CREATE PROCEDURE loginCheckCredentials(
        IN pEmail varchar(50), 
        IN pUsername varchar(10),
        IN pPassword varchar(15)
    )
BEGIN
    DECLARE proposedUID int DEFAULT NULL;
  
	INSERT INTO tblPlayer(Email, Username, `Password`) 
	VALUES (pEmail, pUsername, pPassword)
     
END //
DELIMITER ;

CALL newUserRegistration('jtop@amazon.com', 'John', 'P@ssword1');
SELECT * FROM tblPlayer;
