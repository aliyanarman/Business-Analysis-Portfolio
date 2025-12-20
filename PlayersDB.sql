1. -- Finding the average player salary by year.

SELECT salaries.year,
	   ROUND(AVG(salaries.salary), 2) AS "average salary"
FROM salaries
GROUP BY salaries.year
ORDER BY salaries.year DESC;

+------+----------------+
| year | average salary |
+------+----------------+
| 2001 | 2279841.06     |
| 2000 | 1992984.57     |
| 1999 | 1485316.85     |
| 1998 | 1280844.56     |
| 1997 | 1218687.44     |
| 1996 | 1027909.29     |
| 1995 | 964979.07      |
| 1994 | 1049588.56     |
| 1993 | 976966.56      |
| 1992 | 1047520.58     |
| 1991 | 894961.19      |
| 1990 | 511973.69      |
| 1989 | 506323.08      |
| 1988 | 453171.08      |
| 1987 | 434729.47      |
| 1986 | 417147.04      |
| 1985 | 476299.45      |
+------+----------------+

2. /* The team is deciding by what percent to raise salary for its player Ken Griffey Jr.
Fetch Ken's home run history to help the team make a better decision */

SELECT
	performances.year AS "Year",
	performances.HR AS "HomeRun"
FROM
	performances
	JOIN players ON players.id = performances.player_id
WHERE
	players.first_name = 'Ken'
	AND players.last_name = 'Griffey'
	AND players.birth_year = 1969
ORDER BY
	performances.year DESC;

+------+---------+
| Year | HomeRun |
+------+---------+
| 2001 | 22      |
| 2000 | 40      |
| 1999 | 48      |
| 1998 | 56      |
| 1997 | 56      |
| 1996 | 49      |
| 1995 | 17      |
| 1994 | 40      |
| 1993 | 45      |
| 1992 | 27      |
| 1991 | 22      |
| 1990 | 22      |
| 1989 | 16      |
+------+---------+


3. --Find names of all the teams that Satchel Paige played for
SELECT "S. Paige Teams Played"
FROM teams
WHERE id IN (
	SELECT team_id
	FROM performances
	WHERE player_id =
		(SELECT id
		FROM players
		WHERE first_name = 'Satchel'
		AND last_name = 'Paige')
);

+-----------------------+
| S. Paige Teams Played |
+-----------------------+
| Cleveland Indians     |
| Kansas City Athletics |
| St. Louis Browns      |
+-----------------------+


4. /* The team has to hire a player with a dwindling budget, the general manager wants to know which
players were paid the lowest salaries and their home run in 2001 so they can decide which players to hire */

SELECT players.first_name || " " || players.last_name AS "Player Name",
	   salaries.salary AS Salary,
	   performances.HR AS "Home Runs"
FROM players
		 JOIN salaries ON players.id = salaries.player_id
		 JOIN performances ON players.id = performances.player_id
WHERE salaries.year = 2001
	  AND performances.year = 2001
	  AND performances.HR > 0
ORDER BY salaries.salary ASC,
		 players.first_name ASC,
		 players.last_name ASC
LIMIT 5;

+------------------+--------+-----------+
|   Player Name    | Salary | Home Runs |
+------------------+--------+-----------+
| Albert Pujols    | 200000 | 37        |
| D Angelo Jimenez | 200000 | 3         |
| Damian Rolls     | 200000 | 2         |
| David Eckstein   | 200000 | 4         |
| Donaldo Mendez   | 200000 | 1         |
+------------------+--------+-----------+

5. -- Find top 5 teams, sorted by the total number of hits by players in 2001
SELECT teams.name as "Team Name",
	   SUM(performances.H) AS "Total Hits"
FROM teams
JOIN performances ON performances.team_id = teams.id
WHERE performances.year = 2001
GROUP BY teams.name
ORDER BY "Total Hits" DESC
LIMIT 5;

+-------------------+------------+
|     Team Name     | Total Hits |
+-------------------+------------+
| Colorado Rockies  | 1663       |
| Seattle Mariners  | 1637       |
| Texas Rangers     | 1566       |
| Cleveland Indians | 1559       |
| Minnesota Twins   | 1514       |
+-------------------+------------+

6. -- Find the 5 lowest paying competitor teams (by average salary)

SELECT
    t.name AS "Team Name",
    ROUND(AVG(s.salary)) AS "Average Salary"
FROM teams t
JOIN salaries s
    ON s.team_id = t.id
GROUP BY t.name
HAVING AVG(s.salary) > 0
ORDER BY "Average Salary" ASC
LIMIT 5;

+--------------------+----------------+
|     Team Name      | Average Salary |
+--------------------+----------------+
| Minnesota Twins    | 893703         |
| Montreal Expos     | 1134177        |
| Florida Marlins    | 1153629        |
| Oakland Athletics  | 1252250        |
| Kansas City Royals | 1265089        |
+--------------------+----------------+
