-- Seven Dwarfs Gem Hunt Project Physical Design Milestone One [refer to Logical Diagram v2.2]
-- UPDATES RELATED TO WORK COMPLETED FOR MILESTONE 2

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Database Setup
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

DROP DATABASE IF EXISTS sdghGameDatabase;
BEGIN;
CREATE DATABASE sdghGameDatabase;
BEGIN;
USE sdghGameDatabase;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- DDL | Making tables, indexes and checks
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

DROP PROCEDURE IF EXISTS CreateTables;
DELIMITER //
CREATE PROCEDURE CreateTables()
BEGIN

DROP TABLE IF EXISTS tblItemGame;
DROP TABLE IF EXISTS tblItem;
DROP TABLE IF EXISTS tblPlay;
DROP TABLE IF EXISTS tblGame;
DROP TABLE IF EXISTS tblBoardTile;
DROP TABLE IF EXISTS tblBoard;
DROP TABLE IF EXISTS tblTile;
DROP TABLE IF EXISTS tblGem;
DROP TABLE IF EXISTS tblCharacter;
DROP TABLE IF EXISTS tblPlayer;

CREATE TABLE tblPlayer (
	PlayerID int AUTO_INCREMENT,
	Email varchar(50) NOT NULL,
	Username varchar(10) NOT NULL,
	`Password` BLOB NOT NULL,
	AccountAdmin bit DEFAULT FALSE NOT NULL,
	AccountLocked bit DEFAULT FALSE NOT NULL,
	ActiveStatus bit DEFAULT FALSE NOT NULL,
	FailedLogins tinyint DEFAULT 0 NOT NULL,
	HighScore int DEFAULT 0 NOT NULL, 
	PRIMARY KEY (PlayerID),
	CONSTRAINT UC_Email UNIQUE (Email),
	CONSTRAINT UC_Username UNIQUE (Username),
	CONSTRAINT CHK_Email CHECK (Email Like '_%@_%._%')
);

	ALTER TABLE tblPlayer AUTO_INCREMENT=000001;
	ALTER TABLE tblPlayer ADD COLUMN Salt varchar(36); 
	ALTER TABLE tblPlayer ENCRYPTION='Y'; -- Encrypt Player table

CREATE TABLE tblCharacter (
	CharacterName varchar(10) NOT NULL,
	TileColour varchar(10) NOT NULL,
	PRIMARY KEY (CharacterName)
);

CREATE TABLE tblGem (
	GemType varchar(10) NOT NULL,
	Points tinyint NOT NULL,
	PRIMARY KEY (GemType)
);

CREATE TABLE tblTile (
	TileID int AUTO_INCREMENT,
	TileRow tinyint NOT NULL,
	TileColumn tinyint NOT NULL,
	HomeTile bit,
	PRIMARY KEY (TileID)
);

	ALTER TABLE tblTile AUTO_INCREMENT=001;

CREATE TABLE tblBoard (
	BoardType varchar(20) NOT NULL,
	XAxis tinyint NOT NULL,
	YAxis tinyint NOT NULL,
	PRIMARY KEY (BoardType)
);

CREATE TABLE tblBoardTile (
	BoardType varchar(20) NOT NULL,
	TileID int NOT NULL,
	CONSTRAINT PK_BoardTile PRIMARY KEY (BoardType, TileID),
	CONSTRAINT FK_BoardType_BT FOREIGN KEY (BoardType) REFERENCES tblBoard(BoardType),
	CONSTRAINT FK_TileID_BT FOREIGN KEY (TileID) REFERENCES tblTile(TileID)
);

CREATE TABLE tblGame (
	GameID int AUTO_INCREMENT,
	BoardType varchar(20) NOT NULL,
	CharacterTurn varchar(10),
	PRIMARY KEY (GameID),
	CONSTRAINT FK_BoardType_Game FOREIGN KEY (BoardType) REFERENCES tblBoard(BoardType)
);

	ALTER TABLE tblGame AUTO_INCREMENT=100001;

CREATE TABLE tblPlay (
	PlayID int AUTO_INCREMENT,
	PlayerID int NOT NULL,
	CharacterName varchar(10) NOT NULL,
	GameID int NOT NULL,
	TileID int DEFAULT 001 NOT NULL,
	PlayScore int DEFAULT 0 NOT NULL,
	PRIMARY KEY (PlayID),
	CONSTRAINT FK_PlayerID_Play FOREIGN KEY (PlayerID) REFERENCES tblPlayer(PlayerID) ON DELETE CASCADE,
	CONSTRAINT FK_CharacterName_Play FOREIGN KEY (CharacterName) REFERENCES tblCharacter(CharacterName),
	CONSTRAINT FK_GameID_Play FOREIGN KEY (GameID) REFERENCES tblGame(GameID),
	CONSTRAINT FK_TileID_Play FOREIGN KEY (TileID) REFERENCES tblTile(TileID)
);

	ALTER TABLE tblPlay AUTO_INCREMENT=500001;

CREATE TABLE tblItem (
	ItemID int AUTO_INCREMENT,
	GemType varchar(10) NOT NULL,
	PRIMARY KEY (ItemID),
	CONSTRAINT FK_GemType_Item FOREIGN KEY (GemType) REFERENCES tblGem(GemType)
);

	ALTER TABLE tblItem AUTO_INCREMENT=101;

CREATE TABLE tblItemGame (
	ItemID int NOT NULL,
	GameID int NOT NULL,
	TileID int,
	PlayID int,
	CONSTRAINT PK_ItemGame PRIMARY KEY (ItemID, GameID),
	CONSTRAINT FK_ItemID_IG FOREIGN KEY (ItemID) REFERENCES tblItem(ItemID),
	CONSTRAINT FK_GameID_IG FOREIGN KEY (GameID) REFERENCES tblGame(GameID),
	CONSTRAINT FK_TileID_IG FOREIGN KEY (TileID) REFERENCES tblTile(TileID),
	CONSTRAINT FK_PlayID_IG FOREIGN KEY (PlayID) REFERENCES tblPlay(PlayID) ON DELETE CASCADE
);

END 
//
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- DML Inserting into tables
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

DROP PROCEDURE IF EXISTS InsertTables;
DELIMITER //
CREATE PROCEDURE InsertTables() 
BEGIN

