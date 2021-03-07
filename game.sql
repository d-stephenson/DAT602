-- Seven Dwarfs Gem Hunt Project Physical Design SQL model v1.0 [refer to Logical Diagram v1.1]

-- Database Setup

USE gameDatabase;

-- DDL | Making tables, indexes and checks

DELIMITER //
DROP PROCEDURE IF EXISTS CreateTables;
CREATE PROCEDURE CreateTables()
BEGIN

DROP TABLE IF EXISTS tblPlay;
DROP TABLE IF EXISTS tblBoardTile;
DROP TABLE IF EXISTS tblItemLocation;
DROP TABLE IF EXISTS tblInventory;
DROP TABLE IF EXISTS tblGameCharacter;
DROP TABLE IF EXISTS tblGame;
DROP TABLE IF EXISTS tblBoard;
DROP TABLE IF EXISTS tblItem;
DROP TABLE IF EXISTS tblTile;
DROP TABLE IF EXISTS tblGem;
DROP TABLE IF EXISTS tblCharacter;
DROP TABLE IF EXISTS tblPlayer;

CREATE TABLE tblPlayer (
PlayerID int AUTO_INCREMENT,
Email varchar(50) NOT NULL,
Username varchar(10) NOT NULL,
AccountAdmin bit NOT NULL,
AccountLocked bit NOT NULL,
ActiveStatus bit NOT NULL,
FailedLogins tinyint NOT NULL,
Highscore tinyint NOT NULL, 
CONSTRAINT CHK_Email CHECK (Email Like '_%@_%._%'),
PRIMARY KEY (PlayerID)
);

ALTER TABLE tblPlayer AUTO_INCREMENT=000001;

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
TileRow varchar(2) NOT NULL,
TileColumn tinyint NOT NULL,
HomeTile bit,
PRIMARY KEY (TileID)
);

ALTER TABLE tblTile AUTO_INCREMENT=001;

CREATE TABLE tblItems (
ItemID int AUTO_INCREMENT,
GemType varchar(10) NOT NULL,
PRIMARY KEY (ItemID),
CONSTRAINT FK_GemType_Items FOREIGN KEY (GemType) REFERENCES tblGem(GemType)
);

ALTER TABLE tblItems AUTO_INCREMENT=001;

CREATE TABLE tblBoard (
BoardType varchar(20) NOT NULL,
PRIMARY KEY (BoardType)
);

CREATE TABLE tblGame (
GameID int AUTO_INCREMENT,
BoardType varchar(20) NOT NULL,
PlayerCount tinyint NOT NULL,
PlayerTurn varchar(10),
PRIMARY KEY (GameID),
CONSTRAINT FK_BoardType_Game FOREIGN KEY (BoardType) REFERENCES tblBoard(BoardType),
);

ALTER TABLE tblGame AUTO_INCREMENT=000001;

CREATE TABLE tblGameCharacter (
GameID int NOT NULL,
CharacterName int NOT NULL,
CONSTRAINT PK_GameCharacter PRIMARY KEY (GameID, CharacterName),
CONSTRAINT FK_GameID_GC FOREIGN KEY (GameID) REFERENCES tblGame(GameID),
CONSTRAINT FK_CharacterName_GC FOREIGN KEY (CharacterName) REFERENCES tblCharacter(CharacterName),
);

CREATE TABLE tblInventory (
GameID int NOT NULL,
CharacterName int NOT NULL,
ItemID int NOT NULL,
CONSTRAINT PK_Inventory PRIMARY KEY (GameID, CharacterName, ItemID),
CONSTRAINT FK_GameID_Inv FOREIGN KEY (GameID) REFERENCES tblGame(GameID),
CONSTRAINT FK_CharacterName_Play FOREIGN KEY (CharacterName) REFERENCES tblCharacter(CharacterName),
CONSTRAINT FK_ItemID_Inv FOREIGN KEY (ItemID) REFERENCES tblItem(ItemID)
);

CREATE TABLE tblItemLocation (
ItemID int NOT NULL,
TileID int NOT NULL,
CONSTRAINT PK_ItemLocation PRIMARY KEY (ItemID, TileID),
CONSTRAINT FK_ItemID_IL FOREIGN KEY (ItemID) REFERENCES tblItem(ItemID),
CONSTRAINT FK_TileID_IL FOREIGN KEY (TileID) REFERENCES tblTile(TileID)
);

CREATE TABLE tblBoardTile (
BoardType varchar(20) NOT NULL,
TileID int NOT NULL,
CONSTRAINT PK_ItemLocation PRIMARY KEY (BoardType, TileID),
CONSTRAINT FK_BoardType_BT FOREIGN KEY (BoardType) REFERENCES tblBoard(BoardType),
CONSTRAINT FK_TileID_BT FOREIGN KEY (TileID) REFERENCES tblTile(TileID)
);

