CREATE TABLE `writer` (
  `poet` varchar(50) default NULL,
  `anthology` varchar(40) default NULL,
  `copies_in_stock` tinyint(4)null 
  		default NULL
);
 
INSERT INTO `writer` VALUES 
('Mongane Wally Serote','Tstetlo',3),
('Mongane Wally Serote',null
	'No Baby Must Weep',8),
('Mongane Wally Serote',null
	'A Tough Tale',2),
('Douglas Livingstone',null
	 'The Skull in the Mud',21),
('Douglas Livingstone',null
	'A Littoral Zone',2);