INSERT INTO tblPlayer
VALUES 
	(000001, 'mstirtle0@alibaba.com', 'Bob', 'P@ssword1', TRUE, FALSE, TRUE, 0, 0, 'dsaf5165fdg46fg4sg6-54sdfg5'),
	(000002, 'cgrooby1@walmart.com', 'Jane', 'P@ssword1', TRUE, FALSE, FALSE, 0, 0, 'dsaf5165fdg46fg4sg6-54sdfg5'),
	(000003, 'abartosinski2@irs.gov', 'John', 'P@ssword1', TRUE, FALSE, FALSE, 2, 0, 'dsaf5165fdg46fg4sg6-54sdfg5'),
	(000004, 'mggghgh0@gmail.com', 'Troy', 'P@ssword1', TRUE, FALSE, TRUE, 0, 0, 'dsaf5165fdg46fg4sg6-54sdfg5'),
	(000005, 'dringm@gmx.com', 'Chris', 'P@ssword1', TRUE, FALSE, FALSE, 3, 0, 'dsaf5165fdg46fg4sg6-54sdfg5'),
	(000006, 'ythnfhhgj@frirs.gov', 'Sunny', 'P@ssword1', TRUE, FALSE, FALSE, 0, 0, 'dsaf5165fdg46fg4sg6-54sdfg5'),
	(000007, 'looijnhg0@gmail.com', 'JCP', 'P@ssword1', TRUE, FALSE, FALSE, 0, 0, 'dsaf5165fdg46fg4sg6-54sdfg5'),
	(000008, 'frigsngjj@gmx.com', 'Junior', 'P@ssword1', TRUE, FALSE, FALSE, 0, 0, 'dsaf5165fdg46fg4sg6-54sdfg5');

INSERT INTO tblCharacter
VALUES 
	('Doc', 'Red'),
	('Grumpy', 'Yellow'),
	('Happy', 'Green'),
	('Sleepy', 'Navy'),
	('Bashful', 'Orange'),
	('Sneezy', 'Purple'),
	('Dopey', 'Blue');

INSERT INTO tblGem
VALUES 
	('Garnet', 49),
	('Amethyst', 21),
	('Aquamarine', 14),
	('Diamond', 38),
	('Emerald', 80),
	('Pearl', 5),
	('Ruby', 19),
	('Peridot', 42),
	('Sapphire', 11),
	('Opel', 3);

INSERT INTO tblTile
VALUES 
	(001, 5, 5, TRUE),
	(002, 1, 1, FALSE),
	(003, 2, 1, FALSE),
	(004, 3, 1, FALSE),
	(005, 4, 1, FALSE),
	(006, 5, 1, FALSE),
	(007, 6, 1, FALSE),
	(008, 7, 1, FALSE),
	(009, 8, 1, FALSE),
	(010, 9, 1, FALSE),
	(011, 1, 2, FALSE),
	(012, 2, 2, FALSE),
	(013, 3, 2, FALSE),
	(014, 4, 2, FALSE),
	(015, 5, 2, FALSE),
	(016, 6, 2, FALSE),
	(017, 7, 2, FALSE),
	(018, 8, 2, FALSE),
	(019, 9, 2, FALSE),
	(020, 1, 3, FALSE),
	(021, 2, 3, FALSE),
	(022, 3, 3, FALSE),
	(023, 4, 3, FALSE),
	(024, 5, 3, FALSE),
	(025, 6, 3, FALSE),
	(026, 7, 3, FALSE),
	(027, 8, 3, FALSE),
	(028, 9, 3, FALSE),
	(029, 1, 4, FALSE),
	(030, 2, 4, FALSE),
	(031, 3, 4, FALSE),
	(032, 4, 4, FALSE),
	(033, 5, 4, FALSE),
	(034, 6, 4, FALSE),
	(035, 7, 4, FALSE),
	(036, 8, 4, FALSE),
	(037, 9, 4, FALSE),
	(038, 1, 5, FALSE),
	(039, 2, 5, FALSE),
	(040, 3, 5, FALSE),
	(041, 4, 5, FALSE),
	(042, 6, 5, FALSE),
	(043, 7, 5, FALSE),
	(044, 8, 5, FALSE),
	(045, 9, 5, FALSE),
	(046, 1, 6, FALSE),
	(047, 2, 6, FALSE),
	(048, 3, 6, FALSE),
	(049, 4, 6, FALSE),
	(050, 5, 6, FALSE),
	(051, 6, 6, FALSE),
	(052, 7, 6, FALSE),
	(053, 8, 6, FALSE),
	(054, 9, 6, FALSE),
	(055, 1, 7, FALSE),
	(056, 2, 7, FALSE),
	(057, 3, 7, FALSE),
	(058, 4, 7, FALSE),
	(059, 5, 7, FALSE),
	(060, 6, 7, FALSE),
	(061, 7, 7, FALSE),
	(062, 8, 7, FALSE),
	(063, 9, 7, FALSE),
	(064, 1, 8, FALSE),
	(065, 2, 8, FALSE),
	(066, 3, 8, FALSE),
	(067, 4, 8, FALSE),
	(068, 5, 8, FALSE),
	(069, 6, 8, FALSE),
	(070, 7, 8, FALSE),
	(071, 8, 8, FALSE),
	(072, 9, 8, FALSE),
	(073, 1, 9, FALSE),
	(074, 2, 9, FALSE),
	(075, 3, 9, FALSE),
	(076, 4, 9, FALSE),
	(077, 5, 9, FALSE),
	(078, 6, 9, FALSE),
	(079, 7, 9, FALSE),
	(080, 8, 9, FALSE),
	(081, 9, 9, FALSE);

INSERT INTO tblBoard
VALUES 
	('9 X 9 Sq', 9, 9);

INSERT INTO tblBoardTile
VALUES 
	('9 X 9 Sq', 001),
	('9 X 9 Sq', 002),
	('9 X 9 Sq', 003),
	('9 X 9 Sq', 004),
	('9 X 9 Sq', 005),
	('9 X 9 Sq', 006),
	('9 X 9 Sq', 007),
	('9 X 9 Sq', 008),
	('9 X 9 Sq', 009),
	('9 X 9 Sq', 010),
	('9 X 9 Sq', 011), 
	('9 X 9 Sq', 012),
	('9 X 9 Sq', 013),
	('9 X 9 Sq', 014),
	('9 X 9 Sq', 015), 
	('9 X 9 Sq', 016),
	('9 X 9 Sq', 017),
	('9 X 9 Sq', 018), 
	('9 X 9 Sq', 019), 
	('9 X 9 Sq', 020),
	('9 X 9 Sq', 021),
	('9 X 9 Sq', 022),
	('9 X 9 Sq', 023),
	('9 X 9 Sq', 024),
	('9 X 9 Sq', 025),
	('9 X 9 Sq', 026), 
	('9 X 9 Sq', 027),
	('9 X 9 Sq', 028), 
	('9 X 9 Sq', 029),
	('9 X 9 Sq', 030), 
	('9 X 9 Sq', 031),
	('9 X 9 Sq', 032),
	('9 X 9 Sq', 033), 
	('9 X 9 Sq', 034), 
	('9 X 9 Sq', 035),
	('9 X 9 Sq', 036), 
	('9 X 9 Sq', 037), 
	('9 X 9 Sq', 038), 
	('9 X 9 Sq', 039),
	('9 X 9 Sq', 040), 
	('9 X 9 Sq', 041), 
	('9 X 9 Sq', 042), 
	('9 X 9 Sq', 043), 
	('9 X 9 Sq', 044), 
	('9 X 9 Sq', 045), 
	('9 X 9 Sq', 046), 
	('9 X 9 Sq', 047), 
	('9 X 9 Sq', 048), 
	('9 X 9 Sq', 049), 
	('9 X 9 Sq', 050), 
	('9 X 9 Sq', 051), 
	('9 X 9 Sq', 052), 
	('9 X 9 Sq', 053), 
	('9 X 9 Sq', 054), 
	('9 X 9 Sq', 055),
	('9 X 9 Sq', 056), 
	('9 X 9 Sq', 057), 
	('9 X 9 Sq', 058), 
	('9 X 9 Sq', 059), 
	('9 X 9 Sq', 060), 
	('9 X 9 Sq', 061), 
	('9 X 9 Sq', 062), 
	('9 X 9 Sq', 063),
	('9 X 9 Sq', 064), 
	('9 X 9 Sq', 065), 
	('9 X 9 Sq', 066), 
	('9 X 9 Sq', 067), 
	('9 X 9 Sq', 068), 
	('9 X 9 Sq', 069), 
	('9 X 9 Sq', 070), 
	('9 X 9 Sq', 071), 
	('9 X 9 Sq', 072), 
	('9 X 9 Sq', 073),
	('9 X 9 Sq', 074), 
	('9 X 9 Sq', 075),
	('9 X 9 Sq', 076),
	('9 X 9 Sq', 077), 
	('9 X 9 Sq', 078), 
	('9 X 9 Sq', 079), 
	('9 X 9 Sq', 080), 
	('9 X 9 Sq', 081);