CREATE TABLE tblPlay (
GameID int NOT NULL,
CharacterName varchar(10) NOT NULL,
PlayerID int,
TileID int NOT NULL,
GamePoints int NOT NULL,
CONSTRAINT PK_Play PRIMARY KEY (GameID, CharacterName),
CONSTRAINT FK_GameID_Play FOREIGN KEY (GameID) REFERENCES tblGame(GameID),
CONSTRAINT FK_CharacterName_Play FOREIGN KEY (CharacterName) REFERENCES tblCharacter(CharacterName),
CONSTRAINT FK_PlayerID_Play FOREIGN KEY (PlayerID) REFERENCES tblPlayer(PlayerID),
CONSTRAINT FK_TileID_Play FOREIGN KEY (TileID) REFERENCES tblTile(TileID)
);

END
//
DELIMITER ;

-- DML Inserting into tables

DELIMITER //
DROP PROCEDURE IF EXISTS InsertTables;
CREATE PROCEDURE InsertTables() 
BEGIN

INSERT INTO tblPlayer
VALUES 
(000001, 'mstirtle0@alibaba.com', 'Bob', TRUE, FALSE, FALSE, 0, 0),
(000002, 'cgrooby1@walmart.com', 'Jane', TRUE, FALSE, FALSE, 0, 0),
(000003, 'abartosinski2@irs.gov', 'John', FALSE, FALSE, FALSE, 0, 0)
(000004, 'mggghgh0@gmail.com', 'Troy', TRUE, FALSE, FALSE, 0, 0),
(000005, 'dringm@gmx.com', 'Chris', TRUE, FALSE, FALSE, 0, 0);

CREATE TABLE tblCharacter (
CharacterName varchar(10) NOT NULL,
TileColour varchar(10) NOT NULL,
PRIMARY KEY (CharacterName)
);

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
(001, 'A', 1, FALSE),
(002, 'B', 1, FALSE),
(003, 'C', 1, FALSE),
(004, 'D', 1, FALSE),
(005, 'E', 1, FALSE),
(006, 'F', 1, FALSE),
(007, 'G', 1, FALSE),
(008, 'H', 1, FALSE),
(009, 'I', 1, FALSE),
(010, 'A', 2, FALSE),
(011, 'B', 2, FALSE),
(012, 'C', 2, FALSE),
(013, 'D', 2, FALSE),
(014, 'E', 2, FALSE),
(015, 'F', 2, FALSE),
(016, 'G', 2, FALSE),
(017, 'H', 2, FALSE),
(018, 'I', 2, FALSE),
(019, 'A', 3, FALSE),
(020, 'B', 3, FALSE),
(021, 'C', 3, FALSE),
(022, 'D', 3, FALSE),
(023, 'E', 3, FALSE),
(024, 'F', 3, FALSE),
(025, 'G', 3, FALSE),
(026, 'H', 3, FALSE),
(027, 'I', 3, FALSE),
(028, 'A', 4, FALSE),
(029, 'B', 4, FALSE),
(030, 'C', 4, FALSE),
(031, 'D', 4, FALSE),
(032, 'E', 4, FALSE),
(033, 'F', 4, FALSE),
(034, 'G', 4, FALSE),
(035, 'H', 4, FALSE),
(036, 'I', 4, FALSE),
(037, 'A', 5, FALSE),
(038, 'B', 5, FALSE),
(039, 'C', 5, FALSE),
(040, 'D', 5, FALSE),
(041, 'E', 5, TRUE),
(042, 'F', 5, FALSE),
(043, 'G', 5, FALSE),
(044, 'H', 5, FALSE),
(045, 'I', 5, FALSE),
(046, 'A', 6, FALSE),
(047, 'B', 6, FALSE),
(048, 'C', 6, FALSE),
(049, 'D', 6, FALSE),
(050, 'E', 6, FALSE),
(051, 'F', 6, FALSE),
(052, 'G', 6, FALSE),
(053, 'H', 6, FALSE),
(054, 'I', 6, FALSE),
(055, 'A', 7, FALSE),
(056, 'B', 7, FALSE),
(057, 'C', 7, FALSE),
(058, 'D', 7, FALSE),
(059, 'E', 7, FALSE),
(060, 'F', 7, FALSE),
(061, 'G', 7, FALSE),
(062, 'H', 7, FALSE),
(063, 'I', 7, FALSE),
(064, 'A', 8, FALSE),
(065, 'B', 8, FALSE),
(066, 'C', 8, FALSE),
(067, 'D', 8, FALSE),
(068, 'E', 8, FALSE),
(069, 'F', 8, FALSE),
(070, 'G', 8, FALSE),
(071, 'H', 8, FALSE),
(072, 'I', 8, FALSE),
(073, 'A', 9, FALSE),
(074, 'B', 9, FALSE),
(075, 'C', 9, FALSE),
(076, 'D', 9, FALSE),
(077, 'E', 9, FALSE),
(078, 'F', 9, FALSE),
(079, 'G', 9, FALSE),
(080, 'H', 9, FALSE),
(081, 'I', 9, FALSE);

