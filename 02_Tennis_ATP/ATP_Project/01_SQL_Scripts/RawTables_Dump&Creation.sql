-- Check and delete data from the ATP_Matches_Raw table if it exists
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'ATP_Matches_Raw' AND xtype = 'U')
BEGIN
    TRUNCATE TABLE dbo.ATP_Matches_Raw;
    PRINT 'Data in table dbo.atp_matches truncated successfully.';

    DROP TABLE dbo.ATP_Matches_Raw;
    PRINT 'Table dbo.atp_matches dropped successfully.';
END
ELSE
BEGIN
    PRINT 'Table dbo.atp_matches does not exist.';
END;
GO

-- Check and delete data from the ATP_Players_Raw table if it exists
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'ATP_Players_Raw' AND xtype = 'U')
BEGIN
    TRUNCATE TABLE dbo.ATP_Players_Raw;
    PRINT 'Data in table dbo.atp_matches truncated successfully.';

    DROP TABLE dbo.ATP_Players_Raw;
    PRINT 'Table dbo.atp_matches dropped successfully.';
END
ELSE
BEGIN
    PRINT 'Table dbo.atp_matches does not exist.';
END;
GO

-- Create table for ATP_Matches_Raw
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'ATP_Matches_Raw' AND xtype = 'U')
BEGIN
    CREATE TABLE dbo.ATP_Matches_Raw (
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
    PRINT 'Table dbo.ATP_Matches_Raw created successfully.';
END
ELSE
BEGIN
    PRINT 'Table dbo.ATP_Matches_Raw already exists.';
END
GO

-- Create table for ATP_Players_Raw
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'ATP_Players_Raw' AND xtype = 'U')
BEGIN
    CREATE TABLE dbo.ATP_Players_Raw (
        db_player_id INT IDENTITY(1,1) PRIMARY KEY,
        player_id INT,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        hand CHAR(1),
        birth_date DATE,
        country_code VARCHAR(3)
    );
    PRINT 'Table dbo.ATP_Players_Raw created successfully.';
END
ELSE
BEGIN
    PRINT 'Table dbo.ATP_Players_Raw already exists.';
END
GO