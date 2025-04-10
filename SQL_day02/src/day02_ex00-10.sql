-- Ex00
/*Write a SQL statement that returns a list of pizzerias with the corresponding rating value that have not been visited by people.*/

/*SELECT name, rating FROM pizzeria
WHERE NOT EXISTS (SELECT pizzeria_id FROM person_visits WHERE pizzeria_id = pizzeria.id);*/

SELECT pizzeria.name, pizzeria.rating FROM pizzeria 
LEFT JOIN person_visits ON pizzeria.id = person_visits.pizzeria_id WHERE person_visits.pizzeria_id IS NULL;

/*
    name    | rating 
------------+--------
 DoDo Pizza |    3.2
(1 row)
*/



-- Ex01
/*Please write a SQL statement that returns the missing days from January 1 through January 10, 2022 (including all days) for visits by people with identifiers 1 or 2 (i.e., days missed by both). Please order by visit days in ascending mode. The sample data with column names is shown below.*/

/*SELECT DISTINCT visit_date AS missing_date FROM person_visits
EXCEPT
SELECT visit_date FROM person_visits WHERE visit_date BETWEEN '2022-01-01' AND '2022-01-10' AND person_id IN (1, 2)
ORDER BY missing_date;*/

SELECT DISTINCT person_visits.visit_date AS missing_date
FROM (SELECT visit_date FROM person_visits WHERE visit_date BETWEEN '2022-01-01' AND '2022-01-10' AND person_id BETWEEN 1 AND 2) AS target_visits
RIGHT JOIN person_visits ON target_visits.visit_date = person_visits.visit_date WHERE target_visits.visit_date IS NULL
ORDER BY person_visits.visit_date;


/*
 missing_date 
--------------
 2022-01-03
 2022-01-04
 2022-01-05
 2022-01-06
 2022-01-07
 2022-01-08
 2022-01-09
 2022-01-10
(8 rows)
*/



-- Ex02
/*Please write an SQL statement that will return the entire list of names of people who visited (or did not visit) pizzerias during the period from January 1 to January 3, 2022 on one side and the entire list of names of pizzerias that were visited (or did not visit) on the other side. The data sample with the required column names is shown below. Please note the replacement value '-' for NULL values in the columns person_name and pizzeria_name. Please also add the order for all 3 columns.*/

SELECT
COALESCE (person.name, NULL, '-') AS person_name, target_visits.visit_date, COALESCE (pizzeria.name, NULL, '-') AS pizzeria_name FROM person
FULL JOIN (SELECT * FROM person_visits WHERE visit_date BETWEEN '2022-01-01' AND '2022-01-03') AS target_visits ON person.id = target_visits.person_id
FULL JOIN pizzeria ON pizzeria.id = target_visits.pizzeria_id
ORDER BY person_name, visit_date, pizzeria_name;

/*
 person_name | visit_date | pizzeria_name 
-------------+------------+---------------
 -           |            | DinoPizza
 -           |            | DoDo Pizza
 Andrey      | 2022-01-01 | Dominos
 Andrey      | 2022-01-02 | Pizza Hut
 Anna        | 2022-01-01 | Pizza Hut
 Denis       |            | -
 Dmitriy     |            | -
 Elvira      |            | -
 Irina       | 2022-01-01 | Papa Johns
 Kate        | 2022-01-03 | Best Pizza
 Nataly      |            | -
 Peter       | 2022-01-03 | Pizza Hut
(12 rows)
*/



-- Ex03
/*Let's go back to Exercise #01, please rewrite your SQL using the CTE (Common Table Expression) pattern. Please go to the CTE part of your "day generator". The result should look similar to Exercise #01.*/

WITH day_generator AS (SELECT * FROM generate_series('2022-01-01', '2022-01-10',interval '1 day') AS day_generator )
SELECT day_generator::date AS missing_date FROM (SELECT * FROM person_visits WHERE person_id BETWEEN 1 AND 2) AS target_visits
RIGHT JOIN day_generator ON target_visits.visit_date = day_generator WHERE target_visits.id IS null
ORDER BY missing_date;

/*
 missing_date 
--------------
 2022-01-03
 2022-01-04
 2022-01-05
 2022-01-06
 2022-01-07
 2022-01-08
 2022-01-09
 2022-01-10
(8 rows)
*/



-- Ex04
/*Find complete information about all possible pizzeria names and prices to get mushroom or pepperoni pizza. Then sort the result by pizza name and pizzeria name. The result of the sample data is shown below (please use the same column names in your SQL statement).*/

SELECT pizza_name, pizzeria.name AS pizzeria_name, menu.price AS price FROM menu 
JOIN pizzeria ON pizzeria.id = menu.pizzeria_id WHERE pizza_name = 'mushroom pizza' OR pizza_name = 'pepperoni pizza'
ORDER BY pizza_name, pizzeria_name;

