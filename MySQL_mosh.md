```sql
CREATE DATABASE sql_hr;

CREATE DATABASE sql_inventory;

CREATE DATABASE sql_invoicing;

CREATE DATABASE sql_store;

USE sql_store;

SELECT 
    name, 
    unit_price, 
    (unit_price * 1.1) AS new_price
FROM products;




-- #####################################

SELECT *
FROM orders
WHERE order_date >= '2024-01-01';

SELECT *
FROM orders
WHERE birth_date > '2024-01-01' OR points > 1000; 

SELECT *
FROM orders
WHERE birth_date > '2024-01-01' OR 
	(points > 1000 AND state = 'VA'); 
    
SELECT *
FROM orders
WHERE NOT (birth_date > '2024-01-01' OR points > 1000);
-- WHERE birth_date <= '2024-01-01' AND points <= 1000)	-- same as line above

SELECT * 
FROM order_items
WHERE order_id = 6 
	AND (unit_price * quantity) > 30;




-- #####################################    

SELECT *
FROM customers
WHERE state IN ('VA', 'FL', 'GA');
-- WHERE state NOT IN ('VA', 'FL', 'GA');

SELECT *
FROM products
WHERE quantity_in_stock IN (49, 38, 72);

SELECT *
FROM customers
WHERE points BETWEEN 1000 AND 3000;
-- WHERE pointS >= 1000 AND points <= 3000;

SELECT *
FROM customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01';




-- #####################################

SELECT *
FROM customers
-- WHERE address LIKE '%trail%' OR address LIKE '%avenue%';
	WHERE address REGEXP 'trail|avenue';
    --
SELECT *
FROM customers
-- WHERE phone_number LIKE '9%';
WHERE phone_number REGEXP '^9';
	--
/* 
^ - beginning of a string
$ - end of a string
| - logical OR (for multiple search patterns)
[abcd] - match any single chars listed in the brackets
[a-f] - range of characters
__

'^field' - string start with 'field'
'field$' - string end with 'field'
'field|mac|rose' - string with 'field' or 'mac' or 'rose'
'^field|mac|rose' - string start with 'field' or have the word 'mac' or have the word 'rose' in it
'field$|mac|rose' - string end with 'field' or have the word 'mac' or have the word 'rose' in it
'[gim]e' - string with 'ge' or 'ie' or 'me'
'e[fmq]' - string with 'ef' or 'em' or 'eq'
'[a-h]' - string with any letter from a to h
*/

SELECT *
FROM customers
-- where clauses each in its own statement (4 diff tasks)
WHERE first_name REGEXP 'elka|ambur';
-- WHERE last_name REGEXP 'ey$|on$';
-- WHERE last_name REGEXP '^my|se';
-- WHERE last_name REGEXP 'b[ru]';		-- 'br|bu'




-- #####################################

SELECT *
FROM orders
WHERE shipped_date IS NULL;

SELECT *, quantity * unit_price AS total_price
FROM order_items
WHERE order_id = 2
ORDER BY total_price DESC;




-- #####################################

SELECT *
FROM customers
LIMIT 3;	-- displays 3 records

-- Page 1: 1 - 3
-- Page 2: 4 - 6
-- Page 3: 7 - 9
 
SELECT *
FROM customers
LIMIT 6, 3;	-- 7 - 9

-- to 3 loyal customers
SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3;




-- #####################################

SELECT 
	order_id, 
    o.customer_id, 
    first_name, 
    last_name
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id;

SELECT 
	order_id, 
    oi.product_id, 
    quantity, 
    oi.unit_price
FROM order_items oi
JOIN products p
	ON o.product_id = p.product_id;




-- #####################################

-- prefeix table that are not part of the current database
SELECT 
	order_id, 
	oi.product_id, 
    quantity, 
    oi.unit_price
FROM order_items oi
JOIN sql_inventory.products p
	ON oi.product_id = p.product_id;

-- self join

SELECT 
	e.employee_id, 
	e.first_name, 
	CONACT(m.first_name, " ", m.last_name) AS manager
FROM employees e
JOIN employees m
	ON e.reports_to = m.reports_to;

-- joining multiple tables

SELECT 
	o.order_id, 
	o.order_date, 
	c.first_name, 
	c.last_name,
    os.name AS status
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
JOIN order_status os
	ON o.status = os.oreder_status_id;
    
--

SELECT 
	c.name,
	pm.name,
    p.date,
    p.invoice,
    p.amount
FROM clients c
JOIN payments p
	ON c.client_id = p.client_id
JOIN payment_method pm
	ON p.payment_method = pm.payment_method_id;
    
-- compound join conditions

SELECT *
FROM order_items oi
JOIN order_items_notes oin
	ON oi.order_id = oin.order_id
    AND oi.product_id = oin.product_id;
    
-- implicit join syntax | it's not advised tho

SELECT *
FROM orders o, customers c
WHERE o.customer_id = c.customer_id;
-- when you miss the WHERE clause, you'll get a cross join

-- Its equivalent (explicit join)
SELECT *
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id;

-- outer joins

SELECT 
	c.customer_id, 
	c.first_name, 
	o.order_id
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

--

SELECT 
	c.customer_id, 
	c.first_name, 
	o.order_id
FROM orders o
RIGHT JOIN customer c 	
-- interchanged from above left join to see all customers even those that didn't place orders
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- ex

SELECT 
	p.product_id,
	p.name,
    oi.quantity
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.products_id;

-- outer joins between multiple tables

SELECT 
	c.customer_id, 
	c.first_name, 
	o.order_id,
    sh.name AS shipper
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
ORDER BY c.customer_id;

-- ex

SELECT
	o.order_date,
    o.order_id,
    c.first_name AS customer,
    sh.name AS shipper,
    os.name AS status
FROM orders o
LEFT JOIN customers c
	ON o.customer_id = c.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
LEFT JOIN order_status os
	ON o.status = os.order_status_id;
    
-- self outer join
--

SELECT 
	e.employee_id,
    e.firtsname,
    CONCAT(m.first_name, " ", m.last_name) AS manager
FROM employees e
LEFT JOIN employees m	-- to show the manager/ CEO
	ON e.reports_to = m.employee_id;
    
    
    
    
-- ##################################### USING clause

SELECT 
	o.order_id,
    c.first_name,
    sh.name AS shipper
FROM orders o
JOIN customers c
	-- ON o.customer_id = c.customer_id;
    -- if the column has the same column name across tables use the USING clause
    USING(customer_id)
LEFT JOIN shippers sh	-- LEFT JOIN to see customers who didn't ship
	-- ON c.shippers_id = sh.shippers_id;
    USING(shippers_id);

--

SELECT *
FROM order_items oi
JOIN order_items_notes oin
-- 	ON oi.order_id = oin.order_id 
--     AND oi.product_id = oin.product_id;
	USING (order_id, product_id);
    
-- ex

SELECT
	p.date,
	c.name AS client,
	p.amount,
	pm.name AS payment_method
FROM payments p
JOIN clients c USING (client_id)
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id;

    
    
    
-- ##################################### Natural joins

SELECT 
	o.orders_id,
	c.first_name
FROM orders o
NATURAL JOIN customers c;
-- can produce unexpected results since we're letting the database engine guess the join
-- and we have no control over it




-- ##################################### Cross joins
-- used to join every record from the first table to every record in the second table

SELECT 
	c.first_name AS customer,
	p.name AS product
FROM customers c
CROSS JOIN products p	-- explicit cross join
ORDER BY c.first_name;
-- table of sizes (small, medium, large & table of colors (rgbcymk)

SELECT 
	c.first_name AS customer,
	p.name AS product
FROM customers c, products p	-- implicit cross join
ORDER BY c.first_name;

-- ex

SELECT 
	sh.name AS shippers,
    p.name AS products
FROM shippers sh, products p
ORDER BY c.first_name;

--

SELECT  
	sh.name AS shippers,
    p.name AS products
FROM shippers sh
CROSS JOIN products p
ORDER BY c.first_name;




-- ##################################### UNIONS

SELECT
	order_id,
	order_date,
	'Active' AS status
FROM orders
WHERE order_date >= '2019-01-01'
UNION
SELECT
	order_id,
	order_date,
	'Archived' AS status
FROM orders
WHERE order_date < '2019-01-01';

--

SELECT first_name
FROM customers
UNION
SELECT name
FROM shippers;

-- ex

SELECT 
	customer_id, 
	first_name, 
	points, 
	'Bronze' AS type
FROM customers
WHERE points < 2000
UNION
SELECT 
	customer_id, 
	first_name, 
	points, 
	'Silver' AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT 
	customer_id, 
	first_name, 
	points, 
	'Gold' AS type
FROM customers
WHERE points > 3000
ORDER BY first_name;




-- ##################################### creating a copy of a table

USE mydb;

SELECT * FROM mydb.employees_archived;

CREATE TABLE mydb.employees_archived AS
SELECT * FROM practice.employees;	-- subquery

CREATE TABLE mydb.employees22 LIKE 
practice.employees;
INSERT INTO mydb.employees22
SELECT * FROM practice.employees;

-- subquery

DELETE FROMmydb.employees_archived

INSERT INTO mydb.employees_archived
SELECT *
FROM practice.employees
WHERE order_date < '2019-01-01';

-- ex

SELECT * FROM sql_invoicing.invoice;
SELECT * FROM sql_invoicing.invoices_archive;

invoice_id
number
client_id *
invoice_total
payment_total

CREATE TABLE sql_invoicing.invoices_archive AS
SELECT 
	i.invoice_id
	i.number
	c.name AS client
	i.invoice_total
	i.payment_total
	i.invoice_date
	i.due_date
	i.payment_date
FROM invoice i
JOIN client c
	-- USING(client_id)
WHERE payment_date IS NOT NULL;

--

UPDATE invoices_archive
SET payment_method = DEFAULT,
	payment_date = NULL
WHERE invoice_id = 1;

--

UPDATE invoices_archive
SET payment_method = invoivce_total * 0.5,
	payment_date = due_date
WHERE invoice_id = 3;

UPDATE invoices_archive
SET payment_method = invoivce_total * 0.5,
	payment_date = due_date
WHERE invoice_id = 
	(SELECT client_id
	FROM clients
	WHERE name = 'Myworks');

UPDATE invoices_archive
SET payment_method = invoivce_total * 0.5,
	payment_date = due_date
WHERE invoice_id IN
	(SELECT client_id
	FROM clients
	WHERE state IN ('NY', 'CA'));	-- 1, 3

--

UPDATE customers
SET points = points + 50
WHERE birth_date < '1990-01-01';

--
 
UPDATE orders
SET comments = 'Gold customers'
WHERE customer_id IN
	(SELECT customer_id
	WHERE points > 3000)


-- ##################################### aggregate functions
-- only operate on none NULL values
SELECT
	MAX(invoice_total) AS highest,
	MIN(invoice_total) AS lowest,
	AVG(invoice_total) AS average,
	SUM(invoice_total) AS total,
    SUM(invoice_total * 1.1) AS total,
	COUNT(DISTINCT invoice_total) AS number_of_invoices,
    COUNT(*) AS total_records -- includes NULL values
FROM invoices
WHERE invoice_date > '2019-07-01';

--

SELECT
	'First half of 2019' AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date
	BETWEEN '2019-01-01' AND '2019-06-30'
UNION
SELECT
	'Second half of 2019' AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date
	BETWEEN '2019-07-01' AND '2019-12-31'
UNION
SELECT
	'Total' AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date
	BETWEEN '2019-01-01' AND '2019-12-31';




-- ##################################### GROUP BY

SELECT
	state,
    city,
	client_id,
    SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients c USING(client_id)
GROUP BY client_id, state, city
ORDER BY total_sales DESC;

-- ex

SELECT
	date,
    pm.name AS payment_method,
    SUM(amount) AS total_payments
FROM payments p
JOIN payment_method pm
	ON p.payment_method = pm.payment_method_id
GROUP BY date, payment_method
ORDER BY date;





-- ##################################### HAVING clause

SELECT
	client_id,
    SUM(invoice_total) AS total_sale,
    COUNT(*) AS number_of_invoices
FROM invoices 
GROUP BY client_id
HAVING total_sale > 500
	AND number_of_invoices > 5;
-- WHERE filters data after rows are grouped while HAVING filters data after rows are grouped
-- with HAVING columns filtered show be included in the SELECT clause

-- ex
-- while using GROUP BY with aggregate functions, columns grouped by should appear in the SELECT clause

USE sql_store;

SELECT 
	c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM customers c
JOIN orders o USING(customer_id)
JOIN order_items oi USING(order_id)
WHERE  state = 'VA'
GROUP BY
	c.customer_id,
    c.first_name,
    c.last_name
HAVING total_sales > 100;




-- ##################################### ROLLUP 

SELECT 
	client_id,
    SUM(invoice_total) AS total_sales
FROM invoices i
GROUP BY client_id WITH ROLLUP;

--
USE sql_invoicing;

SELECT 
	state,
    city,
    SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients c USING(client_id)
GROUP BY state, city WITH ROLLUP;

-- ex

USE sql_invoicing;
SELECT
	pm.name AS payment_method,
    SUM(amount) AS total
FROM payments p
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id
GROUP BY pm.name WITH ROLLUP;
-- with ROLLUP, column aliases can't be used




-- ##################################### subqueries
USE store;
SELECT *
FROM products
WHERE unit_price >
	(SELECT unit_price
	FROM products
	WHERE product_id = 3);
    
--
USE sql_hr;
SELECT *
FROM employees
WHERE salary >
	(SELECT AVG(salary)
	FROM employees);
    
--
USE sql_store;
SELECT * 
FROM products
WHERE product_id NOT IN 
	(SELECT DISTINCT product_id
	FROM order_items);

-- ex
USE sql_invoicing;
SELECT *
FROM clients
WHERE client_id NOT IN
	(SELECT DISTINCT client_id
	FROM invoices);




-- ##################################### subqueries vs joins

-- clients with no invoices froma above example
USE sql_invoicing;
SELECT *
FROM clients
LEFT JOIN invoices USING (client_id)
WHERE invoice_id IS NOT NULL;

-- ex

USE sql_store;
SELECT 
	customer_id,
    first_name,
    last_name
FROM customers
WHERE customer_id IN
	(SELECT o.customer_id
    FROM order_items oi 
    JOIN orders o USING (order_id)
    WHERE product_id = 3);

--

SELECT DISTINCT
	customer_id,
    first_name,
    last_name
FROM customers c
JOIN orders o USING (customer_id)
JOIN order_items oi USING (order_id)
	WHERE oi.product_id = 3;




-- ##################################### ALL keyword

USE sql_invoicing;

SELECT *
FROM invoices
WHERE invoice_total > 
	(SELECT MAX(invoice_total)
	FROM invoices
	WHERE client_id = 3
	);
    
-- alternative
SELECT *
FROM invoices
WHERE invoice_total > ALL
	(SELECT invoice_total
	FROM invoices
	WHERE client_id = 3
	);




-- ##################################### ANY keyword
-- clients with at least 2 invoices
SELECT *
FROM clients
WHERE client_id IN
	(SELECT client_id
	FROM invoices
	GROUP BY client_id
	HAVING COUNT(*) > 2
	);
    
-- alternative
SELECT *
FROM clients
WHERE client_id = ANY
	(SELECT client_id
	FROM invoices
	GROUP BY client_id
	HAVING COUNT(*) > 2
	);




-- ##################################### correlated subqueries

-- for each employees
	-- calc the avg salay for employee.office
    -- return the employee if salary > avg
USE sql_hr;
SELECT *
FROM employees e
WHERE salary > (
	SELECT AVG(salary)
	FROM employees
	WHERE office_id = e.office_id
	);

-- get invoices that are larger than the client's avg invoice amount
USE sql_invoicing;
SELECT *
FROM invoices i 
WHERE invoice_total > (
	SELECT AVG(invoice_total)
    FROM invoices
    WHERE client_id = i.client_id
);




-- ##################################### EXISTS operator

-- select clients that have an invoice
USE sql_invoicing;
SELECT *
FROM clients
WHERE client_id = ANY (
	SELECT DISTINCT client_id
	FROM invoices
);

-- -
SELECT *
FROM clients C
WHERE EXISTS (
	SELECT client_id
	FROM invoices
    WHERE client_id = c.client_id
);

-- find products that have never been ordered
USE sql_store;
SELECT *
FROM products p
WHERE NOT EXISTS (
	SELECT product_id
	FROM order_items
	WHERE product_id = p.product_id
);




-- ##################################### subqueries in SELECT clause
USE sql_invoicing;
SELECT 
	invoice_id,
    invoice_total,
	(SELECT AVG(invoice_total) 
		FROM invoices) AS invoice_average,
    invoice_total - (SELECT invoice_average) AS difference
FROM invoices;

-- ex

SELECT
	client_id,
    name,
    (SELECT SUM(invoice_total)
		FROM invoices
        WHERE client_id = c.client_id) AS total_sales,
	 (SELECT AVG(invoice_total)
		FROM invoices) AS average,
	(SELECT total_sales - average) AS difference
FROM clients c;




-- ##################################### subqueries in FROM clause
-- views are the simpler version of the this subquery
SELECT *
FROM
(
	SELECT
		client_id,
		name,
		(SELECT SUM(invoice_total)
			FROM invoices
			WHERE client_id = c.client_id) AS total_sales,
		 (SELECT AVG(invoice_total)
			FROM invoices) AS average,
		(SELECT total_sales - average) AS difference
	FROM clients c
) AS sale_summary
WHERE total_sales IS NOT NULL;




-- ##################################### numeric functions

SELECT ROUND(5.73);		-- 6
SELECT ROUND(5.73, 1);		-- 5.7
SELECT ROUND(5.7345, 2);		-- 5.73
SELECT TRUNCATE(5.7345, 2);		-- 5.73
SELECT CEIL(5.2);		-- 6
SELECT FLOOR(5.2);		-- 5




-- ##################################### string functions

SELECT LENGTH('sky');		-- 3
SELECT UPPER('sky');		-- SKY
SELECT LOWER('Sky');		-- sky
SELECT LTRIM('	Sky');		-- removes leading spaces
SELECT RTRIM('Sky	');		-- removes trailing spaces
SELECT TRIM('	Sky		');		-- removes any leading or trailing spaces
SELECT LEFT('Kindergarten', 4);		-- Kind
SELECT RIGHT('Kindergarten', 6);		-- garten
SELECT SUBSTRING('Kindergarten', 3, 5);		-- 3-start, 5-length, nderg
SELECT LOCATE('n', 'Kindergarten');		-- 3
SELECT LOCATE('garten', 'Kindergarten');		-- 7
SELECT REPLACE('Kindergarten', 'garten', 'garDen');




-- ##################################### date functions

SELECT NOW(), CURDATE(), CURTIME();
SELECT YEAR(NOW()), MONTH(NOW()), DAY(NOW()), HOUR(NOW()), MINUTE(NOW()), SECOND(NOW());
SELECT MONTHNAME(NOW()), DAYNAME(NOW())
```