/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM fact_sales;

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM fact_sales;

-- Find the average selling price
SELECT AVG(price) AS avg_price FROM fact_sales;

-- Find the Total number of Orders
SELECT COUNT(order_number) AS total_orders FROM fact_sales;
SELECT COUNT(DISTINCT order_number) AS total_orders FROM fact_sales;

-- Find the total number of products
SELECT COUNT(product_name) AS total_products FROM dim_products;

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM dim_customers;

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM fact_sales;

-- Generate a Report that shows all key metrics of the business (rounded to whole numbers)
SELECT 'Total Sales' AS measure_name, ROUND(SUM(sales_amount), 0) AS measure_value FROM fact_sales
UNION ALL
SELECT 'Total Quantity', ROUND(SUM(quantity), 0) FROM fact_sales
UNION ALL
SELECT 'Average Price', ROUND(AVG(price), 0) FROM fact_sales
UNION ALL
SELECT 'Total Orders', ROUND(COUNT(DISTINCT order_number), 0) FROM fact_sales
UNION ALL
SELECT 'Total Products', ROUND(COUNT(DISTINCT product_name), 0) FROM dim_products
UNION ALL
SELECT 'Total Customers', ROUND(COUNT(customer_key), 0) FROM dim_customers;