CREATE DATABASE test_exercise1;
USE test_exercise1;

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
    
select * from `writer`;
