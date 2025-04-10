-- Ex00
/*Please create a simple BTree index for each foreign key in our database. The name pattern should match the next rule "idx_{table_name}_{column_name}". For example, the name of the BTree index for the pizzeria_id column in the menu table is idx_menu_pizzeria_id.*/

CREATE INDEX idx_menu_pizzeria_id ON menu (pizzeria_id);

CREATE INDEX idx_person_visits_person_id ON person_visits (person_id);

CREATE INDEX idx_person_visits_pizzeria_id ON person_visits (pizzeria_id);

CREATE INDEX idx_person_order_person_id ON person_order (person_id);

CREATE INDEX idx_person_order_menu_id ON person_order (menu_id);



-- Ex01
/*Before proceeding, please write an SQL statement that returns pizzas and the corresponding pizzeria names. See the example result below (no sorting required).
Let's prove that your indexes work for your SQL. The sample proof is the output of the EXPLAIN ANALYZE command. Please take a look at the sample output of the command.
...
->  Index Scan using idx_menu_pizzeria_id on menu m  (...)
...
*/

EXPLAIN ANALYZE SELECT pizza_name, pizzeria.name AS pizzeria_name
FROM menu
JOIN pizzeria ON pizzeria_id = pizzeria.id;

/*
                                                 QUERY PLAN                                                  
-------------------------------------------------------------------------------------------------------------
 Hash Join  (cost=1.45..22.79 rows=20 width=64) (actual time=0.073..0.089 rows=20 loops=1)
   Hash Cond: (pizzeria.id = menu.pizzeria_id)
   ->  Seq Scan on pizzeria  (cost=0.00..18.10 rows=810 width=40) (actual time=0.018..0.021 rows=6 loops=1)
   ->  Hash  (cost=1.20..1.20 rows=20 width=40) (actual time=0.038..0.040 rows=20 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 10kB
         ->  Seq Scan on menu  (cost=0.00..1.20 rows=20 width=40) (actual time=0.013..0.022 rows=20 loops=1)
 Planning Time: 0.282 ms
 Execution Time: 0.142 ms
(8 rows)
*/

SET enable_seqscan TO ON;

/*
                                                 QUERY PLAN                                                  
-------------------------------------------------------------------------------------------------------------
 Hash Join  (cost=1.45..22.79 rows=20 width=64) (actual time=0.066..0.081 rows=20 loops=1)
   Hash Cond: (pizzeria.id = menu.pizzeria_id)
   ->  Seq Scan on pizzeria  (cost=0.00..18.10 rows=810 width=40) (actual time=0.016..0.018 rows=6 loops=1)
   ->  Hash  (cost=1.20..1.20 rows=20 width=40) (actual time=0.035..0.036 rows=20 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 10kB
         ->  Seq Scan on menu  (cost=0.00..1.20 rows=20 width=40) (actual time=0.012..0.020 rows=20 loops=1)
 Planning Time: 0.286 ms
 Execution Time: 0.129 ms
(8 rows)
*/

SET enable_seqscan TO OFF; --принуждение сканировать по индексам 

/*                                                             QUERY PLAN                                                              
-------------------------------------------------------------------------------------------------------------------------------------
 Nested Loop  (cost=0.29..63.79 rows=20 width=64) (actual time=7.748..7.856 rows=20 loops=1)
   ->  Index Scan using idx_menu_pizzeria_id on menu  (cost=0.14..12.44 rows=20 width=40) (actual time=7.654..7.672 rows=20 loops=1)
   ->  Index Scan using pizzeria_pkey on pizzeria  (cost=0.15..2.57 rows=1 width=40) (actual time=0.006..0.006 rows=1 loops=20)
         Index Cond: (id = menu.pizzeria_id)
 Planning Time: 0.301 ms
 Execution Time: 7.913 ms
(6 rows)
*/



-- Ex02
/*Please create a functional B-Tree index  named idx_person_name on the column name of the person table. The index should contain person names in upper case.
Write and provide any SQL with proof (EXPLAIN ANALYZE) that index idx_person_name works.*/

CREATE INDEX idx_person_name ON person (UPPER(name));

SET enable_seqscan TO OFF;

EXPLAIN ANALYZE SELECT name FROM person WHERE UPPER(name) = 'elvira';

/*
                                                        QUERY PLAN                                                        
--------------------------------------------------------------------------------------------------------------------------
 Index Scan using idx_person_name on person  (cost=0.14..8.15 rows=1 width=108) (actual time=0.061..0.062 rows=0 loops=1)
   Index Cond: (upper((name)::text) = 'elvira'::text)
 Planning Time: 8.071 ms
 Execution Time: 0.095 ms
(4 rows)
*/



