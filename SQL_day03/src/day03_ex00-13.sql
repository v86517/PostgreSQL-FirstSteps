-- Ex00
/*Please write a SQL statement that returns a list of pizza names, pizza prices, pizzeria names, and visit dates for Kate and for prices ranging from 800 to 1000 rubles. Please sort by pizza, price, and pizzeria name. See a sample of the data below.*/

SELECT pizza_name, price, pizzeria.name AS pizzeria_name, person_visits.visit_date FROM
(menu JOIN person_visits ON person_visits.pizzeria_id = menu.pizzeria_id
      JOIN person ON person_id = person.id
      JOIN pizzeria ON menu.pizzeria_id = pizzeria.id)
WHERE person.name = 'Kate' AND menu.price BETWEEN 800 AND 1000 ORDER BY pizza_name, price, pizzeria_name;

/*
   pizza_name    | price | pizzeria_name | visit_date 
-----------------+-------+---------------+------------
 cheese pizza    |   950 | DinoPizza     | 2022-01-04
 pepperoni pizza |   800 | Best Pizza    | 2022-01-03
 pepperoni pizza |   800 | DinoPizza     | 2022-01-04
 sausage pizza   |  1000 | DinoPizza     | 2022-01-04
 supreme pizza   |   850 | Best Pizza    | 2022-01-03
(5 rows)
*/



-- Ex01
/*Find all menu identifiers that are not ordered by anyone. The result should be sorted by identifier. The sample output is shown below.*/

SELECT id AS menu_id FROM menu
EXCEPT
SELECT menu_id FROM person_order
ORDER BY menu_id;

/*
 menu_id 
---------
       5
      10
      11
      12
      15
(5 rows)
*/



-- Ex02
/*Please use the SQL statement from Exercise #01 and display the names of pizzas from the pizzeria that no one has ordered, including the corresponding prices. The result should be sorted by pizza name and price. The sample output data is shown below.*/

SELECT pizza_name, price, pizzeria.name AS pizzeria_name FROM
(menu JOIN pizzeria ON pizzeria_id = pizzeria.id
      LEFT JOIN person_order ON menu.id = menu_id) WHERE person_order.menu_id IS NULL
ORDER BY menu.pizza_name, menu.price;

/*  pizza_name   | price | pizzeria_name 
---------------+-------+---------------
 cheese pizza  |   700 | Papa Johns
 cheese pizza  |   780 | DoDo Pizza
 cheese pizza  |   950 | DinoPizza
 sausage pizza |   950 | Papa Johns
 supreme pizza |   850 | DoDo Pizza
(5 rows)
*/



-- Ex03
/*Please find pizzerias that have been visited more often by women or by men. Save duplicates for any SQL operators with sets (UNION ALL, EXCEPT ALL, INTERSECT ALL constructions). Please sort a result by the name of the pizzeria. The sample data is shown below.*/

WITH women AS (SELECT pizzeria.name AS pizzeria_name FROM
(person JOIN person_visits ON person_id = person.id AND person.gender = 'female'
	JOIN pizzeria ON pizzeria.id = pizzeria_id)),

men AS (SELECT pizzeria.name AS pizzeria_name FROM
(person JOIN person_visits ON person_id = person.id AND person.gender = 'male'
	JOIN pizzeria ON pizzeria.id = pizzeria_id))

(TABLE women EXCEPT ALL TABLE men) UNION ALL (TABLE men EXCEPT ALL TABLE women) ORDER BY pizzeria_name;

/* pizzeria_name 
---------------
 Best Pizza
 Dominos
 Papa Johns
(3 rows)
*/



-- Ex04
/*Find a union of pizzerias that have orders from either women or men. In other words, you should find a set of names of pizzerias that have been ordered only by women and make "UNION" operation with set of names of pizzerias that have been ordered only by men. Please be careful with word "only" for both genders. For all SQL operators with sets don't store duplicates (UNION, EXCEPT, INTERSECT).  Please sort a result by the name of the pizzeria. The sample data is shown below.*/

WITH women AS (SELECT pizzeria.name AS pizzeria_name FROM
(person JOIN person_order ON person_id = person.id AND person.gender = 'female'
	JOIN menu ON menu_id = menu.id
	JOIN pizzeria ON pizzeria.id = pizzeria_id)),

