-- Ex00
/*Please write a SQL statement that returns the menu identifier and pizza names from the menu table and the person identifier and person name from the person table in one global list (with column names as shown in the example below) ordered by object_id and then by object_name columns.*/

SELECT id AS object_id, pizza_name AS object_name FROM menu UNION SELECT id AS object_id, name AS object_name FROM person ORDER BY object_id, object_name;

/*
 object_id |   object_name   
-----------+-----------------
         1 | Anna
         1 | cheese pizza
         2 | Andrey
         2 | pepperoni pizza
         3 | Kate
         3 | sausage pizza
         4 | Denis
         4 | supreme pizza
         5 | cheese pizza
         5 | Elvira
         6 | Irina
         6 | pepperoni pizza
         7 | Peter
         7 | sausage pizza
         8 | cheese pizza
         8 | Nataly
         9 | Dmitriy
         9 | mushroom pizza
        10 | cheese pizza
        11 | supreme pizza
        12 | cheese pizza
        13 | mushroom pizza
        14 | pepperoni pizza
        15 | sausage pizza
        16 | cheese pizza
        17 | pepperoni pizza
        18 | supreme pizza
(27 rows)
*/



-- Ex01
/*Please modify an SQL statement from "Exercise 00" by removing the object_id column. Then change the order by object_name for part of the data from the person table and then from the menu table (as shown in an example below). Please save duplicates!*/

(SELECT name AS object_name FROM person ORDER BY name) UNION ALL (SELECT pizza_name AS object_name FROM menu ORDER BY pizza_name);

/*
   object_name   
-----------------
 Andrey
 Anna
 Denis
 Dmitriy
 Elvira
 Irina
 Kate
 Nataly
 Peter
 cheese pizza
 cheese pizza
 cheese pizza
 cheese pizza
 cheese pizza
 cheese pizza
 mushroom pizza
 mushroom pizza
 pepperoni pizza
 pepperoni pizza
 pepperoni pizza
 pepperoni pizza
 sausage pizza
 sausage pizza
 sausage pizza
 supreme pizza
 supreme pizza
 supreme pizza
(27 rows)
*/



-- Ex02
/*Write an SQL statement that returns unique pizza names from the menu table and sorts them by the pizza_name column in descending order. Please note the Denied section.*/

SELECT pizza_name FROM menu UNION SELECT pizza_name FROM menu ORDER BY pizza_name DESC;

/*
   pizza_name    
-----------------
 supreme pizza
 sausage pizza
 pepperoni pizza
 mushroom pizza
 cheese pizza
(5 rows)
*/



-- Ex03
/*Write an SQL statement that returns common rows for attributes order_date, person_id from the person_order table on one side and visit_date, person_id from the person_visits table on the other side (see an example below). In other words, let's find the identifiers of persons who visited and ordered a pizza on the same day. Actually, please add the order by action_date in ascending mode and then by person_id in descending mode.*/

SELECT order_date AS action_date, person_id FROM person_order INTERSECT SELECT visit_date AS action_date, person_id FROM person_visits ORDER BY action_date ASC, person_id DESC; 
         
/*
 action_date | person_id 
-------------+-----------
 2022-01-01  |         6
 2022-01-01  |         2
 2022-01-01  |         1
 2022-01-03  |         7
 2022-01-04  |         3
 2022-01-05  |         7
 2022-01-06  |         8
 2022-01-07  |         8
 2022-01-07  |         4
 2022-01-08  |         4
 2022-01-09  |         9
 2022-01-09  |         5
 2022-01-10  |         9
(13 rows)
*/



-- Ex04
/*Please write a SQL statement that returns a difference (minus) of person_id column values while saving duplicates between person_order table and person_visits table for order_date and visit_date are for January 7, 2022.*/

SELECT person_id FROM person_order WHERE order_date = '2022-01-07'
EXCEPT ALL
SELECT person_id FROM person_visits WHERE visit_date = '2022-01-07';

/*
 person_id 
-----------
         4
         4
(2 rows)
*/



