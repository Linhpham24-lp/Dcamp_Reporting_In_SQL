--Identifying Duplication

-- Pull total gold_medals for winter sports
SELECT XUM(gold) AS gold_medals
FROM winter_games;

/*-- Comment out the query after noting the gold medal count
SELECT SUM(gold) AS gold_medals
FROM winter_games;
-- TOTAL GOLD MEDALS: 47  */

-- Show gold_medals and avg_gdp by country_id
SELECT 
	w.country_id, 
    SUM(gold) AS gold_medals, 
    AVG(gdp) AS avg_gdp
FROM winter_games AS w
JOIN country_stats AS c
-- Only join on the country_id fields
ON w.country_id = c.country_id
GROUP BY 1;


-- Comment out the query after noting the gold medal count
/*SELECT SUM(gold) AS gold_medals
FROM winter_games;*/
-- TOTAL GOLD MEDALS: 47 

-- Calculate the total gold_medals in your query
SELECT SUM(gold_medals)
FROM
	(SELECT 
        w.country_id, 
     	SUM(gold) AS gold_medals, 
        AVG(gdp) AS avg_gdp
    FROM winter_games AS w
    JOIN country_stats AS c
    ON c.country_id = w.country_id
    -- Alias your query as subquery
    GROUP BY w.country_id) AS subquery;
    
    
    SELECT SUM(gold_medals) AS gold_medals
FROM
	(SELECT 
     	w.country_id, 
     	SUM(gold) AS gold_medals, 
     	AVG(gdp) AS avg_gdp
    FROM winter_games AS w
    JOIN country_stats AS c
    -- Update the subquery to join on a second field
    ON c.country_id = w.country_id AND CAST(c.year AS DATE) = CAST(w.year AS DATE)
    GROUP BY w.country_id) AS subquery;
    
    
    
    
    
    
    --Report 3: Countries with high medal rates: medals vs population rate.
    SELECT 
	country,
    -- Add the three medal fields using one sum function
	SUM(COALESCE(gold,0)+COALESCE(bronze,0)+COALESCE(silver,0)) AS medals
FROM summer_games AS s
JOIN countries AS c
ON c.id = s.country_id
GROUP BY 1
ORDER BY medals DESC;


SELECT 
	c.country,
    -- Pull in pop_in_millions and medals_per_million 
    pop_in_millions,
    -- Add the three medal fields using one sum function
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) AS medals,
    SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0))/CAST(pop_in_millions AS float) AS medals_per_million
FROM summer_games AS s
JOIN countries AS c
ON s.country_id = c.id
-- Add a join
JOIN country_stats AS cs
ON cs.country_id = s.country_id
GROUP BY c.country, pop_in_millions
ORDER BY medals DESC;



SELECT 
	c.country,
    -- Pull in pop_in_millions and medals_per_million 
	pop_in_millions,
    -- Add the three medal fields using one sum function
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) AS medals,
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) / CAST(cs.pop_in_millions AS float) AS medals_per_million
FROM summer_games AS s
JOIN countries AS c 
ON s.country_id = c.id
-- Update the newest join statement to remove duplication
JOIN country_stats AS cs 
ON s.country_id = cs.country_id AND CAST(s.year AS DATE) = CAST(cs.year AS DATE)
GROUP BY c.country, pop_in_millions
ORDER BY medals DESC;



SELECT 
	-- Clean the country field to only show country_code
    LEFT(TRIM(UPPER(REPLACE(c.country,'.',''))),3) as country_code,
    -- Pull in pop_in_millions and medals_per_million 
	cs.pop_in_millions,
    -- Add the three medal fields using one sum function
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) AS medals,
	SUM(COALESCE(bronze,0) + COALESCE(silver,0) + COALESCE(gold,0)) / CAST(cs.pop_in_millions AS float) AS medals_per_million
FROM summer_games AS s
JOIN countries AS c 
ON s.country_id = c.id
-- Update the newest join statement to remove duplication
JOIN country_stats AS cs 
ON s.country_id = cs.country_id AND s.year = CAST(cs.year AS date)
-- Filter out null populations
WHERE cs.pop_in_millions IS NOT NULL
GROUP BY c.country, pop_in_millions
-- Keep only the top 25 medals_per_million rows
ORDER BY medals_per_million DESC
LIMIT 25;
