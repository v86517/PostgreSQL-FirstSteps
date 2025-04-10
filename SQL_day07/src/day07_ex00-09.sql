-- Ex00
/*Let's make a simple aggregation, please write a SQL statement that returns person identifiers and corresponding number of visits in any pizzerias and sorts by number of visits in descending mode and sorts by person_id in ascending mode. Please take a look at the sample of data below.

person_id	count_of_visits
   9			4
   4			3
   ...			...
*/

SELECT person_id, COUNT(pizzeria_id) AS count_of_visits
FROM person_visits GROUP BY person_id
ORDER BY count_of_visits DESC, person_id ASC;

/*
 person_id | count_of_visits 
-----------+-----------------
         9 |               4
         4 |               3
         6 |               3
         8 |               3
         2 |               2
         3 |               2
         5 |               2
         7 |               2
         1 |               1
(9 rows)
*/



-- Ex01
/*Please modify an SQL statement from Exercise 00 and return a person name (not an identifier). Additional clause is we need to see only top 4 people with maximum visits in each pizzerias and sorted by a person name. See the example of output data below.

name	count_of_visits
Dmitriy		4
Denis		3
...		...
*/

SELECT person.name, COUNT(pizzeria_id) AS count_of_visits
FROM person_visits
JOIN person ON person.id = person_id
GROUP BY person.name ORDER BY count_of_visits DESC, person.name ASC LIMIT 4;

/*
  name   | count_of_visits 
---------+-----------------
 Dmitriy |               4
 Denis   |               3
 Irina   |               3
 Nataly  |               3
(4 rows)
*/



-- Ex02
/*Please write a SQL statement to see 3 favorite restaurants by visits and by orders in a list (please add an action_type column with values 'order' or 'visit', it depends on the data from the corresponding table). Please have a look at the example data below. The result should be sorted in ascending order by the action_type column and in descending order by the count column.

name		count	action_type
Dominos		6	order
...		...	...
Dominos		7	visit
...		...	...
*/

(SELECT pizzeria.name AS name, count(pizzeria_id) AS count, 'order' AS action_type FROM person_order
JOIN menu on menu_id = menu.id
JOIN pizzeria ON pizzeria_id = pizzeria.id
GROUP BY pizzeria.name, action_type ORDER BY count DESC, name LIMIT 3)

UNION ALL

(SELECT pizzeria.name AS name, count(person_id) AS count, 'visit' AS action_type FROM person_visits
JOIN pizzeria ON pizzeria_id = pizzeria.id
GROUP BY name ORDER BY count DESC LIMIT 3);

/*
(SELECT pizzeria.name AS name, count(person_id) AS count, 'visit' AS action_type FROM person_visits
JOIN pizzeria ON pizzeria_id = pizzeria.id
GROUP BY name ORDER BY count DESC LIMIT 3);
    name    | count | action_type 
------------+-------+-------------
 Dominos    |     6 | order
 Best Pizza |     5 | order
 DinoPizza  |     5 | order
 Dominos    |     7 | visit
 DinoPizza  |     4 | visit
 Pizza Hut  |     4 | visit
(6 rows)
*/



-- Ex03
/*
Write an SQL statement to see how restaurants are grouped by visits and by orders, and joined together by restaurant name.
You can use the internal SQL from Exercise 02 (Restaurants by Visits and by Orders) without any restrictions on the number of rows.
In addition, add the following rules.

-Compute a sum of orders and visits for the corresponding pizzeria (note that not all pizzeria keys are represented in both tables).
-Sort the results by the total_count column in descending order and by the name column in ascending order.
Take a look at the example data below.

name		total_count
Dominos		13
DinoPizza	9
...		...
*/

WITH cnt_orders_visits AS
((SELECT pizzeria.name AS name, count(pizzeria_id) AS count FROM person_order
JOIN menu on menu_id = menu.id
JOIN pizzeria ON pizzeria_id = pizzeria.id
GROUP BY pizzeria.name ORDER BY count DESC)--, name LIMIT 3)
UNION ALL
(SELECT pizzeria.name AS name, count(person_id) AS count FROM person_visits
JOIN pizzeria ON pizzeria_id = pizzeria.id
GROUP BY pizzeria.name ORDER BY count DESC))-- LIMIT 3))

SELECT name, sum(count) AS total_count FROM cnt_orders_visits
GROUP BY name ORDER BY total_count DESC, name;

/*
    name    | total_count 
------------+-------------
 Dominos    |          13
 DinoPizza  |           9
 Best Pizza |           8
 Pizza Hut  |           8
 Papa Johns |           5
 DoDo Pizza |           1
(6 rows)
*/



-- Ex04
/*
Please write a SQL statement that returns the person's name and the corresponding number of visits to any pizzerias if the person has visited more than 3 times (> 3). Please take a look at the sample data below.

name		count_of_visits
Dmitriy		4
*/

