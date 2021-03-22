----------------------------------------------------------------------------------
-- Test System Login
----------------------------------------------------------------------------------

drop database if exists DAT602_one;
create database DAT602_one;
use DAT602_one;

SELECT round(RAND() * (3)) + 1 as TeamToPresent into @team;

select @team;

drop procedure if exists createdb;
delimiter //
create procedure createdb()
begin

    CREATE TABLE `user` (
	  `ID` int NOT NULL AUTO_INCREMENT,
	  `username` varchar(50) DEFAULT NULL,
	  `password` varchar(500) DEFAULT NULL,
	  PRIMARY KEY (`ID`)
	) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

	CREATE TABLE `comment` (
	  `ID` int NOT NULL AUTO_INCREMENT,
	  `comment` varchar(100) DEFAULT NULL,
	  `userID` int DEFAULT NULL,
	  PRIMARY KEY (`ID`),
	  KEY `userID` (`userID`),
	  FOREIGN KEY (`userID`) REFERENCES `user` (`ID`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
    
    insert into `user`(`username`,`password`)
    values ('Terry',1234), 
            ('Tania',1234),
            ('Theresa',1234);
    select * from `user`;
    
     insert into `comment` (`comment`,`userID`)
     values
	     ('Hello from Terry',7),
	     ('Goodbye from Theresa',9);
            
	create table tblteam( 
    
		ID Int, 
		Name Varchar(255)
		);

	insert into tblteam(ID, Name)
	values( 1, 'TheGamblers'),(2,'The C team'), (3,'TeamName'),(4,'Teeeaaammmmm ');

	select * from tblTeam;
    
    
end //
delimiter ;

ALTER TABLE `user` 
ADD `LoginCount` tinyint DEFAULT 0 NOT NULL,
ADD `LoggedIn` bit DEFAULT False NOT NULL,
ADD `LockedOut` bit DEFAULT False NOT NULL
;

drop procedure if exists showTeamName;
delimiter //
create procedure showTeamName( IN pID INT)
begin
	select Name
	from tblTeam
	where ID = pID;
end //

delimiter ;

call createdb();
call showTeamName(@team);

-- drop procedure if exists checkLogin;
-- delimiter $$
-- create procedure checkLogin(in pName varchar(50), in pPassword varchar(500))
-- begin
--     declare proposedUID int default null;
--   
-- 	select `ID` 
-- 	from 
-- 		`user`
-- 	where 
-- 		 `username` = pName and 
-- 		 `password` = pPassword
-- 	 into proposedUID;
--      
--      if proposedUID is NULL then
--          select 'Invalid Password' as 'Message', -1 as `Value`;
-- 	 elseif proposedUID is NULL then 
-- 		UPDATE `user` 
--         SET `LoginCount` = COUNT +1 
--         WHERE `username` = pName; 
-- 	 else
-- 		select 'Valid Password' as 'Message', proposedUID as `Value`;
-- 	 end if;
--      
-- end $$
-- delimiter ;

drop procedure if exists checkLogin;
delimiter $$
create procedure checkLogin(in pName varchar(50), in pPassword varchar(500))
begin
    declare proposedUID int default null;
  
	select `ID` 
	from 
		`user`
	where 
		 `username` = pName and 
		 `password` = pPassword
	 into proposedUID;
     
     if proposedUID is NULL then
		UPDATE `user` 
        SET `LoginCount` = LoginCount +1, `LockedOut` = (LoginCount +1) > 5, `LoggedIn` = (LoginCount +1) < 1
        WHERE `username` = pName; 
	 elseif proposedUID is NOT NULL then
		UPDATE `user`
        SET `LoggedIn` = True, `LoginCount` = 0, `LockedOut` = 0
        WHERE `username` = pName; 
	 end if;
     
end $$
delimiter ;

call checkLogin('John',1234);
call checkLogin('Terry',1245);
call checkLogin('Terry',1234);
update `user` SET `LoginCount` = 0, `LoggedIn` = 0, `LockedOut` = 0 WHERE `username` = 'Terry';
select * from user;