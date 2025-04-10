-- Ex00
/*Let's add a new business feature to our data model.
Every person wants to see a personal discount and every business wants to be closer for customers.
Think about personal discounts for people from one side and pizza restaurants from the other. Need to create a new relational table (please set a name person_discounts) with the following rules.

Set id attribute like a Primary Key (please have a look at id column in existing tables and choose the same data type).
Set attributes person_id and pizzeria_id as foreign keys for corresponding tables (data types should be the same as for id columns in corresponding parent tables).
Please set explicit names for foreign key constraints using the pattern fk_{table_name}_{column_name}, for example fk_person_discounts_person_id.
Add a discount attribute to store a discount value in percent. Remember that the discount value can be a floating-point number (just use the numeric datatype). So please choose the appropriate datatype to cover this possibility.
*/

CREATE TABLE person_discounts (id BIGINT PRIMARY KEY, person_id BIGINT NOT NULL, pizzeria_id BIGINT NOT NULL, discount NUMERIC NOT NULL,
CONSTRAINT fk_person_discounts_person_id FOREIGN KEY (person_id) REFERENCES person(id),
CONSTRAINT fk_person_discounts_pizzeria_id FOREIGN KEY (pizzeria_id) REFERENCES pizzeria(id));

/*
slavadb2=> table person_discounts ;
 id | person_id | pizzeria_id | discount 
----+-----------+-------------+----------
(0 rows)
*/



-- Ex01
/*
Actually, we have created a structure to store our discounts and we are ready to go further and fill our person_discounts table with new records.
So, there is a table person_order which stores the history of a person's orders. Please write a DML statement (INSERT INTO ... SELECT ...) that makes inserts new records into the person_discounts table based on the following rules.

Take aggregated state from person_id and pizzeria_id columns.

Calculate personal discount value by the next pseudo code:
if “amount of orders” = 1 then “discount” = 10.5  else if “amount of orders” = 2 then  “discount” = 22 else  “discount” = 30

To create a primary key for the person_discounts table, use the following SQL construct (this construct is from the WINDOW FUNCTION SQL section).
... ROW_NUMBER( ) OVER ( ) AS id ...
*/

-- drop table person_discounts ;

INSERT INTO person_discounts
(SELECT ROW_NUMBER() OVER () AS id, person_id, menu.pizzeria_id,
(CASE WHEN COUNT(person_id) = 1 THEN 10.5 WHEN COUNT(person_id) = 2 THEN 22 ELSE 30 END) AS discount
FROM person_order
JOIN menu ON person_order.menu_id = menu.id
GROUP BY person_id, menu.pizzeria_id
ORDER BY person_id);

TABLE person_discounts;

/*
slavadb2=> table person_discounts ;                                                                                                    
 id | person_id | pizzeria_id | discount 
----+-----------+-------------+----------
  1 |         1 |           1 |       22
  2 |         2 |           2 |       22
  3 |         3 |           5 |     10.5
  4 |         4 |           2 |     10.5
  5 |         4 |           5 |       30
  6 |         4 |           6 |       22
  7 |         5 |           6 |       22
  8 |         6 |           2 |     10.5
  9 |         6 |           4 |     10.5
 10 |         7 |           1 |       22
 11 |         7 |           2 |     10.5
 12 |         8 |           2 |     10.5
 13 |         8 |           4 |     10.5
 14 |         9 |           5 |     10.5
 15 |         9 |           6 |     10.5
(15 rows)
*/



-- Ex02
/*Write a SQL statement that returns the orders with actual price and price with discount applied for each person in the corresponding pizzeria restaurant, sorted by person name and pizza name. Please see the sample data below.*/

SELECT person.name, menu.pizza_name, menu.price, round(menu.price - menu.price * person_discounts.discount / 100) AS discount_price, pizzeria.name AS pizzeria_name
FROM person
JOIN person_discounts ON person.id = person_id
JOIN pizzeria ON pizzeria.id = pizzeria_id
JOIN person_order ON person.id = person_order.person_id
JOIN menu ON menu.id = menu_id
ORDER BY person.name, pizza_name;

