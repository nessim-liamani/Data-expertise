-- Connect to your SQL Server and run the following script

-- Check if the database already exists
IF NOT EXISTS (
    SELECT name 
    FROM sys.databases 
    WHERE name = N'ATP_0_Main'
)
BEGIN
    PRINT 'Database ATP_0_Main does not exist.';
END;
GO

-- Use the ATP_0_Main database if it exists
IF EXISTS (
    SELECT name 
    FROM sys.databases 
    WHERE name = N'ATP_0_Main'
)
BEGIN
    USE ATP_0_Main;
END;
GO

-- Check and delete data from the atp_matches table if it exists
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'atp_matches' AND xtype = 'U')
BEGIN
    TRUNCATE TABLE dbo.atp_matches;
    PRINT 'Data in table dbo.atp_matches truncated successfully.';

    DROP TABLE dbo.atp_matches;
    PRINT 'Table dbo.atp_matches dropped successfully.';
END
ELSE
BEGIN
    PRINT 'Table dbo.atp_matches does not exist.';
END;
GO

-- Check and delete data from the atp_players table if it exists
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'atp_players' AND xtype = 'U')
BEGIN
    TRUNCATE TABLE dbo.atp_players;
    PRINT 'Data in table dbo.atp_players truncated successfully.';

    DROP TABLE dbo.atp_players;
    PRINT 'Table dbo.atp_players dropped successfully.';
END
ELSE
BEGIN
    PRINT 'Table dbo.atp_players does not exist.';
END;
GO
