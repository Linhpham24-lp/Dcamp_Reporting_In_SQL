--String functions
-- Convert country to lower case
SELECT 
	country, 
    LOWER(country) AS country_altered
FROM countries
GROUP BY country;



-- Convert country to proper case
SELECT 
	country, 
    INITCAP(LOWER(country)) AS country_altered
FROM countries
GROUP BY country;


-- Output the left 3 characters of country
SELECT 
	country, 
    LEFT(INITCAP(country),3) AS country_altered
FROM countries
GROUP BY country;


-- Output all characters starting with position 7
SELECT 
	country, 
    LEFT(country,3) AS country_altered
FROM countries
GROUP BY country;


-- Output all characters starting with position 7
SELECT 
	country, 
    SUBSTR(country,7) AS country_altered
FROM countries
GROUP BY country;



--Replacing and removing substrings
SELECT 
	region, 
    -- Replace all '&' characters with the string 'and'
    REPLACE(region,'&','and') AS character_swap,
    -- Remove all periods
    REPLACE(region,'.','') AS character_remove
FROM countries
WHERE region = 'LATIN AMER. & CARIB'
GROUP BY region;


SELECT 
	region, 
    -- Replace all '&' characters with the string 'and'
    REPLACE(region,'&','and') AS character_swap,
    -- Remove all periods
    REPLACE(region,'.','') AS character_remove,
    -- Combine the functions to run both changes at once
    REPLACE(REPLACE(region,'&','and'),'.','') AS character_swap_and_remove
FROM countries
WHERE region = 'LATIN AMER. & CARIB'
GROUP BY region;


--Fixing incorrect groupings
-- Pull event and unique athletes from summer_games_messy 
SELECT 
	event, 
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games_messy
-- Group by the non-aggregated field
GROUP BY 1;


-- Pull event and unique athletes from summer_games_messy 
SELECT
    -- Remove trailing spaces and alias as event_fixed
	TRIM(event) as event_fixed, 
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games_messy
-- Update the group by accordingly
GROUP BY event_fixed;

-- Pull event and unique athletes from summer_games_messy 
SELECT 
    -- Remove dashes from all event values
    TRIM(REPLACE(event,'-','')) AS event_fixed, 
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games_messy
-- Update the group by accordingly
GROUP BY event_fixed;
