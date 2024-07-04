-- Drop tables if they already exist
IF OBJECT_ID('dbo.ATP_Matches_Raw', 'U') IS NOT NULL DROP TABLE dbo.DB_0_Raw_ATP_Matches;
IF OBJECT_ID('dbo.ATP_Players_Raw', 'U') IS NOT NULL DROP TABLE dbo.DB_0_Raw_ATP_Matches_Players;

-- Create ATP_Matches table with increased VARCHAR sizes
CREATE TABLE dbo.DB_0_Raw_ATP_Matches (
    tourney_id VARCHAR(100),
    tourney_name VARCHAR(200),
    surface VARCHAR(100),
    draw_size INT,
    tourney_level CHAR(10),
    tourney_date DATE,
    match_num INT,
    winner_id INT,
    winner_seed INT,
    winner_entry VARCHAR(100),
    winner_name VARCHAR(200),
    winner_hand CHAR(10),
    winner_ht INT,
    winner_ioc CHAR(10),
    winner_age FLOAT,
    winner_rank INT,
    winner_rank_points INT,
    loser_id INT,
    loser_seed INT,
    loser_entry VARCHAR(100),
    loser_name VARCHAR(200),
    loser_hand CHAR(10),
    loser_ht INT,
    loser_ioc CHAR(10),
    loser_age FLOAT,
    loser_rank INT,
    loser_rank_points INT,
    score VARCHAR(100),
    best_of INT,
    round VARCHAR(50),
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
GO

-- Create ATP_Players table with increased VARCHAR sizes
CREATE TABLE dbo.DB_0_Raw_ATP_Players (
    player_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    hand CHAR(10),
    birth_date DATE,
    country_code CHAR(10)
);
GO

-- ==========================================================================================

-- Import data into ATP_Matches table
DECLARE @Year INT = 1999;
DECLARE @FilePath NVARCHAR(1000);
DECLARE @SQL NVARCHAR(MAX);

WHILE @Year <= 2017
BEGIN
    SET @FilePath = CONCAT('G:\\My Drive\\DocumentsAdministratifs\\Nessim Liamani\\Etudes\\03_FormationsEtCertificationsPro\\ICT\\Data Analysis\\00_Divers\\DA2024_Projects\\python_workspace\\06_BI_Labo_00\\01_Tennis_ATP\\ATP_Project\\00_SourceData\\atp_matches_qual_chall_', @Year, '.csv');
    
    SET @SQL = '
    BEGIN TRY
        BULK INSERT dbo.DB_0_Raw_ATP_Matches
        FROM ''' + @FilePath + '''
        WITH (
            FIELDTERMINATOR = '','',
            ROWTERMINATOR = ''\n'',
            FIRSTROW = 2
        );
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH';
    
    EXEC sp_executesql @SQL;

    SET @Year = @Year + 1;
END

-- Import data into ATP_Players table
DECLARE @PlayersFilePath NVARCHAR(1000) = 'G:\\My Drive\\DocumentsAdministratifs\\Nessim Liamani\\Etudes\\03_FormationsEtCertificationsPro\\ICT\\Data Analysis\\00_Divers\\DA2024_Projects\\python_workspace\\06_BI_Labo_00\\01_Tennis_ATP\\ATP_Project\\00_SourceData\\atp_players.csv';

SET @SQL = '
BEGIN TRY
    BULK INSERT dbo.DB_0_Raw_ATP_Players
    FROM ''' + @PlayersFilePath + '''
    WITH (
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''\n'',
        FIRSTROW = 2
    );
END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_LINE() AS ErrorLine,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH';

EXEC sp_executesql @SQL;
