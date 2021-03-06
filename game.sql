-- Seven Dwarfs Gem Hunt Project Physical Design SQL model v1.0 [refer to Logical Diagram v1.1]

-- Database Setup

USE gameDatabase;

-- DDL | Making tables, indexes and checks

DELIMITER //
DROP PROCEDURE IF EXISTS CreateTables;
CREATE PROCEDURE CreateTables()
BEGIN

DROP TABLE IF EXISTS tblPlayer;
DROP TABLE IF EXISTS tblGem;
DROP TABLE IF EXISTS tblTile;
DROP TABLE IF EXISTS tblItem;
DROP TABLE IF EXISTS tblBoard;
DROP TABLE IF EXISTS tblGame;
DROP TABLE IF EXISTS tblInventory;
DROP TABLE IF EXISTS tblItemLocation;
DROP TABLE IF EXISTS tblBoardTile;
DROP TABLE IF EXISTS tblPlay;

CREATE TABLE tblAdministrator (
AdminID int AUTO_INCREMENT,
Email varchar(50) NOT NULL,
Surname varchar(30) NOT NULL,
FirstName varchar(30) NOT NULL,
SecurityPassword varchar(30) NOT NULL,
PRIMARY KEY (AdminID)
);

ALTER TABLE tblAdministrator AUTO_INCREMENT=001;

CREATE TABLE tblEmail (
PrimaryEmail varchar(50) NOT NULL,
SecondaryEmail varchar(50),
CONSTRAINT CHK_PrimaryEmail CHECK (PrimaryEmail Like '_%@_%._%'),
CONSTRAINT CHK_SecondaryEmail CHECK (SecondaryEmail Like '_%@_%._%'),
PRIMARY KEY (PrimaryEmail)
);

CREATE TABLE tblContactNumber (
PrimaryTelNo varchar(20) NOT NULL,
SecondaryTelNo varchar(20),
PRIMARY KEY (PrimaryTelNo)
);

CREATE TABLE tblCountry (
Country varchar(100) NOT NULL,
PRIMARY KEY (Country)
);

CREATE TABLE tblJobRole (
EmploymentPosition varchar(30) NOT NULL,
PRIMARY KEY (EmploymentPosition)
);

CREATE TABLE tblDepartment (
BusinessUnit varchar(30) NOT NULL,
PRIMARY KEY (BusinessUnit)
);

CREATE TABLE tblAccessLevel (
AccessType varchar(30) NOT NULL,
PRIMARY KEY (AccessType)
);

CREATE TABLE tblPartType (
PartDescription varchar(30) NOT NULL,
PRIMARY KEY (PartDescription)
);

CREATE TABLE tblGender (
GenderDescription varchar(10) NOT NULL,
PRIMARY KEY (GenderDescription)
);

CREATE TABLE tblMonitorType (
MonitorDescription varchar(20) NOT NULL,
PRIMARY KEY (MonitorDescription)
);

END
//
DELIMITER ;

-- DML Inserting into tables

DELIMITER //
DROP PROCEDURE IF EXISTS InsertTables;
CREATE PROCEDURE InsertTables() 
BEGIN

INSERT INTO tblAdministrator
VALUES 
(001, 'mstirtle0@alibaba.com', 'Madelin', 'Stirtle', '9hmQDN'),
(002, 'cgrooby1@walmart.com', 'Caprice', 'Grooby', 'JmOfDQ'),
(003, 'abartosinski2@irs.gov', 'Alisander', 'Bartosinski', 'dVvdDC');

INSERT INTO tblEmail
VALUES 
('shalls0@newyorker.com', 'bportriss0@tuttocitta.it'),
('bewles1@merriam-webster.com', 'estanbro1@weibo.com'),
('lelwill2@google.co.uk', 'edillingham2@japanpost.jp'),
('cadamkiewicz3@dmoz.org', 'ldickey3@usgs.gov'),
('hbigadike4@state.gov', 'swilsee4@cdc.gov'),
('jdubs5@independent.co.uk', 'lwyant5@gmpg.org'),
('naslen6@wikipedia.org', 'pfairbanks6@biblegateway.com'),
('jmigheli7@psu.edu', 'bbenning7@google.ru'),
('cpeppett8@census.gov', 'aporcas8@sphinn.com');

INSERT INTO tblContactNumber
VALUES 
('920-562-1627', '639-367-6215'),
('918-770-7015', '448-494-8588'),
('916-247-9773', '516-799-3170'),
('545-228-3001', '222-603-5376'),
('649-817-6589', '213-739-5433'),
('521-284-7221', '731-624-0134'),
('791-198-6636', '592-131-2222'),
('644-639-1227', '512-418-3391'),
('716-762-7299', '575-323-5837');

INSERT INTO tblCountry
VALUES 
('Malaysia'),
('Estonia'),
('Bosnia and Herzegovina'),
('Japan'),
('Russia'),
('China'),
('Czech Republic'),
('Brazil'),
('Indonesia'),
('United States'),
('Mongolia'),
('Vietnam'),
('Argentina'),
('France'),
('Sweden'),
('Ukraine'),
('United Kingdom');

INSERT INTO tblJobRole
VALUES 
('Automation Specialist II'),
('Quality Engineer');

INSERT INTO tblDepartment
VALUES 
('Legal'),
('Services');

INSERT INTO tblAccessLevel
VALUES 
('Full Admin'),
('Service');

INSERT INTO tblPartType
VALUES 
('penatibus et magnis'),
('interdum in ante'),
('eget congue eget'),
('adipiscing elit'),
('in imperdiet'),
('odio cras'),
('praesent');

INSERT INTO tblGender 
VALUES 
('Other'),
('Female'),
('Male');

INSERT INTO tblMonitorType
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