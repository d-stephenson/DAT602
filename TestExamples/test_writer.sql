DROP DATABASE IF EXISTS `writerDb`;
CREATE DATABASE `writerDb` DEFAULT CHARACTER SET utf8mb4;

USE `writerDb`;

CREATE TABLE `writer` (
  `poet` varchar(50) default NULL,
  `anthology` varchar(40) default NULL,
  `copies_in_stock` tinyint(4)null 
  		default NULL
);
 
INSERT INTO `writer` VALUES 
('Mongane Wally Serote','Tstetlo',3),
('Mongane Wally Serote',
	'No Baby Must Weep',8),
('Mongane Wally Serote',
	'A Tough Tale',2),
('Douglas Livingstone',
	 'The Skull in the Mud',21),
('Douglas Livingstone',
	'A Littoral Zone',2);

SELECT poet, SUM(copies_in_stock) FROM writer GROUP BY poet;

SELECT poet, COUNT(copies_in_stock) FROM writer GROUP BY poet;

SELECT poet, 
MAX(copies_in_stock) max, 
MIN(copies_in_stock) min, 
AVG(copies_in_stock) avg, 
SUM(copies_in_stock) sum 
FROM writer GROUP BY poet;

SELECT poet, 
MAX(copies_in_stock) AS `Maximum`, 
MIN(copies_in_stock) AS `Minimum`, 
AVG(copies_in_stock) AS `Average`, 
SUM(copies_in_stock) AS `Sum` 
FROM writer GROUP BY poet;

SELECT poet, 
MAX(copies_in_stock) AS max, 
MIN(copies_in_stock) AS min, 
AVG(copies_in_stock) AS avg, 
SUM(copies_in_stock) AS sum 
FROM writer GROUP BY poet HAVING avg > 5;

SELECT poet, 
MAX(copies_in_stock) AS max, 
MIN(copies_in_stock) AS min, 
AVG(copies_in_stock) AS avg, 
SUM(copies_in_stock) AS sum 
FROM writer GROUP BY poet HAVING max > 5;

SELECT poet, 
MAX(copies_in_stock) AS max, 
MIN(copies_in_stock) AS min, 
AVG(copies_in_stock) AS avg, 
SUM(copies_in_stock) AS sum 
FROM writer WHERE copies_in_stock > 5 GROUP BY poet;

SELECT * FROM writer WHERE copies_in_stock > 5;

SELECT poet, 
MAX(copies_in_stock) AS max, 
MIN(copies_in_stock) AS min, 
AVG(copies_in_stock) AS avg, 
SUM(copies_in_stock) AS sum 
FROM writer GROUP BY poet HAVING poet > 'E';

SELECT poet, 
MAX(copies_in_stock) AS max, 
MIN(copies_in_stock) AS min, 
AVG(copies_in_stock) AS avg, 
SUM(copies_in_stock) AS sum 
FROM writer WHERE poet > 'E' GROUP BY poet;