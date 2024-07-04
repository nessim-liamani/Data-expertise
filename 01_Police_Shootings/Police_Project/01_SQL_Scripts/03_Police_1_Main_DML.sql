-- Populate Race Table
INSERT INTO oltp.Race (race_code, race_description)
VALUES
    ('A', 'Asian'),
    ('B', 'Black'),
    ('H', 'Hispanic'),
    ('N', 'American-Indian'),
    ('O', 'Other'),
    ('W', 'White');
GO

-- Populate State Table
INSERT INTO oltp.State (state_name, state_abbreviation)
SELECT DISTINCT state_name, state_id
FROM dbo.uscities
WHERE state_name IS NOT NULL AND state_id IS NOT NULL;
GO

-- Populate County Table
INSERT INTO oltp.County (county_name, state_id)
SELECT DISTINCT c.county_name, s.state_id
FROM dbo.uscities c
JOIN oltp.State s ON c.state_id = s.state_abbreviation
WHERE c.county_name IS NOT NULL;
GO

-- Populate City Table
INSERT INTO oltp.City (city_name, county_id, state_id, lat, lng, population, density, source, military, incorporated, timezone, ranking, zips)
SELECT c.city, co.county_id, s.state_id, c.lat, c.lng, c.population, c.density, c.source, c.military, c.incorporated, c.timezone, c.ranking, c.zips
FROM dbo.uscities c
JOIN oltp.County co ON c.county_name = co.county_name
JOIN oltp.State s ON c.state_id = s.state_abbreviation;
GO

-- Populate SecurityAgency Table
INSERT INTO oltp.SecurityAgency (name, type, state_id, oricodes, total_shootings)
SELECT DISTINCT a.name, a.type, s.state_id, a.oricodes, a.total_shootings
FROM dbo.[fatal-police-shootings-agencies] a
JOIN oltp.State s ON a.state = s.state_abbreviation;
GO

-- Populate EthnicitiesByState Table
INSERT INTO [oltp].[EthnicitiesByState] (state_id, race_id, population)
SELECT 
    s.state_id,
    r.race_id,
    CASE r.race_code
        WHEN 'A' THEN CAST(REPLACE(ed.Asian, ',', '') AS INT)
        WHEN 'B' THEN CAST(REPLACE(ed.Black, ',', '') AS INT)
        WHEN 'H' THEN CAST(REPLACE(ed.Hispanic, ',', '') AS INT)
        WHEN 'N' THEN CAST(REPLACE(ed.American_Indian, ',', '') AS INT)
        WHEN 'O' THEN CAST(REPLACE(ed.Total_population, ',', '') AS INT) - 
                   (CAST(REPLACE(ed.White, ',', '') AS INT) + 
                    CAST(REPLACE(ed.Black, ',', '') AS INT) + 
                    CAST(REPLACE(ed.Hispanic, ',', '') AS INT) + 
                    CAST(REPLACE(ed.Asian, ',', '') AS INT) + 
                    CAST(REPLACE(ed.American_Indian, ',', '') AS INT))
        WHEN 'W' THEN CAST(REPLACE(ed.White, ',', '') AS INT)
    END AS population
FROM 
    [Police_Test_00].[dbo].[Ethnicity Data USA] ed
JOIN 
    [Police_Test_00].[oltp].[State] s ON ed.State = s.state_name
CROSS JOIN 
    [Police_Test_00].[oltp].[Race] r
ORDER BY 
    s.state_id, r.race_id;



-- Populate Shooting Table
INSERT INTO oltp.Shooting (name, date, manner_of_death, armed, age, gender, city_id, signs_of_mental_illness, threat_level, flee, body_camera, longitude, latitude, is_geocoding_exact, race_id)
SELECT s.name, s.date, s.manner_of_death, s.armed, s.age, s.gender, c.city_id, s.signs_of_mental_illness, s.threat_level, s.flee, s.body_camera, s.longitude, s.latitude, s.is_geocoding_exact, r.race_id
FROM dbo.[fatal-police-shootings] s
JOIN oltp.City c ON s.city = c.city_name
JOIN oltp.Race r ON s.race = r.race_code;
GO
