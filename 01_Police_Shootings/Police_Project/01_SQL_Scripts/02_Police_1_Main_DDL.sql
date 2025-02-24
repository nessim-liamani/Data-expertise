-- Ensure oltp schema exists
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'oltp')
BEGIN
    EXEC('CREATE SCHEMA oltp');
END;
GO

-- Drop existing tables if they exist
IF OBJECT_ID('oltp.Shooting', 'U') IS NOT NULL
    DROP TABLE oltp.Shooting;
IF OBJECT_ID('oltp.EthnicitiesByState', 'U') IS NOT NULL
    DROP TABLE oltp.EthnicitiesByState;
IF OBJECT_ID('oltp.SecurityAgency', 'U') IS NOT NULL
    DROP TABLE oltp.SecurityAgency;
IF OBJECT_ID('oltp.City', 'U') IS NOT NULL
    DROP TABLE oltp.City;
IF OBJECT_ID('oltp.County', 'U') IS NOT NULL
    DROP TABLE oltp.County;
IF OBJECT_ID('oltp.State', 'U') IS NOT NULL
    DROP TABLE oltp.State;
IF OBJECT_ID('oltp.Race', 'U') IS NOT NULL
    DROP TABLE oltp.Race;
GO

-- Create State Table
CREATE TABLE oltp.State (
    state_id INT IDENTITY(1,1) PRIMARY KEY,
    state_name NVARCHAR(50) NOT NULL,
    state_abbreviation NVARCHAR(2) NOT NULL
);
GO

-- Create County Table
CREATE TABLE oltp.County (
    county_id INT IDENTITY(1,1) PRIMARY KEY,
    county_name NVARCHAR(50) NOT NULL,
    state_id INT,
    FOREIGN KEY (state_id) REFERENCES oltp.State(state_id)
);
GO

-- Create City Table
CREATE TABLE oltp.City (
    city_id INT IDENTITY(1,1) PRIMARY KEY,
    city_name NVARCHAR(50) NOT NULL,
    county_id INT,
    state_id INT,
    lat INT,
    lng INT,
    population INT,
    density INT,
    source NVARCHAR(50),
    military NVARCHAR(50),
    incorporated NVARCHAR(50),
    timezone NVARCHAR(50),
    ranking TINYINT,
    zips VARCHAR(MAX),
    FOREIGN KEY (county_id) REFERENCES oltp.County(county_id),
    FOREIGN KEY (state_id) REFERENCES oltp.State(state_id)
);
GO

-- Create Race Table
CREATE TABLE oltp.Race (
    race_id INT IDENTITY(1,1) PRIMARY KEY,
    race_code CHAR(1) NOT NULL,
    race_description NVARCHAR(50) NOT NULL
);
GO

-- Create SecurityAgency Table
CREATE TABLE oltp.SecurityAgency (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(MAX) NOT NULL,
    type NVARCHAR(50),
    state_id INT,
    oricodes NVARCHAR(MAX),
    total_shootings TINYINT,
    FOREIGN KEY (state_id) REFERENCES oltp.State(state_id)
);
GO

-- Create EthnicitiesByState Table
CREATE TABLE oltp.EthnicitiesByState (
    id INT IDENTITY(1,1) PRIMARY KEY,
    state_id INT,
    race_id INT,
    population INT,
    FOREIGN KEY (state_id) REFERENCES oltp.State(state_id),
    FOREIGN KEY (race_id) REFERENCES oltp.Race(race_id)
);
GO

-- Create Shooting Table
CREATE TABLE oltp.Shooting (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50),
    date DATE NOT NULL,
    manner_of_death NVARCHAR(50) NOT NULL,
    armed NVARCHAR(50),
    age TINYINT,
    gender CHAR(1),
    race_id INT,
    city_id INT,
    signs_of_mental_illness BIT NOT NULL,
    threat_level NVARCHAR(50) NOT NULL,
    flee NVARCHAR(50),
    body_camera BIT NOT NULL,
    longitude FLOAT,
    latitude FLOAT,
    is_geocoding_exact CHAR(5) NOT NULL,
    FOREIGN KEY (race_id) REFERENCES oltp.Race(race_id),
    FOREIGN KEY (city_id) REFERENCES oltp.City(city_id)
);
GO
