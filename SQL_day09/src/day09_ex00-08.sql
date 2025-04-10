-- Ex00
/*We want to be stronger with data, and we don't want to lose any change events. Let's implement an audit function for the incoming changes of INSERT.
Please create a table person_audit with the same structure as a person table, but please add some additional changes. Take a look at the table below with descriptions for each column.

Column			Type			Description
created		timestamp with time zone	timestamp when a new event has been created.  Default value is a current timestamp and NOT NULL
type_event		char(1)			possible values I (insert), D (delete), U (update). Default value is ‘I’. NOT NULL. Add check constraint ch_type_event with possible values ‘I’, ‘U’ and ‘D’
row_id			bigint			copy of person.id. NOT NULL
name			varchar			copy of person.name (no any constraints)
age			integer			copy of person.age (no any constraints)
gender			varchar			copy of person.gender (no any constraints)
address			varchar			copy of person.address (no any constraints)

Actually, let’s create a Database Trigger Function with the name fnc_trg_person_insert_audit that should process INSERT DML traffic and make a copy of a new row in the person_audit table.
Just a hint, if you want to implement a PostgreSQL trigger (please read it in PostgreSQL documentation), you need to create 2 objects: Database Trigger Function and Database Trigger.
So, please define a Database Trigger with the name trg_person_insert_audit with the following options:

trigger with "FOR EACH ROW" option;
trigger with "AFTER INSERT";
trigger calls fnc_trg_person_insert_audit trigger function.

When you are done with the trigger objects, please issue an INSERT statement into the person table.
INSERT INTO person(id, name, age, gender, address) VALUES (10,'Damir', 22, 'male', 'Irkutsk');
*/

DROP TABLE IF EXISTS person_audit;

CREATE TABLE person_audit
( created TIMESTAMP default CURRENT_TIMESTAMP NOT NULL,
  type_event CHAR(1) default 'I' NOT NULL,
  row_id BIGINT NOT NULL,
  name VARCHAR,
  age INTEGER,
  gender VARCHAR ,
  address VARCHAR,
  constraint ch_type_event CHECK (type_event IN ('I','D','U'))
  );

CREATE OR REPLACE FUNCTION fnc_trg_person_insert_audit() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO person_audit(type_event, row_id, name, age, gender, address)
  VALUES('I', new.id, new.name, new.age, new.gender, new.address);
  RETURN NULL;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_person_insert_audit AFTER INSERT ON person FOR EACH ROW EXECUTE FUNCTION fnc_trg_person_insert_audit();

DELETE FROM person where id=10;
INSERT INTO person(id, name, age, gender, address) VALUES (10,'Damir', 22, 'male', 'Irkutsk');
TABLE person_audit;



-- Ex01
/*
Let’s continue to implement our audit pattern for the person table. Just define a trigger trg_person_update_audit and corresponding trigger function fnc_trg_person_update_audit to handle all UPDATE traffic on the person table. We should save the OLD states of all attribute values.
When you are ready, apply the UPDATE statements below.
UPDATE person SET name = 'Bulat' WHERE id = 10;
UPDATE person SET name = 'Damir' WHERE id = 10;
*/

CREATE OR REPLACE FUNCTION fnc_trg_person_update_audit() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO person_audit(type_event,row_id,name,age,gender,address)
  VALUES('U',old.id, old.name, old.age, old.gender, old.address);
  RETURN NULL;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_person_update_audit AFTER UPDATE ON person FOR EACH ROW EXECUTE FUNCTION fnc_trg_person_update_audit();

UPDATE person SET name = 'Bulat' WHERE id = 10; 
UPDATE person SET name = 'Damir' WHERE id = 10;
TABLE person_audit;



-- Ex02
/*
Finally, we need to handle DELETE statements and make a copy of the OLD states for all attribute’s values. Please create a trigger trg_person_delete_audit and corresponding trigger function fnc_trg_person_delete_audit.
When you are ready, use the SQL statement below.
DELETE FROM person WHERE id = 10;
*/