men AS (SELECT pizzeria.name AS pizzeria_name FROM
(person JOIN person_order ON person_id = person.id AND person.gender = 'male'
	JOIN menu ON menu_id = menu.id
	JOIN pizzeria ON pizzeria.id = pizzeria_id))

(TABLE women EXCEPT TABLE men) UNION ALL (TABLE men EXCEPT TABLE women) ORDER BY pizzeria_name;

/*
 pizzeria_name 
---------------
 Papa Johns
(1 row)
*/



-- Ex05
/*Write an SQL statement that returns a list of pizzerias that Andrey visited but did not order from. Please order by the name of the pizzeria. The sample data is shown below.*/

SELECT DISTINCT pizzeria.name FROM
(person_visits JOIN pizzeria ON pizzeria_id = pizzeria.id
	       JOIN person ON person.id = person_id
	       JOIN person_order ON person.id = person_order.person_id)
WHERE person.name = 'Andrey' AND person_visits.visit_date != person_order.order_date;

/*
   name    
-----------
 Pizza Hut
(1 row)
*/



-- Ex06
/*Find the same pizza names that have the same price, but from different pizzerias. Make sure that the result is ordered by pizza name. The data sample is shown below. Please make sure that your column names match the column names below.*/

WITH menu1 AS (SELECT pizza_name AS pizza_name, pizzeria.name AS pizzeria_name_1, price FROM
menu JOIN pizzeria ON pizzeria.id = pizzeria_id), 

menu2 AS (SELECT pizza_name AS pizza_name, pizzeria.name AS pizzeria_name_2, price FROM
menu JOIN pizzeria ON pizzeria.id = pizzeria_id)

SELECT pizza_name, pizzeria_name_1, pizzeria_name_2, price FROM
menu1 NATURAL JOIN menu2
WHERE menu1.pizzeria_name_1 < menu2.pizzeria_name_2 ORDER BY pizza_name;

/*
   pizza_name    | pizzeria_name_1 | pizzeria_name_2 | price 
-----------------+-----------------+-----------------+-------
 cheese pizza    | Best Pizza      | Papa Johns      |   700
 pepperoni pizza | Best Pizza      | DinoPizza       |   800
 supreme pizza   | Best Pizza      | DoDo Pizza      |   850
(3 rows)
*/



-- Ex07
/*Please register a new pizza with the name "greek pizza" (use id = 19) with the price of 800 rubles in the restaurant "Dominos" (pizzeria_id = 2).
Warning: this exercise is likely to cause the modification of data in the wrong way. Actually, you can restore the original database model with data from the link.*/

INSERT INTO menu VALUES (19,2,'greek pizza', 800);

/*
slavadb=> table menu;
 id | pizzeria_id |   pizza_name    | price 
----+-------------+-----------------+-------
  1 |           1 | cheese pizza    |   900
  2 |           1 | pepperoni pizza |  1200
  3 |           1 | sausage pizza   |  1200
  4 |           1 | supreme pizza   |  1200
  5 |           6 | cheese pizza    |   950
  6 |           6 | pepperoni pizza |   800
  7 |           6 | sausage pizza   |  1000
  8 |           2 | cheese pizza    |   800
  9 |           2 | mushroom pizza  |  1100
 10 |           3 | cheese pizza    |   780
 11 |           3 | supreme pizza   |   850
 12 |           4 | cheese pizza    |   700
 13 |           4 | mushroom pizza  |   950
 14 |           4 | pepperoni pizza |  1000
 15 |           4 | sausage pizza   |   950
 16 |           5 | cheese pizza    |   700
 17 |           5 | pepperoni pizza |   800
 18 |           5 | supreme pizza   |   850
(18 rows)

slavadb=> INSERT INTO menu VALUES (19,2,'greek pizza', 800);
INSERT 0 1
slavadb=> table menu;
 id | pizzeria_id |   pizza_name    | price 
----+-------------+-----------------+-------
  1 |           1 | cheese pizza    |   900
  2 |           1 | pepperoni pizza |  1200
  3 |           1 | sausage pizza   |  1200
  4 |           1 | supreme pizza   |  1200
  5 |           6 | cheese pizza    |   950
  6 |           6 | pepperoni pizza |   800
  7 |           6 | sausage pizza   |  1000
  8 |           2 | cheese pizza    |   800
  9 |           2 | mushroom pizza  |  1100
 10 |           3 | cheese pizza    |   780
 11 |           3 | supreme pizza   |   850
 12 |           4 | cheese pizza    |   700
 13 |           4 | mushroom pizza  |   950
 14 |           4 | pepperoni pizza |  1000
 15 |           4 | sausage pizza   |   950
 16 |           5 | cheese pizza    |   700
 17 |           5 | pepperoni pizza |   800
 18 |           5 | supreme pizza   |   850
 19 |           2 | greek pizza     |   800
(19 rows)
*/



