-- This query retrieves the player who won the most matches between 2010 and 2017.
SELECT TOP 1 
    p.first_name + ' ' + p.last_name AS Player_Name,
    COUNT(m.match_id) AS Wins
FROM 
    dbo.Fact_ATP_Matches m
JOIN 
    dbo.dim_atp_players p ON m.winner_id = p.player_id
JOIN 
    dbo.dim_date d ON m.tourney_date = d.full_date
WHERE 
    d.year BETWEEN 2010 AND 2017
GROUP BY 
    p.first_name, p.last_name
ORDER BY 
    Wins DESC;

-- This query calculates the average duration of best of 3-set matches.
SELECT 
    AVG(m.minutes) AS Average_Duration
FROM 
    dbo.Fact_ATP_Matches m
WHERE 
    m.best_of = 3;

-- This query retrieves the player who hit the most aces for each year.
SELECT 
    d.year,
    p.first_name + ' ' + p.last_name AS Player_Name,
    SUM(m.w_ace) AS Total_Aces
FROM 
    dbo.Fact_ATP_Matches m
JOIN 
    dbo.dim_atp_players p ON m.winner_id = p.player_id
JOIN 
    dbo.dim_date d ON m.tourney_date = d.full_date
GROUP BY 
    d.year, p.first_name, p.last_name
ORDER BY 
    d.year, Total_Aces DESC;

-- This query determines on which surface players are more likely to beat Roger Federer.
SELECT 
    m.surface,
    COUNT(m.match_id) AS Losses_Against_Federer
FROM 
    dbo.Fact_ATP_Matches m
JOIN 
    dbo.dim_atp_players p ON m.loser_id = p.player_id
WHERE 
    p.first_name = 'Roger' AND p.last_name = 'Federer'
GROUP BY 
    m.surface
ORDER BY 
    Losses_Against_Federer DESC;

-- This query retrieves the player who won the most matches on each surface.
SELECT 
    m.surface,
    p.first_name + ' ' + p.last_name AS Player_Name,
    COUNT(m.match_id) AS Wins
FROM 
    dbo.Fact_ATP_Matches m
JOIN 
    dbo.dim_atp_players p ON m.winner_id = p.player_id
GROUP BY 
    m.surface, p.first_name, p.last_name
ORDER BY 
    m.surface, Wins DESC;

-- This query retrieves the player who won the most Davis Cup/Fed Cup matches.
SELECT 
    p.first_name + ' ' + p.last_name AS Player_Name,
    COUNT(m.match_id) AS Wins
FROM 
    dbo.Fact_ATP_Matches m
JOIN 
    dbo.dim_atp_players p ON m.winner_id = p.player_id
WHERE 
    m.tourney_level = 'D' OR m.tourney_level = 'F'
GROUP BY 
    p.first_name, p.last_name
ORDER BY 
    Wins DESC;

-- =======================================================================================================================================

-- This query retrieves the number of matches won by a player after losing the first two sets.
SELECT 
    p.first_name + ' ' + p.last_name AS Player_Name,
    COUNT(m.match_id) AS Comeback_Wins
FROM 
    dbo.Fact_ATP_Matches m
JOIN 
    dbo.dim_atp_players p ON m.winner_id = p.player_id
WHERE 
    m.score LIKE '0-6 0-6%' -- Assuming the score format indicates set results
GROUP BY 
    p.first_name, p.last_name
ORDER BY 
    Comeback_Wins DESC;

-- This query retrieves the number of matches Stan Wawrinka won in the 2014 Australian Open
-- to calculate how unlikely his victory was.

SELECT 
    COUNT(m.match_id) AS Wins
FROM 
    dbo.Fact_ATP_Matches m
JOIN 
    dbo.dim_atp_players p ON m.winner_id = p.player_id
JOIN 
    dbo.dim_date d ON m.tourney_date = d.full_date
WHERE 
    p.first_name = 'Stan' AND p.last_name = 'Wawrinka' AND 
    m.tourney_name = 'Australian Open' AND d.year = 2014;

-- This query retrieves the number of matches Marin Cilic won in the 2014 US Open
-- to calculate how unlikely his victory was.

SELECT 
    COUNT(m.match_id) AS Wins
FROM 
    dbo.Fact_ATP_Matches m
JOIN 
    dbo.dim_atp_players p ON m.winner_id = p.player_id
JOIN 
    dbo.dim_date d ON m.tourney_date = d.full_date
WHERE 
    p.first_name = 'Marin' AND p.last_name = 'Cilic' AND 
    m.tourney_name = 'US Open' AND d.year = 2014;

-- This query checks for a correlation between the number of aces and the match winner.
-- It compares the number of aces hit by the winner and the loser for each match.

