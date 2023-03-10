--Identifying data types
-- Pull column_name & data_type from the columns table
SELECT 
	column_name,
    data_type
FROM information_schema.columns
-- Filter for the table 'country_stats'
WHERE table_name = 'country_stats';



--Interpreting error messages
-- Run the query, then convert a data type to fix the error
SELECT AVG(CAST (pop_in_millions AS float)) AS avg_population
FROM country_stats;



SELECT 
	s.country_id, 
    COUNT(DISTINCT s.athlete_id) AS summer_athletes, 
    COUNT(DISTINCT w.athlete_id) AS winter_athletes
FROM summer_games AS s
JOIN winter_games_str AS w
-- Fix the error by making both columns integers
ON CAST(s.country_id AS int) = CAST(w.country_id AS int)
GROUP BY s.country_id;



--Using date functions on strings
SELECT 
	year,
    -- Pull decade, decade_truncate, and the world's gdp
    DATE_PART('decade',CAST(year AS date)) AS decade,
    DATE_TRUNC('decade',CAST(year AS date)) AS decade_truncated,
    SUM(gdp) AS world_gdp
FROM country_stats
-- Group and order by year in descending order
GROUP BY 1,2
ORDER BY 2 DESC;
