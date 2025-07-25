# PostgreSQL

- [connecting to DB](#connecting-to-db)
- [How to Check/Create Them](#how-to-checkcreate-them)
- [creating DBs](#creating-dbs)
- [deleteing DBs](#deleteing-dbs)
- [creating tables without constraints](#creating-tables-without-constraints)
- [creating tables with constraints](#creating-tables-with-constraints)
- [INSERT INTO tables](#insert-into-tables)
- [Importing data from a file](#importing-data-from-a-file)
- [ORDER BY](#order-by)
- [DISTINCT](#distinct)
- [comparison operators](#comparison-operators)
- [LIMIT OFFSET & FETCH](#limit-offset--fetch)
- [IN](#in)
- [BETWEEN](#between)
- [LIKE & ILIKE](#like--ilike)
- [GROUP BY](#group-by)
- [GROUP BY HAVING](#group-by-having)
- [MIN, MAX, SUM, AVG](#min-max-sum-avg)
- [Coalasce](#coalasce)
- [NULLIF](#nullif)
- [DATE & TIMESTAMPS](#date--timestamps)
- [Adding & Subtracting with databases](#adding--subtracting-with-databases)
- [Extracting Fields](#extracting-fields)
- [Age Function](#age-function)
- [PRIMARY KEYS](#primary-keys)
- [Adding PRIMARY KEYS](#adding-primary-keys)
- [UNIQUE constraints](#unique-constraints)
- [Check constraints](#check-constraints)
- [UPDATE records](#update-records)
- [On conflict do nothing](#on-conflict-do-nothing)
- [Forign key, Joins & Relationships](#forign-key-joins--relationships)
- [Deleting records with foreign KEYS](#deleting-records-with-foreign-keys)
- [Exporting Query Results to CSV](#exporting-query-results-to-csv)
- [Serial & Sequences](#serial--sequences)
- [Extensions](#extensions)
- [Understanding UUID data type](#understanding-uuid-data-type)
- [UUID as Primary Key](#uuid-as-primary-key)
- [Resetting Auto-Increment IDs](#resetting-auto-increment-ids)
  - [Complete Reset Solution (For Development/Testing)](#complete-reset-solution-for-developmenttesting)
  - [Partial Reset (Keep Data, Just Fix IDs)](#partial-reset-keep-data-just-fix-ids)

## connecting to DB

```sql
    Connection options:
    -h, --host=HOSTNAME      database server host or socket directory (default: "/var/run/postgresql")
    -p, --port=PORT          database server port (default: "5432")
    -U, --username=USERNAME  database user name (default: "benjn")
    -w, --no-password        never prompt for password
    -W, --password           force password prompt (should happen automatically)

    \l  -- list databases
    \c -- connect to a database
    \d -- list tables in a database
    \dt -- list tables in a database
    \d table_name -- list table detailed info
    \dt table_name -- list just that table if it exists

        psql -h localhost -p 5432 -U <username> <dbname>;

    -- alternatively

        sudo -i -u postgres
        psql
        \l
        \c <dbname> -> to connect to a database
```

### Use `sudo -i -u postgres` when you need to

- Perform multiple PostgreSQL admin tasks
- Access files owned by the postgres user

### Use `sudo -u postgres psql` when you need to

- Quickly get a PostgreSQL superuser prompt
- Run a single admin command

### Use `psql -U user -d db-name` when you

- Want to connect as a regular database user
- Are working with application databases (not admin tasks)

_Important Security Note: For production systems, avoid using the postgres superuser for routine operations. Instead:_

1. Create dedicated database users with limited privileges
2. Use `psql -U youruser -d yourdb` for daily work
3. Only use postgres access for admin/maintenance tasks

```sql
-- If you need a new user/database (replace youruser and yourdb):
sudo -u postgres createuser --interactive  # Follow prompts
sudo -u postgres createdb yourdb

-- Connect to Your Database
psql -U youruser -d yourdb

-- Example workflow

-- 1. Create role and database (as postgres admin)
sudo -u postgres psql -c "CREATE USER benjamin WITH PASSWORD '12345678';"
sudo -u postgres psql -c "CREATE DATABASE Quiz;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE Quiz TO benjamin;"

-- 2. Connect as benjamin (PostgreSQL role)
psql -U benjamin -d Quiz
-- Enter password when prompted: 12345678

-- 3. Once connected, you can run \l to list databases
```

```sql
sudo -u postgres psql -c "\du"

sudo -u postgres psql -c "DROP OWNED BY benjamin CASCADE; DROP ROLE IF EXISTS benjamin;"

sudo -u postgres psql -c "\du"
```

- `DROP OWNED BY` removes all objects (tables, etc.) owned by benjamin.
- `DROP ROLE` deletes the user.

## How to Check/Create Them

### 1. Check if User & DB Exist (as admin)

```sql
sudo -u postgres psql -c "\du"         # List all users/roles
sudo -u postgres psql -c "\l"          # List all databases
```

### 2. Create Missing User & Database

If either doesn't exist, create them first (as postgres admin):

```sql
# Create a new user (role) with password
sudo -u postgres psql -c "CREATE USER youruser WITH PASSWORD 'yourpassword';"

# Create a database and grant privileges
sudo -u postgres psql -c "CREATE DATABASE yourdb;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE yourdb TO youruser;"
```

## creating DBs

```sql
    CREATE DATABASE <dbname>;
    \l
```

## deleteing DBs

```sql
    DROP DATABASE <dbname>;
    \l
```

## creating tables without constraints

```sql
    CREATE TABLE <table_name> (
        <column_name> <datatype>
    );

    CREATE TABLE person (
        id INT,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        gender VARCHAR(7),
        date_of_birth DATE
    );

    \d -> list relations
    \dt -> list tables
    \d <table_name> -> list table details
```

## creating tables with constraints

```sql
    CREATE TABLE <table_name> (
        <column_name> <datatype> <constraint>
    );

    DROP TABLE person;

    CREATE TABLE person (
        id SERIAL NOT NULL PRIMARY KEY,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        gender VARCHAR(7) NOT NULL,
        date_of_birth DATE NOT NULL
    );

    -
    ALTER TABLE person
    ADD COLUMN email VARCHAR(100);

    -
    ALTER TABLE person
    DROP COLUMN email;
```

## INSERT INTO tables

```sql
    INSERT INTO person (first_name, last_name, gender, date_of_birth, email)
    VALUES ('Anne', 'Smith', 'FEMALE', DATE '1988-01-09', NULL),
        ('Jake', 'Jones', 'MALE', DATE '1990-01-10', 'jake@gmail.com');
```

## Importing data from a file

```sql
    -- Mockaroo.com

    -- sql
    \i /home/benjn/Desktop/postrgreSQL/persona.sql -> to import file

    -- csv
    COPY table_name FROM /home/benjn/Desktop/file.csv
    DELIMITER ','
    CSV HEADER;
```

## ORDER BY

```sql
    SELECT *
    FROM person
    ORDER BY country_of_birth DESC;
```

## DISTINCT

```sql
    SELECT DISTINCT country_of_birth
    FROM person
    ORDER BY country_of_birth DESC;
```

## comparison operators

```sql
    SELECT *
    FROM person
    WHERE gender = 'Male'
    AND date_of_birth > DATE '1990-01-01';

    SELECT 1 = 1;       -- t
    SELECT 1 = 0;       -- f
    SELECT 1 >= 0;      -- t
```

## LIMIT OFFSET & FETCH

```sql
    SELECT *
    FROM person
    LIMIT 10;       -- top 10

    -
    SELECT *
    FROM person
    OFFSET 5;       -- skip 5

    -
    SELECT *
    FROM person
    LIMIT 10
    OFFSET 10;      -- 11-20

    -
    SELECT *
    FROM person
    ORDER BY country_of_birth DESC
    LIMIT 5
    OFFSET 5;       --  6-9

    -
    SELECT *
    FROM person
    OFFSET 10 ROWS
    FETCH NEXT 20 ROWS ONLY;

    -
    SELECT *
    FROM person
    OFFSET 10
    FETCH FIRST ROW ONLY;
```

## IN

```sql
    SELECT *
    FROM person
    WHERE country_of_birth
    IN ('Uganda', 'Mayotte', 'Canada')
    ORDER BY country_of_birth DESC;
```

## BETWEEN

```sql
    SELECT *
    FROM person
    WHERE date_of_birth
    BETWEEN DATE '2023-01-01' AND DATE '2024-12-31'
    ORDER BY date_of_birth DESC;
```

## LIKE & iLIKE

```sql
    SELECT *
    FROM person
    WHERE email LIKE '%@google.com'
    ORDER BY email DESC;

    -
    SELECT *
    FROM person
    WHERE country_of_birth iLIKE 'p%';  -- ignores case-sensitivity
```

## GROUP BY

```sql
    SELECT country_of_birth, COUNT(*) AS Counts
    FROM person
    GROUP BY country_of_birth
    ORDER BY country_of_birth;
```

## GROUP BY HAVING

```sql
    SELECT country_of_birth, COUNT(*)
    FROM person
    GROUP BY country_of_birth
    HAVING COUNT(*) > 50
    ORDER BY country_of_birth;
```

## MIN, MAX, SUM, AVG

```sql
    SELECT MIN(price),
        MAX(price),
        SUM(price),
        ROUND(AVG(price))
    FROM car;

    -
    SELECT
        make, model,
        MIN(price)
    FROM car
    GROUP BY make, model;

    -
    SELECT
        make,
        MIN(price)
    FROM car
    GROUP BY make;

    ----
    SELECT SUM(price)
    FROM car;

    -
    SELECT
        make,
        SUM(price)
    FROM car
    GROUP BY make;
```

## Coalasce

```sql
-- Handling NULL values, have a default value incase first one is not present

    SELECT COALESCE(1);

    SELECT COALESCE(null, 1) AS number;

    SELECT COALESCE(email, 'Email not provided') FROM person;   -- Column with NULL get 'Email not provided' instead
```

## NULLIF

```sql
-- Used to compare two expressions. If the expressions are equal, NULLIF returns NULL; if they are not equal, it returns the value of the first expression.

    SELECT NULLIF(1, 1) AS result;      -- Returns NULL
    SELECT NULLIF(1, 2) AS result;      -- Returns 1
    SELECT 10 / NULLIF(2,9);             -- Returns 5
    SELECT COALESCE(10 / NULLIF(0,0), 0);
```

## DATE & TIMESTAMPS

```sql
    SELECT NOW();
    SELECT NOW()::TIME;     -- Casting to time
    SELECT NOW()::DATE;     -- Casting to date
```

## Adding & Subtracting with databases

```sql
    SELECT NOW() - INTERVAL '1 YEAR';
    SELECT NOW() - INTERVAL '10 YEARS';
    SELECT NOW() - INTERVAL '10 MONTHS';
    SELECT NOW() - INTERVAL '10 DAYS';
    SELECT NOW() + INTERVAL '10 DAYS';
    SELECT NOW()::DATE + INTERVAL '10 DAYS';
    SELECT (NOW() + INTERVAL '10 DAYS')::DATE;
```

## Extracting Fields

```sql
    SELECT EXTRACT(YEAR FROM NOW());
    SELECT EXTRACT(MONTH FROM NOW());
    SELECT EXTRACT(DAY FROM NOW());
    SELECT EXTRACT(DOW FROM NOW());     -- Day Of the Week
    SELECT EXTRACT(CENTURY FROM NOW());
```

## Age Function

```sql
    SELECT first_name, last_name, gender, country_of_birth, date_of_birth, AGE(NOW(), date_of_birth)
    AS age
    FROM person;
```

## PRIMARY KEYS

```sql
    ALTER TABLE person
    DROP CONSTRAINT person_pkey;
```

## Adding PRIMARY KEYS

```sql
    ALTER TABLE person
    ADD PRIMARY KEY (id);
```

## UNIQUE constraints

```sql
    SELECT email, COUNT(*) FROM person GROUP BY email;
    SELECT email, COUNT(*) FROM person GROUP BY email HAVING COUNT(*) > 1;

    -
    ALTER TABLE person
    ADD CONSTRAINT unique_email_address
    UNIQUE(email);

    -
    ALTER TABLE person
    DROP CONSTRAINT unique_email_address;

    -
    ALTER TABLE person
    ADD UNIQUE(email);          -- postgres defines the constraint name
```

## Check constraints

```sql
    ALTER TABLE person
    ADD CONSTRAINT chk_gender
    CHECK (gender IN ('Female', 'Male'));

    ALTER TABLE person
    ADD CONSTRAINT chk_gender
    CHECK (gender = 'Female' OR gender = 'Male');
```

## UPDATE records

```sql
    UPDATE person
    SET email = 'new@gmail.com'
    WHERE id = 1;

    -
    UPDATE person
    SET first_name = 'Omar', last_name = 'Montana', email = 'omarmontana@gmail.com'
    WHERE id = 1;
```

## On conflict do nothing

```sql
-- Handling duplicate key errors

    INSERT INTO person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth)
    VALUES (7, 'Jonie', 'Scroggie', 'croggie@sciencedaily.com', 'Female', '2024-02-13', 'China')
    ON CONFLICT (email) DO NOTHING;     -- Column should be unique i.e. with a  constraint
```

## Upsert

## Forign key, Joins & Relationships

```sql
    UPDATE person
    SET car_id = 2
    WHERE id = 1;

    -
    UPDATE person
    SET car_id = 1
    WHERE id = 2;

---- Inner Joins

    -
    SELECT p.first_name,
        p.last_name,
        p.country_of_birth,
        p.car_id,
        c.make,
        c.model
    FROM person p
    JOIN car c
        ON p.car_id = c.id;

    -
    SELECT person.first_name, car.make, car.model, car.price
    FROM person
    JOIN car
        ON person.car_id = car.id;

    -
    SELECT *
    FROM person
    LEFT JOIN car
        ON person.car_id = car.id
    WHERE car.* IS NULL;
```

## Deleting records with foreign KEYS

```sql
    -- Delete child records first

    -- Delete child records referencing the parent record
    DELETE FROM child_table WHERE foreign_key_column = parent_id;
    -- Then delete the parent record
    DELETE FROM parent_table WHERE id = parent_id;
```

```sql
    -- Update foreign key columns to NULL (if allowed)

    -- Set foreign key column to NULL before deleting parent record
    UPDATE child_table SET foreign_key_column = NULL WHERE foreign_key_column = parent_id;
    -- Then delete the parent record
    DELETE FROM parent_table WHERE id = parent_id;
```

```sql
    -- Using ON DELETE CASCADE or SET NULL

    ALTER TABLE child_table
    ADD CONSTRAINT fk_name
    FOREIGN KEY (foreign_key_column)
    REFERENCES parent_table(id)
    ON DELETE CASCADE;  -- Automatically deletes child records when parent is deleted

    -- OR

    ON DELETE SET NULL; -- Sets foreign key to NULL on parent deletion
```

## Exporting Query Results to CSV

```sql
    SELECT *
    FROM person
    LEFT JOIN car
        ON person.car_id = car.id;

    -
    \copy (SELECT *
    FROM person
    LEFT JOIN car
        ON person.car_id = car.id) TO '/tmp/results.csv' DELIMITER ',' CSV HEADER;
```

## Serial & Sequences

```sql
----    BIGSERIAL -> BIGINT, SERIAL -> INT

    SELECT * FROM person_id_seq;                    -- To check sequence status

    SELECT nextval('person_id_seq'::regclass);      -- To get the next value, increments whenever you run this query

    ALTER SEQUENCE person_id_seq
    RESTART WITH 4;
```

## Extensions

```sql
    SELECT * FROM pg_extension;             -- Shows what has already been installed

    SELECT * FROM pg_available_extensions   -- Lists all extensions that can potentially be installed
```

## Understanding UUID data type

```sql
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";     -- To install the uuid-ossp extension

    \df -> list functions

    SELECT uuid_generate_v4();     -- To generate a UUID
```

## UUID as Primary Key

```sql
-------------------------------------------------------

    CREATE TABLE car (
        car_uid UUID NOT NULL PRIMARY KEY,
        make VARCHAR(100) NOT NULL,
        model VARCHAR(100) NOT NULL,
        price NUMERIC(19, 2) NOT NULL CHECK (price > 0)
    );

    CREATE TABLE person (
        person_uid UUID NOT NULL PRIMARY KEY,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        gender VARCHAR(7) NOT NULL,
        email VARCHAR(100),
        date_of_birth DATE NOT NULL,
        country_of_birth VARCHAR(50) NOT NULL,
        car_uid UUID REFERENCES car(car_uid),
        UNIQUE(car_uid),
        UNIQUE(email)
    );

    INSERT INTO car (car_uid, make, model, price)
    VALUES (uuid_generate_v4(), 'Land Rover', 'Sterling', 87665.38);
    INSERT INTO car (car_uid, make, model, price)
    VALUES (uuid_generate_v4(), 'GMC', 'Acadia', 17662.69);

    INSERT INTO person (person_uid, first_name, last_name, gender, email, date_of_birth, country_of_birth)
    VALUES (uuid_generate_v4(), 'Fernanda', 'Beardon', 'Female', 'fernandab@is.gd', '1953-01-28', 'Comoros');
    INSERT INTO person (person_uid, first_name, last_name, gender, email, date_of_birth, country_of_birth)
    VALUES (uuid_generate_v4(), 'Omar', 'Colmore', 'Male', NULL, '1921-04-03', 'Finland');
    INSERT INTO person (person_uid, first_name, last_name, gender, email, date_of_birth, country_of_birth)
    VALUES (uuid_generate_v4(), 'Adriana', 'Matuschek', 'Female', 'amatuschek2@feedburner.com', '1965-02-28', 'Cameroon');

-------------------------------------------------------

    UPDATE person SET car_uid = '305b1bc5-9a35-48ba-bc04-a16fc4fb718e' WHERE person_uid = '580de320-b871-4ed2-b041-ec63f0d77f31';

    UPDATE person SET car_uid = '58016e98-282a-4c5e-b082-96b8f3126e63' WHERE person_uid = '7126a801-a586-48bf-8c22-8e9eecda0327';

-------------------------------------------------------

    SELECT *
    FROM person
    JOIN car
        USING(car_uid);

    -
    SELECT *
    FROM person
    JOIN car
        ON person.car_uid = car.car_uid;

    -
    SELECT *
    FROM person
    LEFT JOIN car
        USING (car_uid)
    WHERE car.* IS NULL;
```

## Resetting Auto-Increment IDs

### Complete Reset Solution (For Development/Testing)

```sql
    -- 1. First truncate choices (child table) to avoid foreign key errors
    TRUNCATE TABLE choices RESTART IDENTITY;

    -- 2. Then truncate questions (parent table)
    TRUNCATE TABLE questions RESTART IDENTITY;

    -- 3. Verify reset worked
    INSERT INTO questions (question_text) VALUES ('Test question');
    INSERT INTO choices (question_id, choice_text, is_correct)
    VALUES (1, 'Test choice', true);

    -- Check results
    SELECT * FROM questions;  -- Should show ID 1
    SELECT * FROM choices;    -- Should show ID 1 with question_id 1
```

### Partial Reset (Keep Data, Just Fix IDs)

```sql
    -- 1. Reset questions sequence
    ALTER SEQUENCE questions_id_seq RESTART WITH 1;

    -- 2. Reset choices sequence
    ALTER SEQUENCE choices_id_seq RESTART WITH 1;

    -- 3. Reassign question IDs sequentially
    WITH new_questions AS (
    SELECT id, ROW_NUMBER() OVER (ORDER BY id) as new_id
    FROM questions
    )
    UPDATE questions q
    SET id = n.new_id
    FROM new_questions n
    WHERE q.id = n.id;

    -- 4. Update choice question_ids to match
    UPDATE choices c
    SET question_id = q.new_id
    FROM (
    SELECT id, ROW_NUMBER() OVER (ORDER BY id) as new_id
    FROM questions
    ) q
    WHERE c.question_id = q.id;

    -- 5. Reassign choice IDs sequentially
    WITH new_choices AS (
    SELECT id, ROW_NUMBER() OVER (ORDER BY id) as new_id
    FROM choices
    )
    UPDATE choices c
    SET id = n.new_id
    FROM new_choices n
    WHERE c.id = n.id;
```

### For SQLAlchemy

```sql
    # Execute raw SQL through your session
    db.execute(text("TRUNCATE TABLE choices RESTART IDENTITY"))
    db.execute(text("TRUNCATE TABLE questions RESTART IDENTITY"))
    db.commit()
```

[Back to top](#postgresql)
