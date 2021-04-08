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

    SELECT * FROM tblPlayer WHERE Username = pUsername;
     
END //
DELIMITER ;

CALL loginCheckCredentials('Sunny', 'P@ssword12');


----------------------------------------------------------------------------------
-- New User Registration Procedure
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS newUserRegistration;
CREATE PROCEDURE newUserRegistration(
        IN pEmail varchar(50), 
        IN pUsername varchar(10),
        IN pPassword varchar(15)
    )

BEGIN
IF EXISTS(SELECT 1 FROM tblPlayer WHERE Username = pUsername);

       SELECT 'Someone already has this username and/or email!'

ELSE

        INSERT INTO tblPlayer(Email, Username, `Password`) 
	    VALUES (pEmail, pUsername, pPassword);
END IF;
	    SELECT * FROM tblPlayer WHERE Email = pEmail;
END //
DELIMITER ;

CALL newUserRegistration('lucyPTYRS@yahoo.com', 'Lucy', 'P@ssword1');


DELIMITER //
DROP PROCEDURE IF EXISTS newUserRegistration;
CREATE PROCEDURE newUserRegistration(
        IN pEmail varchar(50), 
        IN pUsername varchar(10),
        IN pPassword varchar(15)
    )
AS
BEGIN   
        IF NOT EXISTS (SELECT Username FROM tblPlayer
                        WHERE Username = pUsername);
    BEGIN
        INSERT INTO tblPlayer(Email, Username, `Password`) 
	    VALUES (pEmail, pUsername, pPassword)
    END
END //
DELIMITER ;