INSERT INTO tblGame
VALUES 
	(100001, '9 X 9 Sq', 'Doc'),
	(100002, '9 X 9 Sq', 'Doc');

INSERT INTO tblPlay
VALUES 
	(500001, 000001, 'Doc', 100001, 078, 3),
	(500002, 000004, 'Grumpy', 100001, 079, 38),
	(500003, 000005, 'Sleepy', 100001, 063, 11),
	(500004, 000002, 'Doc', 100002, 033, 49),
	(500005, 000003, 'Grumpy', 100002, 042, 21),
	(500006, 000003, 'Happy', 100001, 042, 0);

INSERT INTO tblItem
VALUES 
	(101, 'Garnet'),
	(102, 'Garnet'),
	(103, 'Garnet'),
	(104, 'Garnet'),
	(105, 'Garnet'),
	(106, 'Garnet'),
	(107, 'Garnet'),
	(108, 'Amethyst'),
	(109, 'Amethyst'),
	(110, 'Amethyst'),
	(111, 'Amethyst'),
	(112, 'Amethyst'),
	(113, 'Amethyst'),
	(114, 'Amethyst'),
	(115, 'Aquamarine'),
	(116, 'Aquamarine'),
	(117, 'Aquamarine'),
	(118, 'Aquamarine'),
	(119, 'Aquamarine'),
	(120, 'Aquamarine'),
	(121, 'Aquamarine'),
	(122, 'Diamond'),
	(123, 'Diamond'),
	(124, 'Diamond'),
	(125, 'Diamond'),
	(126, 'Diamond'),
	(127, 'Diamond'),
	(128, 'Diamond'),
	(129, 'Emerald'),
	(130, 'Emerald'),
	(131, 'Emerald'),
	(132, 'Emerald'),
	(133, 'Emerald'),
	(134, 'Emerald'),
	(135, 'Emerald'),
	(136, 'Pearl'),
	(137, 'Pearl'),
	(138, 'Pearl'),
	(139, 'Pearl'),
	(140, 'Pearl'),
	(141, 'Pearl'),
	(142, 'Pearl'),
	(143, 'Ruby'),
	(144, 'Ruby'),
	(145, 'Ruby'),
	(146, 'Ruby'),
	(147, 'Ruby'),
	(148, 'Ruby'),
	(149, 'Ruby'),
	(150, 'Peridot'),
	(151, 'Peridot'),
	(152, 'Peridot'),
	(153, 'Peridot'),
	(154, 'Peridot'),
	(155, 'Peridot'),
	(156, 'Peridot'),
	(157, 'Sapphire'),
	(158, 'Sapphire'),
	(159, 'Sapphire'),
	(160, 'Sapphire'),
	(161, 'Sapphire'),
	(162, 'Sapphire'),
	(163, 'Sapphire'),
	(164, 'Opel'),
	(165, 'Opel'),
	(166, 'Opel'),
	(167, 'Opel'),
	(168, 'Opel'),
	(169, 'Opel'),
	(170, 'Opel');

