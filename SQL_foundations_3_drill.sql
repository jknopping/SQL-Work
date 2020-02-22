--SQL FOUNDATIONS III DRILLS
--2) Write a query that returns the namefirst and namelast fields of the people table, along with the 
--inducted field from the hof_inducted table. All rows from the people table should be returned, 
--and NULL values for the fields from hof_inducted should be returned when there is no match found.

SELECT namefirst, namelast, inducted
FROM people LEFT OUTER JOIN hof_inducted 
ON people.playerid = hof_inducted.playerid;

--3) In 2006, a special Baseball Hall of Fame induction was conducted for players from the negro 
--baseball leagues of the 20th century. In that induction, 17 players were posthumously inducted 
--into the Baseball Hall of Fame. Write a query that returns the first and last names, birth and 
--death dates, and birth countries for these players. Note that the year of induction was 2006, 
--and the value for votedby will be “Negro League.”

SELECT namelast, namefirst, birthyear, deathyear, birthcountry
FROM people JOIN hof_inducted
ON people.playerid = hof_inducted.playerid
WHERE votedby = 'Negro League' AND yearid = '2006'
ORDER BY namelast;
--any JOIN statement should work here

--4) Write a query that returns the yearid, playerid, teamid, and salary fields from the salaries 
--table, along with the category field from the hof_inducted table. Keep only the records that are 
--in both salaries and hof_inducted. Hint: While a field named yearid is found in both tables, 
--don’t JOIN by it. You must, however, explicitly name which field to include.

SELECT salaries.yearid, salaries.playerid, teamid, salary, category
FROM salaries INNER JOIN hof_inducted
ON salaries.playerid = hof_inducted.playerid;

--5) Write a query that returns the playerid, yearid, teamid, lgid, and salary fields from the salaries
--table and the inducted field from the hof_inducted table. Keep all records from both tables.

SELECT hof_inducted.playerid, hof_inducted.yearid, teamid, lgid, salary, inducted
FROM salaries FULL OUTER JOIN hof_inducted
ON salaries.playerid = hof_inducted.playerid
ORDER BY hof_inducted.playerid;
--or:
SELECT salaries.playerid, salaries.yearid, teamid, lgid, salary, inducted
FROM hof_inducted FULL OUTER JOIN salaries
ON hof_inducted.playerid = salaries.playerid;

--6) There are 2 tables, hof_inducted and hof_not_inducted, indicating successful and unsuccessful 
--inductions into the Baseball Hall of Fame, respectively.
--i) Combine these 2 tables by all fields. Keep all records.
--ii) Get a distinct list of all player IDs for players who have been put up for HOF induction.

SELECT * FROM hof_inducted
UNION ALL
SELECT * FROM hof_not_inducted;

SELECT playerid FROM hof_inducted
UNION
SELECT playerid FROM hof_not_inducted;

--7) Write a query that returns the last name, first name (see people table), and total recorded 
--salaries for all players found in the salaries table.

SELECT namelast, namefirst, SUM(salary) AS sum_salary
FROM salaries INNER JOIN people
ON salaries.playerid = people.playerid
GROUP BY namelast, namefirst
ORDER BY namelast, namefirst;
--OR:
SELECT namelast, namefirst, SUM(salary)
FROM salaries LEFT OUTER JOIN people
ON salaries.playerid = people.playerid
GROUP BY namelast, namefirst
ORDER BY namelast, namefirst;
--both types of joins work here

--8) Write a query that returns all records from the hof_inducted and hof_not_inducted tables that 
--include playerid, yearid, namefirst, and namelast. Hint: Each FROM statement will include a LEFT 
--OUTER JOIN!

SELECT hof_inducted.playerid, yearid, namefirst, namelast
FROM hof_inducted LEFT OUTER JOIN people
ON hof_inducted.playerid = people.playerid

UNION ALL

SELECT hof_not_inducted.playerid, yearid, namefirst, namelast
FROM hof_not_inducted LEFT OUTER JOIN people
ON hof_not_inducted.playerid = people.playerid;

--9) Return a table including all records from both hof_inducted and hof_not_inducted, and include a 
--new field, namefull, which is formatted as namelast , namefirst (in other words, the last name, 
--followed by a comma, then a space, then the first name). The query should also return the yearid and 
--inducted fields. Include only records since 1980 from both tables. Sort the resulting table by yearid, 
--then inducted so that Y comes before N. Finally, sort by the namefull field, A to Z.

