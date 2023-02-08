## Chapter 4: Complex Calculations
### Exercise 8: Report 4: Tallest athletes and % GDP by region
The final report on the dashboard is Report 4: Avg Tallest Athlete and % of world GDP by Region.

Report Details:

- Column 1 should be region found in the countries table.
- Column 2 should be avg_tallest, which averages the tallest athlete from each country within the region.
- Column 3 should be perc_world_gdp, which represents what % of the world's GDP is attributed to the region.
- GDP should only be counted from years 2005 and on.
- Only winter_games should be included (no summer events).

### Instructions for the exercises: 
- **Query 1**:
    - Pull country_id and height for winter athletes, group by these two fields, and order by country_id and height in descending order.
    - Use ROW_NUMBER() to create row_num, which numbers rows within a country by height where 1 is the tallest.
- **Query 2**:
    - Alias your query as subquery then use this subquery to join the countries table to pull in the region and average_tallest field, the last of which averages the tallest height of each country.
- **Query 3**:
    - Join to the country_stats table to create the perc_world_gdp field that calculates [region's GDP] / [world's GDP].
 ```sql
--Month-over-month comparison

SELECT
	-- Pull month and country_id
	DATE_PART('month',date) AS month,
	country_id,
    -- Pull in current month views
    SUM(views) AS month_views,
    -- Pull in last month views
    LAG(SUM(views)) OVER(PARTITION BY country_id ORDER BY DATE_PART('month',date)) AS previous_month_views,
    -- Calculate the percent change
    SUM(views) /  LAG(SUM(views)) OVER(PARTITION BY country_id ORDER BY DATE_PART('month',date)) -1 AS perc_change
FROM web_data
WHERE date <= '2018-05-31'
GROUP BY month, country_id;




--Week-over-week comparison
SELECT
	-- Pull in date and daily_views
	date,
	SUM(views) AS daily_views,
    -- Calculate the rolling 7 day average
	AVG(SUM(views)) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS weekly_avg
FROM web_data
GROUP BY date;

SELECT 
	-- Pull in date and weekly_avg
	date,
    weekly_avg,
    -- Output the value of weekly_avg from 7 days prior
    LAG(weekly_avg,7) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS weekly_avg_previous
FROM
  (SELECT
      -- Pull in date and daily_views
      date,
      SUM(views) AS daily_views,
      -- Calculate the rolling 7 day average
      AVG(SUM(views)) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS weekly_avg
  FROM web_data
  -- Alias as subquery
  GROUP BY date) AS subquery
-- Order by date in descending order
ORDER BY date DESC;

SELECT 
	-- Pull in date and weekly_avg
	date,
    weekly_avg,
    -- Output the value of weekly_avg from 7 days prior
    LAG(weekly_avg,7) OVER (ORDER BY date) AS weekly_avg_previous,
    -- Calculate percent change vs previous period
    weekly_avg / LAG(weekly_avg,7) OVER (ORDER BY date) - 1 AS perc_change
FROM
  (SELECT
      -- Pull in date and daily_views
      date,
      SUM(views) AS daily_views,
      -- Calculate the rolling 7 day average
      AVG(SUM(views)) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS weekly_avg
  FROM web_data
  -- Alias as subquery
  GROUP BY date) AS subquery
-- Order by date in descending order
ORDER BY date DESC;





--Report 4: Tallest athletes and % GDP by region

SELECT 
	-- Pull in country_id and height
	country_id,
    height,
    -- Number the height of each country's athletes
    ROW_NUMBER() OVER(PARTITION BY country_id) AS row_num
FROM winter_games AS w
JOIN athletes AS a
ON a.id = w.athlete_id
GROUP BY 1, 2
-- Order by country_id and then height in descending order
ORDER BY 1, 2 DESC;


SELECT
	-- Pull in region and calculate avg tallest height
	region,
    AVG(height) AS avg_tallest
FROM countries AS c
JOIN
    (SELECT 
   	    -- Pull in country_id and height
        country_id, 
        height, 
        -- Number the height of each country's athletes
        ROW_NUMBER() OVER (PARTITION BY country_id ORDER BY height DESC) AS row_num
    FROM winter_games AS w 
    JOIN athletes AS a 
    ON w.athlete_id = a.id
    GROUP BY country_id, height
    -- Alias as subquery
    ORDER BY country_id, height DESC) AS subquery
ON c.id = subquery.country_id
-- Only include the tallest height for each country
WHERE row_num = 1
GROUP BY 1;


SELECT
	-- Pull in region and calculate avg tallest height
    region,
    AVG(height) AS avg_tallest,
    -- Calculate region's percent of world gdp
    SUM(gdp) / SUM(SUM(gdp)) OVER() AS perc_world_gdp    
FROM countries AS c
JOIN
    (SELECT 
     	-- Pull in country_id and height
        country_id, 
        height, 
        -- Number the height of each country's athletes
        ROW_NUMBER() OVER (PARTITION BY country_id ORDER BY height DESC) AS row_num
    FROM winter_games AS w 
    JOIN athletes AS a ON w.athlete_id = a.id
    GROUP BY country_id, height
    -- Alias as subquery
    ORDER BY country_id, height DESC) AS subquery
ON c.id = subquery.country_id
-- Join to country_stats
JOIN country_stats AS cs
ON cs.country_id = c.id
-- Only include the tallest height for each country
WHERE row_num = 1
GROUP BY region;
```
