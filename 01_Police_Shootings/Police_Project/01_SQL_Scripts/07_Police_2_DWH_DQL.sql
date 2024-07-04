-- 1. Global Situation: Analyze overall trends in police shootings

-- 1.1 Annual number of fatal police shootings in the United States from 2015 to 2022
SELECT dd.Year, 
       COUNT(*) AS TotalFatalShootings
FROM dwh.FactShooting fs
JOIN dwh.DimDate dd ON fs.DateID = dd.DateID
WHERE dd.Year BETWEEN 2015 AND 2022
GROUP BY dd.Year
ORDER BY dd.Year;

-- 1.2 Most common circumstances (manner of death, armed status) under which police shootings occur
SELECT fs.MannerOfDeath AS MannerOfDeath, 
       COUNT(*) AS NumberOfShootings
FROM dwh.FactShooting fs
GROUP BY fs.MannerOfDeath
ORDER BY NumberOfShootings DESC;

-- 1.3 Demographic profile (age, gender, race) of individuals involved in police shootings
SELECT fs.Age, 
       fs.Gender, 
       r.RaceDescription, 
       COUNT(*) AS NumberOfShootings
FROM dwh.FactShooting fs
JOIN dwh.DimRace r ON fs.RaceID = r.RaceID
GROUP BY fs.Age, fs.Gender, r.RaceDescription
ORDER BY NumberOfShootings DESC;

-- 2. Ethnic Discrimination: Determine if certain ethnic groups are disproportionately affected

-- 2.1 Rate of fatal police shootings per 100,000 people for each ethnic group
WITH RacePopulation AS (
    SELECT e.RaceID,
           SUM(CAST(e.Population AS BIGINT)) AS TotalPopulation
    FROM dwh.DimEthnicitiesByState e
    GROUP BY e.RaceID
)
SELECT r.RaceDescription,
       rp.TotalPopulation AS Population,
       COUNT(fs.ShootingID) AS NumberOfShootings,
       CAST(((COUNT(fs.ShootingID) * 1.0 / rp.TotalPopulation) * 100000) AS DECIMAL(10, 2)) AS ShootingRatePer100000
FROM RacePopulation rp
JOIN dwh.DimRace r ON rp.RaceID = r.RaceID
LEFT JOIN dwh.FactShooting fs ON rp.RaceID = fs.RaceID
GROUP BY r.RaceDescription, rp.TotalPopulation
ORDER BY ShootingRatePer100000 DESC;


-- 2.2 Characteristics of police shootings (armed status, threat level) differ between ethnic groups
SELECT r.RaceDescription, 
       fs.ThreatLevel AS ThreatLevel, 
       COUNT(*) AS NumberOfShootings
FROM dwh.FactShooting fs
JOIN dwh.DimRace r ON fs.RaceID = r.RaceID
GROUP BY r.RaceDescription, fs.ThreatLevel
ORDER BY NumberOfShootings DESC;

-- 2.3 Proportion of total police shootings for each ethnic group compared to their population proportion
WITH RacePopulation AS (
    SELECT e.RaceID,
           SUM(CAST(e.Population AS BIGINT)) AS TotalPopulation
    FROM dwh.DimEthnicitiesByState e
    GROUP BY e.RaceID
),
TotalShootings AS (
    SELECT COUNT(*) AS TotalShootings
    FROM dwh.FactShooting
),
TotalPopulation AS (
    SELECT SUM(Population) AS TotalPopulation
    FROM dwh.DimEthnicitiesByState
)
SELECT r.RaceDescription,
       COUNT(fs.ShootingID) AS NumberOfShootings,
       rp.TotalPopulation AS Population,
       CAST((COUNT(fs.ShootingID) * 1.0 / ts.TotalShootings * 100) AS DECIMAL(10, 2)) AS ShootingProportion,
       CAST((rp.TotalPopulation * 1.0 / tp.TotalPopulation * 100) AS DECIMAL(10, 2)) AS PopulationProportion