SELECT concat(namelast, ' , ', namefirst) AS namefull, yearid, inducted
FROM hof_inducted LEFT OUTER JOIN people
ON hof_inducted.playerid = people.playerid
WHERE yearid >= 1980

UNION ALL

SELECT concat(namelast, ' , ', namefirst) AS namefull, yearid, inducted
FROM hof_not_inducted LEFT OUTER JOIN people
ON hof_not_inducted.playerid = people.playerid
WHERE yearid >= 1980

ORDER BY yearid, inducted DESC, namefull;

--10) Write a query that returns the highest annual salary for each teamid, ranked from high to low, 
--along with the corresponding playerid. Bonus! Return namelast and namefirst in the resulting table. 
--(You can find these in the people table.)

WITH max_sal AS
(
	SELECT MAX(salary) as highest_sal, teamid, yearid
	FROM salaries 
	GROUP BY teamid, yearid
)

SELECT salaries.yearid, salaries.teamid, playerid, max_sal.highest_sal
FROM max_sal LEFT OUTER JOIN salaries
ON salaries.teamid = max_sal.teamid 
AND salaries.yearid = max_sal.yearid 
AND salaries.salary = max_sal.highest_sal
ORDER BY max_sal.highest_sal DESC;

--bonus:
WITH max AS
(SELECT MAX(salary) as max_salary, teamid, yearid
FROM salaries
GROUP BY teamid, yearid)
SELECT salaries.yearid, salaries.teamid, salaries.playerid, namelast, namefirst, max.max_salary
FROM salaries LEFT OUTER JOIN people
ON salaries.playerid = people.playerid
RIGHT OUTER JOIN max
ON salaries.teamid = max.teamid AND salaries.yearid = max.yearid AND salaries.salary = max.max_salary
ORDER BY max.max_salary DESC;

--11) Select birthyear, deathyear, namefirst, and namelast of all the players born since the birth year
--of Babe Ruth (playerid = ruthba01). Sort the results by birth year from low to high.

--first get birth year of babe ruth
SELECT birthyear
FROM people
WHERE namefirst = 'Babe' AND namelast = 'Ruth';
--could've also used playerid here
--use that query as a subquery
--answer:
SELECT birthyear, deathyear, namefirst, namelast
FROM people
WHERE birthyear >
		(SELECT birthyear
		FROM people
		WHERE namefirst = 'Babe' AND namelast = 'Ruth')
ORDER BY birthyear;

--12) Using the people table, write a query that returns namefirst, namelast, and a field called 
--usaborn where. The usaborn field should show the following: if the player's birthcountry is the USA,
--then the record is 'USA.' Otherwise, it's 'non-USA.' Order the results by 'non-USA' records first.

SELECT namefirst, namelast,
CASE
		WHEN birthcountry = 'USA' THEN 'USA'
		ELSE 'non-USA'
END
FROM people
ORDER BY (CASE
				WHEN birthcountry = 'USA' THEN 'USA'
				ELSE 'non-USA'
		END);
		
--OR (rather than repeating case statement):
SELECT namefirst, namelast,
CASE
		WHEN birthcountry = 'USA' THEN 'USA'
		ELSE 'non-USA'
END
FROM people
ORDER BY 3;

--13) Calculate the average height for players throwing with their right hand versus their left hand. 
--Name these fields right_height and left_height, respectively.

SELECT
AVG(CASE WHEN throws = 'R' THEN height END) AS right_height,
AVG(CASE WHEN throws = 'L' THEN height END) AS left_height
FROM people;

--14) Get the average of each team's maximum player salary since 2010. Hint: WHERE will go 
--inside your CTE.

WITH max_each_year AS
(SELECT MAX(salary) as max_salary, teamid, yearid
FROM salaries
WHERE yearid > 2010
GROUP BY teamid, yearid)

SELECT teamid, AVG(max_salary) AS avg_max_sal
FROM max_each_year
GROUP BY teamid
ORDER BY teamid;

--or:
WITH max_sal_by_team_by_year AS
(
SELECT teamid, yearid, MAX(salary) AS max_sal
FROM salaries
GROUP BY teamid, yearid
)
SELECT teamid, AVG(max_sal) AS avg_max_sal_since_2010
FROM max_sal_by_team_by_year
WHERE yearid > 2010
GROUP BY teamid;

--WHERE clause can go inside or outside CTE!
