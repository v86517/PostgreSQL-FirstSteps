-- Ex00
-- Please make a select statement which returns all person's names and person's ages from the city ‘Kazan’.

SELECT name, age FROM person WHERE address = 'Kazan';

/*
  name  | age 
--------+-----
 Kate   |  33
 Denis  |  13
 Elvira |  45
(3 rows)
*/



-- Ex01
-- Please make a select statement which returns names , ages for all women from the city ‘Kazan’. Yep, and please sort result by name.

SELECT  name, age FROM person WHERE address = 'Kazan' AND gender = 'female' ORDER BY name;

/*
  name  | age 
--------+-----
 Elvira |  45
 Kate   |  33
(2 rows)
*/



-- Ex02
/*Please make 2 syntax different select statements which return a list of pizzerias (pizzeria name and rating) with rating between 3.5 and 5 points (including limit points) and ordered by pizzeria rating.*/

-- the 1st select statement must contain comparison signs  (<=, >=);
SELECT name, rating FROM pizzeria WHERE rating >= '3.5' AND rating <= '5' ORDER BY rating;

-- the 2nd select statement must contain BETWEEN keyword.
SELECT name, rating FROM pizzeria WHERE rating BETWEEN '3.5' AND '5' ORDER BY rating;
/*
    name    | rating 
------------+--------
 DinoPizza  |    4.2
 Dominos    |    4.3
 Pizza Hut  |    4.6
 Papa Johns |    4.9
(4 rows)
*/



-- Ex03
/*Please make a select statement that returns the person identifiers (without duplicates) who visited pizzerias in a period from January 6, 2022 to January 9, 2022 (including all days) or visited pizzerias with identifier 2. Also include ordering clause by person identifier in descending mode.*/

SELECT DISTINCT person_id FROM person_visits WHERE visit_date BETWEEN '2022-01-06' AND '2022-01-09' OR pizzeria_id = '2' ORDER BY person_id DESC;

/*
 person_id 
-----------
         9
         8
         7
         6
         5
         4
         2
(7 rows)
*/



-- Ex04
/*Please make a select statement which returns one calculated field with name ‘person_information’ in one string like described in the next sample:
Anna (age:16,gender:'female',address:'Moscow')
Finally, please add the ordering clause by calculated column in ascending mode.
Please pay attention to the quotation marks in your formula!
*/

SELECT name || ' (age:' || age || ',gender:' || '''' || gender || '''' ||',address:''' || address || ''')' AS person_information FROM person ORDER BY person_information;

/*
                    person_information                     
-----------------------------------------------------------
 Andrey (age:21,gender:'male',address:'Moscow')
 Anna (age:16,gender:'female',address:'Moscow')
 Denis (age:13,gender:'male',address:'Kazan')
 Dmitriy (age:18,gender:'male',address:'Samara')
 Elvira (age:45,gender:'female',address:'Kazan')
 Irina (age:21,gender:'female',address:'Saint-Petersburg')
 Kate (age:33,gender:'female',address:'Kazan')
 Nataly (age:30,gender:'female',address:'Novosibirsk')
 Peter (age:24,gender:'male',address:'Saint-Petersburg')
(9 rows)
*/



-- Ex05
/*Write a select statement that returns the names of people (based on an internal query in the SELECT clause) who placed orders for the menu with identifiers 13, 14, and 18, and the date of the orders should be January 7, 2022. Be careful with "Denied Section" before your work.

SELECT 
    (SELECT ... ) AS NAME  -- this is an internal query in a main SELECT clause
FROM ...
WHERE ...
*/
-- SELECT name FROM person JOIN person_order ON person.id = person_order.person_id  WHERE menu_id IN ('13', '14', '18') AND order_date IN ('2022-01-07');
SELECT (SELECT name FROM person WHERE person.id = person_order.person_id) AS name FROM person_order WHERE menu_id IN ('13', '14', '18') AND order_date IN ('2022-01-07');

/*
  name  
--------
 Denis
 Nataly
(2 rows)
*/



