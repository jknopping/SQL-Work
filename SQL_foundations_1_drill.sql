--1) How many records are in the vehicles table? Provide the query you’d use to determine this as well as the answer to the question.
SELECT COUNT(*)
FROM vehicles;
--ANSWER: 33442

--2) Write a query that returns all the records in the vehicles table.
SELECT *
FROM vehicles;

--3) Write a query that returns the id, make, and model fields for all the records for 2010 vehicles.
SELECT id, make, model
FROM vehicles
WHERE year = 2010;

--4) Write a query that returns the count of vehicles from 2010. Also provide the answer.
SELECT COUNT(*)
FROM vehicles
WHERE year = 2010;
--ANSWER: 1109

--5) Write a query that returns the count of vehicles in the vehicles table between the years 2010 and 2015, inclusive. Provide the query as well as the answer.
SELECT COUNT(*)
FROM vehicles
WHERE year BETWEEN 2010 AND 2015;
--ANSWER: 5995

--6) Write a query that returns the count of vehicles from the years 1990, 2000, and 2010. Provide the query and the result.
SELECT COUNT(*)
FROM vehicles
WHERE year IN(1990, 2000, 2010);
--ANSWER: 3026

--7) Write a query that returns the count of all records between 1987 and 2005, exclusive of the years 1990 and 2000.
SELECT COUNT(*)
FROM vehicles
WHERE year BETWEEN 1987 AND 2005
AND year NOT IN (1990, 2000);
--ANSWER: 17,235

--8) Write a query that returns the year, make, model, and a field called average_mpg that calculates the average highway/city fuel consumption. (For example, if hwy is 24 and cty is 20, then average_mpg = (24 + 20)/ 2 = 22.)
SELECT year, make, model, (hwy + cty)/2 AS average_mpg
FROM vehicles;

--9) Write a query that returns the year, make, model, and a text field displaying “X highway; Y city.” (For example, if hwy is 24 and cty is 20, then hwy_city is “24 highway; 20 city.”)
SELECT year, make, model, CONCAT(hwy, ' highway; ', cty, ' city.') AS mpg_breakdown
FROM vehicles;

--10) Write a query that returns the id, make, model, and year for all records that have NULL for either the cyl or displ fields.
SELECT id, make, model, year
FROM vehicles
WHERE cyl IS NULL 
OR displ IS NULL;

--11) Write a query that returns all fields for records with rear-wheel drive and diesel vehicles since 2000, inclusive. Also sort by year and highway mileage, both descending. Hint: to view the distinct values in a field, you can use DISTINCT. For example, use SELECT DISTINCT(drive) FROM vehicles; to get the unique values that appear in that field, or use SELECT DISTINCT(fuel) FROM vehicles;.
SELECT *
FROM vehicles
WHERE 
	drive = 'Rear-Wheel Drive' 
	AND fuel = 'Diesel'
	AND year >= 2000
ORDER BY year DESC, hwy DESC;

--12) Write a query that counts the number of vehicles that are either Fords or Chevrolets and either compact cars or 2-seaters. Provide the query and the answer.
SELECT COUNT(*) AS num_vehicles
FROM vehicles
WHERE 
	make IN ('Ford', 'Chevrolet')
	AND class IN ('Compact Cars', 'Two Seaters');
--ANSWER= 612

--13) Write a query that returns the records for 10 vehicles with the highest highway fuel mileage.
SELECT *
FROM vehicles
ORDER BY hwy DESC
LIMIT 10;

--14) Write a query that returns all the records of vehicles since the year 2000 whose model name starts with a capital X. Sort the list A through Z by make. What happens when you use a lowercase “x” instead?
SELECT *
FROM vehicles
WHERE
	year >= 2000
	AND model LIKE 'X%'
ORDER BY make ASC;
--VS.
SELECT *
FROM vehicles
WHERE
	year >= 2000
	AND model LIKE 'x%'
ORDER BY make ASC;
--Results include only Scions that start with lowercase x (LIKE clasue is case sensitive)
--'ASC' is technically not needed

--15) Write a query that returns the count of records where the “cyl” field is NULL. Provide the query as well as the answer.
SELECT COUNT(*) AS answer
FROM vehicles
WHERE cyl IS NULL;
--Answer is 58.

--16) Write a query that returns the count of all records before the year 2000 that got more than 20 mpg hwy and had greater than 3 liters displacement (“displ” field). Provide the query as well as the answer.
SELECT COUNT(*) AS answer
FROM vehicles
WHERE
	year < 2000
	AND hwy > 20
	AND displ > 3;
--Answer is 1964

--17) Write a query that returns all records whose model name has a (capital) X in its 3rd position. Hint: make sure your wildcard operator accommodates for any characters after the “X”!
SELECT *
FROM vehicles
WHERE model LIKE '__X%';
