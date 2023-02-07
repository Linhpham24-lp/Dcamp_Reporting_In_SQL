--Exploring summer_games
-- Update the query to explore the bronze field
SELECT bronze
FROM summer_games;

-- Update query to explore the unique bronze field values
SELECT DISTINCT bronze
FROM summer_games;

-- Recreate the query by using GROUP BY 
SELECT bronze
FROM summer_games
GROUP BY 1;


-- Add the rows column to your query
SELECT 
	bronze, 
	COUNT(*) AS rows
FROM summer_games
GROUP BY bronze;



--Validating our query
-- Pull total_bronze_medals from summer_games below
SELECT SUM(bronze) AS total_bronze_medals
FROM summer_games;


/* Pull total_bronze_medals from summer_games below
SELECT SUM(bronze) AS total_bronze_medals
FROM summer_games; 
>> OUTPUT = 141 total_bronze_medals */

-- Setup a query that shows bronze_medal by country
SELECT 
	country, 
    SUM(bronze) AS bronze_medals
FROM summer_games AS s
JOIN countries  AS c
ON s.country_id = c.id
GROUP BY 1;

/* Pull total_bronze_medals below
SELECT SUM(bronze) AS total_bronze_medals
FROM summer_games; 
>> OUTPUT = 141 total_bronze_medals */

-- Select the total bronze_medals from your query
SELECT SUM(bronze_medals)
FROM (
-- Previous query is shown below.  Alias this AS subquery
  SELECT 
      country, 
      SUM(bronze) AS bronze_medals
  FROM summer_games AS s
  JOIN countries AS c
  ON s.country_id = c.id
  GROUP BY country) subquery
;


--Report 1: Most decorated summer athletes
-- Pull athlete_name and gold_medals for summer games
SELECT 
	name AS athlete_name, 
    SUM(s.gold) AS gold_medals
FROM summer_games AS s
JOIN athletes AS a
ON a.id = s.athlete_id
GROUP BY 1
-- Filter for only athletes with 3 gold medals or more
HAVING SUM(s.gold) >= 3
-- Sort to show the most gold medals at the top
ORDER BY gold_medals DESC;