-- Ex08
/*Please register a new pizza with the name "sicilian pizza" (whose id should be calculated by the formula "maximum id value + 1") with the price of 900 rubles in the restaurant "Dominos" (please use internal query to get the identifier of the pizzeria).
Warning: This exercise is likely to cause the modification of data in the wrong way. Actually, you can restore the original database model with data from the link in the "Rules of the day" section and replay the script from Exercise 07.*/

INSERT INTO menu VALUES ((SELECT MAX(id) FROM menu)+1, (SELECT id FROM pizzeria WHERE name = 'Dominos'), 'sicilian pizza', 900);

/*
slavadb=> table menu;
 id | pizzeria_id |   pizza_name    | price 
----+-------------+-----------------+-------
  1 |           1 | cheese pizza    |   900
  2 |           1 | pepperoni pizza |  1200
  3 |           1 | sausage pizza   |  1200
  4 |           1 | supreme pizza   |  1200
  5 |           6 | cheese pizza    |   950
  6 |           6 | pepperoni pizza |   800
  7 |           6 | sausage pizza   |  1000
  8 |           2 | cheese pizza    |   800
  9 |           2 | mushroom pizza  |  1100
 10 |           3 | cheese pizza    |   780
 11 |           3 | supreme pizza   |   850
 12 |           4 | cheese pizza    |   700
 13 |           4 | mushroom pizza  |   950
 14 |           4 | pepperoni pizza |  1000
 15 |           4 | sausage pizza   |   950
 16 |           5 | cheese pizza    |   700
 17 |           5 | pepperoni pizza |   800
 18 |           5 | supreme pizza   |   850
 19 |           2 | greek pizza     |   800
(19 rows)

slavadb=> INSERT INTO menu VALUES ((SELECT MAX(id) FROM menu)+1, (SELECT id FROM pizzeria WHERE name = 'Dominos'), 'sicilian pizza', 900);
INSERT 0 1
slavadb=> table menu;
 id | pizzeria_id |   pizza_name    | price 
----+-------------+-----------------+-------
  1 |           1 | cheese pizza    |   900
  2 |           1 | pepperoni pizza |  1200
  3 |           1 | sausage pizza   |  1200
  4 |           1 | supreme pizza   |  1200
  5 |           6 | cheese pizza    |   950
  6 |           6 | pepperoni pizza |   800
  7 |           6 | sausage pizza   |  1000
  8 |           2 | cheese pizza    |   800
  9 |           2 | mushroom pizza  |  1100
 10 |           3 | cheese pizza    |   780
 11 |           3 | supreme pizza   |   850
 12 |           4 | cheese pizza    |   700
 13 |           4 | mushroom pizza  |   950
 14 |           4 | pepperoni pizza |  1000
 15 |           4 | sausage pizza   |   950
 16 |           5 | cheese pizza    |   700
 17 |           5 | pepperoni pizza |   800
 18 |           5 | supreme pizza   |   850
 19 |           2 | greek pizza     |   800
 20 |           2 | sicilian pizza  |   900
(20 rows)
*/



-- Ex09
/*Please record new visits to Domino's restaurant by Denis and Irina on February 24, 2022.
Warning: This exercise is likely to cause the modification of data in the wrong way. Actually, you can restore the original database model with data from the link in the "Rules of the Day" section and replay the script from Exercises 07 and 08.*/