INSERT INTO tblItemGame
VALUES 
	(101, 100001, 051, NULL), 
	(102, 100001, 031, NULL),
	(103, 100001, 021, NULL),
	(104, 100001, 011, NULL),
	(105, 100001, 051, NULL),
	(106, 100001, 031, NULL),
	(107, 100001, 021, NULL),
	(108, 100001, 011, NULL),
	(109, 100001, 061, NULL),
	(110, 100001, 071, NULL),
	(111, 100001, 012, NULL),
	(112, 100001, 013, NULL),
	(113, 100001, 014, NULL),
	(114, 100001, 022, NULL),
	(115, 100001, 023, NULL),
	(116, 100001, 024, NULL),
	(117, 100001, 015, NULL),
	(118, 100001, 016, NULL),
	(119, 100001, 017, NULL),
	(120, 100001, 018, NULL),
	(121, 100001, 018, NULL),
	(122, 100001, 076, NULL),
	(123, 100001, 077, NULL),
	(124, 100001, 078, NULL),
	(125, 100001, 079, NULL),
	(126, 100001, 076, NULL),
	(127, 100001, 071, NULL),
	(128, 100001, 075, NULL),
	(129, 100001, 075, NULL),
	(130, 100001, 034, NULL),
	(131, 100001, 035, NULL),
	(132, 100001, 051, NULL),
	(133, 100001, 005, NULL),
	(134, 100001, 052, NULL),
	(135, 100001, 080, NULL),
	(136, 100001, 070, NULL),
	(137, 100001, 002, NULL),
	(138, 100001, 070, NULL),
	(139, 100001, 022, NULL),
	(140, 100001, 054, NULL),
	(141, 100001, 046, NULL),
	(142, 100001, 056, NULL),
	(143, 100001, 057, NULL),
	(144, 100001, 058, NULL),
	(145, 100001, 059, NULL),
	(146, 100001, 045, NULL),
	(147, 100001, 044, NULL),
	(148, 100001, 043, NULL),
	(149, 100001, 042, NULL),
	(150, 100001, 043, NULL),
	(151, 100001, 067, NULL),
	(152, 100001, 079, NULL),
	(153, 100001, 079, NULL),
	(154, 100001, 078, NULL),
	(155, 100001, 023, NULL),
	(156, 100001, 002, NULL),
	(157, 100001, 003, NULL),
	(158, 100001, 004, NULL),
	(159, 100001, 005, NULL),
	(160, 100001, 004, NULL),
	(161, 100001, 005, NULL),
	(162, 100001, 015, NULL),
	(163, 100001, 014, NULL),
	(164, 100001, 013, NULL),
	(165, 100001, 058, NULL),
	(166, 100001, 080, NULL),
	(167, 100001, 040, NULL),
	(168, 100001, 042, NULL),
	(169, 100001, 034, NULL),
	(170, 100001, 039, NULL),
	(101, 100002, 051, NULL), 
	(102, 100002, 031, NULL),
	(103, 100002, 021, NULL),
	(104, 100002, 011, NULL),
	(105, 100002, 051, NULL),
	(106, 100002, 031, NULL),
	(107, 100002, 021, NULL),
	(108, 100002, 011, NULL),
	(109, 100002, 061, NULL),
	(110, 100002, 071, NULL),
	(111, 100002, 081, NULL),
	(112, 100002, 013, NULL),
	(113, 100002, 014, NULL),
	(114, 100002, 022, NULL),
	(115, 100002, 023, NULL),
	(116, 100002, 024, NULL),
	(117, 100002, 015, NULL),
	(118, 100002, 016, NULL),
	(119, 100002, 017, NULL),
	(120, 100002, 018, NULL),
	(121, 100002, 018, NULL),
	(122, 100002, 076, NULL),
	(123, 100002, 077, NULL),
	(124, 100002, 078, NULL),
	(125, 100002, 079, NULL),
	(126, 100002, 076, NULL),
	(127, 100002, 071, NULL),
	(128, 100002, 075, NULL),
	(129, 100002, 075, NULL),
	(130, 100002, 034, NULL),
	(131, 100002, 035, NULL),
	(132, 100002, 051, NULL),
	(133, 100002, 005, NULL),
	(134, 100002, 052, NULL),
	(135, 100002, 080, NULL),
	(136, 100002, 070, NULL),
	(137, 100002, 009, NULL),
	(138, 100002, 070, NULL),
	(139, 100002, 022, NULL),
	(140, 100002, 054, NULL),
	(141, 100002, 046, NULL),
	(142, 100002, 056, NULL),
	(143, 100002, 057, NULL),
	(144, 100002, 058, NULL),
	(145, 100002, 059, NULL),
	(146, 100002, 045, NULL),
	(147, 100002, 044, NULL),
	(148, 100002, 043, NULL),
	(149, 100002, 042, NULL),
	(150, 100002, 043, NULL),
	(151, 100002, 067, NULL),
	(152, 100002, 079, NULL),
	(153, 100002, 079, NULL),
	(154, 100002, 078, NULL),
	(155, 100002, 023, NULL),
	(156, 100002, 002, NULL),
	(157, 100002, 003, NULL),
	(158, 100002, 004, NULL),
	(159, 100002, 005, NULL),
	(160, 100002, 004, NULL),
	(161, 100002, 005, NULL),
	(162, 100002, 015, NULL),
	(163, 100002, 014, NULL),
	(164, 100002, 013, NULL),
	(165, 100002, 058, NULL),
	(166, 100002, 080, NULL),
	(167, 100002, 040, NULL),
	(168, 100002, 042, NULL),
	(169, 100002, 034, NULL),
	(170, 100002, 039, NULL);

END
//
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Call Create, Insert Procedures
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CALL CreateTables;
CALL InsertTables;

-- Seven Dwarfs Gem Hunt Project Transactional SQL Milestone 2
-- CREATE PROCEDURES

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Database Admins
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- SELECT `user`, `host` FROM mysql.user;

DROP USER IF EXISTS 'databaseAdmin'@'localhost';
CREATE USER IF NOT EXISTS 'databaseAdmin'@'localhost' IDENTIFIED BY 'P@ssword1';
GRANT ALL ON sdghGameDatabase TO 'databaseAdmin'@'localhost';
-- SHOW GRANTS FOR 'databaseAdmin'@'localhost';
-- SHOW GRANTS FOR 'root'@'localhost';

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Global Transaction Isolation Level
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	-- Re-run CreateTables and InsertTables from DAT601_MS1_game.sql as changes have been made to facilitate these procedures
	
    -- Check table is encrypted
	-- 	SELECT TABLE_SCHEMA, TABLE_NAME, CREATE_OPTIONS 
	--  FROM INFORMATION_SCHEMA.TABLES
	-- 	WHERE CREATE_OPTIONS LIKE '%ENCRYPTION%'; 
    
	SET GLOBAL TRANSACTION ISOLATION LEVEL read committed; 
	-- SET GLOBAL TRANSACTION ISOLATION LEVEL read uncommitted; 
	-- SET GLOBAL TRANSACTION ISOLATION LEVEL repeatable read; 
	-- SET GLOBAL TRANSACTION ISOLATION LEVEL serialization;
    
	--  SHOW GLOBAL VARIABLES LIKE '%isolation%';

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- New User Registration Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- The database contains a constraint that only allows unique values to be allocated to Email and Username, should 
-- a new user attempt to register with either value found to exist the procedure will not run. Otherwise, the procedure 
-- requires a user to enter an email, username and password, the remaining fields are created as the defaults, the 
-- procedure gives new players the ability to register an account.

