-- Ensure dwh schema exists
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'dwh')
BEGIN
    EXEC('CREATE SCHEMA dwh');
END;
GO

-- Drop existing tables if they exist
IF OBJECT_ID('dwh.FactShooting', 'U') IS NOT NULL
    DROP TABLE dwh.FactShooting;
IF OBJECT_ID('dwh.DimEthnicitiesByState', 'U') IS NOT NULL
    DROP TABLE dwh.DimEthnicitiesByState;
IF OBJECT_ID('dwh.DimSecurityAgency', 'U') IS NOT NULL
    DROP TABLE dwh.DimSecurityAgency;
IF OBJECT_ID('dwh.DimCity', 'U') IS NOT NULL
    DROP TABLE dwh.DimCity;
IF OBJECT_ID('dwh.DimCounty', 'U') IS NOT NULL
    DROP TABLE dwh.DimCounty;
IF OBJECT_ID('dwh.DimState', 'U') IS NOT NULL
    DROP TABLE dwh.DimState;
IF OBJECT_ID('dwh.DimRace', 'U') IS NOT NULL
    DROP TABLE dwh.DimRace;
IF OBJECT_ID('dwh.DimDate', 'U') IS NOT NULL
    DROP TABLE dwh.DimDate;
GO

-- Dimension Table: DimDate
CREATE TABLE dwh.DimDate (
    DateID INT PRIMARY KEY,
    Date DATE,
    Year INT,
    Month INT,
    Day INT,
    Quarter INT,
    DayOfWeek NVARCHAR(10),
    WeekOfYear INT,
    IsWeekend BIT
);
GO

-- Dimension Table: DimState
CREATE TABLE dwh.DimState (
    StateID INT PRIMARY KEY,
    StateName NVARCHAR(50),
    StateAbbreviation NVARCHAR(2)
);
GO

-- Dimension Table: DimCounty
CREATE TABLE dwh.DimCounty (
    CountyID INT PRIMARY KEY,
    CountyName NVARCHAR(50),
    StateID INT,
    FOREIGN KEY (StateID) REFERENCES dwh.DimState(StateID)
);
GO

-- Dimension Table: DimCity
CREATE TABLE dwh.DimCity (
    CityID INT PRIMARY KEY,
    CityName NVARCHAR(50),
    StateID INT,
    CountyID INT,
    Latitude FLOAT,
    Longitude FLOAT,
    FOREIGN KEY (StateID) REFERENCES dwh.DimState(StateID),
    FOREIGN KEY (CountyID) REFERENCES dwh.DimCounty(CountyID)
);
GO

-- Dimension Table: DimRace
CREATE TABLE dwh.DimRace (
    RaceID INT PRIMARY KEY,
    RaceCode CHAR(1),
    RaceDescription NVARCHAR(50)
);
GO

-- Dimension Table: DimEthnicitiesByState
CREATE TABLE dwh.DimEthnicitiesByState (
    EthnicityStateID INT PRIMARY KEY,
    StateID INT,
    RaceID INT,
    Population INT,
    FOREIGN KEY (StateID) REFERENCES dwh.DimState(StateID),
    FOREIGN KEY (RaceID) REFERENCES dwh.DimRace(RaceID)
);
GO

-- Dimension Table: DimSecurityAgency
CREATE TABLE dwh.DimSecurityAgency (
    SecurityAgencyID INT PRIMARY KEY,
    Name NVARCHAR(MAX),
    Type NVARCHAR(50),
    StateName NVARCHAR(50),
    Oricodes NVARCHAR(MAX),
    TotalShootings TINYINT
);
GO

-- Fact Table: FactShooting
CREATE TABLE dwh.FactShooting (
    ShootingID INT PRIMARY KEY,
    DateID INT,
    StateID INT,
    CityID INT,
    CountyID INT,
    RaceID INT,
    SecurityAgencyID INT,
    SignsOfMentalIllness BIT,
    ThreatLevel NVARCHAR(50),
    Flee NVARCHAR(50),
    BodyCamera BIT,
    Longitude FLOAT,
    Latitude FLOAT,
    IsGeocodingExact CHAR(5),
    Name NVARCHAR(50),
    MannerOfDeath NVARCHAR(50),
    Armed NVARCHAR(50),
    Age TINYINT,
    Gender CHAR(1),
    FOREIGN KEY (DateID) REFERENCES dwh.DimDate(DateID),
    FOREIGN KEY (StateID) REFERENCES dwh.DimState(StateID),
    FOREIGN KEY (CityID) REFERENCES dwh.DimCity(CityID),
    FOREIGN KEY (CountyID) REFERENCES dwh.DimCounty(CountyID),
    FOREIGN KEY (RaceID) REFERENCES dwh.DimRace(RaceID)
);
GO
