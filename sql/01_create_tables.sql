-- Raw data table
CREATE OR REPLACE TABLE superstore_dataset.sales_data AS
SELECT * FROM source;

-- Cleaned data
CREATE OR REPLACE TABLE superstore_dataset.sales_data_cleaned AS
SELECT * FROM superstore_dataset.sales_data;

-- Enriched data
CREATE OR REPLACE TABLE superstore_dataset.sales_data_enriched AS
SELECT *,
  EXTRACT(YEAR FROM order_date) AS year,
  DATE_DIFF(ship_date, order_date, DAY) AS delivery_days
FROM superstore_dataset.sales_data_cleaned;