-- Ex03
/*
Please create a better multi-column B-Tree index named idx_person_order_multi for the SQL statement below.

SELECT person_id, menu_id,order_date
FROM person_order
WHERE person_id = 8 AND menu_id = 19;

The EXPLAIN ANALYZE command should return the next pattern. Please pay attention to "Index Only Scan" scanning!

Index Only Scan using idx_person_order_multi on person_order ...


Provide any SQL with proof (EXPLAIN ANALYZE) that index idx_person_order_multi works.
*/

CREATE INDEX idx_person_order_multi ON person_order (person_id, menu_id, order_date);

SET enable_seqscan TO OFF;

EXPLAIN ANALYZE
SELECT person_id, menu_id, order_date FROM person_order WHERE person_id = 8 AND menu_id = 19;

/*
                                                                QUERY PLAN                                                                 
-------------------------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using idx_person_order_multi on person_order  (cost=0.14..8.16 rows=1 width=20) (actual time=0.059..0.059 rows=0 loops=1)
   Index Cond: ((person_id = 8) AND (menu_id = 19))
   Heap Fetches: 0
 Planning Time: 0.838 ms
 Execution Time: 0.093 ms
(5 rows)
*/



-- Ex04
/*Please create a unique BTree index named idx_menu_unique on the menu table for  pizzeria_id and pizza_name columns. Write and provide any SQL with proof (EXPLAIN ANALYZE) that index idx_menu_unique works.*/

CREATE UNIQUE INDEX idx_menu_unique ON menu (pizzeria_id, pizza_name);

SET enable_seqscan TO OFF;

EXPLAIN ANALYZE
SELECT pizzeria_id, pizza_name FROM menu;

/*
                                                          QUERY PLAN                                                           
-------------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using idx_menu_unique on menu  (cost=0.14..12.42 rows=19 width=40) (actual time=0.064..0.079 rows=19 loops=1)
   Heap Fetches: 19
 Planning Time: 0.380 ms
 Execution Time: 0.109 ms
(4 rows)
*/



-- Ex05
/*
Please create a partially unique BTree index named idx_person_order_order_date on the person_order table for the person_id and menu_id attributes with partial uniqueness for the order_date column for the date '2022-01-01'.
The EXPLAIN ANALYZE command should return the next pattern.

Index Only Scan using idx_person_order_order_date on person_order …
*/

CREATE UNIQUE INDEX idx_person_order_order_date ON person_order (person_id, menu_id) WHERE order_date = '2022-01-01';

SET enable_seqscan TO OFF;

EXPLAIN ANALYZE
SELECT menu_id FROM person_order WHERE person_id = 1 AND order_date = '2022-01-01';

/*
-----------------------------------------------------------------------------------------------------------------------------------------------
 Index Only Scan using idx_person_order_order_date on person_order  (cost=0.13..8.15 rows=1 width=8) (actual time=0.072..0.076 rows=2 loops=1)
   Index Cond: (person_id = 1)
   Heap Fetches: 2
 Planning Time: 0.948 ms
 Execution Time: 0.109 ms
(5 rows)
*/



-- Ex06
/*
Take a look at the SQL below from a technical perspective (ignore a logical case of this SQL statement).

SELECT
    m.pizza_name AS pizza_name,
    max(rating) OVER (PARTITION BY rating ORDER BY rating ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS k
FROM  menu m
INNER JOIN pizzeria pz ON m.pizzeria_id = pz.id
ORDER BY 1,2;


Create a new BTree index named idx_1 that should improve the "Execution Time" metric of this SQL. Provide evidence (EXPLAIN ANALYZE) that the SQL has been improved.
Hint: This exercise looks like a "brute force" task to find a good cover index, so before your new test, remove the idx_1 index.
Sample of my improvement:
Before:

Sort  (cost=26.08..26.13 rows=19 width=53) (actual time=0.247..0.254 rows=19 loops=1)
"  Sort Key: m.pizza_name, (max(pz.rating) OVER (?))"
Sort Method: quicksort  Memory: 26kB
->  WindowAgg  (cost=25.30..25.68 rows=19 width=53) (actual time=0.110..0.182 rows=19 loops=1)
        ->  Sort  (cost=25.30..25.35 rows=19 width=21) (actual time=0.088..0.096 rows=19 loops=1)
            Sort Key: pz.rating
            Sort Method: quicksort  Memory: 26kB
            ->  Merge Join  (cost=0.27..24.90 rows=19 width=21) (actual time=0.026..0.060 rows=19 loops=1)
                    Merge Cond: (m.pizzeria_id = pz.id)
                    ->  Index Only Scan using idx_menu_unique on menu m  (cost=0.14..12.42 rows=19 width=22) (actual time=0.013..0.029 rows=19 loops=1)
                        Heap Fetches: 19
                    ->  Index Scan using pizzeria_pkey on pizzeria pz  (cost=0.13..12.22 rows=6 width=15) (actual time=0.005..0.008 rows=6 loops=1)
Planning Time: 0.711 ms
Execution Time: 0.338 ms


After:

Sort  (cost=26.28..26.33 rows=19 width=53) (actual time=0.144..0.148 rows=19 loops=1)
"  Sort Key: m.pizza_name, (max(pz.rating) OVER (?))"
Sort Method: quicksort  Memory: 26kB
->  WindowAgg  (cost=0.27..25.88 rows=19 width=53) (actual time=0.049..0.107 rows=19 loops=1)
        ->  Nested Loop  (cost=0.27..25.54 rows=19 width=21) (actual time=0.022..0.058 rows=19 loops=1)
            ->  Index Scan using idx_1 on …
            ->  Index Only Scan using idx_menu_unique on menu m  (cost=0.14..2.19 rows=3 width=22) (actual time=0.004..0.005 rows=3 loops=6)
…
Planning Time: 0.338 ms
Execution Time: 0.203 ms
*/

