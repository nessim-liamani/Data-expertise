-- 1. Overall Situation of Fatal Police Shootings in the United States

-- Total number of fatal police shootings
SELECT FORMAT(TotalFatalShootings, 'N0') AS TotalFatalShootings
FROM (
    SELECT COUNT(*) AS TotalFatalShootings
    FROM oltp.Shooting
) AS Subquery;

-- Breakdown by manner of death
WITH OrderedMannerOfDeath AS (
    SELECT manner_of_death, COUNT(*) AS NumberOfShootings
    FROM oltp.Shooting
    GROUP BY manner_of_death
),
FormattedMannerOfDeath AS (
    SELECT manner_of_death, NumberOfShootings, FORMAT(NumberOfShootings, 'N0') AS FormattedNumberOfShootings
    FROM OrderedMannerOfDeath
)
SELECT manner_of_death, FormattedNumberOfShootings AS NumberOfShootings
FROM FormattedMannerOfDeath
ORDER BY NumberOfShootings + 0 DESC;

-- Breakdown by whether the person was armed
WITH OrderedArmed AS (
    SELECT armed, COUNT(*) AS NumberOfShootings
    FROM oltp.Shooting
    GROUP BY armed
)
SELECT armed, FORMAT(NumberOfShootings, 'N0') AS NumberOfShootings
FROM OrderedArmed
ORDER BY NumberOfShootings + 0 DESC;

-- 2. Discrimination of a Certain Ethnic Group Among Others

-- Fatal police shootings by race
WITH OrderedShootingsByRace AS (
    SELECT r.race_description, COUNT(*) AS NumberOfShootings
    FROM oltp.Shooting s
    JOIN oltp.Race r ON s.race_id = r.race_id
    GROUP BY r.race_description
)
SELECT race_description, FORMAT(NumberOfShootings, 'N0') AS NumberOfShootings
FROM OrderedShootingsByRace
ORDER BY NumberOfShootings + 0 DESC;

-- Proportion of each race's population that has been involved in fatal police shootings per 100,000 inhabitants
WITH OrderedProportion AS (
    SELECT r.race_description,
           SUM(CAST(ebs.population AS BIGINT)) AS Population,
           COUNT(sh.id) AS NumberOfShootings,
           CAST(((COUNT(sh.id) * 1.0 / SUM(CAST(ebs.population AS BIGINT))) * 100000) AS DECIMAL(10, 2)) AS ShootingRatePer100000
    FROM oltp.EthnicitiesByState ebs
    JOIN oltp.State s ON ebs.state_id = s.state_id
    JOIN oltp.Race r ON ebs.race_id = r.race_id
    LEFT JOIN oltp.Shooting sh ON ebs.state_id = (
        SELECT ci.state_id
        FROM oltp.City ci
        WHERE ci.city_id = sh.city_id
    ) AND ebs.race_id = sh.race_id
    GROUP BY r.race_description
)
SELECT race_description,
       FORMAT(Population, 'N0') AS Population,
       FORMAT(NumberOfShootings, 'N0') AS NumberOfShootings,
       ShootingRatePer100000
FROM OrderedProportion
ORDER BY ShootingRatePer100000 DESC;

-- 3. Differences in Different Regions of the United States

-- Number of fatal police shootings by state
WITH OrderedShootingsByState AS (
    SELECT st.state_name, COUNT(*) AS NumberOfShootings
    FROM oltp.Shooting s
    JOIN oltp.City c ON s.city_id = c.city_id
    JOIN oltp.State st ON c.state_id = st.state_id
    GROUP BY st.state_name
)
SELECT state_name, FORMAT(NumberOfShootings, 'N0') AS NumberOfShootings
FROM OrderedShootingsByState
ORDER BY NumberOfShootings + 0 DESC;

-- Number of fatal police shootings by county
WITH OrderedShootingsByCounty AS (
    SELECT co.county_name, COUNT(*) AS NumberOfShootings
    FROM oltp.Shooting s
    JOIN oltp.City c ON s.city_id = c.city_id
    JOIN oltp.County co ON c.county_id = co.county_id
    GROUP BY co.county_name
)
SELECT county_name, FORMAT(NumberOfShootings, 'N0') AS NumberOfShootings
FROM OrderedShootingsByCounty
ORDER BY NumberOfShootings + 0 DESC;

-- 4. Evolution Over Time

-- Number of fatal police shootings by year
WITH OrderedShootingsByYear AS (
    SELECT YEAR(date) AS Year, COUNT(*) AS NumberOfShootings
    FROM oltp.Shooting
    GROUP BY YEAR(date)
)
SELECT Year, FORMAT(NumberOfShootings, 'N0') AS NumberOfShootings
FROM OrderedShootingsByYear
ORDER BY Year;

-- Number of fatal police shootings by month
WITH OrderedShootingsByMonth AS (
    SELECT YEAR(date) AS Year, MONTH(date) AS Month, COUNT(*) AS NumberOfShootings
    FROM oltp.Shooting
    GROUP BY YEAR(date), MONTH(date)
)
SELECT Year, Month, FORMAT(NumberOfShootings, 'N0') AS NumberOfShootings
FROM OrderedShootingsByMonth
ORDER BY Year, Month;

-- 5. Police Blunders

-- Number of fatal police shootings where the individual was unarmed
SELECT FORMAT(UnarmedShootings, 'N0') AS UnarmedShootings
FROM (
    SELECT COUNT(*) AS UnarmedShootings
    FROM oltp.Shooting
    WHERE armed = 'Unarmed'
) AS Subquery;

-- Number of fatal police shootings with signs of mental illness
SELECT FORMAT(MentalIllnessShootings, 'N0') AS MentalIllnessShootings
FROM (
    SELECT COUNT(*) AS MentalIllnessShootings
    FROM oltp.Shooting
    WHERE signs_of_mental_illness = 1
) AS Subquery;

-- Number of fatal police shootings where the individual was fleeing
SELECT FORMAT(FleeingShootings, 'N0') AS FleeingShootings
FROM (
    SELECT COUNT(*) AS FleeingShootings
    FROM oltp.Shooting
    WHERE flee IS NOT NULL
) AS Subquery;
