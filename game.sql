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
DROP TABLE IF EXISTS tblGame;
DROP TABLE IF EXISTS tblBoard;
DROP TABLE IF EXISTS tblItem;
DROP TABLE IF EXISTS tblTile;
DROP TABLE IF EXISTS tblGem;
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

CREATE TABLE tblInventory (
GameID int NOT NULL,
PlayerID int NOT NULL,
ItemID int NOT NULL,
CONSTRAINT PK_Inventory PRIMARY KEY (GameID, PlayerID, ItemID),
CONSTRAINT FK_GameID_Inv FOREIGN KEY (GameID) REFERENCES tblGame(GameID),
CONSTRAINT FK_PlayerID_Inv FOREIGN KEY (PlayerID) REFERENCES tblPlayer(PlayerID),
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
PlayerID int NOT NULL,
TileID int NOT NULL,
GamePoints int NOT NULL,
CONSTRAINT PK_Play PRIMARY KEY (GameID, PlayerID, TileID),
CONSTRAINT FK_GameID_Play FOREIGN KEY (GameID) REFERENCES tblGame(GameID),
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
(001, 'B', 1, FALSE),
(001, 'C', 1, FALSE),
(001, 'D', 1, FALSE),
(001, 'E', 1, FALSE),
(001, 'F', 1, FALSE),
(001, 'G', 1, FALSE),
(001, 'H', 1, FALSE),
(001, 'I', 1, FALSE),
(001, 'A', 2, FALSE),
(001, 'B', 2, FALSE),
(001, 'C', 2, FALSE),
(001, 'D', 2, FALSE),
(001, 'E', 2, FALSE),
(001, 'F', 2, FALSE),
(001, 'G', 2, FALSE),
(001, 'H', 2, FALSE),
(001, 'I', 2, FALSE),
(001, 'A', 3, FALSE),
(001, 'B', 3, FALSE),
(001, 'C', 3, FALSE),
(001, 'D', 3, FALSE),
(001, 'E', 3, FALSE),
(001, 'F', 3, FALSE),
(001, 'G', 3, FALSE),
(001, 'H', 3, FALSE),
(001, 'I', 3, FALSE),
(001, 'A', 4, FALSE),
(001, 'B', 4, FALSE),
(001, 'C', 4, FALSE),
(001, 'D', 4, FALSE),
(001, 'E', 4, FALSE),
(001, 'F', 4, FALSE),
(001, 'G', 4, FALSE),
(001, 'H', 4, FALSE),
(001, 'I', 4, FALSE),
(001, 'A', 5, FALSE),
(001, 'B', 5, FALSE),
(001, 'C', 5, FALSE),
(001, 'D', 5, FALSE),
(001, 'E', 5, TRUE),
(001, 'F', 5, FALSE),
(001, 'G', 5, FALSE),
(001, 'H', 5, FALSE),
(001, 'I', 5, FALSE),
(001, 'A', 6, FALSE),
(001, 'B', 6, FALSE),
(001, 'C', 6, FALSE),
(001, 'D', 6, FALSE),
(001, 'E', 6, FALSE),
(001, 'F', 6, FALSE),
(001, 'G', 6, FALSE),
(001, 'H', 6, FALSE),
(001, 'I', 6, FALSE),
(001, 'A', 7, FALSE),
(001, 'B', 7, FALSE),
(001, 'C', 7, FALSE),
(001, 'D', 7, FALSE),
(001, 'E', 7, FALSE),
(001, 'F', 7, FALSE),
(001, 'G', 7, FALSE),
(001, 'H', 7, FALSE),
(001, 'I', 7, FALSE),
(001, 'A', 8, FALSE),
(001, 'B', 8, FALSE),
(001, 'C', 8, FALSE),
(001, 'D', 8, FALSE),
(001, 'E', 8, FALSE),
(001, 'F', 8, FALSE),
(001, 'G', 8, FALSE),
(001, 'H', 8, FALSE),
(001, 'I', 8, FALSE),
(001, 'A', 9, FALSE),
(001, 'B', 9, FALSE),
(001, 'C', 9, FALSE),
(001, 'D', 9, FALSE),
(001, 'E', 9, FALSE),
(001, 'F', 9, FALSE),
(001, 'G', 9, FALSE),
(001, 'H', 9, FALSE),
(001, 'I', 9, FALSE);

INSERT INTO tblItems
VALUES 
('Malaysia'),
('Estonia'),
('Sweden'),
('Ukraine'),
('United Kingdom');

INSERT INTO tblBoard
VALUES 
('Automation Specialist II'),
('Quality Engineer');

INSERT INTO tblGame
VALUES 
('Legal'),
('Services');

INSERT INTO tblInventory
VALUES 
('Full Admin'),
('Service');

INSERT INTO tblItemLocation
VALUES 
('penatibus et magnis'),
('interdum in ante'),
('eget congue eget'),
('adipiscing elit'),
('in imperdiet'),
('odio cras'),
('praesent');

INSERT INTO tblBoardTile
VALUES 
('Other'),
('Female'),
('Male');

INSERT INTO tblPlay
VALUES 
('Medical'),
('Care Home'),
('Private'),
('Family');

END
//
DELIMITER ;

CALL CreateTables;
CALL InsertTables;