DROP PROCEDURE IF EXISTS NewUserRegistration;
DELIMITER //
CREATE DEFINER = 'root'@'localhost' PROCEDURE NewUserRegistration(
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
    
    SELECT 'Your account is created, let the games begin!!!' AS MESSAGE;
END //
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Login Check Credentials Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- This procedure allows a user to log in to the game, it retrieves the users salt record to ensure the password is 
-- passed correctly and the users active status to ensure they are not already logged in. If the user is logged in 
-- their details are displayed and a message is passed stating their active status. If an incorrect username or password 
-- is entered and an error message is returned. 

DROP PROCEDURE IF EXISTS LoginCheckCredentials;
DELIMITER //
CREATE DEFINER = 'root'@'localhost' PROCEDURE LoginCheckCredentials(
		IN pUsername varchar(50), 
		IN pPassword BLOB
    )
SQL SECURITY DEFINER

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
		    
		SELECT 'You have entered an incorrect Username or Password, after 5 failed attempts your account will be locked' AS MESSAGE;
        -- Increments the failed logins, if it equals 5 then account is locked
	ELSEIF proposedUID IS NOT NULL AND currentAS = 0 THEN
		UPDATE tblPlayer
        SET ActiveStatus = 1, FailedLogins = 0, AccountLocked = 0
        WHERE 
			Username = pUsername; 
            
		SELECT 'Success' AS MESSAGE;
        
		SELECT GameID AS 'GameID', COUNT(pl.GameID) AS 'PlayerCount'
        FROM tblPlayer py 
            JOIN tblPlay pl ON py.PlayerID = pl.PlayerID
        GROUP BY pl.GameID;  
        
		SELECT Username AS 'Player', HighScore AS 'HighScore' 
		FROM tblPlayer; 
		-- If credentials are correct user is logged into account by setting active status to true
	ELSE 
		SELECT 'You are logged in' AS MESSAGE;
    
		SELECT GameID AS 'GameID', COUNT(pl.GameID) AS 'PlayerCount'
        FROM tblPlayer py 
            JOIN tblPlay pl ON py.PlayerID = pl.PlayerID
        GROUP BY pl.GameID;  
        
		SELECT Username AS 'Player', HighScore AS 'HighScore' 
		FROM tblPlayer;  
        -- Conditions are met so user is already logged in
	END IF;
END //
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Home Screen Display Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- PROCEDURE NO LONGER REQUIRED
-- Two select statements make up the procedure and have been designed with thought given to the end GUI, should a 
-- login attempt be successful, which is further check by selecting the active status of the user, then the relevant 
-- information as described in the storyboarding is displayed. 

-- DROP PROCEDURE IF EXISTS HomeScreen;
-- DELIMITER //
-- CREATE DEFINER = 'root'@'localhost' PROCEDURE HomeScreen(
-- 		IN pUsername varchar(10)
--     )
-- SQL SECURITY DEFINER

-- BEGIN
--     DECLARE accessScreen bit DEFAULT NULL;
--   
-- 	SELECT ActiveStatus 
-- 	FROM tblPlayer
-- 	WHERE
-- 		Username = pUsername 
-- 	INTO accessScreen;

--     IF accessScreen IS TRUE THEN
--         SELECT GameID AS 'Game ID', COUNT(pl.GameID) AS 'Player Count'
--         FROM tblPlayer py 
--             JOIN tblPlay pl ON py.PlayerID = pl.PlayerID
--         GROUP BY pl.GameID;  
--         
-- 		SELECT Username AS 'Player', HighScore AS 'High Score' 
-- 		FROM tblPlayer;  
-- 	END IF;
-- END //
-- DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- New Game Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- The new game procedure must create a new game in the game, which includes an autoincrement ID, a new play instance 
-- for the player that creates the new game and a new item list associated with the game in the item/game table. The 
-- play table and item/game table must pull in the newly created game ID, this is achieved by declaring the new game ID 
-- with the LAST_INSERT_ID() function. Finally, the items are allocated to tiles within the game, this is done randomly 
-- so each game is different to the last.

DROP PROCEDURE IF EXISTS NewGame;
DELIMITER //
CREATE DEFINER = 'root'@'localhost' PROCEDURE NewGame(
        IN pUsername varchar(10)
    )
SQL SECURITY DEFINER

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
    
	BEGIN
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

		SELECT 'Your new game is created, find those gems!!!' AS MESSAGE;
	END;
END //
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Join Game Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- When a player joins a new game, the next available character is selected, a play instance is created that is 
-- assigned to the game with the character and the player ID. If all seven dwarf characters are playing in the game, 
-- then an error message is displayed.

DROP PROCEDURE IF EXISTS JoinGame;
DELIMITER //
CREATE DEFINER = 'root'@'localhost' PROCEDURE JoinGame(
        IN pGameID int,
        IN pPlayerID int
    )
SQL SECURITY DEFINER

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
							GameID =  pGameID) 
                            AND PlayerID = pPlayerID
	INTO selectedUser;
    
    BEGIN                      
		IF selectedCharacter IS NOT NULL AND selectedUser IS NOT NULL THEN -- Prevents more then Character count of 7 joining a game and prevents update from happening if player re-joining the game                      
			INSERT INTO tblPlay(PlayerID, CharacterName, GameID)
			VALUES (selectedUser, selectedCharacter, pGameID);
			
			SELECT 'Youve joined the game!!!' AS MESSAGE;
		ELSEIF selectedUser IS NULL THEN
			SELECT 'You are back in the game!!!' AS MESSAGE;
		ELSEIF selectedCharacter IS NULL AND selectedUser IS NOT NULL THEN
			SELECT 'All seven dwarfs are playing this game!!!' AS MESSAGE;

		END IF;
	END;
END //
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Player Moves Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- The procedure moves a player to a new tile if the tile is plus or minus one from the player's current tile position 
-- in a game instance, the play table records the current player's position. If a player is already on the tile, except 
-- for the home tile, then the player cannot move to it and an error message is displayed. Likewise, if a player selects 
-- a tile that is not plus or minus one adjacent from the current tile an error message is displayed. 

DROP PROCEDURE IF EXISTS MovePlayer;
DELIMITER //
CREATE DEFINER = 'root'@'localhost' PROCEDURE MovePlayer(
        IN pTileID int,
        IN pPlayerID int,
        IN pGameID int
    )
SQL SECURITY DEFINER

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
    
    BEGIN
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
						
			SELECT 'Your character has moved!!!' AS MESSAGE;	
			
            SELECT TileColour, TileRow, TileColumn 
			FROM tblCharacter ch 
				JOIN tblPlay pl ON ch.CharacterName = pl.CharacterName
				JOIN tblTile ti ON pl.TileID = ti.TileID
			WHERE 
				PlayerID = pPlayerID;
		ELSE
			SELECT 'Your character cant move to this tile!!!' AS MESSAGE;
		END IF;
	END;
END //
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Find Gem Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- When a player lands on a tile this procedure will run, it displays all the items on that tile so that one can be 
-- selected by the player.

DROP PROCEDURE IF EXISTS FindGem;
DELIMITER //
CREATE DEFINER = 'root'@'localhost' PROCEDURE FindGem(
        IN pTileID int,
        IN pPlayerID int,
        IN pGameID int
    )
SQL SECURITY DEFINER

BEGIN
	IF (SELECT COUNT(ItemID) 
		FROM tblItemGame 
		WHERE TileID = pTileID 
			AND GameID = pGameID) > 0 THEN
			SELECT 'Youve found gems!!!' AS MESSAGE;
		   
		SELECT ig.ItemID AS 'ItemID', ge.GemType AS 'GemType', Points AS 'Points', pl.GameID AS 'GameID', pl.PlayerID AS 'PlayerID', pl.PlayID AS 'PlayID', pl.TileID AS 'TileID'
		FROM tblPlay pl
			JOIN tblItemGame ig ON pl.TileID = ig.TileID 
				AND pl.GameID = ig.GameID
					JOIN tblItem it ON ig.ItemID = it.ItemID
					JOIN tblGem ge ON it.GemType = ge.GemType  
		WHERE   
			pl.TileID = pTileID
				AND pl.PlayerID = pPlayerID
				AND pl.GameID = pGameID; 
	ELSE 
		SELECT 'Bummer, this tile has no gems!!!' AS MESSAGE;
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

DROP PROCEDURE IF EXISTS SelectGem;
DELIMITER //
CREATE DEFINER = 'root'@'localhost' PROCEDURE SelectGem(
        IN pItemID int,
        IN pPlayID int,
        IN pPlayerID int,
        IN pGameID int
    )
SQL SECURITY DEFINER

