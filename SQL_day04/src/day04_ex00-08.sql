-- Ex00
/*Please create 2 Database Views (with similar attributes as the original table) based on a simple filtering by gender of persons. Set the corresponding names for the database views: v_persons_female and v_persons_male.*/

CREATE VIEW v_persons_female AS (SELECT * FROM person WHERE gender = 'female');

CREATE VIEW v_persons_male AS SELECT * FROM person WHERE gender = 'male';

/*
slavadb=> CREATE VIEW v_persons_female AS (SELECT * FROM person WHERE gender = 'female');
CREATE VIEW
slavadb=> CREATE VIEW v_persons_male AS SELECT * FROM person WHERE gender = 'male';
CREATE VIEW
slavadb=> 
slavadb=> table v_persons_female;
 id |  name  | age | gender |     address      
----+--------+-----+--------+------------------
  1 | Anna   |  16 | female | Moscow
  3 | Kate   |  33 | female | Kazan
  5 | Elvira |  45 | female | Kazan
  6 | Irina  |  21 | female | Saint-Petersburg
  8 | Nataly |  30 | female | Novosibirsk
(5 rows)

slavadb=> table v_persons_male;
 id |  name   | age | gender |     address      
----+---------+-----+--------+------------------
  2 | Andrey  |  21 | male   | Moscow
  4 | Denis   |  13 | male   | Kazan
  7 | Peter   |  24 | male   | Saint-Petersburg
  9 | Dmitriy |  18 | male   | Samara
(4 rows)
*/



-- Ex01
/*Please use 2 Database Views from Exercise #00 and write SQL to get female and male person names in one list. Please specify the order by person name. The sample data is shown below.*/

SELECT name FROM v_persons_female UNION SELECT name FROM v_persons_male ORDER BY name;

/*
  name   
---------
 Andrey
 Anna
 Denis
 Dmitriy
 Elvira
 Irina
 Kate
 Nataly
 Peter
(9 rows)
*/



-- Ex02
/*Please create a Database View (with name v_generated_dates) which should "store" generated dates from January 1st to January 31st, 2022 in type DATE. Don't forget the order of the generated_date column.*/

CREATE VIEW v_generated_dates AS
SELECT generated_date::date
FROM generate_series(DATE '2022-01-01', DATE '2022-01-31', INTERVAL '1 day') AS generated_date;

/*
slavadb=> CREATE VIEW v_generated_dates AS
SELECT generated_date::date
FROM generate_series(DATE '2022-01-01', DATE '2022-01-31', INTERVAL '1 day') AS generated_date;
CREATE VIEW
slavadb=> table v_generated_dates ;
 generated_date 
----------------
 2022-01-01
 2022-01-02
 2022-01-03
 2022-01-04
 2022-01-05
 2022-01-06
 2022-01-07
 2022-01-08
 2022-01-09
 2022-01-10
 2022-01-11
 2022-01-12
 2022-01-13
 2022-01-14
 2022-01-15
 2022-01-16
 2022-01-17
 2022-01-18
 2022-01-19
 2022-01-20
 2022-01-21
 2022-01-22
 2022-01-23
 2022-01-24
 2022-01-25
 2022-01-26
 2022-01-27
 2022-01-28
 2022-01-29
 2022-01-30
 2022-01-31
(31 rows)
*/



-- Ex03
/*Write a SQL statement that returns missing days for people's visits in January 2022. Use the v_generated_dates view for this task and sort the result by the missing_date column. The sample data is shown below.*/

SELECT generated_date AS missing_date FROM v_generated_dates
EXCEPT
SELECT visit_date FROM person_visits
ORDER BY missing_date;

/*
missing_date 
--------------
 2022-01-11
 2022-01-12
 2022-01-13
 2022-01-14
 2022-01-15
 2022-01-16
 2022-01-17
 2022-01-18
 2022-01-19
 2022-01-20
 2022-01-21
 2022-01-22
 2022-01-23
 2022-01-24
 2022-01-25
 2022-01-26
 2022-01-27
 2022-01-28
 2022-01-29
 2022-01-30
 2022-01-31
(21 rows)
*/



-- Ex04
/*Write an SQL statement that satisfies the formula (R - S)∪(S - R) .
Where R is the person_visits table with a filter through January 2, 2022, S is also the person_visits table but with a different filter through January 6, 2022. Please do your calculations with sets under the person_id column and this column will be alone in a result. Please sort the result by the person_id column and present your final SQL in the v_symmetric_union (*) database view.
(*) To be honest, the definition of "symmetric union" doesn't exist in set theory. This is the author's interpretation, the main idea is based on the existing rule of symmetric difference.*/

CREATE VIEW v_symmetric_union AS SELECT person_id FROM
        ((SELECT * FROM person_visits WHERE visit_date = '2022-01-02'
        EXCEPT
        SELECT * FROM person_visits WHERE visit_date = '2022-01-06')
        UNION 
        (SELECT * FROM person_visits WHERE visit_date = '2022-01-06'
        EXCEPT
        SELECT * FROM person_visits WHERE visit_date = '2022-01-02')) AS person_visits
        ORDER BY person_id;
        
