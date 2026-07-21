-- ============================================================
-- 1. Drop and recreate the database
-- ============================================================
DROP DATABASE IF EXISTS DataWarehouseAnalytics;
CREATE DATABASE DataWarehouseAnalytics;
USE DataWarehouseAnalytics;

-- ============================================================
-- 2. Create tables
-- ============================================================
CREATE TABLE dim_customers (
    customer_key INT,
    customer_id INT,
    customer_number VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(50),
    gender VARCHAR(50),
    birthdate DATE,
    create_date DATE
);

CREATE TABLE dim_products (
    product_key INT,
    product_id INT,
    product_number VARCHAR(50),
    product_name VARCHAR(100),
    category_id VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance VARCHAR(50),
    cost INT,
    product_line VARCHAR(50),
    start_date DATE
);

CREATE TABLE fact_sales (
    order_number VARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity TINYINT,
    price INT
);

-- ============================================================
-- 3. Enable LOCAL INFILE
-- ============================================================
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';   -- verify it's ON

-- ============================================================
-- 4. Load data with NULLIF to handle empty dates
-- ============================================================

-- 4a. dim_customers
TRUNCATE TABLE dim_customers;
LOAD DATA LOCAL INFILE '/Users/vinitbargujar/Downloads/VINIT/SQL/sql-data-analytics-project/datasets/files/dim_customers.csv'
INTO TABLE dim_customers
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@customer_key, @customer_id, @customer_number, @first_name, @last_name, @country, @marital_status, @gender, @birthdate, @create_date)
SET 
    customer_key = @customer_key,
    customer_id = @customer_id,
    customer_number = @customer_number,
    first_name = @first_name,
    last_name = @last_name,
    country = @country,
    marital_status = @marital_status,
    gender = @gender,
    birthdate = NULLIF(@birthdate, ''),
    create_date = NULLIF(@create_date, '');

-- 4b. dim_products
TRUNCATE TABLE dim_products;
LOAD DATA LOCAL INFILE '/Users/vinitbargujar/Downloads/VINIT/SQL/sql-data-analytics-project/datasets/files/dim_products.csv'
INTO TABLE dim_products
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@product_key, @product_id, @product_number, @product_name, @category_id, @category, @subcategory, @maintenance, @cost, @product_line, @start_date)
SET 
    product_key = @product_key,
    product_id = @product_id,
    product_number = @product_number,
    product_name = @product_name,
    category_id = @category_id,
    category = @category,
    subcategory = @subcategory,
    maintenance = @maintenance,
    cost = @cost,
    product_line = @product_line,
    start_date = NULLIF(@start_date, '');

-- 4c. fact_sales
TRUNCATE TABLE fact_sales;
LOAD DATA LOCAL INFILE '/Users/vinitbargujar/Downloads/VINIT/SQL/sql-data-analytics-project/datasets/files/fact_sales.csv'
INTO TABLE fact_sales
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@order_number, @product_key, @customer_key, @order_date, @shipping_date, @due_date, @sales_amount, @quantity, @price)
SET 
    order_number = @order_number,
    product_key = @product_key,
    customer_key = @customer_key,
    order_date = NULLIF(@order_date, ''),
    shipping_date = NULLIF(@shipping_date, ''),
    due_date = NULLIF(@due_date, ''),
    sales_amount = @sales_amount,
    quantity = @quantity,
    price = @price;

-- ============================================================
-- 5. Verify row counts
-- ============================================================
SELECT 'dim_customers' AS table_name, COUNT(*) AS row_count FROM dim_customers
UNION ALL
SELECT 'dim_products', COUNT(*) FROM dim_products
UNION ALL
SELECT 'fact_sales', COUNT(*) FROM fact_sales;

-- ============================================================
-- 6. (Optional) Check for remaining warnings
-- ============================================================
-- SHOW WARNINGS;


SELECT 
  (SELECT COUNT(*) FROM dim_customers WHERE create_date IS NULL) AS null_create_dates,
  (SELECT COUNT(*) FROM dim_products WHERE start_date IS NULL) AS null_start_dates,
  (SELECT COUNT(*) FROM fact_sales WHERE order_date IS NULL) AS null_order_dates;