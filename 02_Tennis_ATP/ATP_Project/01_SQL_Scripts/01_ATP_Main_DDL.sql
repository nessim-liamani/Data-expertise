-- Connect to your SQL Server and run the following script

-- Check if the database already exists
IF NOT EXISTS (
    SELECT name 
    FROM sys.databases 
    WHERE name = N'ATP_0_Main'
)
BEGIN
    -- Create the database if it does not exist
    CREATE DATABASE ATP_0_Main;
    PRINT 'Database ATP_0_Main created successfully.';
END
ELSE
BEGIN
    PRINT 'Database ATP_0_Main already exists.';
END
GO

-- Use the ATP_0_Main database
USE ATP_0_Main;
GO

-- Create table for ATP Matches
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'atp_matches' AND xtype = 'U')
BEGIN
    CREATE TABLE dbo.atp_matches (
        match_id INT IDENTITY(1,1) PRIMARY KEY,
        tourney_id VARCHAR(50),
        tourney_name VARCHAR(100),
        surface VARCHAR(50),
        draw_size INT,
        tourney_level VARCHAR(10), -- Adjusted length to accommodate longer values
        tourney_date DATE,
        match_num INT,
        winner_id INT,
        winner_seed INT,
        winner_entry VARCHAR(50),
        winner_name VARCHAR(100),
        winner_hand CHAR(10),
        winner_ht INT,
        winner_ioc VARCHAR(3),
        winner_age FLOAT,
        winner_rank INT,
        winner_rank_points INT,
        loser_id INT,
        loser_seed INT,
        loser_entry VARCHAR(50),
        loser_name VARCHAR(100),
        loser_hand CHAR(1),
        loser_ht INT,
        loser_ioc VARCHAR(3),
        loser_age FLOAT,
        loser_rank INT,
        loser_rank_points INT,
        score VARCHAR(50),
        best_of INT,
        round VARCHAR(10),
        minutes INT,
        w_ace INT,
        w_df INT,
        w_svpt INT,
        w_1stIn INT,
        w_1stWon INT,
        w_2ndWon INT,
        w_SvGms INT,
        w_bpSaved INT,
        w_bpFaced INT,
        l_ace INT,
        l_df INT,
        l_svpt INT,
        l_1stIn INT,
        l_1stWon INT,
        l_2ndWon INT,
        l_SvGms INT,
        l_bpSaved INT,
        l_bpFaced INT
    );
    PRINT 'Table dbo.atp_matches created successfully.';
END
ELSE
BEGIN
    PRINT 'Table dbo.atp_matches already exists.';
END
GO

-- Create table for ATP Players
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'atp_players' AND xtype = 'U')
BEGIN
    CREATE TABLE dbo.atp_players (
        db_player_id INT IDENTITY(1,1) PRIMARY KEY,
        player_id INT,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        hand CHAR(1),
        birth_date DATE,
        country_code VARCHAR(3)
    );
    PRINT 'Table dbo.atp_players created successfully.';
END
ELSE
BEGIN
    PRINT 'Table dbo.atp_players already exists.';
END
GO