INSERT INTO person_visits VALUES 
((SELECT MAX(id) FROM person_visits)+1, (SELECT id FROM person WHERE name = 'Denis'), (SELECT id FROM pizzeria WHERE name = 'Dominos'), '2022-02-24'),
((SELECT MAX(id) FROM person_visits)+2, (SELECT id FROM person WHERE name = 'Irina'), (SELECT id FROM pizzeria WHERE name = 'Dominos'), '2022-02-24');

/*
slavadb=> table person_visits;
 id | person_id | pizzeria_id | visit_date 
----+-----------+-------------+------------
  1 |         1 |           1 | 2022-01-01
  2 |         2 |           2 | 2022-01-01
  3 |         2 |           1 | 2022-01-02
  4 |         3 |           5 | 2022-01-03
  5 |         3 |           6 | 2022-01-04
  6 |         4 |           5 | 2022-01-07
  7 |         4 |           6 | 2022-01-08
  8 |         5 |           2 | 2022-01-08
  9 |         5 |           6 | 2022-01-09
 10 |         6 |           2 | 2022-01-09
 11 |         6 |           4 | 2022-01-01
 12 |         7 |           1 | 2022-01-03
 13 |         7 |           2 | 2022-01-05
 14 |         8 |           1 | 2022-01-05
 15 |         8 |           2 | 2022-01-06
 16 |         8 |           4 | 2022-01-07
 17 |         9 |           4 | 2022-01-08
 18 |         9 |           5 | 2022-01-09
 19 |         9 |           6 | 2022-01-10
(19 rows)

slavadb=> INSERT INTO person_visits VALUES 
((SELECT MAX(id) FROM person_visits)+1, (SELECT id FROM person WHERE name = 'Denis'), (SELECT id FROM pizzeria WHERE name = 'Dominos'), '2022-02-24'),
((SELECT MAX(id) FROM person_visits)+2, (SELECT id FROM person WHERE name = 'Irina'), (SELECT id FROM pizzeria WHERE name = 'Dominos'), '2022-02-24');
INSERT 0 2
slavadb=> table person_visits;
 id | person_id | pizzeria_id | visit_date 
----+-----------+-------------+------------
  1 |         1 |           1 | 2022-01-01
  2 |         2 |           2 | 2022-01-01
  3 |         2 |           1 | 2022-01-02
  4 |         3 |           5 | 2022-01-03
  5 |         3 |           6 | 2022-01-04
  6 |         4 |           5 | 2022-01-07
  7 |         4 |           6 | 2022-01-08
  8 |         5 |           2 | 2022-01-08
  9 |         5 |           6 | 2022-01-09
 10 |         6 |           2 | 2022-01-09
 11 |         6 |           4 | 2022-01-01
 12 |         7 |           1 | 2022-01-03
 13 |         7 |           2 | 2022-01-05
 14 |         8 |           1 | 2022-01-05
 15 |         8 |           2 | 2022-01-06
 16 |         8 |           4 | 2022-01-07
 17 |         9 |           4 | 2022-01-08
 18 |         9 |           5 | 2022-01-09
 19 |         9 |           6 | 2022-01-10
 20 |         4 |           2 | 2022-02-24
 21 |         6 |           2 | 2022-02-24
(21 rows)
*/



-- Ex10
/*Please register new orders from Denis and Irina on February 24, 2022 for the new menu with "sicilian pizza".
Warning: This exercise will probably cause you to change data in the wrong way. Actually, you can restore the original database model with data from the link in the Rules of the Day section and replay the script from Exercises 07, 08 and 09.*/

