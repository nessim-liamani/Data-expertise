-- Insert data into DimDate
MERGE dwh.DimDate AS target
USING (
    SELECT DISTINCT 
        CAST(CONVERT(VARCHAR, s.date, 112) AS INT) AS DateID,
        s.date AS Date,
        YEAR(s.date) AS Year,
        MONTH(s.date) AS Month,
        DAY(s.date) AS Day,
        DATEPART(QUARTER, s.date) AS Quarter,
        DATENAME(WEEKDAY, s.date) AS DayOfWeek,
        DATEPART(WEEK, s.date) AS WeekOfYear,
        CASE WHEN DATENAME(WEEKDAY, s.date) IN ('Saturday', 'Sunday') THEN 1 ELSE 0 END AS IsWeekend
    FROM oltp.Shooting s
) AS source
ON (target.DateID = source.DateID)
WHEN NOT MATCHED THEN
    INSERT (DateID, Date, Year, Month, Day, Quarter, DayOfWeek, WeekOfYear, IsWeekend)
    VALUES (source.DateID, source.Date, source.Year, source.Month, source.Day, source.Quarter, source.DayOfWeek, source.WeekOfYear, source.IsWeekend);
GO

-- Insert data into DimState
MERGE dwh.DimState AS target
USING (
    SELECT state_id AS StateID, state_name AS StateName, state_abbreviation AS StateAbbreviation
    FROM oltp.State
) AS source
ON (target.StateID = source.StateID)
WHEN NOT MATCHED THEN
    INSERT (StateID, StateName, StateAbbreviation)
    VALUES (source.StateID, source.StateName, source.StateAbbreviation);
GO

-- Insert data into DimCounty
MERGE dwh.DimCounty AS target
USING (
    SELECT county_id AS CountyID, county_name AS CountyName, state_id AS StateID
    FROM oltp.County
) AS source
ON (target.CountyID = source.CountyID)
WHEN NOT MATCHED THEN
    INSERT (CountyID, CountyName, StateID)
    VALUES (source.CountyID, source.CountyName, source.StateID);
GO

-- Insert data into DimCity
MERGE dwh.DimCity AS target
USING (
    SELECT city_id AS CityID, city_name AS CityName, state_id AS StateID, county_id AS CountyID, lat AS Latitude, lng AS Longitude
    FROM oltp.City
) AS source
ON (target.CityID = source.CityID)
WHEN NOT MATCHED THEN
    INSERT (CityID, CityName, StateID, CountyID, Latitude, Longitude)
    VALUES (source.CityID, source.CityName, source.StateID, source.CountyID, source.Latitude, source.Longitude);
GO

-- Insert data into DimRace
MERGE dwh.DimRace AS target
USING (
    SELECT race_id AS RaceID, race_code AS RaceCode, race_description AS RaceDescription
    FROM oltp.Race
) AS source
ON (target.RaceID = source.RaceID)
WHEN NOT MATCHED THEN
    INSERT (RaceID, RaceCode, RaceDescription)
    VALUES (source.RaceID, source.RaceCode, source.RaceDescription);
GO

-- Insert data into DimEthnicitiesByState
MERGE dwh.DimEthnicitiesByState AS target
USING (
    SELECT id AS EthnicityStateID, state_id AS StateID, race_id AS RaceID, population AS Population
    FROM oltp.EthnicitiesByState
) AS source
ON (target.EthnicityStateID = source.EthnicityStateID)
WHEN NOT MATCHED THEN
    INSERT (EthnicityStateID, StateID, RaceID, Population)
    VALUES (source.EthnicityStateID, source.StateID, source.RaceID, source.Population);
GO

-- Insert data into DimSecurityAgency
MERGE dwh.DimSecurityAgency AS target
USING (
    SELECT id AS SecurityAgencyID, name AS Name, type AS Type, s.state_name AS StateName, oricodes AS Oricodes, total_shootings AS TotalShootings
    FROM oltp.SecurityAgency sa
    JOIN oltp.State s ON sa.state_id = s.state_id
) AS source
ON (target.SecurityAgencyID = source.SecurityAgencyID)
WHEN NOT MATCHED THEN
    INSERT (SecurityAgencyID, Name, Type, StateName, Oricodes, TotalShootings)
    VALUES (source.SecurityAgencyID, source.Name, source.Type, source.StateName, source.Oricodes, source.TotalShootings);
GO

-- Insert data into FactShooting
MERGE dwh.FactShooting AS target
USING (
    SELECT 
        s.id AS ShootingID,
        CAST(CONVERT(VARCHAR, s.date, 112) AS INT) AS DateID,
        c.state_id AS StateID,
        s.city_id AS CityID,
        c.county_id AS CountyID,
        r.race_id AS RaceID,
        NULL AS SecurityAgencyID, -- Assuming no direct link to security agency in the shooting table
        s.signs_of_mental_illness AS SignsOfMentalIllness,
        s.threat_level AS ThreatLevel,
        s.flee AS Flee,
        s.body_camera AS BodyCamera,
        s.longitude AS Longitude,
        s.latitude AS Latitude,
        s.is_geocoding_exact AS IsGeocodingExact,
        s.name AS Name,
        s.manner_of_death AS MannerOfDeath,
        s.armed AS Armed,
        s.age AS Age,
        s.gender AS Gender
    FROM oltp.Shooting s
    JOIN oltp.City c ON s.city_id = c.city_id
    JOIN oltp.County co ON c.county_id = co.county_id
    JOIN oltp.Race r ON s.race_id = r.race_id
) AS source
ON (target.ShootingID = source.ShootingID)
WHEN NOT MATCHED THEN
    INSERT (ShootingID, DateID, StateID, CityID, CountyID, RaceID, SecurityAgencyID, SignsOfMentalIllness, ThreatLevel, Flee, BodyCamera, Longitude, Latitude, IsGeocodingExact, Name, MannerOfDeath, Armed, Age, Gender)
    VALUES (source.ShootingID, source.DateID, source.StateID, source.CityID, source.CountyID, source.RaceID, source.SecurityAgencyID, source.SignsOfMentalIllness, source.ThreatLevel, source.Flee, source.BodyCamera, source.Longitude, source.Latitude, source.IsGeocodingExact, source.Name, source.MannerOfDeath, source.Armed, source.Age, source.Gender);
GO