SELECT 
    CASE 
        WHEN m.w_ace > m.l_ace THEN 'Winner Hits More Aces'
        WHEN m.w_ace < m.l_ace THEN 'Loser Hits More Aces'
        ELSE 'Equal Aces'
    END AS Aces_Comparison,
    COUNT(m.match_id) AS Matches
FROM 
    dbo.Fact_ATP_Matches m
GROUP BY 
    CASE 
        WHEN m.w_ace > m.l_ace THEN 'Winner Hits More Aces'
        WHEN m.w_ace < m.l_ace THEN 'Loser Hits More Aces'
        ELSE 'Equal Aces'
    END;

-- =======================================================================================================================================

-- This query retrieves the top 5 players with the most wins.
-- It joins the Fact_ATP_Matches table with the dim_atp_players table using the winner_id field
-- and counts the number of wins for each player.
-- The results are ordered by the number of wins in descending order.

SELECT TOP 5 
    p.first_name + ' ' + p.last_name AS Player_Name,
    COUNT(m.match_id) AS Wins
FROM 
    dbo.Fact_ATP_Matches m
JOIN 
    dbo.dim_atp_players p ON m.winner_id = p.player_id
GROUP BY 
    p.first_name, p.last_name
ORDER BY 
    Wins DESC;

-- This query calculates the average duration of matches for each surface type.
-- It groups the Fact_ATP_Matches table by surface and calculates the average minutes for each group.
-- The results are ordered by the average duration in descending order.

SELECT 
    m.surface,
    AVG(m.minutes) AS Average_Duration
FROM 
    dbo.Fact_ATP_Matches m
GROUP BY 
    m.surface
ORDER BY 
    Average_Duration DESC;

-- This query retrieves the count of matches for each month over the years.
-- It joins the Fact_ATP_Matches table with the dim_date table using the tourney_date field
-- and groups the data by year and month.
-- The results show the number of matches held in each month of each year.

SELECT 
    d.year,
    d.month,
    COUNT(m.match_id) AS Match_Count
FROM 
    dbo.Fact_ATP_Matches m
JOIN 
    dbo.dim_date d ON m.tourney_date = d.full_date
GROUP BY 
    d.year, d.month
ORDER BY 
    d.year, d.month;

-- This query retrieves the win/loss record of players for a specific year.
-- It joins the Fact_ATP_Matches table with the dim_atp_players table twice,
-- once for the winner and once for the loser, and filters the matches to a specific year.
-- The results show the number of wins and losses for each player in that year.

DECLARE @Year INT = 2023;

SELECT 
    p.player_id,
    p.first_name + ' ' + p.last_name AS Player_Name,
    SUM(CASE WHEN m.winner_id = p.player_id THEN 1 ELSE 0 END) AS Wins,
    SUM(CASE WHEN m.loser_id = p.player_id THEN 1 ELSE 0 END) AS Losses
FROM 
    dbo.Fact_ATP_Matches m
JOIN 
    dbo.dim_atp_players p ON m.winner_id = p.player_id OR m.loser_id = p.player_id
JOIN 
    dbo.dim_date d ON m.tourney_date = d.full_date
WHERE 
    d.year = @Year
GROUP BY 
    p.player_id, p.first_name, p.last_name
ORDER BY 
    Wins DESC, Losses ASC;

-- This query retrieves the performance (win rate) of players grouped by age within a specific date range.
-- It joins the Fact_ATP_Matches table with the dim_atp_players table and calculates
-- the number of wins and total matches played by players in different age groups.
-- The results show the win rate for each age group.

DECLARE @StartDate DATE = '1970-01-01';
DECLARE @EndDate DATE = '1971-12-31';

SELECT 
    FLOOR(DATEDIFF(YEAR, p.birth_date, m.tourney_date)) AS Age_Group,
    COUNT(m.match_id) AS Matches_Played,
    SUM(CASE WHEN m.winner_id = p.player_id THEN 1 ELSE 0 END) AS Wins,
    SUM(CASE WHEN m.loser_id = p.player_id THEN 1 ELSE 0 END) AS Losses,
    CAST(SUM(CASE WHEN m.winner_id = p.player_id THEN 1 ELSE 0 END) AS FLOAT) / COUNT(m.match_id) AS Win_Rate
FROM 
    dbo.Fact_ATP_Matches m
JOIN 
    dbo.dim_atp_players p ON m.winner_id = p.player_id OR m.loser_id = p.player_id
WHERE 
    m.tourney_date BETWEEN @StartDate AND @EndDate
GROUP BY 
    FLOOR(DATEDIFF(YEAR, p.birth_date, m.tourney_date))
ORDER BY 
    Age_Group;


