# MySQL Bro Code

```sql
####################################### CREATE a table

    CREATE TABLE employee (
        employee_id INT,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        hourly_pay DECIMAL(5, 2),
        hire_date DATE
    );

    -
    SELECT * FROM employees;

    -
    SELECT * 
    FROM employees
    WHERE employee_id != 1;

    -
    SELECT * 
    FROM employees
    WHERE hire_date IS NULL ;
    -- WHERE hire_date IS NOT NULL ;

    -
    RENAME TABLE employees TO workers;

    -
    DROP TABLE employees;

----- Adding a column to a table

    ALTER TABLE employees
    ADD COLUMN phone_number VARCHAR(15);

----- Renaming a column

    ALTER TABLE employees
    RENAME COLUMN phone_number TO email;

    ALTER TABLE employees
    MODIFY COLUMN email VARCHAR(100);

----- Moving a column

    ALTER TABLE employees
    MODIFRY email VARCHAR(100)
    AFTER last_name; 

    -
    ALTER TABLE employees
    MODIFRY email VARCHAR(100)
    FIRST; 

----- Removing a column

    ALTER TABLE employees
    DROP COLUMN email; 




####################################### INSERT a row into a table (Filling a table)

    INSERT INTO employees
    VALUES (1, "Eugene", "Krabs", 25.50, "2023-01-02"),
    (2, "Squidward", "Tentacles", 15.00, "2023-01-03"),
    (3, "Spongebob", "squarepants", 12.50, "2023-01-04"),
    (4, "Patrick", "Star", 12.50, "2023-01-05"),
    (5, "Sandy", "Cheeks", 17.25, "2023-01-06");

    -
    INSERT INTO employees (employee_id, first_name, last_name)
    VALUES (6, "Sheldon", "Plankton");




####################################### CREATE a database

    A database is like a folder and tables being files

    CREATE DATABASE myDB;

    USE myDB;       -- Sets DB as default schema

    DROP DATABASE myDB; 

----- Setting DB to read-only

    ALTER DATABASE myDB READ ONLY = 1;      -- DB can't be dropped
    ALTER DATABASE myDB READ ONLY = 0;      -- To disable read-only

----- Encrypting a DB

    ALTER DATABASE myDB ENCRYPTION = 'Y';




####################################### UPDATE and DELETE data from a table

    UPDATE employees
    SET hourly_pay = 10.50, hire_date = "2023-01-07"
    WHERE employee_id = 6;
    SELECT * FROM employees;

    -
    UPDATE employees
    SET hire_date = NULL
    WHERE employee_id = 6;
    SELECT * FROM employees;    

----- Delete a row from a table

    DELETE FROM employees
    WHERE employee_id = 6;
    SELECT * FROM employees;

    -
    SELECT * 
    FROM employees
    WHERE job = "cook" AND hire_date < "2023-01-05";

    -
    SELECT * 
    FROM employees
    WHERE job = "cook" OR job = "cashier";

    -
    SELECT * 
    FROM employees
    WHERE NOT job = "manager";

    -
    SELECT * 
    FROM employees
    WHERE NOT job = "manager" AND NOT job = "asst. manager";




####################################### JOINS

    Foreign key is transactions.customer_id     (right)
    Primary key is customers.customer_id    (left)

    -
    SELECT transaction_id, amount, first_name, last_name
    FROM transactions 
    INNER JOIN customers
    ON transactions.customer_id = customers.customer_id;

    -
    SELECT transaction_id, amount, first_name, last_name
    FROM transactions 
    LEFT JOIN customers
    ON transactions.customer_id = customers.customer_id;

    -
    SELECT transaction_id, amount, first_name, last_name
    FROM transactions 
    RIGHT JOIN customers
    ON transactions.customer_id = customers.customer_id;




####################################### Logical operators

----- Adding column

    ALTER TABLE employees 
    ADD COLUMN job VARCHAR(25)
    AFTER hourly_pay;
    SELECT * FROM employees;

    -
    UPDATE employees
    SET job = "manager"
    WHERE employee_id = 1 ;
    SELECT * FROM employees;

    -
    SELECT * 
    FROM employees
    WHERE NOT job = "manager" AND NOT job = "asst. manager";

    -
    SELECT * 
    FROM employees
    WHERE hire_date BETWEEN "2023-01-04" AND "2023-01-07";

    -
    SELECT * 
    FROM employees
    WHERE job IN ("cook", "cashier", "janitor");




####################################### Wild cards

    SELECT * FROM employees
    WHERE first_name LIKE "s%";

    -
    SELECT * FROM employees
    WHERE job LIKE "_ook";

    -
    SELECT * FROM employees
    WHERE job LIKE "_a%";




####################################### DEFAULT CONSTRAINT

    _
    DELETE FROM products
    WHERE product_id >= 104;
    SELECT * FROM products;

    _
    CREATE TABLE products (
        product_id INT,
        product_name VARCHAR(25),
        price DECIMAL(4, 2) DEFAULT 0
    );
    SELECT * FROM products;

----- Already created table to include DEFAULT constraint

    ALTER TABLE products
    ALTER price 
    SET DEFAULT 0;
    SELECT * FROM products;

    After
    _
    INSERT INTO products (product_id, product_name)
    VALUES (104, "straw"),
    (105, "napkin"),
    (106, "fork"),
    (107, "spoon");
    SELECT * FROM products;

    _
    CREATE TABLE transactions(
    transaction_id INT,
    amount DECIMAL(5, 2),
    transaction_date DATETIME DEFAULT NOW()
    );

    _
    INSERT INTO transactions (transaction_id, amount)
    VALUES (1, 4.99);
    SELECT * FROM transactions;




####################################### NOT NULL

----- Create a table with NOT NULL constraint

    CREATE TABLE products(
    product_id INT,
    product_name VARCHAR(25),
    price DECIMAL(4, 2) NOT NULL
    );

----- Adding NOT NULL to an exsiting table

    ALTER TABLE products
    MODIFY price DECIMAL(4, 2) NOT NULL;
    SELECT * FROM products;

    _
    INSERT INTO products
    VALUES (104, "cookie", 0);
    SELECT * FROM products;




####################################### UNION

    > Combines the results of two or more SELECT statements
    Tables need the same number of columns

----- Tables have different number of columns

    SELECT first_name, last_name FROM employees
    UNION
    SELECT first_name, last_name FROM customers;

    -- UNION doesn't allow duplicates while UNION ALL allows




####################################### AUTO_INCREMENT

    CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(5, 2)
    );

    _
    INSERT INTO transactions (amount)
    VALUES (4.99);
    SELECT * FROM transactions;

----- Setting AUTO_INCREMENT value (then delete rows) 

    ALTER TABLE transactions
    AUTO_INCREMENT = 1000;

    _
    DELETE FROM transactions;
    SELECT * FROM transactions;

    _
    INSERT INTO transactions (amount)
    VALUES (4.99);
    SELECT * FROM transactions;
    



####################################### Functions

----- Count rows in amount column

    SELECT COUNT(amount) AS "Today's Counted"
    FROM transactions;

    SELECT MAX(amount) AS Maximum
    FROM transactions;

    SELECT MIN(amount) AS Minimum
    FROM transactions;

    SELECT AVG(amount) AS Average
    FROM transactions;

    SELECT SUM(amount) AS Summation
    FROM transactions;

    SELECT CONCAT(first_name, " ", last_name) AS "Full Name"
    FROM employees;
    



####################################### Views

    Are Virtual Tables

    CREATE VIEW employee_attendance AS
    SELECT first_name, last_name
    FROM employees;
    SELECT * FROM employee_attendance;

    _
    SELECT * FROM employee_attendance
    ORDER BY first_name ASC;

    _
    DROP VIEW employee_attendance

    _
    CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    referral_id INT
    );
    SELECT * FROM customers;

    _
    INSERT INTO customers (first_name, last_name, referral_id)
    VALUES ("Fred", "Fish", NULL),
    ("Larry", "Lobster", 1),
    ("Bubble", "Bass", 2),
    ("Poppy", "Puff", 2);
    SELECT * FROM customers;

    _
    ALTER TABLE customers
    ADD COLUMN email VARCHAR(50);
    SELECT * FROM customers;

    _
    UPDATE customers
    SET email = "ffish2gmail.com"
    WHERE customer_id = 1;
    SELECT * FROM customers;

-----

    CREATE VIEW customer_emails AS
    SELECT email
    FROM customers;
    SELECT * FROM customer_emails;

    _
    INSERT INTO customers (first_name, last_name, referral_id, email)
    VALUES ("Pearl", "Krabs", NULL, "pkrabs@gmail.com");
    SELECT * FROM customers;

    _ Updated (It updates)
    SELECT * FROM customer_emails;




####################################### Indexes (BTree data structure)

    Used to find values with in sepcific columns more quickly
    UPDATE takes more time, SELECT takes less time
     _
    SHOW INDEXES FROM customers;

    _
    CREATE INDEX last_name_idx
    ON customers(last_name);

    _
    SHOW INDEXES FROM customers;

    _
    SELECT * FROM customers
    WHERE last_name = "Puff";

    _
    CREATE INDEX last_name_first_name_idx
    ON customers (last_name, first_name);

    _
    SHOW INDEXES FROM customers;

    _
    ALTER TABLE customers
    DROP INDEX last_name_idx;




####################################### SELF JOIN

    Join another copy of a table to itself
    Used to compare rows of the same table
    Helps to display a hierarchy of data

    _
    UPDATE customers
    SET referral_id = 1
    WHERE customer_id = 2;
    SELECT * FROM customers;

    _
    UPDATE customers
    SET referral_id = 2
    WHERE customer_id = 3 OR customer_id = 4;
    SELECT * FROM customers;

    _
    a = original
    b = copy

    -----
    SELECT *
    FROM customers AS a
    INNER JOIN customers AS b
    ON a.referral_id = b.customer_id;
    -----

    SELECT a.customer_id, a.first_name, a.last_name,
    CONCAT(b.first_name, " ", b.last_name) AS "referred_by"
    FROM customers AS a
    INNER JOIN customers AS b
    ON a.referral_id = b.customer_id;

    _
    ALTER TABLE employees
    ADD supervisor_id INT;
    SELECT * FROM employees;

    _
    UPDATE employees
    SET supervisor_id = 5
    WHERE employee_id IN (2, 3, 4);
    SELECT * FROM employees;

    _
    SELECT a.first_name, a.last_name,
    CONCAT(b.first_name, " ", b.last_name) AS "reports to"
    FROM employees AS a
    INNER JOIN employees AS b
    ON a.supervisor_id = b.employee_id;




####################################### ORDER BY

    SELECT * FROM mydb.employees
    ORDER BY last_name DESC;

    _
    SELECT * FROM transactions
    ORDER BY amount, transaction_id;




####################################### LIMIT

    Used to limit the number of records

    _
    SELECT * FROM mydb.customers
    ORDER BY last_name LIMIT 1;

    _
    SELECT * FROM mydb.customers
    ORDER BY last_name DESC LIMIT 1;

    _
    SELECT * FROM mydb.customers
    LIMIT 3, 1;

----- Pagination
    SELECT * FROM mydb.customers
    LIMIT 20, 10;

    20 - offset
    10 - number of records




####################################### SUBQUERIES

    Query within another query

    SELECT first_name, last_name, hourly_pay, (SELECT AVG(hourly_pay) FROM employees) AS Average  
    FROM mydb.employees;

    _
    SELECT first_name, last_name, hourly_pay
    FROM employees
    WHERE hourly_pay > (SELECT AVG(hourly_pay) FROM employees);

    _
    SELECT first_name, last_name
    FROM customers
    WHERE customer_id IN
    (SELECT DISTINCT customer_id
    FROM transactions
    WHERE customer_id IS NOT NULL); -- (1, 2, 3)

    _
    SELECT first_name, last_name
    FROM customers
    WHERE customer_id NOT IN (1, 2, 3);




####################################### GROUP BY

    Aggregate all ros by a specific column
    Used aggregate functions ex. SUM() MAX() MIN() AVG() COUNT()

    _
    SELECT SUM(amount), order_date
    FROM transactions
    GROUP BY order_date;

    _
    SELECT MAX(amount), order_date
    FROM transactions
    GROUP BY order_date;

    _
    SELECT MIN(amount), order_date
    FROM transactions
    GROUP BY order_date;

    _
    SELECT AVG(amount), order_date
    FROM transactions
    GROUP BY order_date;

    _
    SELECT COUNT(amount), order_date
    FROM transactions
    GROUP BY order_date;

-----
    _
    SELECT SUM(amount), customer_id
    FROM transactions
    GROUP BY customer_id;

    _
    SELECT MAX(amount), customer_id
    FROM transactions
    GROUP BY customer_id;

    _
    SELECT COUNT(amount), customer_id
    FROM transactions
    GROUP BY customer_id;

-- GROUP BY doesn't work with WHERE instead use HAVING

    _
    SELECT COUNT(amount), customer_id
    FROM transactions
    GROUP BY customer_id
    HAVING COUNT(amount) > 1 AND customer_id IS NOT NULL;




####################################### TRIGGERS

    When an event happens, it triggers something
    ex. (INSERT, UPDATE, DELETE) checks data, handles errors, auditing tables

    _
    ALTER TABLE employees
    ADD COLUMN salary DECIMAL(10, 2)
    AFTER hourly_pay;
    SELECT * FROM employees;

    _
    UPDATE employees
    SET salary = hourly_pay * 40 * 52;
    SELECT * FROM employees;

    _
    CREATE TRIGGER before_hourly_pay_update
    BEFORE 
    UPDATE ON employees
    FOR EACH ROW 
    SET NEW.salary = (NEW.hourly_pay * 40 * 52);

    _
    SHOW TRIGGERS;

    _
    UPDATE employees
    SET hourly_pay = 50     -- salary changes automatically
    WHERE employee_id = 1;
    SELECT * FROM employees;

    _ automatic Update

    UPDATE employees
    SET hourly_pay = hourly_pay + 1;
    SELECT * FROM employees;

    _
    DELETE FROM employees
    WHERE employee_id = 6;
    SELECT * FROM employees;

    _
    CREATE TRIGGER before_hourly_pay_insert
    BEFORE 
    INSERT ON employees
    FOR EACH ROW
    SET NEW.salary = (NEW.hourly_pay * 2080);

    _
    INSERT INTO employees
    VALUES(6, "Sheldon", "Plankton", 10, NULL, "janitor", "2023-01-07", 5);
    SELECT * FROM employees;

    _
    CREATE TABLE expenses(
        expense_id INT PRIMARY KEY,
        expense_name VARCHAR(50),
        expense_total DECIMAL(10, 2)
    );
    SELECT * FROM expenses;

    _
    INSERT INTO expenses
    VALUES (1, "salaries", 0),
    (2, "supplies", 0),
    (3, "taxes", 0);
    SELECT * FROM expenses;

    _
    UPDATE expenses
    SET expense_total = (SELECT SUM(salary) FROM employees)
    WHERE expense_name = "salaries";
    SELECT * FROM expenses;

    _
    CREATE TRIGGER after_salary_delete
    AFTER 
    DELETE ON employees
    FOR EACH ROW
    UPDATE expenses
    SET expense_total = expense_total - OLD.salary
    WHERE expense_name = "salaries";

    _
    DELETE FROM employees
    WHERE employee_id = 6;
    SELECT * FROM expenses;

    _
    CREATE TRIGGER after_salary_insert
    AFTER 
    INSERT ON employees
    FOR EACH ROW
    UPDATE expenses
    SET expense_total = expense_total + NEW.salary
    WHERE expense_name = "salaries";

    _
    INSERT INTO employees
    VALUES(6, "Sheldon", "Plankton", 10, NULL, "janitor", "2023-01-07", 5);
    SELECT * FROM expenses;

    _
    CREATE TRIGGER after_salary_update
    AFTER 
    UPDATE ON employees
    FOR EACH ROW
    UPDATE expenses
    SET expense_total = expense_total + (NEW.salary - OLD.salary)
    WHERE expense_name = "salaries";

    _
    UPDATE employees
    SET hourly_pay = 100
    WHERE employee_id = 1;
    SELECT * FROM expenses;




####################################### STORED PROCEDURES

    Is prepared SQL code that you can save great if there is a query that you write often

    _ $$ or //

    DELIMITER $$
    CREATE PROCEDURE get_all_customers()
    BEGIN
        SELECT * FROM customers;
    END $$
    DELIMITER ;

    _
    CALL get_all_customers();

    _
    DROP PROCEDURE get_all_customers;

    _
    DELIMITER //
    CREATE PROCEDURE find_customer(IN id INT)
    BEGIN
        SELECT * FROM customers
        WHERE customer_id = id;
    END //
    DELIMITER ;

    _
    CALL find_customer(1);

    _
    DELIMITER $$
    CREATE PROCEDURE find_customer(IN f_name VARCHAR(50),
     IN l_name VARCHAR(50))
    BEGIN
        SELECT * FROM customers
        WHERE first_name = f_name AND last_name = l_name;
    END $$
    DELIMITER ;

    _
    CALL find_customer("Larry", "Lobster");




####################################### FOREIGN KEY

    CREATE TABLE transact_fk (
        transaction_id INR PRIMARY KEY AUTO_INCREMENT,
        amount DECIMAL(5, 2),
        customer_id INT,
        FOREIGN KEY(customer_id) REFERENCES customers(customer_id) 
        -- first customer_id is for foreign key and the second is for a primary key
    );
    SELECT * FROM transact_fk;

    _
    ALTER TABLE transact_fk
    DROP FOREIGN KEY transact_fk_ibfk_1;
    -- transact_fk_ibfk_1 is the foreign key name

----- Adding foreign key to existing table

    ALTER TABLE transact_fk
    ADD CONSTRAINT fk_customer_id    -- renames fk
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id);

    _
    DELETE FROM transact_fk;
    SELECT * FROM transact_fk;

    ALTER TABLE transact_fk
    AUTO_INCREMENT = 1000;

    _
    INSERT INTO transact_fk (amount, customer_id)
    VALUES (4.99, 3),
    (2.89, 2),
    (3.38, 3),
    (4.99, 1);
    SELECT * FROM transact_fk;




####################################### PRIMARY KEY

    Must be both unique and not null (unique identifier)
    A table can only have one primary key

----- Adding primary key to existing table

    _
    CREATE TABLE transactions (
        transaction_id INT PRIMARY KEY,
        amount DECIMAL(5, 2)
    );
    SELECT * FROM transactions;
    
    _
    ALTER TABLE transactions
    ADD CONSTRAINT
    PRIMARY KEY(transaction_id);
    SELECT * FROM transactions;

    _
    INSERT INTO transactions
    VALUES (1000, 4.99),
    (1001, 2.89),
    (1002, 3.38),
    (1003, 4.99);
    SELECT * FROM transactions;




####################################### ON DELETE clause

    ON DELETE SET NULL - when a FK is deleted, replace FK with NULL
    ON DELETE CASCADE - when a FK is deleted, delete row

    _
    SET foreign_key_checks = 0;     -- later set it back to 1
    DELETE FROM customers
    WHERE customer_id = 4;
    SELECT * FROM customers;

    _
    INSERT INTO customers
    VALUES (4, "Poppy", "Puff", "PPuff@gmial.com", 2);
    SELECT * FROM customers;

    ---------------------------------------------------
        CREATE TABLE transact_fk (
        transaction_id INR PRIMARY KEY AUTO_INCREMENT,
        amount DECIMAL(5, 2),
        customer_id INT,
        FOREIGN KEY(customer_id) REFERENCES customers(customer_id) 
        ON DELETE SET NULL
    );
    SELECT * FROM transact_fk;
    ---------------------------------------------------

----- To existing table

    ALTER TABLE transactions
    DROP FOREIGN KEY fkIn_customer_id;

----- ON DELETE SET NULL

    ALTER TABLE transactions
    ADD CONSTRAINT fkIn_customer_id
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
    ON DELETE SET NULL;

    _
    DELETE FROM customers
    WHERE customer_id = 4;
    SELECT * FROM transactions;

----- ON DELETE CASCADE

    ALTER TABLE transactions
    ADD CONSTRAINT fkIn_customer_id
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
    ON DELETE CASCADE;

    _
    UPDATE transactions
    SET customer_id = 4
    WHERE transaction_id = 1005;
    SELECT * FROM transactions;

    _
    DELETE FROM customers
    WHERE customer_id = 4;
    SELECT * FROM transactions;




####################################### UNIQUE constraint

    Ensures all values in a column are different

    CREATE TABLE products (
        product_id INT,
        product_name VARCHAR(25) UNIQUE,
        price DECIMAL(4, 2)
    );

----- Adding to existing table

    ALTER TABLE products 
    ADD CONSTRAINT
    UNIQUE(product_name);




####################################### CHECK constraint

    Limits what values can be placed in a column

    CREATE TABLE employees (
        emloyee_id INT,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        hourly_pay DECIMAL(5, 2),
        hire_date DATE,
        CONSTRAINT chk_hourly_pay CHECK (hourly_pay >= 10.00)
    );

-----

    ALTER TABLE employees
    ADD CONSTRAINT chk_hourly_pay 
    CHECK(hourly_pay >= 10.00);

    _
    ALTER TABLE employees
    DROP CHECK chk_hourly_pay;




####################################### ROLLUP

    Extention of the GROUP BY clause produces another row and shows the GRAND TOTAL (super-aggregate value)

    _
    SELECT SUM(amount), order_date
    FROM transactions
    GROUP BY order_date WITH ROLLUP;

    _
    SELECT COUNT(transaction_id), order_date
    FROM transactions
    GROUP BY order_date WITH ROLLUP;

    _
    SELECT COUNT(transaction_id) AS "# of orders", customer_id
    FROM transactions
    GROUP BY customer_id WITH ROLLUP;

    _
    SELECT SUM(hourly_pay), employee_id
    FROM employees
    GROUP BY employee_id WITH ROLLUP;




####################################### AUTOCOMMIT, COMMIT & ROLLBACK

    AUTOCOMMIT is on by default

    SET AUTOCOMMIT = OFF;   -- you need to manually save entries and creates a saving point

    COMMIT;
    ROLLBACK;




####################################### CURRENT_DATE___CURRENT_TIME

    CREATE TABLE trial (
        my_date DATE,
        my_time TIME,
        my_datetime DATETIME
    );

    INSERT INTO trial ()
    VALUES (CURRENT_DATE(), CURRENT_TIME(), NOW()),
            (CURRENT_DATE() + 1, NULL, NULL),   -- Tomorrow
            (CURRENT_DATE() - 1, NULL, NULL);   -- Yesterday



--------------------------------------------------
--------------------------------------------------
--------------------------------------------------

        (INSERT, UPDATE, DELETE)

DELIMITER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT
    ON employee
    FOR EACH ROW 
    BEGIN
        IF NEW.sex = 'M' THEN
            INSERT INTO trigger_test VALUES ('added male employee');
        ELSEIF NEW.sex = 'F' THEN
            INSERT INTO trigger_test VALUES ('added female employee');
        ELSE
            INSERT INTO trigger_test VALUES ('added other employee');
        END IF;
    END $$
DELIMITER ;
SELECT * FROM trigger_test;




#########
######### Moving tables from one database to another
#########




####################################### Using RENAME TABLE (For Tables on the Same Server)

    RENAME TABLE old_database.table_name TO new_database.table_name;

    Ex.
    RENAME TABLE old_db.employees TO new_db.employees;
    



####################################### Using CREATE TABLE and INSERT INTO (Manual Copy)

----- Get the structure of the table from the old database and create it in the new database. Use the output to create the same table in the new database.

    SHOW CREATE TABLE old_db.table_name;

----- Copy all the data from the old table to the new one using INSERT INTO with a SELECT query.

    INSERT INTO new_db.table_name SELECT * FROM old_db.table_name;

    Ex.
    CREATE TABLE new_db.employees LIKE old_db.employees;        
    -- Creates the table with the same structure
    INSERT INTO new_db.employees SELECT * FROM old_db.employees;        
    -- Copies all data from the old table to the new table
    



####################################### Using mysqldump (For Large Tables or Different Servers)

----- Use the mysqldump command to export the table from the old database into a .sql file.

    mysqldump -u username -p old_db table_name > table_name.sql

----- Once you have the .sql file, import it into the new database.

    mysql -u username -p new_db < table_name.sql

    Ex.
    # Export the table from the old database
    mysqldump -u root -p old_db employees > employees.sql

    # Import the table into the new database
    mysql -u root -p new_db < employees.sql
    



####################################### Using SELECT INTO OUTFILE (Alternative for Large Tables)

----- Export the data to a CSV file

    SELECT * INTO OUTFILE '/tmp/employees.csv' 
    FIELDS TERMINATED BY ',' 
    OPTIONALLY ENCLOSED BY '"' 
    LINES TERMINATED BY '\n'
    FROM old_db.employees;

----- Import the data into the new table: First, create the table structure in the new database, then load the CSV data

    LOAD DATA INFILE '/tmp/employees.csv' 
    INTO TABLE new_db.employees
    FIELDS TERMINATED BY ',' 
    OPTIONALLY ENCLOSED BY '"' 
    LINES TERMINATED BY '\n';

    >>>> RENAME TABLE: Quick and efficient for tables on the same server.
    >>>> Manual Copy (CREATE TABLE and INSERT INTO): Provides more control over the process.
    >>>> mysqldump: Ideal for moving tables between different servers or for preserving indexes and constraints.
    >>>> SELECT INTO OUTFILE and LOAD DATA INFILE: Efficient for very large tables when you just need the data.




#########
######### Coping tables from one database to another
#########




####################################### Copy Table Structure and Data

    CREATE TABLE target_database.new_table_name LIKE source_database.old_table_name;
    INSERT INTO target_database.new_table_name SELECT * FROM source_database.old_table_name;

    Ex.
    CREATE TABLE target_db.new_employees LIKE source_db.employees;
    INSERT INTO target_db.new_employees SELECT * FROM source_db.employees;




####################################### Copy Only Table Structure (Without Data)

    CREATE TABLE target_database.new_table_name LIKE source_database.old_table_name;

    Ex.
    CREATE TABLE target_db.new_employees LIKE source_db.employees;




####################################### Copy Only Data (Assuming the Target Table Already Exists)

    INSERT INTO target_database.existing_table_name SELECT * FROM source_database.old_table_name;

    Ex.
    INSERT INTO target_db.employees SELECT * FROM source_db.employees;




####################################### Copy Table Using mysqldump (For Large Tables)

----- Export the table from the source database. Run the mysqldump command to export the table structure and data to a .sql file.

    mysqldump -u username -p source_database old_table_name > old_table_name.sql

----- Import the table into the target database. Once you have the .sql file, you can import it into the target database using the mysql command

    mysql -u username -p target_database < old_table_name.sql




####################################### Copy Table Using phpMyAdmin (GUI Tool)

----- Export the table from the source database:

    Go to phpMyAdmin.
    Select the source database and then the table.
    Click on the Export tab.
    Choose Custom and ensure the table structure and data are selected.
    Download the .sql file.
    
----- Import the table into the target database:

    Select the target database.
    Click on the Import tab.
    Choose the previously exported .sql file and click Go.
```