-- Ex06
/*Use the SQL construction from Exercise 05
SELECT (SELECT name FROM person WHERE person.id = person_order.person_id) AS name FROM person_order WHERE (menu_id = '13' OR menu_id = '14' OR menu_id = '18') AND order_date = '2022-01-07';
 and add a new calculated column (use column name ‘check_name’) with a check statement a pseudocode for this check is given below) in the SELECT clause.

if (person_name == 'Denis') then return true
    else return false
*/

SELECT (SELECT name FROM person WHERE person.id = person_order.person_id) AS name, (SELECT name ='Denis' FROM person WHERE person.id = person_order.person_id) AS check_name FROM person_order WHERE (menu_id='13' OR menu_id='14' OR menu_id='18') AND order_date='2022-01-07';

/*
  name  | check_name 
--------+------------
 Denis  | t
 Nataly | f
(2 rows)
*/



-- Ex07
/*Please make an SQL statement that returns the identifiers of a person, the person's names, and the interval of the person's ages (set a name of a new calculated column as 'interval_info') based on the pseudo code below.

if (age >= 10 and age <= 20) then return 'interval #1'
else if (age > 20 and age < 24) then return 'interval #2'
else return 'interval #3'

please sort a result by ‘interval_info’ column in ascending mode.
*/

SELECT id, name, CASE WHEN age BETWEEN 10 AND 20 THEN 'interval #1' WHEN age > 20 AND age < 24 THEN 'interval #2' ELSE 'interval #3' END AS interval_info FROM person ORDER BY interval_info;

/*
 id |  name   | interval_info 
----+---------+---------------
  1 | Anna    | interval #1
  4 | Denis   | interval #1
  9 | Dmitriy | interval #1
  6 | Irina   | interval #2
  2 | Andrey  | interval #2
  8 | Nataly  | interval #3
  5 | Elvira  | interval #3
  7 | Peter   | interval #3
  3 | Kate    | interval #3
(9 rows)
*/



-- Ex08
/*Create an SQL statement that returns all columns from the person_order table with rows whose identifier is an even number. The result must be ordered by the returned identifier.
*/

SELECT * FROM person_order WHERE id % 2 == 0 ORDER BY id;

/*
 id | person_id | menu_id | order_date 
----+-----------+---------+------------
  2 |         1 |       2 | 2022-01-01
  4 |         2 |       9 | 2022-01-01
  6 |         4 |      16 | 2022-01-07
  8 |         4 |      18 | 2022-01-07
 10 |         4 |       7 | 2022-01-08
 12 |         5 |       7 | 2022-01-09
 14 |         7 |       3 | 2022-01-03
 16 |         7 |       4 | 2022-01-05
 18 |         8 |      14 | 2022-01-07
 20 |         9 |       6 | 2022-01-10
(10 rows)
*/



-- Ex09
/*Please make a select statement that returns person names and pizzeria names based on the person_visits table with a visit date in a period from January 07 to January 09, 2022 (including all days) (based on an internal query in the `FROM' clause).

SELECT (...) AS person_name ,  -- this is an internal query in a main SELECT clause
        (...) AS pizzeria_name  -- this is an internal query in a main SELECT clause
FROM (SELECT … FROM person_visits WHERE …) AS pv -- this is an internal query in a main FROM clause
ORDER BY ...

Please add a ordering clause by person name in ascending mode and by pizzeria name in descending mode.
*/

SELECT (SELECT name FROM person WHERE person.id = pv.person_id) AS person_name, (SELECT name FROM pizzeria WHERE pizzeria.id = pv.pizzeria_id) AS pizzeria_name
FROM (SELECT * FROM person_visits WHERE visit_date BETWEEN '2022-01-07' AND '2022-01-09') AS pv ORDER BY person_name , pizzeria_name DESC;

/*
 person_name | pizzeria_name 
-------------+---------------
 Denis       | DinoPizza
 Denis       | Best Pizza
 Dmitriy     | Papa Johns
 Dmitriy     | Best Pizza
 Elvira      | Dominos
 Elvira      | DinoPizza
 Irina       | Dominos
 Nataly      | Papa Johns
(8 rows)
*/
