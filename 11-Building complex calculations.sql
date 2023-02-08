--TEsting out window function
SELECT 
	country_id,
    year,
    gdp,
    -- Show total gdp per country and alias accordingly
	AVG(gdp) OVER (PARTITION BY country_id) AS country_avg_gdp
FROM country_stats;


SELECT 
	country_id,
    year,
    gdp,
    -- Show total gdp per country and alias accordingly
	SUM(gdp) OVER (PARTITION BY country_id) AS country_sum_gdp
FROM country_stats;


SELECT 
	country_id,
    year,
    gdp,
    -- Show max gdp per country and alias accordingly
	MAX(gdp) OVER (PARTITION BY country_id) AS country_max_gdp
FROM country_stats;


SELECT 
	country_id,
    year,
    gdp,
    -- Show max gdp for the table and alias accordingly
	MAX(gdp) OVER () AS global_max_gdp
FROM country_stats;



--Average total country medals by region
SELECT 
	region, 
    country_id, 
    SUM(gold) AS total_golds
FROM summer_games_clean AS s
JOIN countries AS c
ON s.country_id = c.id
GROUP BY 1,2;


-- Pull in avg_total_golds by region
SELECT 
	region,
    AVG(total_golds) AS avg_total_golds
FROM
  (SELECT 
      region, 
      country_id, 
      SUM(gold) AS total_golds
  FROM summer_games_clean AS s
  JOIN countries AS c
  ON s.country_id = c.id
  -- Alias the subquery
  GROUP BY region, country_id) AS subquery
GROUP BY 1
-- Order by avg_total_golds in descending order
ORDER BY 2 DESC;




--Most decorated athlete per region
SELECT 
	-- Query region, athlete_name, and total gold medals
	region, 
    name AS athlete_name, 
    SUM(gold) AS total_golds,
    -- Assign a regional rank to each athlete
    ROW_NUMBER() OVER(PARTITION BY region ORDER BY SUM(gold)) AS row_num
FROM summer_games_clean AS s
JOIN athletes AS a
ON a.id = s.athlete_id
JOIN countries AS c
ON c.id = s.country_id
GROUP BY 1,2;

-- Query region, athlete name, and total_golds
SELECT 
	region,
    athlete_name,
    total_golds
FROM
    (SELECT 
		-- Query region, athlete_name, and total gold medals
        region, 
        name AS athlete_name, 
        SUM(gold) AS total_golds,
        -- Assign a regional rank to each athlete
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY SUM(gold) DESC) AS row_num
    FROM summer_games_clean AS s
    JOIN athletes AS a
    ON a.id = s.athlete_id
    JOIN countries AS c
    ON s.country_id = c.id
    -- Alias as subquery
    GROUP BY region, athlete_name) AS subquery
-- Filter for only the top athlete per region
WHERE row_num = 1;
