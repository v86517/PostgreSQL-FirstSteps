/*Please use the command line for PostgreSQL database (psql) for this task. You need to check how your changes will be published to the database for other database users.
Actually, we need two active sessions (i.e. 2 parallel sessions in the command line).

Please check a rating for "Pizza Hut" in a transaction mode for both sessions and then make an UPDATE of the rating to a value of 4 in Session #1 and make an UPDATE of the rating to a value of 3.6 in Session #2 (in the same order as in the picture).
*/

-- Session #1
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SHOW TRANSACTION ISOLATION LEVEL;

-- Session #2
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SHOW TRANSACTION ISOLATION LEVEL;

--Session #1
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

--Session #2
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

--Session #1
UPDATE pizzeria SET rating = 4 WHERE name = 'Pizza Hut';

--Session #2
UPDATE pizzeria SET rating = 3.6 WHERE name = 'Pizza Hut';

--Session #1
COMMIT;

--Session #2
COMMIT;

--Session #1
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

--Session #2
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
