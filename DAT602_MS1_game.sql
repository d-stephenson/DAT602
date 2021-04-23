-- Seven Dwarfs Gem Hunt Project Physical Design Milestone One [refer to Logical Diagram v2.2]

----------------------------------------------------------------------------------
-- Database Setup
----------------------------------------------------------------------------------

DROP DATABASE IF EXISTS sdghGameDatabase;
BEGIN;
CREATE DATABASE sdghGameDatabase;
BEGIN;
USE sdghGameDatabase;

----------------------------------------------------------------------------------
-- DDL | Making tables, indexes and checks
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS CreateTables;
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
ALTER TABLE tblPlayer ADD Salt UNIQUEIDENTIFIER;

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
TileID int DEFAULT 041 NOT NULL,
PlayScore int DEFAULT 0 NOT NULL,
PRIMARY KEY (PlayID),
CONSTRAINT FK_PlayerID_Play FOREIGN KEY (PlayerID) REFERENCES tblPlayer(PlayerID),
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
CONSTRAINT FK_PlayID_IG FOREIGN KEY (PlayID) REFERENCES tblPlay(PlayID)
);

END 
//
DELIMITER ;

----------------------------------------------------------------------------------
-- DML Inserting into tables
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS InsertTables;
CREATE PROCEDURE InsertTables() 
BEGIN

INSERT INTO tblPlayer
VALUES 
(000001, 'mstirtle0@alibaba.com', 'Bob', 'P@ssword1', TRUE, FALSE, FALSE, 0, 0),
(000002, 'cgrooby1@walmart.com', 'Jane', 'P@ssword1', TRUE, FALSE, FALSE, 0, 0),
(000003, 'abartosinski2@irs.gov', 'John', 'P@ssword1', FALSE, FALSE, FALSE, 2, 0),
(000004, 'mggghgh0@gmail.com', 'Troy', 'P@ssword1', FALSE, TRUE, FALSE, 0, 0),
(000005, 'dringm@gmx.com', 'Chris', 'P@ssword1', TRUE, FALSE, FALSE, 3, 0),
(000006, 'ythnfhhgj@frirs.gov', 'Sunny', 'P@ssword1', FALSE, FALSE, FALSE, 0, 0),
(000007, 'looijnhg0@gmail.com', 'JCP', 'P@ssword1', FALSE, TRUE, FALSE, 0, 0),
(000008, 'frigsngjj@gmx.com', 'Junior', 'P@ssword1', TRUE, FALSE, FALSE, 0, 0);

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
(137, 100001, 001, NULL),
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
(137, 100002, 001, NULL),
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

----------------------------------------------------------------------------------
-- Call Create, Insert Procedures
----------------------------------------------------------------------------------

CALL CreateTables;
CALL InsertTables;