CREATE OR REPLACE FUNCTION fnc_trg_person_delete_audit() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO person_audit(type_event,row_id,name,age,gender,address)
  VALUES('D',old.id, old.name, old.age, old.gender, old.address);
  RETURN NULL;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_person_delete_audit AFTER DELETE ON person FOR EACH ROW EXECUTE FUNCTION fnc_trg_person_delete_audit();

DELETE FROM person WHERE id = 10;
TABLE person_audit;



-- Ex03
/*
Actually, there are 3 triggers for one person table. Let's merge all our logic into one main trigger called trg_person_audit and a new corresponding trigger function fnc_trg_person_audit.
In other words, all DML traffic (INSERT, UPDATE, DELETE) should be handled by the one function block. Please explicitly define a separate IF-ELSE block for each event (I, U, D)!
Additionally, please follow the steps below .

to remove 3 old triggers from the person table;
to remove 3 old trigger functions;
to do a TRUNCATE (or DELETE) of all rows in our person_audit table.

When you are ready, reapply the set of DML statements.
INSERT INTO person(id, name, age, gender, address)  VALUES (10,'Damir', 22, 'male', 'Irkutsk');
UPDATE person SET name = 'Bulat' WHERE id = 10;
UPDATE person SET name = 'Damir' WHERE id = 10;
DELETE FROM person WHERE id = 10;
*/

DROP TRIGGER IF EXISTS trg_person_insert_audit ON person;
DROP TRIGGER IF EXISTS trg_person_update_audit ON person;
DROP TRIGGER IF EXISTS trg_person_delete_audit ON person;

DROP FUNCTION IF EXISTS fnc_trg_person_delete_audit;
DROP FUNCTION IF EXISTS fnc_trg_person_insert_audit;
DROP FUNCTION IF EXISTS fnc_trg_person_update_audit;

DROP TRIGGER IF EXISTS trg_person_audit ON person;
DROP FUNCTION IF EXISTS fnc_trg_person_audit;

CREATE OR REPLACE FUNCTION fnc_trg_person_audit() RETURNS trigger AS $$
BEGIN
IF (TG_OP = 'INSERT') THEN
  INSERT INTO person_audit(type_event,row_id,name,age,gender,address)
  VALUES('I',new.id, new.name, new.age, new.gender, new.address);
  RETURN NULL;
ELSIF (TG_OP = 'UPDATE') THEN
  INSERT INTO person_audit(type_event,row_id,name,age,gender,address)
  VALUES('U',old.id, old.name, old.age, old.gender, old.address);
  RETURN NULL;
ELSIF (TG_OP = 'DELETE') THEN
  INSERT INTO person_audit(type_event,row_id,name,age,gender,address)
  VALUES('D',old.id, old.name, old.age, old.gender, old.address);
END IF;    
  RETURN NULL;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_person_audit AFTER INSERT OR DELETE OR UPDATE ON person FOR EACH ROW EXECUTE FUNCTION fnc_trg_person_audit();

INSERT INTO person(id, name, age, gender, address) VALUES (10,'Damir', 22, 'male', 'Irkutsk'); 
UPDATE person SET name = 'Bulat' WHERE id = 10; 
UPDATE person SET name = 'Damir' WHERE id = 10; 
DELETE FROM person WHERE id = 10;

TABLE person_audit;



-- Ex04
/*
As you recall, we created 2 database views to separate data from the person tables by gender attribute.
Please define 2 SQL functions (note, not pl/pgsql functions) with the names:

fnc_persons_female (should return female persons),

fnc_persons_male (should return male persons).

To check yourself and call a function, you can make a statement like this (Amazing! You can work with a function like a virtual table!):

SELECT * FROM fnc_persons_male();
SELECT * FROM fnc_persons_female();
*/

CREATE OR REPLACE FUNCTION fnc_persons_female()
RETURNS TABLE (
id BIGINT,
name VARCHAR,
age INTEGER,
gender VARCHAR,
address VARCHAR
) AS $$ (SELECT * FROM person WHERE gender = 'female'); $$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION fnc_persons_male()
RETURNS TABLE (
id BIGINT,
name VARCHAR,
age INTEGER,
gender VARCHAR,
address VARCHAR
) AS $$ (SELECT * FROM person WHERE gender = 'male'); $$ LANGUAGE sql;