INSERT INTO person_order VALUES 
((SELECT MAX(id) FROM person_order) + 1, (SELECT id FROM person WHERE name = 'Denis'), (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza'), '2022-02-24'),
((SELECT MAX(id) FROM person_order) + 2, (SELECT id FROM person WHERE name = 'Irina'), (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza'), '2022-02-24');

/*
slavadb=> table person_order;
 id | person_id | menu_id | order_date 
----+-----------+---------+------------
  1 |         1 |       1 | 2022-01-01
  2 |         1 |       2 | 2022-01-01
  3 |         2 |       8 | 2022-01-01
  4 |         2 |       9 | 2022-01-01
  5 |         3 |      16 | 2022-01-04
  6 |         4 |      16 | 2022-01-07
  7 |         4 |      17 | 2022-01-07
  8 |         4 |      18 | 2022-01-07
  9 |         4 |       6 | 2022-01-08
 10 |         4 |       7 | 2022-01-08
 11 |         5 |       6 | 2022-01-09
 12 |         5 |       7 | 2022-01-09
 13 |         6 |      13 | 2022-01-01
 14 |         7 |       3 | 2022-01-03
 15 |         7 |       9 | 2022-01-05
 16 |         7 |       4 | 2022-01-05
 17 |         8 |       8 | 2022-01-06
 18 |         8 |      14 | 2022-01-07
 19 |         9 |      18 | 2022-01-09
 20 |         9 |       6 | 2022-01-10
(20 rows)

slavadb=> INSERT INTO person_order VALUES 
((SELECT MAX(id) FROM person_order) + 1, (SELECT id FROM person WHERE name = 'Denis'), (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza'), '2022-02-24'),
((SELECT MAX(id) FROM person_order) + 2, (SELECT id FROM person WHERE name = 'Irina'), (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza'), '2022-02-24');
INSERT 0 2
slavadb=> table person_order;
 id | person_id | menu_id | order_date 
----+-----------+---------+------------
  1 |         1 |       1 | 2022-01-01
  2 |         1 |       2 | 2022-01-01
  3 |         2 |       8 | 2022-01-01
  4 |         2 |       9 | 2022-01-01
  5 |         3 |      16 | 2022-01-04
  6 |         4 |      16 | 2022-01-07
  7 |         4 |      17 | 2022-01-07
  8 |         4 |      18 | 2022-01-07
  9 |         4 |       6 | 2022-01-08
 10 |         4 |       7 | 2022-01-08
 11 |         5 |       6 | 2022-01-09
 12 |         5 |       7 | 2022-01-09
 13 |         6 |      13 | 2022-01-01
 14 |         7 |       3 | 2022-01-03
 15 |         7 |       9 | 2022-01-05
 16 |         7 |       4 | 2022-01-05
 17 |         8 |       8 | 2022-01-06
 18 |         8 |      14 | 2022-01-07
 19 |         9 |      18 | 2022-01-09
 20 |         9 |       6 | 2022-01-10
 21 |         4 |      20 | 2022-02-24
 22 |         6 |      20 | 2022-02-24
(22 rows)
*/



-- Ex11
/*Please change the price of "greek pizza" to -10% of the current value.
Warning: This exercise is likely to cause you to change data in the wrong way. Actually, you can rebuild the original database model with data from the link in the "Rules of the Day" section and replay the script from Exercises 07, 08, 09, and 10.*/

UPDATE menu SET price = price * 0.9 WHERE pizza_name = 'greek pizza';

/*
slavadb=> table menu;
 id | pizzeria_id |   pizza_name    | price 
----+-------------+-----------------+-------
  1 |           1 | cheese pizza    |   900
  2 |           1 | pepperoni pizza |  1200
  3 |           1 | sausage pizza   |  1200
  4 |           1 | supreme pizza   |  1200
  5 |           6 | cheese pizza    |   950
  6 |           6 | pepperoni pizza |   800
  7 |           6 | sausage pizza   |  1000
  8 |           2 | cheese pizza    |   800
  9 |           2 | mushroom pizza  |  1100
 10 |           3 | cheese pizza    |   780
 11 |           3 | supreme pizza   |   850
 12 |           4 | cheese pizza    |   700
 13 |           4 | mushroom pizza  |   950
 14 |           4 | pepperoni pizza |  1000
 15 |           4 | sausage pizza   |   950
 16 |           5 | cheese pizza    |   700
 17 |           5 | pepperoni pizza |   800
 18 |           5 | supreme pizza   |   850
 19 |           2 | greek pizza     |   800
 20 |           2 | sicilian pizza  |   900
(20 rows)

slavadb=> UPDATE menu SET price = price * 0.9 WHERE pizza_name = 'greek pizza';
UPDATE 1
slavadb=> table menu;
 id | pizzeria_id |   pizza_name    | price 
----+-------------+-----------------+-------
  1 |           1 | cheese pizza    |   900
  2 |           1 | pepperoni pizza |  1200
  3 |           1 | sausage pizza   |  1200
  4 |           1 | supreme pizza   |  1200
  5 |           6 | cheese pizza    |   950
  6 |           6 | pepperoni pizza |   800
  7 |           6 | sausage pizza   |  1000
  8 |           2 | cheese pizza    |   800
  9 |           2 | mushroom pizza  |  1100
 10 |           3 | cheese pizza    |   780
 11 |           3 | supreme pizza   |   850
 12 |           4 | cheese pizza    |   700
 13 |           4 | mushroom pizza  |   950
 14 |           4 | pepperoni pizza |  1000
 15 |           4 | sausage pizza   |   950
 16 |           5 | cheese pizza    |   700
 17 |           5 | pepperoni pizza |   800
 18 |           5 | supreme pizza   |   850
 20 |           2 | sicilian pizza  |   900
 19 |           2 | greek pizza     | 720.0
(20 rows)
*/



-- Ex12
/*Please register new orders of all persons for "greek pizza" on February 25, 2022.
Warning: This exercise will probably cause you to change data in the wrong way. Actually, you can restore the original database model with data from the link in the "Rules of the Day" section and replay the script from Exercises 07, 08, 09, 10 and 11.*/

INSERT INTO person_order
SELECT generate_series((SELECT MAX(id) FROM person_order) + 1, (SELECT MAX(id) FROM person_order) + (SELECT MAX(id) FROM person), 1),
       generate_series((SELECT MIN(id) FROM person), (SELECT MAX(id) FROM person), 1), 
       (SELECT id FROM menu WHERE pizza_name = 'greek pizza'), '2022-02-25';
       
/*
slavadb=> table person_order;
 id | person_id | menu_id | order_date 
----+-----------+---------+------------
  1 |         1 |       1 | 2022-01-01
  2 |         1 |       2 | 2022-01-01
  3 |         2 |       8 | 2022-01-01
  4 |         2 |       9 | 2022-01-01
  5 |         3 |      16 | 2022-01-04
  6 |         4 |      16 | 2022-01-07
  7 |         4 |      17 | 2022-01-07
  8 |         4 |      18 | 2022-01-07
  9 |         4 |       6 | 2022-01-08
 10 |         4 |       7 | 2022-01-08
 11 |         5 |       6 | 2022-01-09
 12 |         5 |       7 | 2022-01-09
 13 |         6 |      13 | 2022-01-01
 14 |         7 |       3 | 2022-01-03
 15 |         7 |       9 | 2022-01-05
 16 |         7 |       4 | 2022-01-05
 17 |         8 |       8 | 2022-01-06
 18 |         8 |      14 | 2022-01-07
 19 |         9 |      18 | 2022-01-09
 20 |         9 |       6 | 2022-01-10
 21 |         4 |      20 | 2022-02-24
 22 |         6 |      20 | 2022-02-24
(22 rows)

slavadb=> INSERT INTO person_order
SELECT generate_series((SELECT MAX(id) FROM person_order) + 1, (SELECT MAX(id) FROM person_order) + (SELECT MAX(id) FROM person), 1),
       generate_series((SELECT MIN(id) FROM person), (SELECT MAX(id) FROM person), 1), 
       (SELECT id FROM menu WHERE pizza_name = 'greek pizza'), '2022-02-25';
INSERT 0 9
slavadb=> table person_order;
 id | person_id | menu_id | order_date 
----+-----------+---------+------------
  1 |         1 |       1 | 2022-01-01
  2 |         1 |       2 | 2022-01-01
  3 |         2 |       8 | 2022-01-01
  4 |         2 |       9 | 2022-01-01
  5 |         3 |      16 | 2022-01-04
  6 |         4 |      16 | 2022-01-07
  7 |         4 |      17 | 2022-01-07
  8 |         4 |      18 | 2022-01-07
  9 |         4 |       6 | 2022-01-08
 10 |         4 |       7 | 2022-01-08
 11 |         5 |       6 | 2022-01-09
 12 |         5 |       7 | 2022-01-09
 13 |         6 |      13 | 2022-01-01
 14 |         7 |       3 | 2022-01-03
 15 |         7 |       9 | 2022-01-05
 16 |         7 |       4 | 2022-01-05
 17 |         8 |       8 | 2022-01-06
 18 |         8 |      14 | 2022-01-07
 19 |         9 |      18 | 2022-01-09
 20 |         9 |       6 | 2022-01-10
 21 |         4 |      20 | 2022-02-24
 22 |         6 |      20 | 2022-02-24
 23 |         1 |      19 | 2022-02-25
 24 |         2 |      19 | 2022-02-25
 25 |         3 |      19 | 2022-02-25
 26 |         4 |      19 | 2022-02-25
 27 |         5 |      19 | 2022-02-25
 28 |         6 |      19 | 2022-02-25
 29 |         7 |      19 | 2022-02-25
 30 |         8 |      19 | 2022-02-25
 31 |         9 |      19 | 2022-02-25
(31 rows)
*/



--Ex13
/*Write 2 SQL (DML) statements that delete all new orders from Exercise #12 based on the order date. Then delete "greek pizza" from the menu.
Warning: This exercise is likely to cause you to modify data in the wrong way. Actually, you can rebuild the original database model with data from the link in the "Rules of the Day section" and replay the script from Exercises 07, 08, 09, 10, 11, 12, and 13.*/

DELETE FROM person_order WHERE order_date = '2022-02-25';
DELETE FROM menu WHERE pizza_name = 'greek pizza';

/*
slavadb=> DELETE FROM person_order WHERE order_date = '2022-02-25';
DELETE 9
slavadb=> table person_order;
 id | person_id | menu_id | order_date 
----+-----------+---------+------------
  1 |         1 |       1 | 2022-01-01
  2 |         1 |       2 | 2022-01-01
  3 |         2 |       8 | 2022-01-01
  4 |         2 |       9 | 2022-01-01
  5 |         3 |      16 | 2022-01-04
  6 |         4 |      16 | 2022-01-07
  7 |         4 |      17 | 2022-01-07
  8 |         4 |      18 | 2022-01-07
  9 |         4 |       6 | 2022-01-08
 10 |         4 |       7 | 2022-01-08
 11 |         5 |       6 | 2022-01-09
 12 |         5 |       7 | 2022-01-09
 13 |         6 |      13 | 2022-01-01
 14 |         7 |       3 | 2022-01-03
 15 |         7 |       9 | 2022-01-05
 16 |         7 |       4 | 2022-01-05
 17 |         8 |       8 | 2022-01-06
 18 |         8 |      14 | 2022-01-07
 19 |         9 |      18 | 2022-01-09
 20 |         9 |       6 | 2022-01-10
 21 |         4 |      20 | 2022-02-24
 22 |         6 |      20 | 2022-02-24
(22 rows)

slavadb=> DELETE FROM menu WHERE pizza_name = 'greek pizza';
DELETE 1
slavadb=> table menu ;
 id | pizzeria_id |   pizza_name    | price 
----+-------------+-----------------+-------
  1 |           1 | cheese pizza    |   900
  2 |           1 | pepperoni pizza |  1200
  3 |           1 | sausage pizza   |  1200
  4 |           1 | supreme pizza   |  1200
  5 |           6 | cheese pizza    |   950
  6 |           6 | pepperoni pizza |   800
  7 |           6 | sausage pizza   |  1000
  8 |           2 | cheese pizza    |   800
  9 |           2 | mushroom pizza  |  1100
 10 |           3 | cheese pizza    |   780
 11 |           3 | supreme pizza   |   850
 12 |           4 | cheese pizza    |   700
 13 |           4 | mushroom pizza  |   950
 14 |           4 | pepperoni pizza |  1000
 15 |           4 | sausage pizza   |   950
 16 |           5 | cheese pizza    |   700
 17 |           5 | pepperoni pizza |   800
 18 |           5 | supreme pizza   |   850
 20 |           2 | sicilian pizza  |   900
(19 rows)
*/
