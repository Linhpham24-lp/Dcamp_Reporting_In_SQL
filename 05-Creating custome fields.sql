--CASE statement refresher
SELECT 
	name,
    -- Output 'Tall Female', 'Tall Male', or 'Other'
	CASE WHEN height >= 175 and gender ='F' THEN 'Tall Female'
         WHEN height >= 190 and gender = 'M' THEN 'Tall Male'
        ELSE 'Other' END AS segment
FROM athletes;


--BMI bucket by sport
-- Pull in sport, bmi_bucket, and athletes
SELECT 
	s.sport,
    -- Bucket BMI in three groups: <.25, .25-.30, and >.30	
    CASE WHEN weight/height^2*100 <.25 THEN '<.25'
    WHEN weight/height^2*100 <= .30 THEN '.25-.30'
    WHEN weight/height^2*100 >.30 THEN '>.30' END AS bmi_bucket,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games AS s
JOIN athletes AS a
ON a.id = s.athlete_id
-- GROUP BY non-aggregated fields
GROUP BY s.sport,bmi_bucket
-- Sort by sport and then by athletes in descending order
ORDER BY sport, athletes DESC ;



--Troubleshooting CASE statements
SELECT 
    height, weight
    weight/height^2 * 100 as bmi
FROM athletes
WHERE weight/height^2 * 100 IS NULL


-- Uncomment the original query
SELECT 
	sport,
    CASE WHEN weight/height^2*100 <.25 THEN '<.25'
    WHEN weight/height^2*100 <=.30 THEN '.25-.30'
    WHEN weight/height^2*100 >.30 THEN '>.30'
    ELSE  'no weight recorded'
    END AS bmi_bucket,
    COUNT(DISTINCT athlete_id) AS athletes
FROM summer_games AS s
JOIN athletes AS a
ON s.athlete_id = a.id
GROUP BY sport, bmi_bucket
ORDER BY sport, athletes DESC;

/*-- Comment out the troubleshooting query
SELECT 
	height, 
    weight, 
    weight/height^2*100 AS bmi
FROM athletes
WHERE weight/height^2*100 IS NULL;*/
