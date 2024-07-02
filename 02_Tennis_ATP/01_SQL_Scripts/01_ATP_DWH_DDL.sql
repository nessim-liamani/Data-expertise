-- Check if the database already exists
IF NOT EXISTS (
    SELECT name 
    FROM sys.databases 
    WHERE name = N'ATP_1_DWH'
)
BEGIN
    -- Create the database if it does not exist
    CREATE DATABASE ATP_1_DWH;
    PRINT 'Database ATP_1_DWH created successfully.';
END
ELSE
BEGIN
    PRINT 'Database ATP_1_DWH already exists.';
END
GO

-- Use the ATP_1_DWH database
USE ATP_1_DWH;
GO

-- Create table for ATP Matches
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'Fact_ATP_Matches' AND xtype = 'U')
BEGIN
    CREATE TABLE dbo.Fact_ATP_Matches (
        match_id INT IDENTITY(1,1) PRIMARY KEY,
        tourney_id VARCHAR(50),
        tourney_name VARCHAR(100),
        surface VARCHAR(50),
        draw_size INT,
        tourney_level VARCHAR(10),
        tourney_date DATE,
        match_num INT,
        winner_id INT,
        winner_seed INT,
        winner_entry VARCHAR(50),
        winner_name VARCHAR(100),
        winner_hand CHAR(1),
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
    PRINT 'Table dbo.Fact_ATP_Matches created successfully.';
END
ELSE
BEGIN
    PRINT 'Table dbo.Fact_ATP_Matches already exists.';
END
GO

-- Create table for ATP Players
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'dim_atp_players' AND xtype = 'U')
BEGIN
    CREATE TABLE dbo.dim_atp_players (
        db_player_id INT IDENTITY(1,1) PRIMARY KEY,
        player_id INT,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        hand CHAR(1),
        birth_date DATE,
        country_code VARCHAR(3)
    );
    PRINT 'Table dbo.dim_atp_players created successfully.';
END
ELSE
BEGIN
    PRINT 'Table dbo.dim_atp_players already exists.';
END
GO

-- Create the Date Dimension Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'dim_date' AND xtype = 'U')
BEGIN
    CREATE TABLE dbo.dim_date (
        date_id INT IDENTITY(1,1) PRIMARY KEY,
        full_date DATE NOT NULL,
        year INT NOT NULL,
        quarter INT NOT NULL,
        month INT NOT NULL,
        day INT NOT NULL,
        day_of_week INT NOT NULL,
        day_name VARCHAR(10) NOT NULL,
        month_name VARCHAR(10) NOT NULL,
        is_weekend BIT NOT NULL
    );
    PRINT 'Table dbo.dim_date created successfully.';
END
ELSE
BEGIN
    PRINT 'Table dbo.dim_date already exists.';
END
GO

-- Populate the Date Dimension Table
DECLARE @StartDate DATE = '1835-01-01';
DECLARE @EndDate DATE = '2030-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    -- Check if the date already exists
    IF NOT EXISTS (SELECT 1 FROM dbo.dim_date WHERE full_date = @StartDate)
    BEGIN
        INSERT INTO dbo.dim_date (full_date, year, quarter, month, day, day_of_week, day_name, month_name, is_weekend)
        VALUES (
            @StartDate,
            YEAR(@StartDate),
            DATEPART(QUARTER, @StartDate),
            MONTH(@StartDate),
            DAY(@StartDate),
            DATEPART(WEEKDAY, @StartDate),
            DATENAME(WEEKDAY, @StartDate),
            DATENAME(MONTH, @StartDate),
            CASE 
                WHEN DATEPART(WEEKDAY, @StartDate) IN (1, 7) THEN 1
                ELSE 0
            END
        );
    END

    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END

PRINT 'Table dbo.dim_date populated successfully.';
GO

-- Merge statement to populate Fact_ATP_Matches
MERGE dbo.Fact_ATP_Matches AS target
USING (SELECT * FROM ATP_0_Main.dbo.atp_matches) AS source
ON target.match_id = source.match_id
WHEN NOT MATCHED BY TARGET THEN
    INSERT (tourney_id, tourney_name, surface, draw_size, tourney_level, tourney_date, match_num, winner_id, winner_seed, winner_entry, winner_name, winner_hand, winner_ht, winner_ioc, winner_age, winner_rank, winner_rank_points, loser_id, loser_seed, loser_entry, loser_name, loser_hand, loser_ht, loser_ioc, loser_age, loser_rank, loser_rank_points, score, best_of, round, minutes, w_ace, w_df, w_svpt, w_1stIn, w_1stWon, w_2ndWon, w_SvGms, w_bpSaved, w_bpFaced, l_ace, l_df, l_svpt, l_1stIn, l_1stWon, l_2ndWon, l_SvGms, l_bpSaved, l_bpFaced)
    VALUES (source.tourney_id, source.tourney_name, source.surface, source.draw_size, source.tourney_level, source.tourney_date, source.match_num, source.winner_id, source.winner_seed, source.winner_entry, source.winner_name, source.winner_hand, source.winner_ht, source.winner_ioc, source.winner_age, source.winner_rank, source.winner_rank_points, source.loser_id, source.loser_seed, source.loser_entry, source.loser_name, source.loser_hand, source.loser_ht, source.loser_ioc, source.loser_age, source.loser_rank, source.loser_rank_points, source.score, source.best_of, source.round, source.minutes, source.w_ace, source.w_df, source.w_svpt, source.w_1stIn, source.w_1stWon, source.w_2ndWon, source.w_SvGms, source.w_bpSaved, source.w_bpFaced, source.l_ace, source.l_df, source.l_svpt, source.l_1stIn, source.l_1stWon, source.l_2ndWon, source.l_SvGms, source.l_bpSaved, source.l_bpFaced)
