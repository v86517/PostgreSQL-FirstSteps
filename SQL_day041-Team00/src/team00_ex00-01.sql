-- Ex00
/*
Take a look at the nodes on the left.
There are 4 cities (a, b, c and d) and arcs between them with costs (or taxes). Actually, the cost is (a,b) = (b,a).
Please create a table with named nodes using structure {point1, point2, cost} and fill data based on a picture (remember there are direct and reverse hops between 2 nodes).
Please write a SQL statement that returns all tours (aka hops) with minimum travel cost if we start from city "a".
Remember, you need to find the cheapest hop to visit all cities and return to your starting point. For example, the tour looks like a -> b -> c -> d -> a.

total_cost 	    tour
   80 		{a,b,d,c,a}
*/

CREATE TABLE nodes (point1 CHAR NOT NULL, point2 CHAR NOT NULL, cost INT NOT NULL);
                                  
INSERT INTO nodes VALUES
('a', 'b', 10),
('b', 'a', 10),
('b', 'c', 35),
('c', 'b', 35),
('c', 'a', 15),
('a', 'c', 15),
('a', 'd', 20),
('d', 'a', 20),
('b', 'd', 25),
('d', 'b', 25),
('c', 'd', 30),
('d', 'c', 30);

/* Manual calculation
a,b,c,d,a=95
a,b,d,c,a=80 - target
a,c,b,d,a=95
a,c,d,b,a=80 - target
a,d,b,c,a=95
a,d,c,b,a=95
*/

WITH RECURSIVE travel AS 
(SELECT cost AS total_cost, ARRAY[point1]::VARCHAR[] AS tour, point1, point2 FROM nodes WHERE point1 = 'a'
UNION
SELECT (cost + prev.total_cost) AS total_cost, prev.tour || prev.point2 AS tour, nodes.point1, nodes.point2     
     FROM nodes 
        JOIN travel AS prev ON nodes.point1 = prev.point2 WHERE prev.point2 != ALL(tour))

SELECT total_cost, (tour || point2) AS tour FROM travel
WHERE point2 = 'a' AND total_cost = (SELECT MIN(total_cost) FROM travel WHERE ARRAY_LENGTH(tour, 1) = 4)

ORDER BY total_cost, tour;

/*
 total_cost |    tour     
------------+-------------
         80 | {a,b,d,c,a}
         80 | {a,c,d,b,a}
(2 rows)
*/

/* For reference

team00=> table RECURSIVE_RESULT;
 total_cost |   tour    | point1 | point2 
------------+-----------+--------+--------
         10 | {a}       | a      | b
         15 | {a}       | a      | c
         20 | {a}       | a      | d
         20 | {a,b}     | b      | a
         45 | {a,b}     | b      | c
         50 | {a,c}     | c      | b
         30 | {a,c}     | c      | a
         40 | {a,d}     | d      | a
         35 | {a,b}     | b      | d
         45 | {a,d}     | d      | b
         45 | {a,c}     | c      | d
         50 | {a,d}     | d      | c
         55 | {a,d,b}   | b      | a
         60 | {a,c,b}   | b      | a
         80 | {a,d,b}   | b      | c
         85 | {a,c,b}   | b      | c
         85 | {a,d,c}   | c      | b
         80 | {a,b,c}   | c      | b
         65 | {a,d,c}   | c      | a
         60 | {a,b,c}   | c      | a
         65 | {a,c,d}   | d      | a
         55 | {a,b,d}   | d      | a
         70 | {a,d,b}   | b      | d
         75 | {a,c,b}   | b      | d
         70 | {a,c,d}   | d      | b
         60 | {a,b,d}   | d      | b
         80 | {a,d,c}   | c      | d
         75 | {a,b,c}   | c      | d
         75 | {a,c,d}   | d      | c
         65 | {a,b,d}   | d      | c
         80 | {a,c,d,b} | b      | a
         95 | {a,d,c,b} | b      | a
        105 | {a,c,d,b} | b      | c
        120 | {a,d,c,b} | b      | c
        100 | {a,b,d,c} | c      | b
        115 | {a,d,b,c} | c      | b
         80 | {a,b,d,c} | c      | a
         95 | {a,d,b,c} | c      | a
         95 | {a,b,c,d} | d      | a
         95 | {a,c,b,d} | d      | a
         95 | {a,c,d,b} | b      | d
        110 | {a,d,c,b} | b      | d
        100 | {a,b,c,d} | d      | b
        100 | {a,c,b,d} | d      | b
         95 | {a,b,d,c} | c      | d
        110 | {a,d,b,c} | c      | d
        105 | {a,b,c,d} | d      | c
        105 | {a,c,b,d} | d      | c
(48 rows)
*/



-- Ex01
/*
Please add a way to see additional rows with the most expensive cost to the SQL from the previous exercise. Take a look at the sample data below. Please sort the data by total_cost and then by trip.

total_cost 	    tour
   80		{a,b,d,c,a}
   ...		...
   95		{a,d,c,b,a}
*/

WITH RECURSIVE travel AS 
(SELECT cost AS total_cost, ARRAY[point1]::VARCHAR[] AS tour, point1, point2 FROM nodes WHERE point1 = 'a'
UNION
SELECT (cost + prev.total_cost) AS total_cost, prev.tour || prev.point2 AS tour, nodes.point1, nodes.point2     
     FROM nodes
        JOIN travel AS prev ON nodes.point1 = prev.point2 WHERE prev.point2 != ALL(tour))

SELECT total_cost, (tour || point2) AS tour FROM travel
WHERE (point2 = 'a' AND total_cost = (SELECT MIN(total_cost) FROM travel WHERE ARRAY_LENGTH(tour, 1) = 4))
OR (point2 = 'a' AND total_cost = (SELECT MAX(total_cost) FROM travel WHERE (ARRAY_LENGTH(tour, 1) = 4) AND point2 = 'a'))

ORDER BY total_cost, tour;

/*
 total_cost |    tour     
------------+-------------
         80 | {a,b,d,c,a}
         80 | {a,c,d,b,a}
         95 | {a,b,c,d,a}
         95 | {a,c,b,d,a}
         95 | {a,d,b,c,a}
         95 | {a,d,c,b,a}
(6 rows)
*/
