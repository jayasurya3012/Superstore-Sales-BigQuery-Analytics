-- Monthly sales
CREATE OR REPLACE TABLE analytics.monthly_sales AS
SELECT 
  DATE_TRUNC(order_date, MONTH) AS month,
  SUM(sales) AS total_sales,
  SUM(profit) AS total_profit
FROM superstore_dataset.fact_sales
GROUP BY 1;

-- Sales trend with growth
WITH monthly_sales AS (
  SELECT 
    DATE_TRUNC(order_date, MONTH) AS month,
    SUM(sales) AS total_sales
  FROM superstore_dataset.fact_sales
  GROUP BY 1
)
SELECT 
  month,
  total_sales,
  LAG(total_sales) OVER (ORDER BY month) AS prev_month_sales,
  SAFE_DIVIDE(
    total_sales - LAG(total_sales) OVER (ORDER BY month),
    LAG(total_sales) OVER (ORDER BY month)
  ) AS growth_rate
FROM monthly_sales;

-- Dashboard table
CREATE OR REPLACE TABLE analytics.dashboard_data AS
SELECT 
  f.order_id,
  f.order_date,
  DATE_TRUNC(f.order_date, MONTH) AS month,
  f.sales,
  f.profit,
  f.quantity,
  c.segment,
  p.category,
  p.sub_category,
  l.region
FROM superstore_dataset.fact_sales f
JOIN superstore_dataset.dim_customer c ON f.customer_id = c.customer_id
JOIN superstore_dataset.dim_product p ON f.product_id = p.product_id
JOIN superstore_dataset.dim_location l ON f.location_id = l.location_id;