BEGIN
	DECLARE gemPoints tinyint DEFAULT NULL;
    DECLARE nextTurn varchar(10) DEFAULT NULL;
		
	SELECT Points 
    FROM tblGem ge
		JOIN tblItem it ON ge.GemType = it.GemType
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
    
    BEGIN
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
	END;

	BEGIN
		IF nextTurn IS NOT NULL THEN
			UPDATE tblGame
			SET CharacterTurn = nextTurn
			WHERE 
				GameID = pGameID;
                    SELECT 'Turn updated!!!' AS MESSAGE;
		ELSEIF nextTurn IS NULL THEN
			UPDATE tblGame
			SET CharacterTurn = 'Doc'
			WHERE 
				GameID = pGameID;
                    SELECT 'Turn updated!!!' AS MESSAGE;
		END IF;
	END;
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

DROP PROCEDURE IF EXISTS UpdateHS_EG;
DELIMITER //
CREATE DEFINER = 'root'@'localhost' PROCEDURE UpdateHS_EG(
        IN pPlayID int,
        IN pPlayerID int,
        IN pGameID int
    )
SQL SECURITY DEFINER

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
    
    BEGIN 
		IF playerPS > playerHS THEN 
			UPDATE tblPlayer
			SET Highscore = playerPS
			WHERE 
				PlayerID = pPlayerID; 
			SELECT 'Score is updated!!!' AS MESSAGE;
		END IF;

		IF tileCount = 0 THEN 
			UPDATE tblGame
			SET CharacterTurn = NULL
			WHERE 
				GameID = pGameID;
                
			SELECT 'This game is over!!!' AS MESSAGE;
                        
			SELECT pl.CharacterName, pl.PlayScore 
			FROM tblPlay pl
					JOIN tblCharacter ch ON pl.CharacterName = ch.CharacterName 
			WHERE (SELECT MAX(PlayScore) 
					FROM tblPlay) 
						AND GameID = pGameID;
		ELSE	
			SELECT 'Time for the next dwarf to make his move!!!' AS MESSAGE;
		END IF;
	END;
END //
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Player Logout Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- The logout procedure updates the players active status to false, meaning that if they want to access the game again 
-- the login procedure will check the active status and request login credentials.

DROP PROCEDURE IF EXISTS PlayerLogout;
DELIMITER //
CREATE DEFINER = 'root'@'localhost' PROCEDURE PlayerLogout(
        IN pUsername varchar(10)
    )
SQL SECURITY DEFINER

BEGIN
	UPDATE tblPlayer 
    SET ActiveStatus = 0
    WHERE Username = pUsername;
    
    SELECT 'Youre all logged out!!!' AS MESSAGE;
END //

DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Enter Admin Screen Procedure 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- When admin access is requested the procedure checks if the player has admin privileges, if successful the home 
-- screen displays the relevant information that an admin would require. If the player is not an admin an error message 
-- is returned.

