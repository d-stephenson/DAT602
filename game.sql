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
PlayerPassword varchar(15) NOT NULL,
AccountAdmin bit NOT NULL,
AccountLocked bit NOT NULL,
ActiveStatus bit NOT NULL,
FailedLogins tinyint NOT NULL,
HighScore int NOT 
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
TileID int,
PlayID int,
PRIMARY KEY (ItemID),
CONSTRAINT FK_GemType_Item FOREIGN KEY (GemType) REFERENCES tblGem(GemType),
CONSTRAINT FK_TileID_Item FOREIGN KEY (TileID) REFERENCES tblTile(TileID),
CONSTRAINT FK_PlayID_Item FOREIGN KEY (PlayID) REFERENCES tblPlayer(PlayID)
);

ALTER TABLE tblItem AUTO_INCREMENT=101;

CREATE TABLE tblItemGame (
ItemID int NOT NULL,
GameID int NOT NULL,
CONSTRAINT PK_ItemGame PRIMARY KEY (ItemID, GameID),
CONSTRAINT FK_ItemID_IG FOREIGN KEY (ItemID) REFERENCES tblItem(ItemID),
CONSTRAINT FK_GameID_IG FOREIGN KEY (GameID) REFERENCES tblGame(GameID)
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
(000001, 'mstirtle0@alibaba.com', 'Bob', 'P@ssword1', TRUE, FALSE, FALSE, 0, 0),
(000002, 'cgrooby1@walmart.com', 'Jane', 'P@ssword1', TRUE, FALSE, FALSE, 0, 0),
(000003, 'abartosinski2@irs.gov', 'John', 'P@ssword1', FALSE, FALSE, FALSE, 0, 0),
(000004, 'mggghgh0@gmail.com', 'Troy', 'P@ssword1', FALSE, FALSE, FALSE, 0, 0),
(000005, 'dringm@gmx.com', 'Chris', 'P@ssword1', TRUE, FALSE, FALSE, 0, 0),
(000006, 'ythnfhhgj@frirs.gov', 'Sunny', 'P@ssword1', FALSE, FALSE, FALSE, 0, 0),
(000007, 'looijnhg0@gmail.com', 'JCP', 'P@ssword1', FALSE, FALSE, FALSE, 0, 0),
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
(101, 'Garnet', 051, NULL),
(102, 'Garnet', 031, NULL),
(103, 'Garnet', 021, NULL),
(104, 'Garnet', 011, NULL),
(105, 'Garnet', 051, NULL),
(106, 'Garnet', 031, NULL),
(107, 'Garnet', 021, NULL),
(108, 'Amethyst', 011, NULL),
(109, 'Amethyst', 061, NULL),
(110, 'Amethyst', 071, NULL),
(111, 'Amethyst', 081, NULL),
(112, 'Amethyst', 012, NULL),
(113, 'Amethyst', 013, NULL),
(114, 'Amethyst', 014, NULL),
(115, 'Aquamarine', 022, NULL),
(116, 'Aquamarine', 023, NULL),
(117, 'Aquamarine', 024, NULL),
(118, 'Aquamarine', 015, NULL),
(119, 'Aquamarine', 016, NULL),
(120, 'Aquamarine', 017, NULL),
(121, 'Aquamarine', 018, NULL),
(122, 'Diamond', 018, NULL),
(123, 'Diamond', 076, NULL),
(124, 'Diamond', 077, NULL),
(125, 'Diamond', 078, NULL),
(126, 'Diamond', 079, NULL),
(127, 'Diamond', 076, NULL),
(128, 'Diamond', 071, NULL),
(129, 'Emerald', 075, NULL),
(130, 'Emerald', 075, NULL),
(131, 'Emerald', 034, NULL),
(132, 'Emerald', 035, NULL),
(133, 'Emerald', 051, NULL),
(134, 'Emerald', 005, NULL),
(135, 'Emerald', 052, NULL),
(136, 'Pearl', 080, NULL),
(137, 'Pearl', 070, NULL),
(138, 'Pearl', 001, NULL),
(139, 'Pearl', 070, NULL),
(140, 'Pearl', 022, NULL),
(141, 'Pearl', 054, NULL),
(142, 'Pearl', 046, NULL),
(143, 'Ruby', 056, NULL),
(144, 'Ruby', 057, NULL),
(145, 'Ruby', 058, NULL),
(146, 'Ruby', 059, NULL),
(147, 'Ruby', 045, NULL),
(148, 'Ruby', 044, NULL),
(149, 'Ruby', 043, NULL),
(150, 'Peridot', 042, NULL),
(151, 'Peridot', 043, NULL),
(152, 'Peridot', 067, NULL),
(153, 'Peridot', 079, NULL),
(154, 'Peridot', 079, NULL),
(155, 'Peridot', 078, NULL),
(156, 'Peridot', 023, NULL),
(157, 'Sapphire', 002, NULL),
(158, 'Sapphire', 003, NULL),
(159, 'Sapphire', 004, NULL),
(160, 'Sapphire', 005, NULL),
(161, 'Sapphire', 004, NULL),
(162, 'Sapphire', 005, NULL),
(163, 'Sapphire', 015, NULL),
(164, 'Opel', 014, NULL),
(165, 'Opel', 013, NULL),
(166, 'Opel', 058, NULL),
(167, 'Opel', 080, NULL),
(168, 'Opel', 040, NULL),
(169, 'Opel', 042, NULL),
(170, 'Opel', 034, NULL);

INSERT INTO tblItemGame
VALUES 
(101, 100001),
(102, 100001),
(103, 100001),
(104, 100001),
(105, 100001),
(106, 100001),
(107, 100001),
(108, 100001),
(109, 100001),
(110, 100001),
(111, 100001),
(112, 100001),
(113, 100001),
(114, 100001),
(115, 100001),
(116, 100001),
(117, 100001),
(118, 100001),
(119, 100001),
(120, 100001),
(121, 100001),
(122, 100001),
(123, 100001),
(124, 100001),
(125, 100001),
(126, 100001),
(127, 100001),
(128, 100001),
(129, 100001),
(130, 100001),
(131, 100001),
(132, 100001),
(133, 100001),
(134, 100001),
(135, 100001),
(136, 100001),
(137, 100001),
(138, 100001),
(139, 100001),
(140, 100001),
(141, 100001),
(142, 100001),
(143, 100001),
(144, 100001),
(145, 100001),
(146, 100001),
(147, 100001),
(148, 100001),
(149, 100001),
(150, 100001),
(151, 100001),
(152, 100001),
(153, 100001),
(154, 100001),
(155, 100001),
(156, 100001),
(157, 100001),
(158, 100001),
(159, 100001),
(160, 100001),
(161, 100001),
(162, 100001),
(163, 100001),
(164, 100001),
(165, 100001),
(166, 100001),
(167, 100001),
(168, 100001),
(169, 100001),
(170, 100001),
(101, 100002),
(102, 100002),
(103, 100002),
(104, 100002),
(105, 100002),
(106, 100002),
(107, 100002),
(108, 100002),
(109, 100002),
(110, 100002),
(111, 100002),
(112, 100002),
(113, 100002),
(114, 100002),
(115, 100002),
(116, 100002),
(117, 100002),
(118, 100002),
(119, 100002),
(120, 100002),
(121, 100002),
(122, 100002),
(123, 100002),
(124, 100002),
(125, 100002),
(126, 100002),
(127, 100002),
(128, 100002),
(129, 100002),
(130, 100002),
(131, 100002),
(132, 100002),
(133, 100002),
(134, 100002),
(135, 100002),
(136, 100002),
(137, 100002),
(138, 100002),
(139, 100002),
(140, 100002),
(141, 100002),
(142, 100002),
(143, 100002),
(144, 100002),
(145, 100002),
(146, 100002),
(147, 100002),
(148, 100002),
(149, 100002),
(150, 100002),
(151, 100002),
(152, 100002),
(153, 100002),
(154, 100002),
(155, 100002),
(156, 100002),
(157, 100002),
(158, 100002),
(159, 100002),
(160, 100002),
(161, 100002),
(162, 100002),
(163, 100002),
(164, 100002),
(165, 100002),
(166, 100002),
(167, 100002),
(168, 100002),
(169, 100002),
(170, 100002);

END
//
DELIMITER ;

CALL CreateTables;
CALL InsertTables;