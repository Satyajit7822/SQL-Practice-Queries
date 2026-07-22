use batch9;

CREATE TABLE Teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(50) NOT NULL UNIQUE,
    city VARCHAR(50),
    founded_year INT CHECK (founded_year >= 1900)
);


INSERT INTO Teams VALUES
(1, 'Mumbai Strikers', 'Mumbai', 2005),
(2, 'Delhi Dynamos', 'Delhi', 2010),
(3, 'Chennai Chargers', 'Chennai', 2008),
(4, 'Bangalore Blasters', 'Bangalore', 2012),
(5, 'Kolkata Kings', 'Kolkata', 2003);

CREATE TABLE Players (
    player_id INT PRIMARY KEY,
    player_name VARCHAR(50) NOT NULL,
    team_id INT,
    position VARCHAR(20) NOT NULL,
    jersey_number INT,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

INSERT INTO Players VALUES
(101, 'Ravi Kumar', 1, 'Forward', 9),
(102, 'Aman Gupta', 1, 'Midfielder', 8),
(103, 'Priya Sharma', 2, 'Forward', 11),
(104, 'Karan Mehta', 2, 'Defender', 4),
(105, 'Sneha Iyer', 3, 'Forward', 7),
(106, 'Rohit Verma', 3, 'Midfielder', 10),
(107, 'Divya Nair', 4, 'Defender', 3),
(108, 'Anjali Singh', 4, 'Forward', 15),
(109, 'Vikram Rao', 5, 'Midfielder', 6),
(110, 'Neha Joshi', 5, 'Forward', 19);


CREATE TABLE MatchStats (
    stat_id INT PRIMARY KEY,
    player_id INT,
    match_date DATE,
    goals_scored INT DEFAULT 0 CHECK (goals_scored >= 0),
    assists INT DEFAULT 0 CHECK (assists >= 0),
    minutes_played INT CHECK (minutes_played BETWEEN 0 AND 90),
    FOREIGN KEY (player_id) REFERENCES Players(player_id)
);

INSERT INTO MatchStats VALUES
(1, 101, '2026-06-01', 2, 1, 90),
(2, 101, '2026-06-08', 1, 0, 85),
(3, 102, '2026-06-01', 0, 2, 90),
(4, 102, '2026-06-08', 1, 1, 78),
(5, 103, '2026-06-02', 3, 0, 90),
(6, 103, '2026-06-09', 0, 1, 60),
(7, 104, '2026-06-02', 0, 0, 90),
(8, 105, '2026-06-03', 2, 1, 88),
(9, 105, '2026-06-10', 1, 0, 70),
(10, 106, '2026-06-03', 0, 3, 90),
(11, 107, '2026-06-04', 0, 0, 90),
(12, 108, '2026-06-04', 2, 0, 65),
(13, 108, '2026-06-11', 2, 1, 90),
(14, 109, '2026-06-05', 0, 2, 90),
(15, 110, '2026-06-05', 3, 0, 75),
(16, 110, '2026-06-12', 1, 1, 90);

Select * from Teams;
Select * from Players;
Select * from MatchStats;

-- List every players along with their team name.
	Select p.player_name, t.team_name
	from players p 
	inner join teams t
	on p.team_id = t.team_id;
    
-- Find total number of players in each team
	Select t.team_name, count(p.player_id) as Count_Players 
    from players p 
	inner join teams t
	on p.team_id = t.team_id
    group by t.team_name;
    
-- Find teams that have more than 2 players.
	Select t.team_name, count(p.player_id) as Count_Players 
    from players p 
	inner join teams t
	on p.team_id = t.team_id
    group by t.team_name 
    having Count_Players >2;
	
-- Find the total goal score by each player (across all matches)
	Select p.player_name, sum(m.goals_scored) as Total_goals
    from players p
	inner join matchstats m
    on p.player_id = m.player_id
    group by p.player_name;
    
-- Find players who have scored more than 2 goals in total.
	Select p.player_name, sum(m.goals_scored) as Total_goals
    from players p
	inner join matchstats m
    on p.player_id = m.player_id
    group by p.player_name
    having Total_goals >2;

-- Find the total goals scored by each team (inner joining all three tables)
	Select t.team_name, sum(m.goals_scored) as Total_goals
	from teams t
	inner join players p
    on t.team_id = p.team_id
	inner join matchstats m
    on p.player_id = m.player_id
    group by t.team_name;
    
-- 
	Select t.team_name, sum(m.goals_scored) as Total_goals
	from teams t
	inner join players p
    on t.team_id = p.team_id
	inner join matchstats m
    on p.player_id = m.player_id
    group by t.team_name
    having Total_goals>4;

-- Find the average goals scored per match for each player.
	Select p.player_name, round(avg(m.goals_scored),2) as Average_Goal
    from players p
	inner join matchstats m
    on p.player_id = m.player_id
    group by p.player_name;
    
-- Find players whose average assists per match is greater than 1.
	Select p.player_name, round(avg(m.goals_scored),2) as Average_Goal
    from players p
	inner join matchstats m
    on p.player_id = m.player_id
    group by p.player_name
    having Average_Goal>1;
    
-- Find the number of matches played by each player.
	Select p.player_name, count(m.player_id) as No_Of_Matches_Played
    from players p
	inner join matchstats m
    on p.player_id = m.player_id
    group by p.player_name;
    
-- Find the total minutes played by each team.
	Select t.team_name, sum(m.minutes_played) as Total_Playing_Time 
    from teams t
	inner join players p
    on t.team_id = p.team_id
	inner join matchstats m
    on p.player_id = m.player_id
    group by t.team_name;
    
-- Find the total goals scored by players in each position (Forward, Midfielder, Defender).
	Select p.position, sum(m.goals_scored) as Total_Goals_Score
    from players p
	inner join matchstats m
    on p.player_id = m.player_id
    group by p.position;
    
-- Find positions where the average goals scored per match is more than 1.

	Select p.position,
		   avg(m.goals_scored) as avg_goals
	from Players p
	inner join MatchStats m
	on p.player_id = m.player_id
	group by p.position
	having avg(m.goals_scored) > 1;

-- Find players who have not scored a single goal in any match.

	Select p.player_name
	from Players p
	inner join MatchStats m
	on p.player_id = m.player_id
	group by p.player_id, p.player_name
	having SUM(m.goals_scored) = 0;

-- Find the team with the highest total goals scored.

	Select t.team_name,
		   SUM(m.goals_scored) as total_goals
	from Teams t
	inner join Players p
	on t.team_id = p.team_id
	inner join MatchStats m
	on p.player_id = m.player_id
	group by t.team_id, t.team_name
	ORDER BY total_goals DESC;

-- Find the total assists given by each team.

	Select t.team_name,
		   SUM(m.assists) as total_assists
	from Teams t
	inner join Players p
	on t.team_id = p.team_id
	inner join MatchStats m
	on p.player_id = m.player_id
	group by t.team_id, t.team_name;

-- Find teams whose total assists are less than 3.

	Select t.team_name,
		   SUM(m.assists) as total_assists
	from Teams t
	inner join Players p
	on t.team_id = p.team_id
	inner join MatchStats m
	on p.player_id = m.player_id
	group by t.team_id, t.team_name
	having SUM(m.assists) < 3;

-- Find the number of players per position across the whole league.

	Select position,
		   COUNT(*) as total_players
	from Players
	group by position;
	-- Find the average minutes played by players in each team.
	Select t.team_name,
		   avg(m.minutes_played) as avg_minutes
	from Teams t
	inner join Players p
	on t.team_id = p.team_id
	inner join MatchStats m
	on p.player_id = m.player_id
	group by t.team_id, t.team_name;

-- Find teams where the average minutes played is more than 80.

	Select t.team_name,
		   avg(m.minutes_played) as avg_minutes
	from Teams t
	inner join Players p
	on t.team_id = p.team_id
	inner join MatchStats m
	on p.player_id = m.player_id
	group by t.team_id, t.team_name
	having avg(m.minutes_played) > 80;

-- Find the highest single-match goal count recorded by each player.

	Select p.player_name,
		   MAX(m.goals_scored) as highest_goals
	from Players p
	inner join MatchStats m
	on p.player_id = m.player_id
	group by p.player_id, p.player_name;

-- Find players whose best single-match goal count is 3 or more.

	Select p.player_name,
		   MAX(m.goals_scored) as highest_goals
	from Players p
	inner join MatchStats m
	on p.player_id = m.player_id
	group by p.player_id, p.player_name
	having MAX(m.goals_scored) >= 3;

-- Find the total number of matches recorded for each team.

	Select t.team_name,
		   COUNT(m.stat_id) as total_matches
	from Teams t
	inner join Players p
	on t.team_id = p.team_id
	inner join MatchStats m
	on p.player_id = m.player_id
	group by t.team_id, t.team_name;

-- Find the combined goals + assists (total contributions) for each player.

	Select p.player_name,
		   SUM(m.goals_scored + m.assists) as total_contributions
	from Players p
	inner join MatchStats m
	on p.player_id = m.player_id
	group by p.player_id, p.player_name;

-- Find players whose combined goals + assists is greater than 4.

	Select p.player_name,
		   SUM(m.goals_scored + m.assists) as total_contributions
	from Players p
	inner join MatchStats m
	on p.player_id = m.player_id
	group by p.player_id, p.player_name
	having SUM(m.goals_scored + m.assists) > 4;

-- Find the minimum minutes played in a single match for each player.

	Select p.player_name,
		   MIN(m.minutes_played) as minimum_minutes
	from Players p
	inner join MatchStats m
	on p.player_id = m.player_id
	group by p.player_id, p.player_name;

-- Find the number of goals scored by each team, only counting teams founded after 2005.

	Select t.team_name,
		   SUM(m.goals_scored) as total_goals
	from Teams t
	inner join Players p
	on t.team_id = p.team_id
	inner join MatchStats m
	on p.player_id = m.player_id
	WHERE t.founded_year > 2005
	group by t.team_id, t.team_name;

-- Find positions where more than 3 matches have been recorded in total.

	Select p.position,
		   COUNT(m.stat_id) as total_matches
	from Players p
	inner join MatchStats m
	on p.player_id = m.player_id
	group by p.position
	having COUNT(m.stat_id) > 3;

-- Find teams whose players have collectively played more than 300 total minutes.

	Select t.team_name,
		   SUM(m.minutes_played) as total_minutes
	from Teams t
	inner join Players p
	on t.team_id = p.team_id
	inner join MatchStats m
	on p.player_id = m.player_id
	group by t.team_id, t.team_name
	having SUM(m.minutes_played) > 300;

-- Find each team's average goals scored per player (total team goals divided by number of distinct players who scored), 
-- showing only teams averaging more than 1 goal per player.

	Select t.team_name,
		   round(sum(m.goals_scored)/count(distinct p.player_id,2)) as avg_goals_per_player
	from Teams t
	inner join Players p
	on t.team_id = p.team_id
	inner join MatchStats m
	on p.player_id = m.player_id
	group by t.team_id, t.team_name
	having  avg_goals_per_player >1;
    
    
    

# SUBQUERY
	-- Subquery in WHERE Clause
    -- Find players who play for 'Mumbai Strikers'
		Select player_name, position
        from players
        where team_id =
        (Select team_id from teams where team_name = 'Mumbai Strikers');
        
        
	-- Subquery with multiple values
    -- Find players who belong to city delhi and mumbai
    Select player_name, team_id
    from players
    where team_id in
    (Select team_id from teams where city in ('Delhi','Mumbai'));
    
    
# CTEs (Common Table Expression)
    /* A CTE is a named temporary result set,
	defined using WITH, that you can reference
	later in the same query. It's like a subquery
	but more readable, especially when reused or chained.*/
	 -- Basic CTE
		WITH TeamGoals AS (
			Select p.team_id, sum(m.goals_scored) as Total_Goals
            from players p 
            inner join matchstats m 
            on p.player_id = m.player_id
            group by p.team_id
		)
        Select t.team_name, tg.Total_Goals
        from TeamGoals tg
        inner join teams t
        on tg.team_id=t.team_id
        where tg.Total_Goals >2;
        


-- =====================================================
-- SUBQUERY QUESTIONS
-- =====================================================

-- 1. Find all players who belong to the team 'Chennai Chargers'.

SELECT *
FROM Players
WHERE team_id = (
    SELECT team_id
    FROM Teams
    WHERE team_name = 'Chennai Chargers'
);


-- 2. Find the details of the team where player 'Ravi Kumar' plays.

SELECT *
FROM Teams
WHERE team_id = (
    SELECT team_id
    FROM Players
    WHERE player_name = 'Ravi Kumar'
);


-- 3. Find all match records of the player who wears jersey number 9.

SELECT *
FROM MatchStats
WHERE player_id = (
    SELECT player_id
    FROM Players
    WHERE jersey_number = 9
);


-- 4. Find the team founded in the year 2003.

SELECT *
FROM Teams
WHERE founded_year = (
    SELECT MIN(founded_year)
    FROM Teams
    WHERE founded_year = 2003
);


-- 5. Find all players who belong to teams based in 'Delhi' or 'Mumbai'.

SELECT *
FROM Players
WHERE team_id IN (
    SELECT team_id
    FROM Teams
    WHERE city IN ('Delhi', 'Mumbai')
);


-- 6. Find all match records of players whose position is 'Forward'.

SELECT *
FROM MatchStats
WHERE player_id IN (
    SELECT player_id
    FROM Players
    WHERE position = 'Forward'
);


-- 7. Find all teams that have at least one player with jersey number greater than 10.

SELECT *
FROM Teams
WHERE team_id IN (
    SELECT team_id
    FROM Players
    WHERE jersey_number > 10
);


-- 8. Find all players who have played a match with more than 85 minutes.

SELECT *
FROM Players
WHERE player_id IN (
    SELECT player_id
    FROM MatchStats
    WHERE minutes_played > 85
);



-- =====================================================
-- CTE QUESTIONS
-- =====================================================

-- 1. Using a CTE, find the total goals scored by each player.

WITH TotalGoals AS (
    SELECT
        player_id,
        SUM(goals_scored) AS total_goals
    FROM MatchStats
    GROUP BY player_id
)

SELECT
    p.player_name,
    tg.total_goals
FROM Players p
JOIN TotalGoals tg
ON p.player_id = tg.player_id;



-- 2. Using a CTE, find players whose total assists are greater than 1.

WITH TotalAssists AS (
    SELECT
        player_id,
        SUM(assists) AS total_assists
    FROM MatchStats
    GROUP BY player_id
)

SELECT
    p.player_name,
    ta.total_assists
FROM Players p
JOIN TotalAssists ta
ON p.player_id = ta.player_id
WHERE ta.total_assists > 1;



-- 3. Using a CTE, find the total number of matches played by each player.

WITH MatchCount AS (
    SELECT
        player_id,
        COUNT(*) AS total_matches
    FROM MatchStats
    GROUP BY player_id
)

SELECT
    p.player_name,
    mc.total_matches
FROM Players p
JOIN MatchCount mc
ON p.player_id = mc.player_id;



-- 4. Using a CTE, find the average minutes played by each player.

WITH AvgMinutes AS (
    SELECT
        player_id,
        AVG(minutes_played) AS avg_minutes
    FROM MatchStats
    GROUP BY player_id
)

SELECT
    p.player_name,
    ROUND(am.avg_minutes,2) AS average_minutes
FROM Players p
JOIN AvgMinutes am
ON p.player_id = am.player_id;



-- 5. Using a CTE, find each player's name, team name, and total goals scored.

WITH TotalGoals AS (
    SELECT
        player_id,
        SUM(goals_scored) AS total_goals
    FROM MatchStats
    GROUP BY player_id
)

SELECT
    p.player_name,
    t.team_name,
    tg.total_goals
FROM Players p
JOIN Teams t
ON p.team_id = t.team_id
JOIN TotalGoals tg
ON p.player_id = tg.player_id;



-- 6. Using a CTE, find each team's name along with its total assists, joining Teams and Players.

WITH TeamAssists AS (
    SELECT
        p.team_id,
        SUM(ms.assists) AS total_assists
    FROM Players p
    JOIN MatchStats ms
    ON p.player_id = ms.player_id
    GROUP BY p.team_id
)

SELECT
    t.team_name,
    ta.total_assists
FROM Teams t
JOIN TeamAssists ta
ON t.team_id = ta.team_id;



-- 7. Using a CTE, find each player's name, position, and total contribution (goals + assists), joined with their team name.

WITH PlayerContribution AS (
    SELECT
        player_id,
        SUM(goals_scored + assists) AS total_contribution
    FROM MatchStats
    GROUP BY player_id
)

SELECT
    p.player_name,
    p.position,
    t.team_name,
    pc.total_contribution
FROM Players p
JOIN Teams t
ON p.team_id = t.team_id
JOIN PlayerContribution pc
ON p.player_id = pc.player_id;