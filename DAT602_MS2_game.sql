-- Seven Dwarfs Gem Hunt Project Transactional SQL Milestone 2

----------------------------------------------------------------------------------
-- Database Use
----------------------------------------------------------------------------------

USE sdghGameDatabase;

----------------------------------------------------------------------------------
-- Login Check Credentials Procedures
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS loginCheckCredentials;
CREATE PROCEDURE loginCheckCredentials(IN pUsername varchar(50), IN pPassword varchar(15))
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

CALL loginCheckCredentials('John',1234);
