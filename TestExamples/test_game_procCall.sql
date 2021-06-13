-- -- Seven Dwarfs Gem Hunt Project Transactional SQL Milestone 2
-- -- Call Procedures | Test Game

-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- -- Database Use
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- USE sdghGameDatabase;

-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- -- New User Registration Procedure
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- -- TEST PROCEDURE DATA 
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- 	CALL NewUserRegistration('NewUser_1@gmail.com', 'NewUser_1', 'P@ssword1'); -- Run test with these login credentials

-- 	-- Add these users so there are enough players to make a full game
-- 	CALL NewUserRegistration('NewUser_2@gmail.com', 'NewUser_2', 'P@ssword1');
-- 	CALL NewUserRegistration('NewUser_3@gmail.com', 'NewUser_3', 'P@ssword1');
-- 	CALL NewUserRegistration('NewUser_4@gmail.com', 'NewUser_4', 'P@ssword1');
-- 	CALL NewUserRegistration('NewUser_5@gmail.com', 'NewUser_5', 'P@ssword1');
-- 	CALL NewUserRegistration('NewUser_6@gmail.com', 'NewUser_6', 'P@ssword1');
-- 	CALL NewUserRegistration('NewUser_7@gmail.com', 'NewUser_7', 'P@ssword1');

-- 	-- Run test to check user has been added to database
-- 	SELECT * FROM tblPlayer WHERE Username = 'NewUser_1'; 

-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- -- Login Check Credentials Procedure
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- -- TEST PROCEDURE DATA 
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- 	-- Login test is based on credentials entered in registration
-- 	CALL LoginCheckCredentials('NewUser_1', '@ssword1'); -- First test to see login attempt increment
-- 	CALL LoginCheckCredentials('NewUser_1', '@ssword1'); -- Second test to see login attempt increment
-- 	CALL LoginCheckCredentials('NewUser_1', '@ssword1'); -- Third test to see login attempt increment
-- 	CALL LoginCheckCredentials('NewUser_1', '@ssword1'); -- Fourth test to see login attempt increment
-- 	CALL LoginCheckCredentials('NewUser_1', '@ssword1'); -- Fifth test to see login attempt increment and account locked to true
-- 	CALL LoginCheckCredentials('NewUser_1', 'P@ssword1'); -- Sixth test to see correct login attempt
-- 	CALL LoginCheckCredentials('NewUser_1', 'P@ssword1'); -- Seventh test to check error message as user already logged in or test against first test

-- 	-- Login remaining new players
-- 	CALL LoginCheckCredentials('NewUser_2', 'P@ssword1');
-- 	CALL LoginCheckCredentials('NewUser_3', 'P@ssword1');
-- 	CALL LoginCheckCredentials('NewUser_4', 'P@ssword1');
-- 	CALL LoginCheckCredentials('NewUser_5', 'P@ssword1');
-- 	CALL LoginCheckCredentials('NewUser_6', 'P@ssword1');
-- 	CALL LoginCheckCredentials('NewUser_7', 'P@ssword1');
    
-- 	SELECT PlayerID, Username, ActiveStatus FROM tblPlayer WHERE Username = 'NewUser_1';

-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- -- Home Screen Display Procedure
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- -- TEST PROCEDURE DATA 
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- -- PROCEDURE NO LONGER REQUIRED
-- -- 	CALL HomeScreen('NewUser_1');

-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- -- New Game Procedure
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- -- TEST PROCEDURE DATA 
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- 	CALL NewGame('NewUser_1'); -- Run test with new player starting a game

-- 	-- Test new game has been created in the following tables and a play instance for the player
-- 	SELECT * from tblGame ORDER BY GameID DESC; 
-- 	SELECT * FROM tblItemGame ORDER BY GameID DESC; 
-- 	SELECT * FROM tblPlay ORDER BY GameID DESC;

-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- -- Join Game Procedure
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- -- TEST PROCEDURE DATA 
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- 	SELECT * FROM tblPlay ORDER BY PlayerID DESC; -- Find a PlayerID and GameID to join player to game
-- 	CALL JoinGame(100003, 10); -- Test join game procedure

-- 	-- Add remaining players 
-- 	CALL JoinGame(100003, 11);
-- 	CALL JoinGame(100003, 12);
-- 	CALL JoinGame(100003, 13);
-- 	CALL JoinGame(100003, 14);
-- 	CALL JoinGame(100003, 15);

-- 	-- Test player has been added to game and has the next character
-- 	SELECT * FROM tblPlay WHERE GameID = 100003; 

-- 	-- Test no more players can joing a game
-- 	CALL JoinGame(100003, 2);
-- 	SELECT * FROM tblPlay WHERE GameID = 100003; -- Test player has not been added to game

