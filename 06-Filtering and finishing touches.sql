
-- Pull summer bronze_medals, silver_medals, and gold_medals
-- Pull summer bronze_medals, silver_medals, and gold_medals
SELECT 
	count(bronze) as bronze_medals, 
    count(silver) as silver_medals, 
    count(gold) as gold_medals
FROM summer_games
JOIN athletes
ON summer_games.athlete_id = athletes.id
-- Filter for athletes age 16 or below
WHERE age <= 16;


-- Pull summer bronze_medals, silver_medals, and gold_medals
-- Pull summer bronze_medals, silver_medals, and gold_medals
SELECT 
	count(bronze) as bronze_medals, 
    count(silver) as silver_medals, 
    count(gold) as gold_medals
FROM summer_games
-- Add the WHERE statement below
WHERE athlete_id IN
    -- Create subquery list for athlete_ids age 16 or below    
    (SELECT id
     FROM athletes
     WHERE age <= 16);