INSERT INTO tblItems
VALUES 
(001, 'Garnet'),
(002, 'Garnet'),
(003, 'Garnet'),
(004, 'Garnet'),
(005, 'Garnet'),
(006, 'Garnet'),
(007, 'Garnet'),
(008, 'Amethyst'),
(009, 'Amethyst'),
(010, 'Amethyst'),
(011, 'Amethyst'),
(012, 'Amethyst'),
(013, 'Amethyst'),
(014, 'Amethyst'),
(015, 'Aquamarine'),
(016, 'Aquamarine'),
(017, 'Aquamarine'),
(018, 'Aquamarine'),
(019, 'Aquamarine'),
(020, 'Aquamarine'),
(021, 'Aquamarine'),
(022, 'Diamond'),
(023, 'Diamond'),
(024, 'Diamond'),
(025, 'Diamond'),
(026, 'Diamond'),
(027, 'Diamond'),
(028, 'Diamond'),
(029, 'Emerald'),
(030, 'Emerald'),
(031, 'Emerald'),
(032, 'Emerald'),
(033, 'Emerald'),
(034, 'Emerald'),
(035, 'Emerald'),
(036, 'Pearl'),
(037, 'Pearl'),
(038, 'Pearl'),
(039, 'Pearl'),
(040, 'Pearl'),
(041, 'Pearl'),
(042, 'Pearl'),
(043, 'Ruby'),
(044, 'Ruby'),
(045, 'Ruby'),
(046, 'Ruby'),
(047, 'Ruby'),
(048, 'Ruby'),
(049, 'Ruby'),
(050, 'Peridot'),
(051, 'Peridot'),
(052, 'Peridot'),
(053, 'Peridot'),
(054, 'Peridot'),
(055, 'Peridot'),
(056, 'Peridot'),
(057, 'Sapphire'),
(058, 'Sapphire'),
(059, 'Sapphire'),
(060, 'Sapphire'),
(061, 'Sapphire'),
(062, 'Sapphire'),
(063, 'Sapphire'),
(064, 'Opel'),
(065, 'Opel'),
(066, 'Opel'),
(067, 'Opel'),
(068, 'Opel'),
(069, 'Opel'),
(070, 'Opel');

INSERT INTO tblBoard
VALUES 
('9 X 9 Sq');

INSERT INTO tblGame
VALUES 
(000001, '9 X 9 Sq', 3, 'Bob'),
(000002, '9 X 9 Sq', 2, 'Jane');

INSERT INTO tblInventory
VALUES 
(000001, 000001, 067),
(000002, 000002, 001),
(000002, 000003, 009),
(000001, 000004, 025),
(000001, 000005, 057);

INSERT INTO tblItemLocation
VALUES 
(001, 033),
(002, 015),
(003, 016),
(004, 015),
(005, 081),
(006, 081),
(007, 021),
(008, 031),
(009, 042),
(010, 022),
(011, 023),
(012, 024),
(013, 051),
(014, 061),
(015, 071),
(016, 052),
(017, 053),
(018, 054),
(019, 054),
(020, 033),
(021, 044),
(022, 055),
(023, 066),
(024, 077),
(025, 079),
(026, 069),
(027, 059),
(028, 049),
(029, 039),
(030, 029),
(031, 019),
(032, 009),
(033, 005),
(034, 011),
(035, 011),
(036, 056),
(037, 046),
(038, 036),
(039, 026),
(040, 026),
(041, 036),
(042, 047),
(043, 049),
(044, 075),
(045, 065),
(046, 080),
(047, 020),
(048, 030),
(049, 050),
(050, 060),
(051, 065),
(052, 070),
(053, 037),
(054, 004),
(055, 016),
(056, 067),
(057, 063),
(058, 058),
(059, 056),
(060, 012),
(061, 002),
(062, 001),
(063, 043),
(064, 046),
(065, 059),
(066, 077),
(067, 078),
(068, 028),
(069, 028),
(070, 007);

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

INSERT INTO tblPlay
VALUES 
(000001, 'Doc', 000001, 078, 3),
(000002, 'Doc', 000002, 033, 49),
(000002, 'Grumpy', 000003, 042, 21),
(000001, 'Grumpy', 000004, 079, 38),
(000001, 'Sleepy', 000005, 063, 11);

END
//
DELIMITER ;

CALL CreateTables;
CALL InsertTables;