----------------------------------------------------------------------------------
-- Transaction Update tblPlayer
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS UpdatePlayerUsername;
CREATE PROCEDURE UpdatePlayerUsername( pUsername varchar(10), pPlayerID int )
BEGIN
	SET SQL_SAFE_UPDATES = 0; 

	UPDATE tblPlayer
	SET Username = pUsername
	WHERE PlayerID = pPlayerID;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Update tblCharacter
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS UpdateCharacterColour;
CREATE PROCEDURE UpdateCharacterColour( pTileColour varchar(10), pCharacterName varchar(10) )
BEGIN
	SET SQL_SAFE_UPDATES = 0; 

	UPDATE tblCharacter
	SET TileColour = pTileColour 
	WHERE CharacterName = pCharacterName;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Update tblGem
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS UpdateGemPoints;
CREATE PROCEDURE UpdateGemPoints( pGemType varchar(10), pPoints tinyint )
BEGIN
	SET SQL_SAFE_UPDATES = 0; 

	UPDATE tblGem
	SET Points = pPoints
	WHERE GemType = pGemType;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Update tblTile
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS UpdateTileLocation;
CREATE PROCEDURE UpdateTileLocation( pTileID int, pTileRow varchar(2), pTileColumn tinyint )
BEGIN
	SET SQL_SAFE_UPDATES = 0; 

	UPDATE tblTile
	SET TileRow  = pTileRow, TileColumn = pTileColumn 
	WHERE TileID = pTileID;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Update tblBoard
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS UpdateBoardSize;
CREATE PROCEDURE UpdateBoardSize( pBoardType varchar(20), pXAxis tinyint, pYAxis tinyint )
BEGIN
	SET SQL_SAFE_UPDATES = 0; 

	UPDATE tblBoard
	SET XAxis = pXAxis, YAxis = pYAxis
	WHERE BoardType = pBoardType;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Update tblBoardTile 
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS UpdateBoardTile;
CREATE PROCEDURE UpdateBoardTile( pBoardType varchar(20), pTileID int )
BEGIN
	SET SQL_SAFE_UPDATES = 0; 

	UPDATE tblBoardTile 
	SET TileID = pTileID
	WHERE BoardType = pBoardType;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Update tblGame
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS UpdateCharacterTurn;
CREATE PROCEDURE UpdateCharacterTurn( pGameID int, pCharacterTurn varchar(10) )
BEGIN
	SET SQL_SAFE_UPDATES = 0; 

	UPDATE tblGame
	SET CharacterTurn = pCharacterTurn
	WHERE GameID = pGameID;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Update tblPlay
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS UpdatePlayCharacter;
CREATE PROCEDURE UpdatePlayCharacter( pPlayID int, pCharacterName varchar(10) )
BEGIN
	SET SQL_SAFE_UPDATES = 0; 

	UPDATE tblPlay
	SET CharacterName = pCharacterName
	WHERE PlayID = pPlayID;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Update tblItem
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS UpdateItemGemType;
CREATE PROCEDURE UpdateItemGemType( pItemID int, pGemType varchar(10) )
BEGIN
	SET SQL_SAFE_UPDATES = 0; 

	UPDATE tblItem
	SET GemType = pGemType 
	WHERE ItemID = pItemID;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Update tblItemGame
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS UpdateItemTile;
CREATE PROCEDURE UpdateItemTile( pItemID int, pGameID int, pTileID int )
BEGIN
	SET SQL_SAFE_UPDATES = 0; 

	UPDATE tblItemGame
	SET TileID = pTileID
	WHERE ItemID = pItemID AND GameID = pGameID;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Select tblPlayer
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS SelectAccountStatus;
CREATE PROCEDURE SelectAccountStatus( pEmail varchar(50) )
BEGIN
	SELECT PlayerID AS 'Player Ref', Username AS 'Player Name', ActiveStatus AS 'Account Status'
 	FROM tblPlayer
	WHERE Email = pEmail;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Select tblCharacter
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS SelectCharacterName;
CREATE PROCEDURE SelectCharacterName( pTileColour varchar(10) )
BEGIN
	SELECT CharacterName AS 'Character Name'
 	FROM tblCharacter
	WHERE TileColour = pTileColour;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Select tblGem
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS SelectGemPoints;
CREATE PROCEDURE SelectGemPoints( pGemType varchar(10) )
BEGIN
	SELECT GemType AS 'Gem', Points AS 'Gem Points'
 	FROM tblGem
	WHERE GemType = pGemType;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Select tblTile
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS SelectTileID;
CREATE PROCEDURE SelectTileID( pTileID int )
BEGIN
	SELECT TileID AS 'Tile Ref', TileRow AS 'Rown Location', TileColumn AS 'Tile Location'
 	FROM tblTile
	WHERE TileID = pTileID;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Select tblBoard
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS SelectBoardAxis;
CREATE PROCEDURE SelectBoardAxis( pXAxis tinyint )
BEGIN
	SELECT BoardType AS 'Board Description', XAxis AS 'X Axis', YAxis AS 'Y Axis'
 	FROM tblBoard
	WHERE XAxis = pXAxis;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Select tblBoardTile
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS SelectTileBoard;
CREATE PROCEDURE SelectTileBoard( pTileID int )
BEGIN
	SELECT BoardType AS 'Board Description', TileID AS 'Tile Ref'
 	FROM tblBoardTile
	WHERE TileID = pTileID;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Select tblGame
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS SelectGameTurn;
CREATE PROCEDURE SelectGameTurn( pCharacterTurn varchar(10) )
BEGIN
	SELECT GameID AS 'Game Ref', BoardType AS 'Board Description', CharacterTurn AS 'Next Turn'
 	FROM tblGame
	WHERE CharacterTurn = pCharacterTurn;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Select tblPlay
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS SelectTheScore;
CREATE PROCEDURE SelectTheScore( pCharacterName varchar(10), pGameID int )
BEGIN
	SELECT GameID AS 'Game Ref', CharacterName AS 'Character Name', PlayerID AS 'Player Ref', PlayScore AS 'Game Score'
 	FROM tblPlay
	WHERE CharacterName = pCharacterName AND GameID = pGameID;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Select tblItem
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS SelectTypeOfGem;
CREATE PROCEDURE SelectTypeOfGem( pItemID int )
BEGIN
	SELECT ItemID AS 'Item Ref', GemType AS 'Gem'
 	FROM tblItem
	WHERE ItemID = pItemID;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Select tblItemGame
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS SelectItemLocation;
CREATE PROCEDURE SelectItemLocation( pItemID int, pGameID int )
BEGIN
	SELECT ItemID AS 'Item Ref', GameID AS 'Game Ref', TileID AS 'Tile Ref'
 	FROM tblItemGame
	WHERE ItemID = pItemID AND GameID = pGameID;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Delete tblItemGame
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS DeleteItemGame;
CREATE PROCEDURE DeleteItemGame()
BEGIN
	SET SQL_SAFE_UPDATES = 0; 
    
    DELETE FROM tblItemGame;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Delete tblItem
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS DeleteItem;
CREATE PROCEDURE DeleteItem()
BEGIN
	SET SQL_SAFE_UPDATES = 0; 
    
    DELETE FROM tblItem;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Delete tblPlay
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS DeletePlay;
CREATE PROCEDURE DeletePlay( pPlayID int )
BEGIN
	SET SQL_SAFE_UPDATES = 0; 
    
    DELETE FROM tblPlay
	WHERE PlayID = PlayID;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Delete tblGame
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS DeleteGame;
CREATE PROCEDURE DeleteGame( pGameID int )
BEGIN
	SET SQL_SAFE_UPDATES = 0; 
    
    DELETE FROM tblGame
	WHERE GameID = GameID;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Delete tblBoardTile
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS DeleteBoardTile;
CREATE PROCEDURE DeleteBoardTile()
BEGIN
	SET SQL_SAFE_UPDATES = 0; 
    
    DELETE FROM tblBoardTile;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Delete tblBoard
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS DeleteBoard;
CREATE PROCEDURE DeleteBoard( pBoardType varchar(20) )
BEGIN
	SET SQL_SAFE_UPDATES = 0; 
    
    DELETE FROM tblBoard
	WHERE BoardType = pBoardType;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Delete tblTile
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS DeleteTile;
CREATE PROCEDURE DeleteTile( pTileID int )
BEGIN
	SET SQL_SAFE_UPDATES = 0; 
    
    DELETE FROM tblTile
	WHERE TileID = pTileID;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Delete tblGem
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS DeleteGem;
CREATE PROCEDURE DeleteGem( pGemType varchar(10) )
BEGIN
	SET SQL_SAFE_UPDATES = 0; 
    
    DELETE FROM tblGem
    WHERE GemType = pGemType;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Delete tblCharacter
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS DeleteCharacter;
CREATE PROCEDURE DeleteCharacter( pCharacterName varchar(10) )
BEGIN
	SET SQL_SAFE_UPDATES = 0; 
    
    DELETE FROM tblCharacter
    WHERE CharacterName = pCharacterName;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Transaction Delete tblPlayer
