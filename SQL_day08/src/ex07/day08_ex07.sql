/*
Please use the command line for PostgreSQL database (psql) for this task. You need to check how your changes will be published to the database for other database users.
Actually, we need two active sessions (i.e. 2 parallel sessions in the command line).
Let’s reproduce a deadlock situation in our database.

Please write any SQL statement with any isolation level (you can use the default setting) on the table pizzeria to reproduce this deadlock situation.
*/

-- Session #1
BEGIN;

-- Session #2
BEGIN;

-- Session #1
UPDATE pizzeria SET rating = 0.1 WHERE id = 1;

-- Session #2
UPDATE pizzeria SET rating = 0.2 WHERE id = 2;

-- Session #1
UPDATE pizzeria SET rating = 0.3 WHERE id = 2;

-- Session #2
UPDATE pizzeria SET rating = 0.4 WHERE id = 1;

-- Session #1
COMMIT;

-- Session #2
COMMIT;