/*
   pizza_name    | pizzeria_name | price 
-----------------+---------------+-------
 mushroom pizza  | Dominos       |  1100
 mushroom pizza  | Papa Johns    |   950
 pepperoni pizza | Best Pizza    |   800
 pepperoni pizza | DinoPizza     |   800
 pepperoni pizza | Papa Johns    |  1000
 pepperoni pizza | Pizza Hut     |  1200
(6 rows)
*/



-- Ex05
/*Find the names of all females over the age of 25 and sort the result by name. The sample output is shown below.*/

SELECT name FROM person WHERE age > 25 AND gender = 'female' ORDER BY name;

/*  name  
--------
 Elvira
 Kate
 Nataly
(3 rows)
*/



-- Ex06
/*Find all pizza names (and corresponding pizzeria names using the menu table) ordered by Denis or Anna. Sort a result by both columns. The sample output is shown below.*/

SELECT pizza_name, pizzeria.name AS pizzeria_name FROM person_order
JOIN person ON person_order.person_id = person.id
JOIN menu ON person_order.menu_id = menu.id
JOIN pizzeria on menu.pizzeria_id = pizzeria.id
WHERE person.name IN ('Denis', 'Anna') ORDER BY pizza_name, pizzeria_name;

/*   pizza_name    | pizzeria_name 
-----------------+---------------
 cheese pizza    | Best Pizza
 cheese pizza    | Pizza Hut
 pepperoni pizza | Best Pizza
 pepperoni pizza | DinoPizza
 pepperoni pizza | Pizza Hut
 sausage pizza   | DinoPizza
 supreme pizza   | Best Pizza
(7 rows)
*/



-- Ex07
/*Please find the name of pizzeria Dmitriy visited on January 8, 2022 and could eat pizza for less than 800 rubles.
Please find the name of the pizzeria Dmitriy visited on January 8, 2022 and could eat pizza for less than 800 rubles.*/

SELECT pizzeria.name AS pizzeria_name FROM (SELECT * FROM person) AS persons
JOIN person_visits ON persons.id = person_visits.person_id
JOIN pizzeria ON person_visits.pizzeria_id = pizzeria.id
JOIN menu ON pizzeria.id = menu.pizzeria_id
WHERE person_visits.visit_date = '2022-01-08' AND persons.name = 'Dmitriy' AND menu.price < 800;

/*
 pizzeria_name 
---------------
 Papa Johns
(1 row)
*/



-- Ex08
/*Please find the names of all men from Moscow or Samara who order either pepperoni or mushroom pizza (or both). Please sort the result by person names in descending order. The sample output is shown below.*/

SELECT DISTINCT name FROM person
JOIN person_order ON person_order.person_id = person.id
JOIN menu ON menu.id = person_order.menu_id
WHERE gender = 'male' AND address IN('Moscow', 'Samara') AND (menu.pizza_name = 'pepperoni pizza' OR menu.pizza_name = 'mushroom pizza') ORDER BY name DESC;

/*
  name   
---------
 Dmitriy
 Andrey
(2 rows)
*/



-- Ex09
/*Find the names of all women who ordered both pepperoni and cheese pizzas (at any time and in any pizzerias). Make sure that the result is ordered by person's name. The sample data is shown below.*/

SELECT name FROM person
JOIN person_order ON person.id = person_order.person_id
JOIN menu ON person_order.menu_id = menu.id WHERE person.gender = 'female' AND (menu.pizza_name = 'pepperoni pizza')
INTERSECT
SELECT name FROM person
JOIN person_order ON person.id = person_order.person_id
JOIN menu ON person_order.menu_id = menu.id WHERE person.gender = 'female' AND (menu.pizza_name = 'cheese pizza')
ORDER BY name;

/*
  name  
--------
 Anna
 Nataly
(2 rows)
*/



-- Ex10
/*Find the names of people who live at the same address. Make sure the result is sorted by 1st person's name, 2nd person's name, and shared address. The data sample is shown below. Make sure your column names match the column names below.*/

WITH person_1 AS (SELECT id, name, address FROM person),
person_2 AS (SELECT id, name, address FROM person)
SELECT person_1.name AS person_name1, person_2.name AS person_name2, person_1.address AS common_address FROM 
person_1 JOIN person_2 ON person_1.id > person_2.id AND person_1.address = person_2.address
ORDER BY person_name1, person_name2, common_address;

/*
 person_name1 | person_name2 |  common_address  
--------------+--------------+------------------
 Andrey       | Anna         | Moscow
 Denis        | Kate         | Kazan
 Elvira       | Denis        | Kazan
 Elvira       | Kate         | Kazan
 Peter        | Irina        | Saint-Petersburg
(5 rows)
*/