-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- -- Player Moves Procedure
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- -- TEST PROCEDURE DATA 
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- 	-- Do the following checks first 
-- 	SELECT * FROM tblGame WHERE GameID = 100003; -- Confirm that next character turn is character Doc 
-- 	SELECT * FROM tblPlay WHERE GameID = 100003; -- Confirm playerID and tileID location for Doc, should be playerID 9 and tileID 1

-- 	CALL MovePlayer(2, 9, 100003); -- Test procedure player cannot move to this tile
-- 	CALL MovePlayer(32, 9, 100003); -- Displays tile colour and new tile row and column

-- 	-- Re-run tblPlay select query to confirm player is on a new tile location
-- 	SELECT * FROM tblPlay WHERE GameID = 100003; 

-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- -- Find Gem Procedure
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- -- TEST PROCEDURE DATA 
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- 	CALL FindGem(32, 9, 100003); -- Test procedure and check that gem or gems are listed against correct game, player, play instance and tile location
-- 	-- IMPORTANT: RECORD THE ITEM ID & PLAY ID FROM THE TEMPORARY TABLE FOR INSERTION IN Select Gem & Update Turn PROCEDURE AND Update Highscore & End Game PROCEDURE
-- 	-- If the error message is displayed stating there are no items on the tile, next next move procedure below will hopefully have items on the tile, 
-- 	-- if not you may have to move more players or re-run the create table and insert into procedures and start again

-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- -- Select Gem & Update Turn Procedure
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- -- TEST PROCEDURE DATA 
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- 	CALL SelectGem(NULL, 500007, 9, 100003); -- IMPORTANT: Amend the first input to the correct itemID or NULL, second input to the correct playID, third input to correct playerID

-- 	-- Do the following checks to confirm procedure success
-- 	SELECT * FROM tblPlay WHERE PlayerID = 9; -- Check play score has updated from 0
-- 	SELECT * FROM tblGame WHERE GameID = 100003; -- Check character turn has updated in game table
-- 	SELECT * FROM tblItemGame WHERE GameID = 100003 AND PlayID = 500007; -- Check that item/game table has updated tile equals NULL and play equals playID

-- 	-- If there were no items on the tile move the next character turn from the above select game ID statement
-- 	-- Find out which player is the character turn 
-- 	SELECT * FROM tblPlay WHERE CharacterName = 'Bashful' AND GameID = 100003;
-- 	CALL MovePlayer(34, 10, 100003); 
-- 	CALL FindGem(34, 10, 100003); -- Run to check if there are gems on the tile
-- 	CALL SelectGem(NULL, 500008, 10, 100003); -- Run this to ensure player turn updates

-- 	SELECT * FROM tblPlay WHERE CharacterName = 'Dopey' AND GameID = 100003;
-- 	CALL MovePlayer(34, 11, 100003); -- Check this player can't move to tile 34 as previous player moved to tile 34
-- 	CALL MovePlayer(50, 11, 100003); 
-- 	CALL FindGem(50, 11, 100003); -- Run to check if there are gems on the tile
-- 	CALL SelectGem(NULL, 500009, 11, 100003); -- Run this to ensure player turn updates
 	
-- 	SELECT * FROM tblPlay WHERE CharacterName = 'Grumpy' AND GameID = 100003;
-- 	CALL MovePlayer(42, 12, 100003); 
-- 	CALL FindGem(42, 12, 100003); -- Run to check if there are gems on the tile
-- 	CALL SelectGem(NULL, 500010, 12, 100003); -- Run this to ensure player turn updates

-- 	SELECT * FROM tblPlay WHERE CharacterName = 'Happy' AND GameID = 100003;
-- 	CALL MovePlayer(33, 13, 100003); 
-- 	CALL FindGem(33, 13, 100003); -- Run to check if there are gems on the tile
-- 	CALL SelectGem(102, 500011, 13, 100003); -- Run this to ensure player turn updates

-- 	-- Now we can do some checks, if by chance the above second move yielded no items find the next character turn and do it again
-- 	SELECT * FROM tblPlay WHERE PlayerID >= 9 AND PlayerID <= 15; -- Check play score has updated
-- 	SELECT CharacterTurn FROM tblGame WHERE GameID = 100003; -- Check character turn has updated in game table
-- 	SELECT * FROM tblItemGame WHERE GameID = 100003 AND PlayID = 500010; -- Check that Item has moved from tile to play

-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- -- Update High Score & End Game Procedure
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- -- TEST PROCEDURE DATA 
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- 	-- Update the high score and check if game is over for player moves, input the details of the player who found gems from the 
--     -- above procedure
-- 	CALL UpdateHS_EG(500007, 9, 100003);
    