----------------------------------------------------------------------------------

DELIMITER //
DROP PROCEDURE IF EXISTS DeletePlayer;
CREATE PROCEDURE DeletePlayer( pUsername varchar(10) )
BEGIN
	SET SQL_SAFE_UPDATES = 0; 
    
    DELETE FROM tblPlayer
    WHERE Username = pUsername;
END
//
DELIMITER ;

----------------------------------------------------------------------------------
-- Call Update, Select, Delete Procedures
----------------------------------------------------------------------------------

CALL UpdatePlayerUsername('Timmy', 000007);
CALL UpdateCharacterColour('Pink', 'Sleepy');
CALL UpdateGemPoints('Pearl', 9);
CALL UpdateTileLocation(055, 'AB', 9);
CALL UpdateBoardSize('9 X 9 Sq', 11, 11);
CALL UpdateBoardTile('11 X 11 Sq', 055);
CALL UpdateCharacterTurn(100001, 'Grumpy');
CALL UpdatePlayCharacter(500005, 'Sleepy');
CALL UpdateItemGemType(143, 'Emerald');
CALL UpdateItemTile(157, 100002, 015);

CALL SelectAccountStatus('cgrooby1@walmart.com');
CALL SelectCharacterName('Red');
CALL SelectGemPoints('Diamond');
CALL SelectTileID(056);
CALL SelectBoardAxis(11);
CALL SelectTileBoard(019);
CALL SelectGameTurn('Doc');
CALL SelectTheScore('Doc', 100001);
CALL SelectTypeOfGem(111);
CALL SelectItemLocation(134, 100001);

CALL DeleteItemGame();
CALL DeleteItem();
CALL DeletePlay(500002);
CALL DeleteGame(100001);
CALL DeleteBoardTile();
CALL DeleteBoard('9 X 9 Sq');
CALL DeleteTile(025);
CALL DeleteGem('Pearl');
CALL DeleteCharacter('Doc');
CALL DeletePlayer('Junior');