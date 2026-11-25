-- =====================================================================
-- Ecommerce Sales Analysis  (works on MySQL 8+ and PostgreSQL)
-- Source file: data/cleaned_sales_data.csv  (created by scripts/data_cleaning.py)
-- =====================================================================

-- ---------- STEP 1: create the table ----------
DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
    order_id          VARCHAR(20),
    order_date        DATE,
    customer_id       VARCHAR(10),
    customer_name     VARCHAR(100),
    product_name      VARCHAR(100),
    category          VARCHAR(50),
    sub_category      VARCHAR(50),
    region            VARCHAR(20),
    sales             DECIMAL(12,2),
    quantity          INT,
    discount          DECIMAL(4,2),
    profit            DECIMAL(12,2),
    year              INT,
    month             VARCHAR(15),
    month_num         INT,
    profit_margin_pct DECIMAL(8,2)
);

-- ---------- STEP 2: import the CSV ----------
-- MySQL Workbench : right-click table "sales" > Table Data Import Wizard > pick cleaned_sales_data.csv
-- pgAdmin         : right-click table "sales" > Import/Export Data > pick the CSV, enable Header
-- PostgreSQL psql : \copy sales FROM 'data/cleaned_sales_data.csv' CSV HEADER

-- Quick check after import (expect 4643 rows)
SELECT COUNT(*) AS total_rows FROM sales;

-- ---------- STEP 3: analysis queries ----------

-- 1. Overall KPIs
SELECT
    ROUND(SUM(sales), 2)                            AS total_sales,
    ROUND(SUM(profit), 2)                           AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2)        AS profit_margin_pct,
    COUNT(DISTINCT order_id)                        AS total_orders,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM sales;

-- 2. Monthly sales trend
SELECT
    year,
    month_num,
    ROUND(SUM(sales), 2)  AS monthly_sales,
    ROUND(SUM(profit), 2) AS monthly_profit
FROM sales
GROUP BY year, month_num
ORDER BY year, month_num;

-- 3. Sales and profit by category
SELECT
    category,
    ROUND(SUM(sales), 2)  AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS margin_pct
FROM sales
GROUP BY category
ORDER BY total_sales DESC;

-- 4. Top 10 products by revenue
SELECT
    product_name,
    ROUND(SUM(sales), 2) AS total_sales,
    SUM(quantity)        AS units_sold
FROM sales
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- 5. Regional performance
SELECT
    region,
    ROUND(SUM(sales), 2)  AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT customer_id) AS customers
FROM sales
GROUP BY region
ORDER BY total_sales DESC;

-- 6. Top 10 customers by spend
SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales), 2)     AS total_spent
FROM sales
GROUP BY customer_id, customer_name
ORDER BY total_spent DESC
LIMIT 10;

-- 7. Year-over-year sales growth
WITH yearly AS (
    SELECT year, SUM(sales) AS total_sales
    FROM sales
    GROUP BY year
)
SELECT
    year,
    ROUND(total_sales, 2) AS total_sales,
    ROUND((total_sales - LAG(total_sales) OVER (ORDER BY year))
          / LAG(total_sales) OVER (ORDER BY year) * 100, 2) AS yoy_growth_pct
FROM yearly
ORDER BY year;

-- 8. Does discounting hurt profit?
SELECT
    CASE
        WHEN discount = 0   THEN '1. No discount'
        WHEN discount <= 0.2 THEN '2. Low (up to 20%)'
        ELSE '3. High (above 20%)'
    END AS discount_band,
    ROUND(SUM(sales), 2)  AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales
GROUP BY 1
ORDER BY 1;

-- 9. Most profitable sub-categories
SELECT
    sub_category,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales
GROUP BY sub_category
ORDER BY total_profit DESC;
