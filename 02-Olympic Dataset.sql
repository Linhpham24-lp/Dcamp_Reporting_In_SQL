--Age of oldest athlete by region
-- Select the age of the oldest athlete for each region
SELECT 
	region, 
    MAX(a.age) AS age_of_oldest_athlete
FROM summer_games s
-- First JOIN statement
JOIN athletes a
ON a.id = s.athlete_id
-- Second JOIN statement
JOIN countries c
ON c.id = s.country_id
GROUP BY 1;


--Number of events in each sport
-- Select sport and events for summer sports
SELECT 
	sport , 
    COUNT(DISTINCT event) AS events
FROM summer_games s
GROUP BY 1
UNION
-- Select sport and events for winter sports
SELECT 
	sport, 
    COUNT(DISTINCT event)
FROM winter_games
GROUP BY 1
-- Show the most events at the top of the report
ORDER BY events DESC  ;