-- Ex05
/*Please write a SQL statement that returns all possible combinations between person and pizzeria tables, and please set the order of the person identifier columns and then the pizzeria identifier columns. Please take a look at the sample result below. Please note that the column names may be different for you.*/

SELECT * FROM person, pizzeria ORDER BY person.id, pizzeria.id;

/*
id |  name   | age | gender |     address      | id |    name    | rating 
----+---------+-----+--------+------------------+----+------------+--------
  1 | Anna    |  16 | female | Moscow           |  1 | Pizza Hut  |    4.6
  1 | Anna    |  16 | female | Moscow           |  2 | Dominos    |    4.3
  1 | Anna    |  16 | female | Moscow           |  3 | DoDo Pizza |    3.2
  1 | Anna    |  16 | female | Moscow           |  4 | Papa Johns |    4.9
  1 | Anna    |  16 | female | Moscow           |  5 | Best Pizza |    2.3
  1 | Anna    |  16 | female | Moscow           |  6 | DinoPizza  |    4.2
  2 | Andrey  |  21 | male   | Moscow           |  1 | Pizza Hut  |    4.6
  2 | Andrey  |  21 | male   | Moscow           |  2 | Dominos    |    4.3
  2 | Andrey  |  21 | male   | Moscow           |  3 | DoDo Pizza |    3.2
  2 | Andrey  |  21 | male   | Moscow           |  4 | Papa Johns |    4.9
  2 | Andrey  |  21 | male   | Moscow           |  5 | Best Pizza |    2.3
  2 | Andrey  |  21 | male   | Moscow           |  6 | DinoPizza  |    4.2
  3 | Kate    |  33 | female | Kazan            |  1 | Pizza Hut  |    4.6
  3 | Kate    |  33 | female | Kazan            |  2 | Dominos    |    4.3
  3 | Kate    |  33 | female | Kazan            |  3 | DoDo Pizza |    3.2
  3 | Kate    |  33 | female | Kazan            |  4 | Papa Johns |    4.9
  3 | Kate    |  33 | female | Kazan            |  5 | Best Pizza |    2.3
  3 | Kate    |  33 | female | Kazan            |  6 | DinoPizza  |    4.2
  4 | Denis   |  13 | male   | Kazan            |  1 | Pizza Hut  |    4.6
  4 | Denis   |  13 | male   | Kazan            |  2 | Dominos    |    4.3
  4 | Denis   |  13 | male   | Kazan            |  3 | DoDo Pizza |    3.2
  4 | Denis   |  13 | male   | Kazan            |  4 | Papa Johns |    4.9
  4 | Denis   |  13 | male   | Kazan            |  5 | Best Pizza |    2.3
  4 | Denis   |  13 | male   | Kazan            |  6 | DinoPizza  |    4.2
  5 | Elvira  |  45 | female | Kazan            |  1 | Pizza Hut  |    4.6
  5 | Elvira  |  45 | female | Kazan            |  2 | Dominos    |    4.3
  5 | Elvira  |  45 | female | Kazan            |  3 | DoDo Pizza |    3.2
  5 | Elvira  |  45 | female | Kazan            |  4 | Papa Johns |    4.9
  5 | Elvira  |  45 | female | Kazan            |  5 | Best Pizza |    2.3
  5 | Elvira  |  45 | female | Kazan            |  6 | DinoPizza  |    4.2
  6 | Irina   |  21 | female | Saint-Petersburg |  1 | Pizza Hut  |    4.6
  6 | Irina   |  21 | female | Saint-Petersburg |  2 | Dominos    |    4.3
  6 | Irina   |  21 | female | Saint-Petersburg |  3 | DoDo Pizza |    3.2
  6 | Irina   |  21 | female | Saint-Petersburg |  4 | Papa Johns |    4.9
  6 | Irina   |  21 | female | Saint-Petersburg |  5 | Best Pizza |    2.3
  6 | Irina   |  21 | female | Saint-Petersburg |  6 | DinoPizza  |    4.2
  7 | Peter   |  24 | male   | Saint-Petersburg |  1 | Pizza Hut  |    4.6
  7 | Peter   |  24 | male   | Saint-Petersburg |  2 | Dominos    |    4.3
  7 | Peter   |  24 | male   | Saint-Petersburg |  3 | DoDo Pizza |    3.2
  7 | Peter   |  24 | male   | Saint-Petersburg |  4 | Papa Johns |    4.9
  7 | Peter   |  24 | male   | Saint-Petersburg |  5 | Best Pizza |    2.3
  7 | Peter   |  24 | male   | Saint-Petersburg |  6 | DinoPizza  |    4.2
  8 | Nataly  |  30 | female | Novosibirsk      |  1 | Pizza Hut  |    4.6
  8 | Nataly  |  30 | female | Novosibirsk      |  2 | Dominos    |    4.3
  8 | Nataly  |  30 | female | Novosibirsk      |  3 | DoDo Pizza |    3.2
  8 | Nataly  |  30 | female | Novosibirsk      |  4 | Papa Johns |    4.9
  8 | Nataly  |  30 | female | Novosibirsk      |  5 | Best Pizza |    2.3
  8 | Nataly  |  30 | female | Novosibirsk      |  6 | DinoPizza  |    4.2
  9 | Dmitriy |  18 | male   | Samara           |  1 | Pizza Hut  |    4.6
  9 | Dmitriy |  18 | male   | Samara           |  2 | Dominos    |    4.3
  9 | Dmitriy |  18 | male   | Samara           |  3 | DoDo Pizza |    3.2
  9 | Dmitriy |  18 | male   | Samara           |  4 | Papa Johns |    4.9
  9 | Dmitriy |  18 | male   | Samara           |  5 | Best Pizza |    2.3
  9 | Dmitriy |  18 | male   | Samara           |  6 | DinoPizza  |    4.2
(54 rows)
*/



