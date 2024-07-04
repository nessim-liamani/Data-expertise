-- Connect to your SQL Server and run the following script

-- Check if the database already exists
IF NOT EXISTS (
    SELECT name 
    FROM sys.databases 
    WHERE name = N'ATP_1_DWH'
)
BEGIN
    PRINT 'Database ATP_1_DWH does not exist.';
END;
GO

-- Use the ATP_1_DWH database if it exists
IF EXISTS (
    SELECT name 
    FROM sys.databases 
    WHERE name = N'ATP_1_DWH'
)
BEGIN
    USE ATP_1_DWH;
END;
GO

-- Check and delete data from the Fact_ATP_Matches table if it exists
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'Fact_ATP_Matches' AND xtype = 'U')
BEGIN
    TRUNCATE TABLE dbo.Fact_ATP_Matches;
    PRINT 'Data in table dbo.Fact_ATP_Matches truncated successfully.';

    DROP TABLE dbo.Fact_ATP_Matches;
    PRINT 'Table dbo.Fact_ATP_Matches dropped successfully.';
END
ELSE
BEGIN
    PRINT 'Table dbo.Fact_ATP_Matches does not exist.';
END;
GO

-- Check and delete data from the dim_atp_players table if it exists
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'dim_atp_players' AND xtype = 'U')
BEGIN
    TRUNCATE TABLE dbo.dim_atp_players;
    PRINT 'Data in table dbo.dim_atp_players truncated successfully.';

    DROP TABLE dbo.dim_atp_players;
    PRINT 'Table dbo.dim_atp_players dropped successfully.';
END
ELSE
BEGIN
    PRINT 'Table dbo.dim_atp_players does not exist.';
END;
GO

-- Check and delete data from the dim_date table if it exists
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'dim_date' AND xtype = 'U')
BEGIN
    TRUNCATE TABLE dbo.dim_date;
    PRINT 'Data in table dbo.dim_date truncated successfully.';

    DROP TABLE dbo.dim_date;
    PRINT 'Table dbo.dim_date dropped successfully.';
END
ELSE
BEGIN
    PRINT 'Table dbo.dim_date does not exist.';
END;
GO