SELECT name, COUNT (visit_date) AS count_of_visits FROM person_visits 
JOIN person ON person.id = person_id
GROUP BY name HAVING COUNT (visit_date) > 3;

/*
  name   | count_of_visits 
---------+-----------------
 Dmitriy |               4
(1 row)
*/



-- Ex05
/*Please write a simple SQL query that returns a list of unique person names who have placed orders at any pizzerias. The result should be sorted by person name. Please see the example below.

name
Andrey
Anna
...
*/

SELECT DISTINCT name FROM person_order
JOIN person ON person.id = person_id
ORDER BY name;

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



-- Ex06
/*
Please write a SQL statement that returns the number of orders, the average price, the maximum price and the minimum price for pizzas sold by each pizzeria restaurant. The result should be sorted by pizzeria name. See the sample data below.
Round the average price to 2 floating numbers.

name		count_of_orders		average_price	max_price	min_price
Best Pizza	5			780		850		700
DinoPizza	5			880		1000		800
...		...			...		...		...
*/

SELECT pizzeria.name, COUNT (order_date) AS count_of_orders, ROUND (AVG(price), 2) AS average_price, MAX (price) AS max_price, MIN (price) AS min_price
FROM person_order 
JOIN menu ON menu.id = menu_id 
JOIN pizzeria ON pizzeria.id = pizzeria_id
GROUP BY pizzeria.name ORDER BY pizzeria.name;

/*
    name    | count_of_orders | average_price | max_price | min_price 
------------+-----------------+---------------+-----------+-----------
 Best Pizza |               5 |           780 |       850 |       700
 DinoPizza  |               5 |           880 |      1000 |       800
 Dominos    |               6 |           933 |      1100 |       800
 Papa Johns |               2 |           975 |      1000 |       950
 Pizza Hut  |               4 |          1125 |      1200 |       900
(5 rows)
*/



-- Ex07
/*Write an SQL statement that returns a common average rating (the output attribute name is global_rating) for all restaurants. Round your average rating to 4 floating point numbers.*/

SELECT ROUND(AVG(rating), 4) AS global_rating FROM pizzeria;

/*
 global_rating 
---------------
        3.9167
(1 row)
*/



-- Ex08
/*
We know personal addresses from our data. Let's assume that this person only visits pizzerias in his city. Write a SQL statement that returns the address, the name of the pizzeria, and the amount of the person's orders. The result should be sorted by address and then by restaurant name. Please take a look at the sample output data below.

address		name		count_of_orders
Kazan		Best Pizza		4
Kazan		DinoPizza		4
...		...			...
*/

SELECT address, pizzeria.name, COUNT (order_date) AS count_of_orders
FROM person_order 
JOIN person ON person.id = person_id 
JOIN menu ON menu.id = menu_id 
JOIN pizzeria ON pizzeria.id = pizzeria_id
GROUP BY address, pizzeria.name ORDER BY address, pizzeria.name;

/*
     address      |    name    | count_of_orders 
------------------+------------+-----------------
 Kazan            | Best Pizza |               4
 Kazan            | DinoPizza  |               4
 Kazan            | Dominos    |               1
 Moscow           | Dominos    |               2
 Moscow           | Pizza Hut  |               2
 Novosibirsk      | Dominos    |               1
 Novosibirsk      | Papa Johns |               1
 Saint-Petersburg | Dominos    |               2
 Saint-Petersburg | Papa Johns |               1
 Saint-Petersburg | Pizza Hut  |               2
 Samara           | Best Pizza |               1
 Samara           | DinoPizza  |               1
(12 rows)
*/



-- Ex09
/*
Please write a SQL statement that returns aggregated information by person's address, the result of "Maximum Age - (Minimum Age / Maximum Age)" presented as a formula column, next is average age per address and the result of comparison between formula and average columns (in other words, if formula is greater than average, then True, otherwise False value).
The result should be sorted by address column. Please take a look at the example of output data below.

address		formula		average		comparison
Kazan		44.71		30.33		true
Moscow		20.24		18.5		true
...		...		...		...
*/

WITH age_info AS (
SELECT address, ROUND(ROUND(MAX(age), 2) - (ROUND(MIN(age), 2) / ROUND(MAX(age), 2)), 2) AS formula, ROUND(AVG(age), 2) AS average FROM person GROUP BY address)
SELECT *, CASE WHEN formula > average THEN 'true' ELSE 'false' END AS comparison
FROM age_info ORDER BY address;

/*
     address      | formula | average | comparison 
------------------+---------+---------+------------
 Kazan            |   44.71 |   30.33 | true
 Moscow           |   20.24 |   18.50 | true
 Novosibirsk      |   29.00 |   30.00 | false
 Saint-Petersburg |   23.13 |   22.50 | true
 Samara           |   17.00 |   18.00 | false
(5 rows)
*/
