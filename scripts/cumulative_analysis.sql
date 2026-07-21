/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()

Note on moving_average_price:
    - moving_avg_price_unweighted = cumulative average of each YEAR's average price
      (each year counts equally, regardless of order volume). Answers: "how has
      list/pricing strategy trended over time?"
    - moving_avg_price_volume_weighted = cumulative total revenue / cumulative total
      quantity (each transaction counts equally). Answers: "what price did customers
      actually pay on average, across all units sold?"
    - These diverge meaningfully here because yearly order volume is highly skewed
      (14 orders in 2010 vs. 52,782 in 2013), so pick the one that matches the
      question being asked rather than assuming they're interchangeable.
===============================================================================
*/

-- Calculate the total sales per year 
-- and the running total of sales over time 
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
    AVG(avg_price) OVER (ORDER BY order_date) AS moving_avg_price_unweighted,
    SUM(total_revenue_for_price) OVER (ORDER BY order_date) 
        / SUM(total_quantity) OVER (ORDER BY order_date) AS moving_avg_price_volume_weighted
FROM
(
    SELECT 
        DATE_FORMAT(order_date, '%Y-01-01') AS order_date,  -- first day of year
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price,
        SUM(price * quantity) AS total_revenue_for_price,
        SUM(quantity) AS total_quantity
    FROM fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date, '%Y-01-01')
) t
ORDER BY order_date;