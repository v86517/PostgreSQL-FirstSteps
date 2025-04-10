/*
Please use the command line for PostgreSQL database (psql) for this task. You need to check how your changes will be published to the database for other database users.
Actually, we need two active sessions (i.e. 2 parallel sessions in the command line).

Please summarize all ratings for all pizzerias in one transaction mode for Session #1 and then make INSERT of the new restaurant 'Kazan Pizza' with rating 5 and ID=10 in Session #2 (in the same order as in the picture).
*/

-- Session #1
BEGIN ISOLATION LEVEL READ COMMITTED;
SHOW TRANSACTION ISOLATION LEVEL;

-- Session #2
BEGIN ISOLATION LEVEL READ COMMITTED;
SHOW TRANSACTION ISOLATION LEVEL;

-- Session #1
SELECT SUM(rating) FROM pizzeria;

-- Session #2
INSERT INTO pizzeria VALUES (10, 'Kazan Pizza', 5);
COMMIT;

-- Session #1
SELECT SUM(rating) FROM pizzeria;
COMMIT;

-- Session #1
SELECT SUM(rating) FROM pizzeria;

-- Session #2
SELECT SUM(rating) FROM pizzeria;
