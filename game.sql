-- Seven Dwarfs Gem Hunt Project Physical Design [refer to Logical Diagram v2.1]

-- Database Setup

DROP DATABASE IF EXISTS gameDatabase;
BEGIN
CREATE DATABASE gameDatabase;
BEGIN
USE gameDatabase;

-- DDL | Making tables, indexes and checks

DELIMITER //
DROP PROCEDURE IF EXISTS CreateTables;
CREATE PROCEDURE CreateTables()
BEGIN

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
AccountAdmin bit NOT NULL,
AccountLocked bit NOT NULL,
ActiveStatus bit NOT NULL,
FailedLogins tinyint NOT NULL,
HighScore tinyint NOT 
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

CREATE TABLE tblBoard (
BoardType varchar(20) NOT NULL,
XAxis tinyint NOT NULL,
YAxis tinyint NOT NULL,
PRIMARY KEY (BoardType)
);

CREATE TABLE tblBoardTile (
BoardType varchar(20) NOT NULL,
TileID int NOT NULL,
CONSTRAINT PK_ItemLocation PRIMARY KEY (BoardType, TileID),
CONSTRAINT FK_BoardType_BT FOREIGN KEY (BoardType) REFERENCES tblBoard(BoardType),
CONSTRAINT FK_TileID_BT FOREIGN KEY (TileID) REFERENCES tblTile(TileID)
);

CREATE TABLE tblGame (
GameID int AUTO_INCREMENT,
BoardType varchar(20) NOT NULL,
CharacterTurn varchar(10),
PRIMARY KEY (GameID),
CONSTRAINT FK_BoardType_Game FOREIGN KEY (BoardType) REFERENCES tblBoard(BoardType),
);

ALTER TABLE tblGame AUTO_INCREMENT=100001;

CREATE TABLE tblPlay (
PlayID int AUTO_INCREMENT,
PlayerID int NOT NULL,
CharacterName varchar(10) NOT NULL,
GameID int NOT NULL,
TileID int NOT NULL,
PlayScore int NOT NULL,
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
GameID int NOT NULL,
TileID int,
PlayID int,
PRIMARY KEY (ItemID),
CONSTRAINT FK_GemType_Items FOREIGN KEY (GemType) REFERENCES tblGem(GemType),
CONSTRAINT FK_GameID_Items FOREIGN KEY (GameID) REFERENCES tblGame(GameID),
CONSTRAINT FK_TileID_Items FOREIGN KEY (TileID) REFERENCES tblTile(TileID),
CONSTRAINT FK_PlayID_Items FOREIGN KEY (PlayID) REFERENCES tblPlayer(PlayID)
);

ALTER TABLE tblItem AUTO_INCREMENT=101;

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
(000001, 'mstirtle0@alibaba.com', 'Bob', 'P@ssword1', TRUE, FALSE, FALSE, 0, 0),
(000002, 'cgrooby1@walmart.com', 'Jane', 'P@ssword1', TRUE, FALSE, FALSE, 0, 0),
(000003, 'abartosinski2@irs.gov', 'John', 'P@ssword1', FALSE, FALSE, FALSE, 0, 0),
(000004, 'mggghgh0@gmail.com', 'Troy', 'P@ssword1', FALSE, FALSE, FALSE, 0, 0),
(000005, 'dringm@gmx.com', 'Chris', 'P@ssword1', TRUE, FALSE, FALSE, 0, 0);

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
(500005, 000003, 'Grumpy', 100002, 042, 21);

INSERT INTO tblItem
VALUES 
(101, 'Garnet', 100002, 051, NULL),
(102, 'Garnet', 100002, 031, NULL),
(103, 'Garnet', 100002, 021, NULL),
(104, 'Garnet', 100002, 011, NULL),
(105, 'Garnet', 100002, 051, NULL),
(106, 'Garnet', 100002, 031, NULL),
(107, 'Garnet', 100002, 021, NULL),
(108, 'Amethyst', 100002, 011, NULL),
(109, 'Amethyst', 100002, 061, NULL),
(110, 'Amethyst', 100002, 071, NULL),
(111, 'Amethyst', 100002, 081, NULL),
(112, 'Amethyst', 100002, 012, NULL),
(113, 'Amethyst', 100002, 013, NULL),
(114, 'Amethyst', 100002, 014, NULL),
(115, 'Aquamarine', 100002, 022, NULL),
(116, 'Aquamarine', 100002, 023, NULL),
(117, 'Aquamarine', 100002, 024, NULL),
(118, 'Aquamarine', 100002, 015, NULL),
(119, 'Aquamarine', 100002, 016, NULL),
(120, 'Aquamarine', 100002, 017, NULL),
(121, 'Aquamarine', 100002, 018, NULL),
(122, 'Diamond', 100002, 018, NULL),
(123, 'Diamond', 100002, 076, NULL),
(124, 'Diamond', 100002, 077, NULL),
(125, 'Diamond', 100002, 078, NULL),
(126, 'Diamond', 100002, 079, NULL),
(127, 'Diamond', 100002, 076, NULL),
(128, 'Diamond', 100002, 071, NULL),
(129, 'Emerald', 100002, 075, NULL),
(130, 'Emerald', 100002, 075, NULL),
(131, 'Emerald', 100002, 034, NULL),
(132, 'Emerald', 100002, 035, NULL),
(133, 'Emerald', 100002, 051, NULL),
(134, 'Emerald', 100002, 005, NULL),
(135, 'Emerald', 100002, 052, NULL),
(136, 'Pearl', 100002, 080, NULL),
(137, 'Pearl', 100002, 070, NULL),
(138, 'Pearl', 100002, 001, NULL),
(139, 'Pearl', 100002, 070, NULL),
(140, 'Pearl', 100002, 022, NULL),
(141, 'Pearl', 100002, 054, NULL),
(142, 'Pearl', 100002, 046, NULL),
(143, 'Ruby', 100002, 056, NULL),
(144, 'Ruby', 100002, 057, NULL),
(145, 'Ruby', 100002, 058, NULL),
(146, 'Ruby', 100002, 059, NULL),
(147, 'Ruby', 100002, 045, NULL),
(148, 'Ruby', 100002, 044, NULL),
(149, 'Ruby', 100002, 043, NULL),
(150, 'Peridot', 100002, 042, NULL),
(151, 'Peridot', 100002, 043, NULL),
(152, 'Peridot', 100002, 067, NULL),
(153, 'Peridot', 100002, 079, NULL),
(154, 'Peridot', 100002, 079, NULL),
(155, 'Peridot', 100002, 078, NULL),
(156, 'Peridot', 100002, 023, NULL),
(157, 'Sapphire', 100002, 002, NULL),
(158, 'Sapphire', 100002, 003, NULL),
(159, 'Sapphire', 100002, 004, NULL),
(160, 'Sapphire', 100002, 005, NULL),
(161, 'Sapphire', 100002, 004, NULL),
(162, 'Sapphire', 100002, 005, NULL),
(163, 'Sapphire', 100002, 015, NULL),
(164, 'Opel', 100002, 014, NULL),
(165, 'Opel', 100002, 013, NULL),
(166, 'Opel', 100002, 058, NULL),
(167, 'Opel', 100002, 080, NULL),
(168, 'Opel', 100002, 040, NULL),
(169, 'Opel', 100002, 042, NULL),
(170, 'Opel', 100002, 034, NULL);

END
//
DELIMITER ;

CALL CreateTables;
CALL InsertTables;