-- Ex06
/*Let's go back to Exercise #03 and modify our SQL statement to return person names instead of person identifiers and change the order by action_date in ascending mode and then by person_name in descending mode. Take a look at the sample data below.*/

SELECT order_date AS action_date, (SELECT person.name FROM person WHERE person.id = person_order.person_id) AS person_name FROM person_order
INTERSECT
SELECT visit_date AS action_date, (SELECT person.name FROM person WHERE person.id = person_visits.person_id) AS person_name FROM person_visits
ORDER BY action_date ASC, person_name DESC; 

/*
 action_date | person_name 
-------------+-------------
 2022-01-01  | Irina
 2022-01-01  | Anna
 2022-01-01  | Andrey
 2022-01-03  | Peter
 2022-01-04  | Kate
 2022-01-05  | Peter
 2022-01-06  | Nataly
 2022-01-07  | Nataly
 2022-01-07  | Denis
 2022-01-08  | Denis
 2022-01-09  | Elvira
 2022-01-09  | Dmitriy
 2022-01-10  | Dmitriy
(13 rows)
*/



-- Ex07
/*Write an SQL statement that returns the order date from the person_order table and the corresponding person name (name and age are formatted as in the data sample below) who made an order from the person table. Add a sort by both columns in ascending order.*/

SELECT order_date, CONCAT (name, ' (age:', age, ')') AS person_information FROM person_order
JOIN person ON person.id = person_order.person_id
ORDER BY order_date, person_information;

/*
 order_date | person_information 
------------+--------------------
 2022-01-01 | Andrey (age:21)
 2022-01-01 | Andrey (age:21)
 2022-01-01 | Anna (age:16)
 2022-01-01 | Anna (age:16)
 2022-01-01 | Irina (age:21)
 2022-01-03 | Peter (age:24)
 2022-01-04 | Kate (age:33)
 2022-01-05 | Peter (age:24)
 2022-01-05 | Peter (age:24)
 2022-01-06 | Nataly (age:30)
 2022-01-07 | Denis (age:13)
 2022-01-07 | Denis (age:13)
 2022-01-07 | Denis (age:13)
 2022-01-07 | Nataly (age:30)
 2022-01-08 | Denis (age:13)
 2022-01-08 | Denis (age:13)
 2022-01-09 | Dmitriy (age:18)
 2022-01-09 | Elvira (age:45)
 2022-01-09 | Elvira (age:45)
 2022-01-10 | Dmitriy (age:18)
(20 rows)
*/