/*
slavadb=> table v_symmetric_union;
 person_id 
-----------
         2
         8
(2 rows)

slavadb=> 
*/



-- Ex05
/*Please create a Database View v_price_with_discount that returns the orders of a person with person name, pizza name, real price and calculated column discount_price (with applied 10% discount and satisfying formula price - price*0.1). Please sort the result by person names and pizza names and convert the discount_price column to integer type. See a sample result below.*/

CREATE VIEW v_price_with_discount AS
(SELECT person.name, menu.pizza_name, menu.price, CAST((menu.price - (menu.price * 0.1)) AS INT) AS dicount_price FROM
person_order JOIN person ON person_id = person.id
	     JOIN menu ON menu_id = menu.id)
ORDER BY name, pizza_name;

/*
slavadb=> table v_price_with_discount;
  name   |   pizza_name    | price | dicount_price 
---------+-----------------+-------+---------------
 Andrey  | cheese pizza    |   800 |           720
 Andrey  | mushroom pizza  |  1100 |           990
 Anna    | cheese pizza    |   900 |           810
 Anna    | pepperoni pizza |  1200 |          1080
 Denis   | cheese pizza    |   700 |           630
 Denis   | pepperoni pizza |   800 |           720
 Denis   | pepperoni pizza |   800 |           720
 Denis   | sausage pizza   |  1000 |           900
 Denis   | sicilian pizza  |   900 |           810
 Denis   | supreme pizza   |   850 |           765
 Dmitriy | pepperoni pizza |   800 |           720
 Dmitriy | supreme pizza   |   850 |           765
 Elvira  | pepperoni pizza |   800 |           720
 Elvira  | sausage pizza   |  1000 |           900
 Irina   | mushroom pizza  |   950 |           855
 Irina   | sicilian pizza  |   900 |           810
 Kate    | cheese pizza    |   700 |           630
 Nataly  | cheese pizza    |   800 |           720
 Nataly  | pepperoni pizza |  1000 |           900
 Peter   | mushroom pizza  |  1100 |           990
 Peter   | sausage pizza   |  1200 |          1080
 Peter   | supreme pizza   |  1200 |          1080
(22 rows)
*/



-- Ex06
/*Please create a Materialized View mv_dmitriy_visits_and_eats (with data included) based on the SQL statement that finds the name of the pizzeria where Dmitriy visited on January 8, 2022 and could eat pizzas for less than 800 rubles (this SQL can be found at Day #02 Exercise #07).*/

CREATE MATERIALIZED VIEW mv_dmitriy_visits_and_eats AS
SELECT pizzeria.name AS pizzeria_name FROM pizzeria
JOIN person_visits ON pizzeria.id = pizzeria_id
JOIN menu ON pizzeria.id = menu.pizzeria_id
JOIN person ON person_id = person.id
WHERE person_visits.visit_date = '2022-01-08' AND person.name = 'Dmitriy' AND menu.price <800;

/*
slavadb=> table mv_dmitriy_visits_and_eats;
 pizzeria_name 
---------------
 Papa Johns
(1 row)
*/



-- Ex07
/*Let's refresh the data in our Materialized View mv_dmitriy_visits_and_eats from Exercise #06. Before this action, please create another Dmitriy visit that satisfies the SQL clause of the Materialized View except pizzeria, which we can see in a result from Exercise #06.
After adding a new visit, please update a data state for mv_dmitriy_visits_and_eats.*/

INSERT INTO person_visits values 
((SELECT MAX(id)+1 FROM person_visits),
(SELECT id FROM person WHERE name = 'Dmitriy'), 
(SELECT MIN(pizzeria.id) FROM pizzeria
                JOIN menu ON pizzeria.id = pizzeria_id
                WHERE pizzeria.name NOT IN (SELECT pizzeria_name FROM mv_dmitriy_visits_and_eats) AND price < 800),
'2022-01-08');

REFRESH MATERIALIZED VIEW mv_dmitriy_visits_and_eats;

/*
slavadb=> table mv_dmitriy_visits_and_eats;
 pizzeria_name 
---------------
 DoDo Pizza
 Papa Johns
(2 rows)
*/



-- Ex08
/*After all our exercises, we have a couple of Virtual Tables and a Materialized View. Let's drop them!*/

DROP VIEW v_generated_dates, v_persons_female, v_persons_male, v_price_with_discount, v_symmetric_union;
DROP MATERIALIZED VIEW mv_dmitriy_visits_and_eats;

/*
slavadb=> DROP VIEW v_generated_dates, v_persons_female, v_persons_male, v_price_with_discount, v_symmetric_union;
DROP MATERIALIZED VIEW mv_dmitriy_visits_and_eats;
DROP VIEW
DROP MATERIALIZED VIEW
slavadb=> 
*/