FROM RacePopulation rp
JOIN dwh.DimRace r ON rp.RaceID = r.RaceID
LEFT JOIN dwh.FactShooting fs ON rp.RaceID = fs.RaceID
JOIN TotalShootings ts ON 1 = 1
JOIN TotalPopulation tp ON 1 = 1
GROUP BY r.RaceDescription, rp.TotalPopulation, ts.TotalShootings, tp.TotalPopulation
ORDER BY ShootingProportion DESC;


-- 3. Regional Differences: Compare shootings across different U.S. regions

-- 3.1 States or regions with the highest and lowest rates of fatal police shootings
SELECT st.StateName, 
       COUNT(*) AS NumberOfShootings
FROM dwh.FactShooting fs
JOIN dwh.DimCity c ON fs.CityID = c.CityID
JOIN dwh.DimState st ON c.StateID = st.StateID
GROUP BY st.StateName
ORDER BY NumberOfShootings DESC;

-- 3.2 Comparison of police shootings by state, focusing on the number of shootings involving unarmed individuals
SELECT st.StateName, 
       COUNT(*) AS NumberOfShootings,
       SUM(CASE WHEN fs.Armed = 'Unarmed' THEN 1 ELSE 0 END) AS UnarmedShootings
FROM dwh.FactShooting fs
JOIN dwh.DimCity c ON fs.CityID = c.CityID
JOIN dwh.DimState st ON c.StateID = st.StateID
GROUP BY st.StateName
ORDER BY NumberOfShootings DESC;

-- 3.3 Characteristics of police shootings (armed status, threat level) in different regions of the United States
SELECT st.StateName, 
       fs.ThreatLevel AS ThreatLevel, 
       COUNT(*) AS NumberOfShootings
FROM dwh.FactShooting fs
JOIN dwh.DimCity c ON fs.CityID = c.CityID
JOIN dwh.DimState st ON c.StateID = st.StateID
GROUP BY st.StateName, fs.ThreatLevel
ORDER BY NumberOfShootings DESC;

-- 4. Temporal Evolution: Identify trends over time

-- 4.1 Annual change in fatal police shootings from 2015 to 2022
SELECT dd.Year, 
       COUNT(*) AS NumberOfShootings
FROM dwh.FactShooting fs
JOIN dwh.DimDate dd ON fs.DateID = dd.DateID
GROUP BY dd.Year
ORDER BY dd.Year;

-- 4.2 Trends in police shootings for different ethnic groups over time
SELECT dd.Year, 
       r.RaceDescription, 
       COUNT(*) AS NumberOfShootings
FROM dwh.FactShooting fs
JOIN dwh.DimDate dd ON fs.DateID = dd.DateID
JOIN dwh.DimRace r ON fs.RaceID = r.RaceID
GROUP BY dd.Year, r.RaceDescription
ORDER BY dd.Year, r.RaceDescription;

-- 4.3 Seasonal or monthly patterns in the occurrence of fatal police shootings
SELECT dd.Year, 
       dd.Month, 
       COUNT(*) AS NumberOfShootings
FROM dwh.FactShooting fs
JOIN dwh.DimDate dd ON fs.DateID = dd.DateID
GROUP BY dd.Year, dd.Month
ORDER BY dd.Year, dd.Month;

-- 5. Police Misconduct: Assess the extent of police misconduct

-- 5.1 Percentage of fatal police shootings involving unarmed victims
SELECT CAST(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM dwh.FactShooting) * 100 AS DECIMAL(10, 2)) AS UnarmedPercentage
FROM dwh.FactShooting
WHERE Armed = 'Unarmed';

-- 5.2 Incidents involving officers with body cameras turned off or malfunctioning
SELECT COUNT(*) AS IncidentsWithoutBodyCamera
FROM dwh.FactShooting
WHERE BodyCamera = 0;

-- 5.3 Frequency of fatal police shootings involving signs of mental illness and their handling
SELECT COUNT(*) AS MentalIllnessShootings
FROM dwh.FactShooting
WHERE SignsOfMentalIllness = 1;

-- Additional breakdown of mental illness shootings by threat level and flee status
SELECT ThreatLevel, 
       Flee, 
       COUNT(*) AS NumberOfShootings
FROM dwh.FactShooting
WHERE SignsOfMentalIllness = 1
GROUP BY ThreatLevel, Flee
ORDER BY NumberOfShootings DESC;