SET enable_seqscan TO OFF;

SELECT m.pizza_name AS pizza_name,
        max(rating) OVER (PARTITION BY rating ORDER BY rating ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS k
    FROM  menu m
    INNER JOIN pizzeria pz ON m.pizzeria_id = pz.id
    ORDER BY 1,2;

CREATE INDEX idx_1 ON pizzeria(id);

SELECT m.pizza_name AS pizza_name,
        max(rating) OVER (PARTITION BY rating ORDER BY rating ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS k
    FROM  menu m
    INNER JOIN pizzeria pz ON m.pizzeria_id = pz.id
    ORDER BY 1,2;

DROP INDEX idx_1;

--////////////////////////////////////////////////////////////////////// BEFORE ////////////////////////////////////////////////////////////////////////
/*
                                                                       QUERY PLAN                                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=25.95..26.00 rows=19 width=96) (actual time=0.207..0.213 rows=19 loops=1)
   Sort Key: m.pizza_name, (max(pz.rating) OVER (?))
   Sort Method: quicksort  Memory: 26kB
   ->  WindowAgg  (cost=25.17..25.55 rows=19 width=96) (actual time=0.123..0.163 rows=19 loops=1)
         ->  Sort  (cost=25.17..25.22 rows=19 width=64) (actual time=0.101..0.107 rows=19 loops=1)
               Sort Key: pz.rating
               Sort Method: quicksort  Memory: 25kB
               ->  Merge Join  (cost=0.27..24.77 rows=19 width=64) (actual time=0.042..0.074 rows=19 loops=1)
                     Merge Cond: (m.pizzeria_id = pz.id)
                     ->  Index Only Scan using idx_menu_unique on menu m  (cost=0.14..12.42 rows=19 width=40) (actual time=0.026..0.042 rows=19 loops=1)
                           Heap Fetches: 19
                     ->  Index Scan using pizzeria_pkey on pizzeria pz  (cost=0.13..12.22 rows=6 width=40) (actual time=0.008..0.011 rows=6 loops=1)
 Planning Time: 0.323 ms
 Execution Time: 0.293 ms
(14 rows)
//////////////////////////////////////////////////////////////////////// AFTER ///////////////////////////////////////////////////////////////////////////
                                                                       QUERY PLAN                                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------------
 Sort  (cost=25.95..26.00 rows=19 width=96) (actual time=0.089..0.091 rows=19 loops=1)
   Sort Key: m.pizza_name, (max(pz.rating) OVER (?))
   Sort Method: quicksort  Memory: 26kB
   ->  WindowAgg  (cost=25.17..25.55 rows=19 width=96) (actual time=0.054..0.070 rows=19 loops=1)
         ->  Sort  (cost=25.17..25.22 rows=19 width=64) (actual time=0.044..0.047 rows=19 loops=1)
               Sort Key: pz.rating
               Sort Method: quicksort  Memory: 25kB
               ->  Merge Join  (cost=0.27..24.77 rows=19 width=64) (actual time=0.020..0.032 rows=19 loops=1)
                     Merge Cond: (m.pizzeria_id = pz.id)
                     ->  Index Only Scan using idx_menu_unique on menu m  (cost=0.14..12.42 rows=19 width=40) (actual time=0.007..0.013 rows=19 loops=1)
                           Heap Fetches: 19
                     ->  Index Scan using idx_1 on pizzeria pz  (cost=0.13..12.22 rows=6 width=40) (actual time=0.008..0.009 rows=6 loops=1)
 Planning Time: 0.287 ms
 Execution Time: 0.125 ms
(14 rows)
*/
