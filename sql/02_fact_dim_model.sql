-- Customer dimension
CREATE OR REPLACE TABLE superstore_dataset.dim_customer AS
SELECT 
  GENERATE_UUID() AS customer_id,
  customer_name,
  segment
FROM (
  SELECT DISTINCT customer_name, segment
  FROM superstore_dataset.sales_data_enriched
);

-- Product dimension
CREATE OR REPLACE TABLE superstore_dataset.dim_product AS
SELECT DISTINCT
  product_id,
  category,
  sub_category,
  product_name
FROM superstore_dataset.sales_data_enriched;

-- Location dimension
CREATE OR REPLACE TABLE superstore_dataset.dim_location AS
SELECT 
  FARM_FINGERPRINT(CONCAT(region, state, country, market)) AS location_id,
  region,
  state,
  country,
  market
FROM (
  SELECT DISTINCT region, state, country, market
  FROM superstore_dataset.sales_data_enriched
);

-- Fact table
CREATE OR REPLACE TABLE superstore_dataset.fact_sales
PARTITION BY order_date
CLUSTER BY product_id, customer_id
AS
SELECT 
  s.order_id,
  s.order_date,
  s.product_id,
  d.customer_id,
  FARM_FINGERPRINT(CONCAT(s.region, s.state, s.country, s.market)) AS location_id,
  s.sales,
  s.profit,
  s.quantity
FROM superstore_dataset.sales_data_enriched s
JOIN superstore_dataset.dim_customer d
  ON s.customer_name = d.customer_name;

  