-- Ex08
/*Please rewrite a SQL statement from Exercise #07 by using NATURAL JOIN construction. The result must be the same like for Exercise #07.*/

SELECT order_date, CONCAT (name, ' (age:', age, ')') AS person_information FROM person_order
NATURAL JOIN 
(SELECT person.id AS person_id, name, age FROM person)
ORDER BY order_date, person_information;

/*
 order_date | person_information 
------------+--------------------
 2022-01-01 | Andrey (age:21)
 2022-01-01 | Andrey (age:21)
 2022-01-01 | Anna (age:16)
 2022-01-01 | Anna (age:16)
 2022-01-01 | Irina (age:21)
 2022-01-03 | Peter (age:24)
 2022-01-04 | Kate (age:33)
 2022-01-05 | Peter (age:24)
 2022-01-05 | Peter (age:24)
 2022-01-06 | Nataly (age:30)
 2022-01-07 | Denis (age:13)
 2022-01-07 | Denis (age:13)
 2022-01-07 | Denis (age:13)
 2022-01-07 | Nataly (age:30)
 2022-01-08 | Denis (age:13)
 2022-01-08 | Denis (age:13)
 2022-01-09 | Dmitriy (age:18)
 2022-01-09 | Elvira (age:45)
 2022-01-09 | Elvira (age:45)
 2022-01-10 | Dmitriy (age:18)
(20 rows)
*/



-- Ex09
/*Write 2 SQL statements that return a list of pizzerias that have not been visited by people using IN for the first and EXISTS for the second.*/

SELECT name FROM pizzeria WHERE pizzeria.id NOT IN (SELECT pizzeria_id FROM person_visits);

SELECT name FROM pizzeria WHERE NOT EXISTS (SELECT pizzeria_id FROM person_visits WHERE person_visits.pizzeria_id = pizzeria.id);

/*
    name    
------------
 DoDo Pizza
(1 row)

    name    
------------
 DoDo Pizza
(1 row)
*/



-- Ex10
/*Please write an SQL statement that returns a list of the names of the people who ordered pizza from the corresponding pizzeria.
The sample result (with named columns) is provided below and yes ... please make the ordering by 3 columns (person_name, pizza_name, pizzeria_name) in ascending mode.*/

SELECT person.name AS person_name, menu.pizza_name AS pizza_name, pizzeria.name AS pizzeria_name FROM person_order
JOIN person ON person.id = person_order.person_id
JOIN menu ON menu.id = person_order.menu_id
JOIN pizzeria ON menu.pizzeria_id = pizzeria.id
ORDER BY person_name, pizza_name, pizzeria_name;

/*
 person_name |   pizza_name    | pizzeria_name 
-------------+-----------------+---------------
 Andrey      | cheese pizza    | Dominos
 Andrey      | mushroom pizza  | Dominos
 Anna        | cheese pizza    | Pizza Hut
 Anna        | pepperoni pizza | Pizza Hut
 Denis       | cheese pizza    | Best Pizza
 Denis       | pepperoni pizza | Best Pizza
 Denis       | pepperoni pizza | DinoPizza
 Denis       | sausage pizza   | DinoPizza
 Denis       | supreme pizza   | Best Pizza
 Dmitriy     | pepperoni pizza | DinoPizza
 Dmitriy     | supreme pizza   | Best Pizza
 Elvira      | pepperoni pizza | DinoPizza
 Elvira      | sausage pizza   | DinoPizza
 Irina       | mushroom pizza  | Papa Johns
 Kate        | cheese pizza    | Best Pizza
 Nataly      | cheese pizza    | Dominos
 Nataly      | pepperoni pizza | Papa Johns
 Peter       | mushroom pizza  | Dominos
 Peter       | sausage pizza   | Pizza Hut
 Peter       | supreme pizza   | Pizza Hut
(20 rows)
*/
