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
(001, 'mstirtle0@alibaba.com', 'Madelin', 'Stirtle', '9hmQDN'),
(002, 'cgrooby1@walmart.com', 'Caprice', 'Grooby', 'JmOfDQ'),
(003, 'abartosinski2@irs.gov', 'Alisander', 'Bartosinski', 'dVvdDC');

INSERT INTO tblGem
VALUES 
('shalls0@newyorker.com', 'bportriss0@tuttocitta.it'),
('bewles1@merriam-webster.com', 'estanbro1@weibo.com'),
('lelwill2@google.co.uk', 'edillingham2@japanpost.jp'),
('cadamkiewicz3@dmoz.org', 'ldickey3@usgs.gov'),
('cpeppett8@census.gov', 'aporcas8@sphinn.com');

INSERT INTO tblTile
VALUES 
('920-562-1627', '639-367-6215'),
('918-770-7015', '448-494-8588'),
('644-639-1227', '512-418-3391'),
('716-762-7299', '575-323-5837');

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