--     -- Only need to be called if you had to move the player to find a gem
-- 	CALL UpdateHS_EG(500008, 10, 100003); 
-- 	CALL UpdateHS_EG(500009, 11, 100003);
-- 	CALL UpdateHS_EG(500010, 12, 100003);
-- 	CALL UpdateHS_EG(500011, 13, 100003);

-- 	-- Check high score has updated
-- 	SELECT PlayerID, Username, HighScore FROM tblPlayer WHERE PlayerID >= 9 AND PlayerID <= 15; 

-- 	-- Test the end game portion of the procedure
-- 	UPDATE tblItemGame SET TileID = NULL, PlayID = 500007 WHERE GameID = 100003; -- Update all tiles to NULL and all play instances to playID
-- 	SELECT * FROM tblItemGame WHERE GameID = 100003; -- Test select query to confirm above update

-- 	-- IMPORTANT: Amend the ItemID to the correct ID and insert correct tile item was found. Update the item to be back in the game play, re-run above query to check
-- 	UPDATE tblItemGame SET TileID = 51, PlayID = NULL WHERE ItemID = 155 AND GameID = 100003; 
-- 	SELECT * FROM tblItemGame WHERE GameID = 100003 AND TileID = 51; -- Check 1 tile now has an item left
-- 	CALL MovePlayer(51, 14, 100003); -- Move the next player
    
--     -- IMPORTANT: Amend the first input to the correct ItemID. Call SelectGem procedure again
-- 	CALL FindGem(51, 14, 100003); 
-- 	CALL SelectGem(155, 500012, 14, 100003); 
-- 	CALL UpdateHS_EG(500012, 14, 100003); -- Call updateHS procedure again
    
-- 	SELECT * FROM tblGame WHERE GameID = 100003; -- Character turn is now set to NULL as game has finished, no more items to collect

-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- -- Player Logout Procedure
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- -- TEST PROCEDURE DATA 
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- 	CALL PlayerLogout('NewUser_1');

-- 	-- Test active status is displayed as false for player
-- 	SELECT PlayerID, Username, ActiveStatus FROM tblPlayer WHERE Username = 'NewUser_1';
    
--     -- Next player is able to move to tile 79 with player located on it as player is not active
-- 	CALL MovePlayer(32, 15, 100003); 

-- 	SELECT * FROM tblPlay WHERE TileID = 32; -- Test both players are on tile 

-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- -- Enter Admin Screen Procedure 
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- -- TEST PROCEDURE DATA 
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- 	CALL AdminScreen('NewUser_1'); -- Not an admin user
-- 	UPDATE tblPlayer SET AccountAdmin = 1 WHERE Username = 'NewUser_2'; -- Upgrade new user 2 to admin priviledges 
-- 	CALL AdminScreen('NewUser_2'); -- Should now be an admin user
    
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- -- Admin Kill Game Procedure
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- -- TEST PROCEDURE DATA 
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- 	CALL KillGame(100001, 'NewUser_2'); -- Warning message will display saying game has been killed

-- 	-- Confirm game has been deleted
-- 	SELECT * FROM tblGame WHERE GameID = 100001;
-- 	SELECT * FROM tblPlay WHERE GameID = 100001;
-- 	SELECT * FROM tblItemGAme WHERE GameID = 100001;

-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- -- Admin Add Player Procedure
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- -- TEST PROCEDURE DATA 
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- 	CALL AddPlayer('NewUser_2', 'NewUser_8@gmail.com', 'NewUser_8', 'P@ssword1', 1);

-- 	-- Confirm player has been added and has admin privileges
-- 	SELECT * FROM tblPlayer WHERE Username = 'NewUser_8'; 

-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- -- Admin Update Player Procedure
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- -- TEST PROCEDURE DATA 
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- 	CALL UpdatePlayer('NewUser_2', 16, 'NewUser_8@gmail.com', 'NewUser_8', 'P@ssword1', 1, 0, 0, 3, 56); -- Admin NewUser_ updates player NewUser_8
-- 	SELECT * FROM tblPlayer WHERE Username = 'NewUser_8'; -- Check procedure 

-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- -- Admin Delete Player Procedure
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- -- TEST PROCEDURE DATA 
-- -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- 	CALL DeletePlayer('NewUser_2', 'NewUser_1'); -- Delete NewUser_1 

-- 	-- Test records removed from relevant tables
-- 	SELECT * FROM tblPlayer WHERE Username = 'NewUser_1'; 
-- 	SELECT * FROM tblPlay py JOIN tblPlayer pl ON py.PlayerID = pl.PlayerID WHERE Username = 'NewUser_1'; 
-- 	SELECT * FROM tblItemGame ig JOIN tblPlay py ON ig.PlayID = py.PlayID JOIN tblPlayer pl ON py.PlayerID = pl.PlayerID WHERE Username = 'NewUser_1'; 