/*
  name   |   pizza_name    | price | discount_price | pizzeria_name 
---------+-----------------+-------+----------------+---------------
 Andrey  | cheese pizza    |   800 |            624 | Dominos
 Andrey  | mushroom pizza  |  1100 |            858 | Dominos
 Anna    | cheese pizza    |   900 |            702 | Pizza Hut
 Anna    | pepperoni pizza |  1200 |            936 | Pizza Hut
 Denis   | cheese pizza    |   700 |            490 | Best Pizza
 Denis   | cheese pizza    |   700 |            546 | DinoPizza
 Denis   | cheese pizza    |   700 |            627 | Dominos
 Denis   | pepperoni pizza |   800 |            624 | DinoPizza
 Denis   | pepperoni pizza |   800 |            624 | DinoPizza
 Denis   | pepperoni pizza |   800 |            560 | Best Pizza
 Denis   | pepperoni pizza |   800 |            716 | Dominos
 Denis   | pepperoni pizza |   800 |            716 | Dominos
 Denis   | pepperoni pizza |   800 |            560 | Best Pizza
 Denis   | sausage pizza   |  1000 |            700 | Best Pizza
 Denis   | sausage pizza   |  1000 |            780 | DinoPizza
 Denis   | sausage pizza   |  1000 |            895 | Dominos
 Denis   | sicilian pizza  |   900 |            630 | Best Pizza
 Denis   | sicilian pizza  |   900 |            702 | DinoPizza
 Denis   | sicilian pizza  |   900 |            806 | Dominos
 Denis   | supreme pizza   |   850 |            595 | Best Pizza
 Denis   | supreme pizza   |   850 |            663 | DinoPizza
 Denis   | supreme pizza   |   850 |            761 | Dominos
 Dmitriy | pepperoni pizza |   800 |            716 | DinoPizza
 Dmitriy | pepperoni pizza |   800 |            716 | Best Pizza
 Dmitriy | supreme pizza   |   850 |            761 | Best Pizza
 Dmitriy | supreme pizza   |   850 |            761 | DinoPizza
 Elvira  | pepperoni pizza |   800 |            624 | DinoPizza
 Elvira  | sausage pizza   |  1000 |            780 | DinoPizza
 Irina   | mushroom pizza  |   950 |            850 | Dominos
 Irina   | mushroom pizza  |   950 |            850 | Papa Johns
 Irina   | sicilian pizza  |   900 |            806 | Dominos
 Irina   | sicilian pizza  |   900 |            806 | Papa Johns
 Kate    | cheese pizza    |   700 |            627 | Best Pizza
 Nataly  | cheese pizza    |   800 |            716 | Dominos
 Nataly  | cheese pizza    |   800 |            716 | Papa Johns
 Nataly  | pepperoni pizza |  1000 |            895 | Dominos
 Nataly  | pepperoni pizza |  1000 |            895 | Papa Johns
 Peter   | mushroom pizza  |  1100 |            985 | Dominos
 Peter   | mushroom pizza  |  1100 |            858 | Pizza Hut
 Peter   | sausage pizza   |  1200 |           1074 | Dominos
 Peter   | sausage pizza   |  1200 |            936 | Pizza Hut
 Peter   | supreme pizza   |  1200 |           1074 | Dominos
 Peter   | supreme pizza   |  1200 |            936 | Pizza Hut
(43 rows)
*/



-- Ex03
/*
Actually, we need to improve data consistency from one side and performance tuning from the other side. Please create a multi-column unique index (named idx_person_discounts_unique) that prevents duplicates of the person and pizzeria identifier pairs.
After creating a new index, please provide any simple SQL statement that shows proof of the index usage (using EXPLAIN ANALYZE).
The proof example is below:

...
Index Scan using idx_person_discounts_unique on person_discounts
...*/
-- DROP INDEX idx_person_discounts_unique;

CREATE UNIQUE INDEX idx_person_discounts_unique ON person_discounts (person_id, pizzeria_id);

SET enable_seqscan TO OFF;

EXPLAIN ANALYZE
SELECT * FROM person_discounts WHERE person_id = 5 AND pizzeria_id = 6;

/*
                                                                  QUERY PLAN                                                                   
-----------------------------------------------------------------------------------------------------------------------------------------------
 Index Scan using idx_person_discounts_unique on person_discounts  (cost=0.14..8.15 rows=1 width=56) (actual time=0.028..0.031 rows=1 loops=1)
   Index Cond: ((person_id = 5) AND (pizzeria_id = 6))
 Planning Time: 0.165 ms
 Execution Time: 0.069 ms
(4 rows)
*/



-- Ex04
/*Please add the following constraint rules for existing columns of the person_discounts table.

person_id column should not be NULL (use constraint name ch_nn_person_id);
pizzeria_id column should not be NULL (use constraint name ch_nn_pizzeria_id);
discount column should not be NULL (use constraint name ch_nn_discount);
discount column should be 0 percent by default;
discount column should be in a range values from 0 to 100 (use constraint name ch_range_discount).
*/

ALTER TABLE person_discounts
    ADD CONSTRAINT ch_nn_person_id CHECK(person_id is NOT NULL),
    ADD CONSTRAINT ch_nn_pizzeria_id CHECK(pizzeria_id is NOT NULL),
    ADD CONSTRAINT ch_nn_discount CHECK(discount is NOT NULL),
    ADD CONSTRAINT ch_range_discount CHECK(discount BETWEEN 0 AND 100),
    ALTER COLUMN discount SET DEFAULT 0;



-- Ex05
/*To comply with Data Governance Policies, you need to add comments for the table and the table's columns. Let's apply this policy to the person_discounts table. Please add English or Russian comments (it is up to you) explaining what is a business goal of a table and all its attributes.*/

COMMENT ON TABLE person_discounts IS 'Table contains person''s personal discounts information at corresponding pizzerias';
COMMENT ON COLUMN person_discounts.id IS 'PRIMARY KEY of unique discount information for corresponding person at corresponding pizzeria';
COMMENT ON COLUMN person_discounts.person_id IS 'FOREIGIN KEY of unique person id defined in table - persons';
COMMENT ON COLUMN person_discounts.pizzeria_id IS 'FOREIGIN KEY of unique pizzria id defined in table - pizzeria';
COMMENT ON COLUMN person_discounts.discount IS 'Numeric value of discount amount in percents';



-- Ex06
/*
Let’s create a Database Sequence named seq_person_discounts (starting with a value of 1) and set a default value for the id attribute of the person_discounts table to automatically take a value from seq_person_discounts each time.
Please note that your next sequence number is 1, in this case please set an actual value for database sequence based on formula "number of rows in person_discounts table" + 1. Otherwise you will get errors about Primary Key violation constraint.
*/
CREATE SEQUENCE seq_person_discount START WITH 1;
SELECT SETVAL('seq_person_discount', (SELECT MAX(id) FROM person_discounts));
ALTER TABLE person_discounts ALTER COLUMN id SET DEFAULT (NEXTVAL('seq_person_discount'));