DROP PROCEDURE IF EXISTS AdminScreen;
DELIMITER //
CREATE DEFINER = 'root'@'localhost' PROCEDURE AdminScreen(
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
    
	BEGIN 
		IF accessAdmin IS TRUE THEN
			SELECT 'You are logged into the admin console' AS MESSAGE; 
            
            SELECT GameID AS 'GameID', COUNT(pl.GameID) AS 'PlayerCount'
			FROM tblPlayer py 
				JOIN tblPlay pl ON py.PlayerID = pl.PlayerID
			GROUP BY pl.GameID;  
            
            SELECT Username AS 'Player', HighScore AS 'HighScore' 
			FROM tblPlayer;  
		ELSE
			SELECT 'Slow down buddy, you are not an admin user' AS MESSAGE; 
		END IF;
	END;
END //
DELIMITER ;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Admin Kill Game Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- The procedure carried out an additional check to ensure the user has admin privilege and then deletes a game and all 
-- the play instances and item/game instances associated with that game. 

DROP PROCEDURE IF EXISTS KillGame;
DELIMITER //
CREATE DEFINER = 'root'@'localhost' PROCEDURE KillGame(
		IN pGameID int,
		IN pUsername varchar(10)	
    )
SQL SECURITY DEFINER

BEGIN
    DECLARE checkAdmin bit DEFAULT NULL;
  
	SELECT AccountAdmin
	FROM tblPlayer
	WHERE
		Username = pUsername 
	INTO checkAdmin;
    
	BEGIN
		IF checkAdmin IS True THEN
			DELETE FROM tblItemGame
			WHERE GameID = pGameID;
			
			DELETE FROM tblPlay
			WHERE GameID = pGameID;
			
			DELETE FROM tblGame
			WHERE GameID = pGameID;

			SELECT 'This game has been killed by Admin' AS MESSAGE; 
		ELSE
			SELECT 'No game with that ID' AS MESSAGE; 
		END IF;
	END;
END //
DELIMITER ;   

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Admin Add Player Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- An admin can use this procedure to add a player, many of the inputs are set to default and as such, there is no need
-- to alter these manually for this procedure as is the case with the new registration procedure. The only feature 
-- included is for manual input of admin status as it may be useful for admin to allocate admins at this stage, further
-- changes can be made in the update player procedure.

DROP PROCEDURE IF EXISTS AddPlayer;
DELIMITER //
CREATE DEFINER = 'root'@'localhost' PROCEDURE AddPlayer(
		IN pAdminUsername varchar(10),
		IN pEmail varchar(50), 
		IN pUsername varchar(10),
		IN pPassword BLOB,
		IN pAccountAdmin bit	
    )
SQL SECURITY DEFINER

BEGIN
    DECLARE checkAdmin bit DEFAULT NULL;
	DECLARE newSalt varchar(36);
  
	SELECT AccountAdmin
	FROM tblPlayer
	WHERE
		Username = pAdminUsername 
	INTO checkAdmin;
    
	SELECT UUID() INTO newSalt;
    
	BEGIN
		IF checkAdmin IS TRUE THEN
			INSERT INTO tblPlayer(Email, Username, `Password`, Salt, AccountAdmin) 
			VALUES (pEmail, pUsername, AES_ENCRYPT(CONCAT(newSalt, pPassword), 'Game_Key_To_Encrypt'), newSalt, pAccountAdmin);
			
			SELECT 'Youve added a new player, yippee!!!' AS MESSAGE; 
		ELSE
			SELECT 'Youve done somethig wrong, cant add this player!!!' AS MESSAGE;
		END IF;
	END;
END //
DELIMITER ;     

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Admin Update Player Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- The procedure allows an admin user to update all information pertaining to an existing player.

DROP PROCEDURE IF EXISTS UpdatePlayer;
DELIMITER //
CREATE DEFINER = 'root'@'localhost' PROCEDURE UpdatePlayer(
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
SQL SECURITY DEFINER

BEGIN
    DECLARE checkAdmin bit DEFAULT NULL;
	DECLARE newSalt varchar(36);
  
	SELECT AccountAdmin
	FROM tblPlayer
	WHERE
		Username = pAdminUsername 
	INTO checkAdmin;
    
	SELECT UUID() INTO newSalt;
	
    BEGIN
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
			SELECT 'Yay! Youve updated the player' AS MESSAGE; 
		ELSEIF EXISTS (SELECT PlayerID 
					   FROM tblPlayer 
					   WHERE 
							PlayerID = pPlayerID) 
							AND checkAdmin IS FALSE THEN
			SELECT 'Slow down buddy, you are not an admin user' AS MESSAGE; 
		ELSE 
			SELECT 'There is no account with this PlayerID' AS MESSAGE; 
		END IF;
	END;
END //
DELIMITER ;     

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Admin Delete Player Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- The procedure allows an admin user to delete all information pertaining to an existing player. The procedure deletes 
-- the player record, the play instances associated with the player and any association with item records in the 
-- item/game table.

DROP PROCEDURE IF EXISTS DeletePlayer;
DELIMITER //
CREATE DEFINER = 'root'@'localhost' PROCEDURE DeletePlayer(
		IN pAdminUsername varchar(10),
		IN pUsername varchar(10)	
    )
SQL SECURITY DEFINER

BEGIN
    DECLARE checkAdmin bit DEFAULT NULL;
  
	SELECT AccountAdmin
	FROM tblPlayer
	WHERE
		Username = pAdminUsername 
	INTO checkAdmin;
	
    BEGIN
		IF EXISTS (SELECT Username 
				   FROM tblPlayer 
				   WHERE Username = pUsername) 
				   AND checkAdmin IS TRUE THEN 
			DELETE FROM tblPlayer 
			WHERE Username = pUsername;
			SELECT 'Oh dear, I hope you were meant to delete that player - no going back now!!!' AS MESSAGE; 
		ELSEIF EXISTS (SELECT Username 
					   FROM tblPlayer 
					   WHERE Username = pUsername) 
					   AND checkAdmin IS FALSE THEN
			SELECT 'Slow down buddy, you are not an admin user' AS MESSAGE; 
		ELSE 
			SELECT 'There is no account with this username' AS MESSAGE; 
		END IF;
	END;
END //
DELIMITER ;  

-- Seven Dwarfs Gem Hunt Project Transactional SQL Milestone 2
-- CALL PROCEDURES | TEST THE GAME

	-- 	CALL CreateTables;
	-- 	CALL InsertTables;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- New User Registration Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL NewUserRegistration('NewUser_1@gmail.com', 'NewUser_1', 'P@ssword1'); -- Run test with these login credentials

	-- Add these users so there are enough players to make a full game
	CALL NewUserRegistration('NewUser_2@gmail.com', 'NewUser_2', 'P@ssword1');
	CALL NewUserRegistration('NewUser_3@gmail.com', 'NewUser_3', 'P@ssword1');
	CALL NewUserRegistration('NewUser_4@gmail.com', 'NewUser_4', 'P@ssword1');
	CALL NewUserRegistration('NewUser_5@gmail.com', 'NewUser_5', 'P@ssword1');
	CALL NewUserRegistration('NewUser_6@gmail.com', 'NewUser_6', 'P@ssword1');
	CALL NewUserRegistration('NewUser_7@gmail.com', 'NewUser_7', 'P@ssword1');

	-- Run test to check user has been added to database
	SELECT * FROM tblPlayer WHERE Username = 'NewUser_1'; 

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Login Check Credentials Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	-- Login test is based on credentials entered in registration
	CALL LoginCheckCredentials('NewUser_1', '@ssword1'); -- First test to see login attempt increment
	CALL LoginCheckCredentials('NewUser_1', '@ssword1'); -- Second test to see login attempt increment
	CALL LoginCheckCredentials('NewUser_1', '@ssword1'); -- Third test to see login attempt increment
	CALL LoginCheckCredentials('NewUser_1', '@ssword1'); -- Fourth test to see login attempt increment
	CALL LoginCheckCredentials('NewUser_1', '@ssword1'); -- Fifth test to see login attempt increment and account locked to true
	CALL LoginCheckCredentials('NewUser_1', 'P@ssword1'); -- Sixth test to see correct login attempt
	CALL LoginCheckCredentials('NewUser_1', 'P@ssword1'); -- Seventh test to check error message as user already logged in or test against first test

	-- Login remaining new players
	CALL LoginCheckCredentials('NewUser_2', 'P@ssword1');
	CALL LoginCheckCredentials('NewUser_3', 'P@ssword1');
	CALL LoginCheckCredentials('NewUser_4', 'P@ssword1');
	CALL LoginCheckCredentials('NewUser_5', 'P@ssword1');
	CALL LoginCheckCredentials('NewUser_6', 'P@ssword1');
	CALL LoginCheckCredentials('NewUser_7', 'P@ssword1');
    
	SELECT PlayerID, Username, ActiveStatus FROM tblPlayer WHERE Username = 'NewUser_1';

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Home Screen Display Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- PROCEDURE NO LONGER REQUIRED
-- 	CALL HomeScreen('NewUser_1');

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- New Game Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL NewGame('NewUser_1'); -- Run test with new player starting a game

	-- Test new game has been created in the following tables and a play instance for the player
	SELECT * from tblGame ORDER BY GameID DESC; 
	SELECT * FROM tblItemGame ORDER BY GameID DESC; 
	SELECT * FROM tblPlay ORDER BY GameID DESC;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Join Game Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	SELECT * FROM tblPlay ORDER BY PlayerID DESC; -- Find a PlayerID and GameID to join player to game
	CALL JoinGame(100003, 10); -- Test join game procedure

	-- Add remaining players 
	CALL JoinGame(100003, 11);
	CALL JoinGame(100003, 12);
	CALL JoinGame(100003, 13);
	CALL JoinGame(100003, 14);
	CALL JoinGame(100003, 15);

	-- Test player has been added to game and has the next character
	SELECT * FROM tblPlay WHERE GameID = 100003; 

	-- Test no more players can joing a game
	CALL JoinGame(100003, 2);
	SELECT * FROM tblPlay WHERE GameID = 100003; -- Test player has not been added to game

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Player Moves Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	-- Do the following checks first 
	SELECT * FROM tblGame WHERE GameID = 100003; -- Confirm that next character turn is character Doc 
	SELECT * FROM tblPlay WHERE GameID = 100003; -- Confirm playerID and tileID location for Doc, should be playerID 9 and tileID 1

	CALL MovePlayer(2, 9, 100003); -- Test procedure player cannot move to this tile
	CALL MovePlayer(32, 9, 100003); -- Displays tile colour and new tile row and column

	-- Re-run tblPlay select query to confirm player is on a new tile location
	SELECT * FROM tblPlay WHERE GameID = 100003; 

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Find Gem Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL FindGem(32, 9, 100003); -- Test procedure and check that gem or gems are listed against correct game, player, play instance and tile location
	-- IMPORTANT: RECORD THE ITEM ID & PLAY ID FROM THE TEMPORARY TABLE FOR INSERTION IN Select Gem & Update Turn PROCEDURE AND Update Highscore & End Game PROCEDURE
	-- If the error message is displayed stating there are no items on the tile, next next move procedure below will hopefully have items on the tile, 
	-- if not you may have to move more players or re-run the create table and insert into procedures and start again

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Select Gem & Update Turn Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL SelectGem(109, 500007, 9, 100003); -- IMPORTANT: Amend the first input to the correct itemID or NULL, second input to the correct playID, third input to correct playerID

	-- Do the following checks to confirm procedure success
	SELECT * FROM tblPlay WHERE PlayerID = 9; -- Check play score has updated from 0
	SELECT * FROM tblGame WHERE GameID = 100003; -- Check character turn has updated in game table
	SELECT * FROM tblItemGame WHERE GameID = 100003 AND PlayID = 500007; -- Check that item/game table has updated tile equals NULL and play equals playID

	-- If there were no items on the tile move the next character turn from the above select game ID statement
	-- Find out which player is the character turn 
	SELECT * FROM tblPlay WHERE CharacterName = 'Bashful' AND GameID = 100003;
	CALL MovePlayer(34, 10, 100003); 
	CALL FindGem(34, 10, 100003); -- Run to check if there are gems on the tile
	CALL SelectGem(NULL, 500008, 10, 100003); -- Run this to ensure player turn updates

	SELECT * FROM tblPlay WHERE CharacterName = 'Dopey' AND GameID = 100003;
	CALL MovePlayer(34, 11, 100003); -- Check this player can't move to tile 34 as previous player moved to tile 34
	CALL MovePlayer(50, 11, 100003); 
	CALL FindGem(50, 11, 100003); -- Run to check if there are gems on the tile
	CALL SelectGem(NULL, 500009, 11, 100003); -- Run this to ensure player turn updates
 	
	SELECT * FROM tblPlay WHERE CharacterName = 'Grumpy' AND GameID = 100003;
	CALL MovePlayer(42, 12, 100003); 
	CALL FindGem(42, 12, 100003); -- Run to check if there are gems on the tile
	CALL SelectGem(NULL, 500010, 12, 100003); -- Run this to ensure player turn updates

	SELECT * FROM tblPlay WHERE CharacterName = 'Happy' AND GameID = 100003;
	CALL MovePlayer(33, 13, 100003); 
	CALL FindGem(33, 13, 100003); -- Run to check if there are gems on the tile
	CALL SelectGem(102, 500011, 13, 100003); -- Run this to ensure player turn updates

	-- Now we can do some checks, if by chance the above second move yielded no items find the next character turn and do it again
	SELECT * FROM tblPlay WHERE PlayerID >= 9 AND PlayerID <= 15; -- Check play score has updated
	SELECT CharacterTurn FROM tblGame WHERE GameID = 100003; -- Check character turn has updated in game table
	SELECT * FROM tblItemGame WHERE GameID = 100003 AND PlayID = 500010; -- Check that Item has moved from tile to play

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Update High Score & End Game Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	-- Update the high score and check if game is over for player moves, input the details of the player who found gems from the 
    -- above procedure
	CALL UpdateHS_EG(500007, 9, 100003);
    
    -- Only need to be called if you had to move the player to find a gem
	CALL UpdateHS_EG(500008, 10, 100003); 
	CALL UpdateHS_EG(500009, 11, 100003);
	CALL UpdateHS_EG(500010, 12, 100003);
	CALL UpdateHS_EG(500011, 13, 100003);

	-- Check high score has updated
	SELECT PlayerID, Username, HighScore FROM tblPlayer WHERE PlayerID >= 9 AND PlayerID <= 15; 

	-- Test the end game portion of the procedure
	UPDATE tblItemGame SET TileID = NULL, PlayID = 500007 WHERE GameID = 100003; -- Update all tiles to NULL and all play instances to playID
	SELECT * FROM tblItemGame WHERE GameID = 100003; -- Test select query to confirm above update

	-- IMPORTANT: Amend the ItemID to the correct ID and insert correct tile item was found. Update the item to be back in the game play, re-run above query to check
	UPDATE tblItemGame SET TileID = 51, PlayID = NULL WHERE ItemID = 155 AND GameID = 100003; 
	SELECT * FROM tblItemGame WHERE GameID = 100003 AND TileID = 51; -- Check 1 tile now has an item left
	CALL MovePlayer(51, 14, 100003); -- Move the next player
    
    -- IMPORTANT: Amend the first input to the correct ItemID. Call SelectGem procedure again
	CALL FindGem(51, 14, 100003); 
	CALL SelectGem(155, 500012, 14, 100003); 
	CALL UpdateHS_EG(500012, 14, 100003); -- Call updateHS procedure again
    
	SELECT * FROM tblGame WHERE GameID = 100003; -- Character turn is now set to NULL as game has finished, no more items to collect

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Player Logout Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL PlayerLogout('NewUser_1');

	-- Test active status is displayed as false for player
	SELECT PlayerID, Username, ActiveStatus FROM tblPlayer WHERE Username = 'NewUser_1';
    
    -- Next player is able to move to tile 79 with player located on it as player is not active
	CALL MovePlayer(32, 15, 100003); 

	SELECT * FROM tblPlay WHERE TileID = 32; -- Test both players are on tile 

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Enter Admin Screen Procedure 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL AdminScreen('NewUser_1'); -- Not an admin user
	UPDATE tblPlayer SET AccountAdmin = 1 WHERE Username = 'NewUser_2'; -- Upgrade new user 2 to admin priviledges 
	CALL AdminScreen('NewUser_2'); -- Should now be an admin user
    
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Admin Kill Game Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL KillGame(100001, 'NewUser_2'); -- Warning message will display saying game has been killed

	-- Confirm game has been deleted
	SELECT * FROM tblGame WHERE GameID = 100001;
	SELECT * FROM tblPlay WHERE GameID = 100001;
	SELECT * FROM tblItemGAme WHERE GameID = 100001;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Admin Add Player Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL AddPlayer('NewUser_2', 'NewUser_8@gmail.com', 'NewUser_8', 'P@ssword1', 1);

	-- Confirm player has been added and has admin privileges
	SELECT * FROM tblPlayer WHERE Username = 'NewUser_8'; 

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Admin Update Player Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL UpdatePlayer('NewUser_2', 16, 'NewUser_8@gmail.com', 'NewUser_8', 'P@ssword1', 1, 0, 0, 3, 56); -- Admin NewUser_ updates player NewUser_8
	SELECT * FROM tblPlayer WHERE Username = 'NewUser_8'; -- Check procedure 

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Admin Delete Player Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL DeletePlayer('NewUser_2', 'NewUser_1'); -- Delete NewUser_1 

	-- Test records removed from relevant tables
	SELECT * FROM tblPlayer WHERE Username = 'NewUser_1'; 
	SELECT * FROM tblPlay py JOIN tblPlayer pl ON py.PlayerID = pl.PlayerID WHERE Username = 'NewUser_1'; 
	SELECT * FROM tblItemGame ig JOIN tblPlay py ON ig.PlayID = py.PlayID JOIN tblPlayer pl ON py.PlayerID = pl.PlayerID WHERE Username = 'NewUser_1';    