WHEN MATCHED AND 
    (target.tourney_id <> source.tourney_id OR
     target.tourney_name <> source.tourney_name OR
     target.surface <> source.surface OR
     target.draw_size <> source.draw_size OR
     target.tourney_level <> source.tourney_level OR
     target.tourney_date <> source.tourney_date OR
     target.match_num <> source.match_num OR
     target.winner_id <> source.winner_id OR
     target.winner_seed <> source.winner_seed OR
     target.winner_entry <> source.winner_entry OR
     target.winner_name <> source.winner_name OR
     target.winner_hand <> source.winner_hand OR
     target.winner_ht <> source.winner_ht OR
     target.winner_ioc <> source.winner_ioc OR
     target.winner_age <> source.winner_age OR
     target.winner_rank <> source.winner_rank OR
     target.winner_rank_points <> source.winner_rank_points OR
     target.loser_id <> source.loser_id OR
     target.loser_seed <> source.loser_seed OR
     target.loser_entry <> source.loser_entry OR
     target.loser_name <> source.loser_name OR
     target.loser_hand <> source.loser_hand OR
     target.loser_ht <> source.loser_ht OR
     target.loser_ioc <> source.loser_ioc OR
     target.loser_age <> source.loser_age OR
     target.loser_rank <> source.loser_rank OR
     target.loser_rank_points <> source.loser_rank_points OR
     target.score <> source.score OR
     target.best_of <> source.best_of OR
     target.round <> source.round OR
     target.minutes <> source.minutes OR
     target.w_ace <> source.w_ace OR
     target.w_df <> source.w_df OR
     target.w_svpt <> source.w_svpt OR
     target.w_1stIn <> source.w_1stIn OR
     target.w_1stWon <> source.w_1stWon OR
     target.w_2ndWon <> source.w_2ndWon OR
     target.w_SvGms <> source.w_SvGms OR
     target.w_bpSaved <> source.w_bpSaved OR
     target.w_bpFaced <> source.w_bpFaced OR
     target.l_ace <> source.l_ace OR
     target.l_df <> source.l_df OR
     target.l_svpt <> source.l_svpt OR
     target.l_1stIn <> source.l_1stIn OR
     target.l_1stWon <> source.l_1stWon OR
     target.l_2ndWon <> source.l_2ndWon OR
     target.l_SvGms <> source.l_SvGms OR
     target.l_bpSaved <> source.l_bpSaved OR
     target.l_bpFaced <> source.l_bpFaced)
THEN
    UPDATE SET 
        target.tourney_id = source.tourney_id,
        target.tourney_name = source.tourney_name,
        target.surface = source.surface,
        target.draw_size = source.draw_size,
        target.tourney_level = source.tourney_level,
        target.tourney_date = source.tourney_date,
        target.match_num = source.match_num,
        target.winner_id = source.winner_id,
        target.winner_seed = source.winner_seed,
        target.winner_entry = source.winner_entry,
        target.winner_name = source.winner_name,
        target.winner_hand = source.winner_hand,
        target.winner_ht = source.winner_ht,
        target.winner_ioc = source.winner_ioc,
        target.winner_age = source.winner_age,
        target.winner_rank = source.winner_rank,
        target.winner_rank_points = source.winner_rank_points,
        target.loser_id = source.loser_id,
        target.loser_seed = source.loser_seed,
        target.loser_entry = source.loser_entry,
        target.loser_name = source.loser_name,
        target.loser_hand = source.loser_hand,
        target.loser_ht = source.loser_ht,
        target.loser_ioc = source.loser_ioc,
        target.loser_age = source.loser_age,
        target.loser_rank = source.loser_rank,
        target.loser_rank_points = source.loser_rank_points,
        target.score = source.score,
        target.best_of = source.best_of,
        target.round = source.round,
        target.minutes = source.minutes,
        target.w_ace = source.w_ace,
        target.w_df = source.w_df,
        target.w_svpt = source.w_svpt,
        target.w_1stIn = source.w_1stIn,
        target.w_1stWon = source.w_1stWon,
        target.w_2ndWon = source.w_2ndWon,
        target.w_SvGms = source.w_SvGms,
        target.w_bpSaved = source.w_bpSaved,
        target.w_bpFaced = source.w_bpFaced,
        target.l_ace = source.l_ace,
        target.l_df = source.l_df,
        target.l_svpt = source.l_svpt,
        target.l_1stIn = source.l_1stIn,
        target.l_1stWon = source.l_1stWon,
        target.l_2ndWon = source.l_2ndWon,
        target.l_SvGms = source.l_SvGms,
        target.l_bpSaved = source.l_bpSaved,
        target.l_bpFaced = source.l_bpFaced;
GO

-- Merge statement to populate dim_atp_players
MERGE dbo.dim_atp_players AS target
USING (SELECT * FROM ATP_0_Main.dbo.atp_players) AS source
ON target.player_id = source.player_id
WHEN NOT MATCHED BY TARGET THEN
    INSERT (player_id, first_name, last_name, hand, birth_date, country_code)
    VALUES (source.player_id, source.first_name, source.last_name, source.hand, source.birth_date, source.country_code)
WHEN MATCHED AND 
    (target.first_name <> source.first_name OR
     target.last_name <> source.last_name OR
     target.hand <> source.hand OR
     target.birth_date <> source.birth_date OR
     target.country_code <> source.country_code)
THEN
    UPDATE SET 
        target.first_name = source.first_name,
        target.last_name = source.last_name,
        target.hand = source.hand,
        target.birth_date = source.birth_date,
        target.country_code = source.country_code;
GO

