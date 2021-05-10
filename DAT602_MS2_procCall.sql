-- Seven Dwarfs Gem Hunt Project Transactional SQL Milestone 2
-- Call Procedures | Test Game

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Database Use
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

USE sdghGameDatabase;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- New User Registration Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL newUserRegistration('NewUser_1@gmail.com', 'NewUser_1', 'P@ssword1'); -- Run test with these login credentials

	-- Add these users so there are enough players to make a full game
	CALL newUserRegistration('NewUser_2@gmail.com', 'NewUser_2', 'P@ssword1');
	CALL newUserRegistration('NewUser_3@gmail.com', 'NewUser_3', 'P@ssword1');
	CALL newUserRegistration('NewUser_4@gmail.com', 'NewUser_4', 'P@ssword1');
	CALL newUserRegistration('NewUser_5@gmail.com', 'NewUser_5', 'P@ssword1');
	CALL newUserRegistration('NewUser_6@gmail.com', 'NewUser_6', 'P@ssword1');
	CALL newUserRegistration('NewUser_7@gmail.com', 'NewUser_7', 'P@ssword1');

	-- Run test to check user has been added to database
	SELECT * FROM tblPlayer WHERE Username = 'NewUser_1'; 

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Login Check Credentials Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	-- Login test is based on credentials entered in registration
	CALL loginCheckCredentials('NewUser_1', '@ssword1'); -- First test to see login attempt increment
	CALL loginCheckCredentials('NewUser_1', '@ssword1'); -- Second test to see login attempt increment
	CALL loginCheckCredentials('NewUser_1', '@ssword1'); -- Third test to see login attempt increment
	CALL loginCheckCredentials('NewUser_1', '@ssword1'); -- Fourth test to see login attempt increment
	CALL loginCheckCredentials('NewUser_1', '@ssword1'); -- Fifth test to see login attempt increment and account locked to true
	CALL loginCheckCredentials('NewUser_1', 'P@ssword1'); -- Sixth test to see correct login attempt
	CALL loginCheckCredentials('NewUser_1', 'P@ssword1'); -- Seventh test to check error message as user already logged in or test against first test

	-- Login remaining new players
	CALL loginCheckCredentials('NewUser_2', 'P@ssword1');
	CALL loginCheckCredentials('NewUser_3', 'P@ssword1');
	CALL loginCheckCredentials('NewUser_4', 'P@ssword1');
	CALL loginCheckCredentials('NewUser_5', 'P@ssword1');
	CALL loginCheckCredentials('NewUser_6', 'P@ssword1');
	CALL loginCheckCredentials('NewUser_7', 'P@ssword1');

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Home Screen Display Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL homeScreen('NewUser_1');

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- New Game Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL newGame('NewUser_1'); -- Run test with new player starting a game

	-- Test new game has been created in the following tables and a play instance for the player
	SELECT * from tblGame ORDER BY GameID DESC; 
	SELECT * FROM tblItemGame ORDER BY GameID DESC; 
	SELECT * FROM tblPlay ORDER BY GameID DESC;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Join Game Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	SELECT * FROM tblPlay ORDER BY PlayerID DESC; -- Find a PlayerID and GameID to join player to game
	CALL joinGame(100003, 10); -- Test join game procedure

	-- Add remaining players 
	CALL joinGame(100003, 11);
	CALL joinGame(100003, 12);
	CALL joinGame(100003, 13);
	CALL joinGame(100003, 14);
	CALL joinGame(100003, 15);

	-- Test player has been added to game and has the next character
	SELECT * FROM tblPlay WHERE GameID = 100003; 

	-- Test no more players can joing a game
	CALL joinGame(100003, 2);
	SELECT * FROM tblPlay WHERE GameID = 100003; -- Test player has not been added to game

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Player Moves Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	-- Do the following checks first 
	SELECT * FROM tblGame WHERE GameID = 100003; -- Confirm that next character turn is character Doc 
	SELECT * FROM tblPlay WHERE GameID = 100003; -- Confirm playerID and tileID location for Doc, should be playerID 9 and tileID 1

	CALL movePlayer(2, 9, 100003); -- Test procedure player cannot move to this tile
	CALL movePlayer(34, 9, 100003); -- Displays tile colour and new tile row and column

	-- Re-run tblPlay select query to confirm player is on a new tile location
	SELECT * FROM tblPlay WHERE GameID = 100003; 

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Find Gem Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL findGem(34, 9, 100003); -- Test procedure and check that gem or gems are listed against correct game, player, play instance and tile location
	-- IMPORTANT: RECORD THE ITEM ID & PLAY ID FROM THE TEMPORARY TABLE FOR INSERTION IN Select Gem & Update Turn PROCEDURE AND Update Highscore & End Game PROCEDURE
	-- If the error message is displayed stating there are no items on the tile, next next move procedure below will hopefully have items on the tile, 
	-- if not you may have to move more players or re-run the create table and insert into procedures and start again

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Select Gem & Update Turn Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL selectGem(NULL, 500007, 9, 100003); -- IMPORTANT: Amend the first input to the correct itemID and secong input to the correct playID

	-- Do the following checks to confirm procedure success
	SELECT * FROM tblPlay WHERE PlayerID = 9; -- Check play score has updated
	SELECT * FROM tblGame WHERE GameID = 100003; -- Check character turn has updated in game table
	SELECT * FROM tblItemGame WHERE GameID = 100003 AND PlayID = 500007; -- Check that item/game table has updated tile equals NULL and play equals playID

	-- If there were no items on the tile move the next character turn from the above select game ID statement
	-- Find out which player is the character turn 
	SELECT * FROM tblPlay WHERE CharacterName = 'Bashful' AND GameID = 100003;
	CALL movePlayer(50, 10, 100003); 
	CALL findGem(50, 10, 100003);
	CALL selectGem(NULL, 500008, 10, 100003);

	SELECT * FROM tblPlay WHERE CharacterName = 'Dopey' AND GameID = 100003;
	CALL movePlayer(50, 11, 100003); -- Check this player can't move to tile 50 as previous player moved to tile 50
	CALL movePlayer(49, 11, 100003); 
	CALL findGem(49, 11, 100003);
	CALL selectGem(NULL, 500009, 11, 100003);

	SELECT * FROM tblPlay WHERE CharacterName = 'Grumpy' AND GameID = 100003;
	CALL movePlayer(42, 12, 100003); 
	CALL findGem(42, 12, 100003);
	CALL selectGem(139, 500010, 12, 100003);

	-- Now we can do the check, if by chance the above second move yeilded no items find the next character turn and do it again
	SELECT * FROM tblPlay WHERE PlayerID = 12; -- Check play score has updated
	SELECT * FROM tblGame WHERE GameID = 100003; -- Check character turn has updated in game table
	SELECT * FROM tblItemGame WHERE GameID = 100003 AND PlayID = 500010;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Update High Score & End Game Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL updateHS_EG(500010, 12, 100003);

	-- Check high score has updated
	SELECT * FROM tblPlayer WHERE PlayerID = 12; 

	-- Test the end game portion of the procedure
	UPDATE tblItemGame SET TileID = NULL, PlayID = 500007 WHERE GameID = 100003; -- Update all tiles to NULL and all play instances to playID
	SELECT * FROM tblItemGame WHERE GameID = 100003; -- Test select query to confirm above update

	-- IMPORTANT: Amend the ItemID to the correct ID and insert correct tile item was found. Update the item to be back in the game play, re-run above query to check
	UPDATE tblItemGame SET TileID = 50, PlayID = NULL WHERE ItemID = 155 AND GameID = 100003; 
	CALL selectGem(155, 500008, 10, 100003); -- IMPORTANT: Amend the first input to the correct ItemID. Call selectGem procedure again
	CALL updateHS(500008, 10, 100003); -- Call updateHS procedure again
	SELECT * FROM tblGame WHERE GameID = 100003; -- Character turn is now set to NULL as game has finished, no more items to collect

	-- Re-run select all query from item/game table to confirm tile ID are NULL and play ID relate to play instance
	SELECT * FROM tblItemGame WHERE GameID = 100003; 

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Player Logout Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL playerLogout('NewUser_1');

	-- Test active status will be displayed as false
	SELECT * FROM tblPlayer WHERE Username = 'NewUser_1';
    
    -- Let's move a Player to NewUser_1 location in game 100003
    SELECT PlayerID, pl.GameID
    FROM tblPlay pl
		JOIN tblGame ga ON pl.CharacterName = ga.CharacterTurn 
    WHERE pl.GameiD = 100003; 
    
    SELECT * FROM tblPlay WHERE PlayerID = 13;
    
	CALL movePlayer(34, 13, 100003); 
	SELECT * FROM tblPlay WHERE TileID = 34;
	CALL findGem(34, 13, 100003);
	CALL selectGem(NULL, 500011, 13, 100003);

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Enter Admin Screen Procedure 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	UPDATE tblPlayer SET AccountAdmin = 1 WHERE Username = 'NewUser_1'; -- Upgrade new user 1 to admin priviledges 
	CALL adminScreen('NewUser_1');

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Admin Kill Game Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL killGame(100003, 'NewUser_1'); -- Warning message will display saying game has been killed

	-- Confirm game has been deleted
	SELECT * FROM tblGame WHERE GameID = 100003;
	SELECT * FROM tblPlay WHERE GameID = 100003;
	SELECT * FROM tblItemGAme WHERE GameID = 100003;

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Admin Add Player Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL addPlayer('NewUser_1', 'NewUser_8@gmail.com', 'NewUser_8', 'P@ssword1', 1);

	-- Confirm player has been added and has admin privileges
	SELECT * FROM tblPlayer WHERE Username = 'NewUser_8'; 

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Admin Update Player Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL updatePlayer('NewUser_1', 16, 'NewUser_8@gmail.com', 'NewUser_8', 'P@ssword1', 1, 0, 1, 3, 456); -- Admin NewUser_ updates player NewUser_8
	SELECT * FROM tblPlayer WHERE Username = 'NewUser_8'; -- Check procedure 

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Admin Delete Player Procedure
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- TEST PROCEDURE DATA 
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	CALL deletePlayer('NewUser_8', 'NewUser_1'); -- Delete NewUser_1 

	-- Test records removed from relevant tables
	SELECT * FROM tblPlayer WHERE Username = 'NewUser_1'; 
	SELECT * FROM tblPlay py JOIN tblPlayer pl ON py.PlayerID = pl.PlayerID WHERE Username = 'NewUser_1'; 
	SELECT * FROM tblItemGame ig JOIN tblPlay py ON ig.PlayID = py.PlayID JOIN tblPlayer pl ON py.PlayerID = pl.PlayerID WHERE Username = 'NewUser_1'; 