SELECT * FROM fnc_persons_male();
SELECT * FROM fnc_persons_female();



-- Ex05
/*
Looks like 2 functions from Exercise 04 need a more generic approach. Please remove these functions from the database before proceeding.
Write a generic SQL function (note, not pl/pgsql-function) called fnc_persons. This function should have an IN parameter pgender with the default value = 'female'.
To check yourself and call a function, you can make a statement like this (Wow! You can work with a function like with a virtual table, but with more flexibility!):

select * from fnc_persons(pgender := 'male');
select * from fnc_persons();
*/

CREATE OR REPLACE FUNCTION fnc_persons(pgender VARCHAR DEFAULT 'female')
RETURNS TABLE (
id BIGINT,
name VARCHAR,
age INTEGER,
gender VARCHAR,
address VARCHAR
) AS $$
BEGIN
    RETURN QUERY SELECT * FROM person WHERE person.gender = pgender;
END;
$$ LANGUAGE plpgsql;

select * from fnc_persons(pgender := 'male');
select * from fnc_persons();



-- Ex06
/*
Now let's look at pl/pgsql functions.
Please create a pl/pgsql function fnc_person_visits_and_eats_on_date based on an SQL statement that will find the names of pizzerias that a person (IN pperson parameter with default value 'Dmitriy') visited and where he could buy pizza for less than the given amount in rubles (IN pprice parameter with default value 500) on the given date (IN pdate parameter with default value January 8, 2022).
To check yourself and call a function, you can make a statement like the one below.

select * from fnc_person_visits_and_eats_on_date(pprice := 800);
select * from fnc_person_visits_and_eats_on_date(pperson := 'Anna',pprice := 1300,pdate := '2022-01-01');
*/

CREATE OR REPLACE FUNCTION fnc_person_visits_and_eats_on_date(pperson VARCHAR DEFAULT'Dmitriy', pprice INT DEFAULT 500, pdate DATE DEFAULT '2022-01-08')
RETURNS TABLE 
(pizzeria_name VARCHAR) AS $$
   (SELECT DISTINCT pizzeria.name FROM person_visits
   JOIN person ON person.id=person_visits.person_id
   JOIN pizzeria ON pizzeria.id=person_visits.pizzeria_id
   JOIN menu ON menu.pizzeria_id=pizzeria.id
   WHERE person.name = pperson AND person_visits.visit_date = pdate AND menu.price < pprice)
$$ LANGUAGE sql;

select * from fnc_person_visits_and_eats_on_date(pprice := 800);
select * from fnc_person_visits_and_eats_on_date(pperson := 'Anna',pprice := 1300,pdate := '2022-01-01');



-- Ex07
/*
Please write an SQL or pl/pgsql function func_minimum (it is up to you) that has an input parameter that is an array of numbers and the function should return a minimum value.
To check yourself and call a function, you can make a statement like the one below.

SELECT func_minimum(VARIADIC arr => ARRAY[10.0, -1.0, 5.0, 4.4]);
*/

CREATE OR REPLACE FUNCTION func_minimum (arr numeric[]) RETURNS numeric AS $$
 SELECT MIN(el) FROM UNNEST (arr) AS el;
$$ LANGUAGE SQL;

SELECT func_minimum(VARIADIC arr => ARRAY[10.0, -1.0, 5.0, 4.4]);



-- Ex08
/*
Write an SQL or pl/pgsql function fnc_fibonacci (it's up to you) that has an input parameter pstop of type integer (default is 10) and the function output is a table of all Fibonacci numbers less than pstop.
To check yourself and call a function, you can make a statement like the one below.

select * from fnc_fibonacci(100);
select * from fnc_fibonacci();
*/

CREATE OR REPLACE FUNCTION fnc_fibonacci(IN pstop INTEGER DEFAULT 10)
RETURNS TABLE (num bigint) AS $$

WITH RECURSIVE fib(a, b) AS (SELECT 0 AS a, 1 AS b
UNION ALL
SELECT b, a + b FROM fib WHERE b < pstop)
SELECT a FROM fib;

$$ LANGUAGE SQL;

SELECT * FROM fnc_fibonacci(100);
SELECT * FROM fnc_fibonacci();

