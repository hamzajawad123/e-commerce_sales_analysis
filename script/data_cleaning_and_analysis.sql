-- We have data from Sep 2016 to Oct 2018

-- =====================================================
-- Step 1: Create and Use database
-- =====================================================

create database ecommerce_db;
USE ecommerce_db;

-- =====================================================
-- Step 2: Create Tables
-- =====================================================

CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(10,8),
    geolocation_lng DECIMAL(11,8),
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
);

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY(order_id, order_item_id)
);

CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);

CREATE TABLE order_reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

CREATE TABLE product_category_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

-- =====================================================
-- Step 3: Import Data (LOAD DATA LOCAL INFILE)
-- =====================================================

LOAD DATA LOCAL INFILE 'F:/coursera_courses/Google_Data_Analytics/case_studies/case_study_3/case_study_3_datasets/raw_datasets/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'F:/coursera_courses/Google_Data_Analytics/case_study_3/case_study_3_datasets/raw_datasets/olist_geolocation_dataset.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'F:/coursera_courses/Google_Data_Analytics/case_study_3/case_study_3_datasets/raw_datasets/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'F:/coursera_courses/Google_Data_Analytics/case_study_3/case_study_3_datasets/raw_datasets/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'F:/coursera_courses/Google_Data_Analytics/case_study_3/case_study_3_datasets/raw_datasets/olist_order_payments_dataset.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'F:/coursera_courses/Google_Data_Analytics/case_study_3/case_study_3_datasets/raw_datasets/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'F:/coursera_courses/Google_Data_Analytics/case_study_3/case_study_3_datasets/raw_datasets/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'F:/coursera_courses/Google_Data_Analytics/case_study_3/case_study_3_datasets/raw_datasets/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'F:/coursera_courses/Google_Data_Analytics/case_study_3/case_study_3_datasets/raw_datasets/product_category_name_translation.csv'
INTO TABLE product_category_translation
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- =====================================================
-- Step 4: Add Foreign Key Constraints
-- =====================================================

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_items_orders FOREIGN KEY (order_id) REFERENCES orders(order_id),
ADD CONSTRAINT fk_items_products FOREIGN KEY (product_id) REFERENCES products(product_id),
ADD CONSTRAINT fk_items_sellers FOREIGN KEY (seller_id) REFERENCES sellers(seller_id);

ALTER TABLE order_payments
ADD CONSTRAINT fk_payments_orders FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE order_reviews
ADD CONSTRAINT fk_reviews_orders FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE products
ADD CONSTRAINT fk_products_category FOREIGN KEY (product_category_name) REFERENCES product_category_translation(product_category_name);

-- =====================================================
-- Data Anallysis Process
-- =====================================================

-- =====================================================
-- Step 1: Creating backups of tables
-- =====================================================

create table backup_customers as select * from customers;
create table backup_geolocation as select * from geolocation;
create table backup_order_items as select * from order_items;
create table backup_order_payments as select * from order_payments;
create table backup_order_reviews as select * from order_reviews;
create table backup_orders as select * from orders;
create table backup_product_cateogry_translation as select * from product_category_translation;
create table backup_products as select * from products;
create table backup_sellers as select * from sellers;

-- =====================================================
-- Step 2: Inspecting the datasets
-- =====================================================

-- Checking number of rows in each dataset

select count(*) as total_rows, 'cutomers'  as category from customers
union all
select count(*), 'geolocation' from geolocation
union all
select count(*), 'orders' from orders
union all
select count(*), 'order_items' from order_items
union all
select count(*), 'order_payments' from order_payments
union all
select count(*), 'order_reviews' from order_reviews
union all
select count(*), 'products' from products
union all
select count(*), 'product_category_translation' from product_category_translation
union all
select count(*), 'sellers' from sellers;

-- Taking overview of each dataset

select * from customers limit 5;
select * from geolocation limit 5;
select * from orders limit 5;
select * from order_reviews limit 5;
select * from order_payments limit 5;
select * from order_items limit 5;
select * from products limit 5;
select * from product_category_translation limit 5;
select * from sellers limit 5;

-- Checking Starting and Ending Date of orders dataset (main dataset)

select min(order_purchase_timestamp) as starting_date, max(order_purchase_timestamp) as ending_date from orders;

-- This query generator generates a list of queries to check nulls in each column of each tables in dataset

SELECT
  CONCAT(
    'SELECT \'',
    TABLE_NAME,
    '.',
    COLUMN_NAME,
    '\' AS ColumnCheck, COUNT(*) AS NullCount FROM ',
    TABLE_SCHEMA,
    '.',
    TABLE_NAME,
    ' WHERE ',
    COLUMN_NAME,
    ' IS NULL HAVING COUNT(*) > 0;'
  ) AS NullCheckQuery
FROM
  INFORMATION_SCHEMA.COLUMNS
WHERE
  TABLE_SCHEMA = 'ecommerce_db';

-- These are the queries generated from the above query generator to check any null value in each column of each table

SELECT 'customers.customer_city' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.customers WHERE customer_city IS NULL HAVING COUNT(*) > 0;
SELECT 'customers.customer_id' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.customers WHERE customer_id IS NULL HAVING COUNT(*) > 0;
SELECT 'customers.customer_state' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.customers WHERE customer_state IS NULL HAVING COUNT(*) > 0;
SELECT 'customers.customer_unique_id' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.customers WHERE customer_unique_id IS NULL HAVING COUNT(*) > 0;
SELECT 'customers.customer_zip_code_prefix' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.customers WHERE customer_zip_code_prefix IS NULL HAVING COUNT(*) > 0;
SELECT 'geolocation.geolocation_city' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.geolocation WHERE geolocation_city IS NULL HAVING COUNT(*) > 0;
SELECT 'geolocation.geolocation_lat' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.geolocation WHERE geolocation_lat IS NULL HAVING COUNT(*) > 0;
SELECT 'geolocation.geolocation_lng' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.geolocation WHERE geolocation_lng IS NULL HAVING COUNT(*) > 0;
SELECT 'geolocation.geolocation_state' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.geolocation WHERE geolocation_state IS NULL HAVING COUNT(*) > 0;
SELECT 'geolocation.geolocation_zip_code_prefix' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.geolocation WHERE geolocation_zip_code_prefix IS NULL HAVING COUNT(*) > 0;
SELECT 'order_items.freight_value' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_items WHERE freight_value IS NULL HAVING COUNT(*) > 0;
SELECT 'order_items.order_id' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_items WHERE order_id IS NULL HAVING COUNT(*) > 0;
SELECT 'order_items.order_item_id' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_items WHERE order_item_id IS NULL HAVING COUNT(*) > 0;
SELECT 'order_items.price' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_items WHERE price IS NULL HAVING COUNT(*) > 0;
SELECT 'order_items.product_id' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_items WHERE product_id IS NULL HAVING COUNT(*) > 0;
SELECT 'order_items.seller_id' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_items WHERE seller_id IS NULL HAVING COUNT(*) > 0;
SELECT 'order_items.shipping_limit_date' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_items WHERE shipping_limit_date IS NULL HAVING COUNT(*) > 0;
SELECT 'order_payments.order_id' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_payments WHERE order_id IS NULL HAVING COUNT(*) > 0;
SELECT 'order_payments.payment_installments' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_payments WHERE payment_installments IS NULL HAVING COUNT(*) > 0;
SELECT 'order_payments.payment_sequential' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_payments WHERE payment_sequential IS NULL HAVING COUNT(*) > 0;
SELECT 'order_payments.payment_type' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_payments WHERE payment_type IS NULL HAVING COUNT(*) > 0;
SELECT 'order_payments.payment_value' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_payments WHERE payment_value IS NULL HAVING COUNT(*) > 0;
SELECT 'order_reviews.order_id' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_reviews WHERE order_id IS NULL HAVING COUNT(*) > 0;
SELECT 'order_reviews.review_answer_timestamp' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_reviews WHERE review_answer_timestamp IS NULL HAVING COUNT(*) > 0;
SELECT 'order_reviews.review_comment_message' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_reviews WHERE review_comment_message IS NULL HAVING COUNT(*) > 0;
SELECT 'order_reviews.review_comment_title' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_reviews WHERE review_comment_title IS NULL HAVING COUNT(*) > 0;
SELECT 'order_reviews.review_creation_date' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_reviews WHERE review_creation_date IS NULL HAVING COUNT(*) > 0;
SELECT 'order_reviews.review_id' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_reviews WHERE review_id IS NULL HAVING COUNT(*) > 0;
SELECT 'order_reviews.review_score' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.order_reviews WHERE review_score IS NULL HAVING COUNT(*) > 0;
SELECT 'orders.customer_id' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.orders WHERE customer_id IS NULL HAVING COUNT(*) > 0;
SELECT 'orders.order_approved_at' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.orders WHERE order_approved_at IS NULL HAVING COUNT(*) > 0;
SELECT 'orders.order_delivered_carrier_date' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.orders WHERE order_delivered_carrier_date IS NULL HAVING COUNT(*) > 0;
SELECT 'orders.order_delivered_customer_date' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.orders WHERE order_delivered_customer_date IS NULL HAVING COUNT(*) > 0;
SELECT 'orders.order_estimated_delivery_date' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.orders WHERE order_estimated_delivery_date IS NULL HAVING COUNT(*) > 0;
SELECT 'orders.order_id' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.orders WHERE order_id IS NULL HAVING COUNT(*) > 0;
SELECT 'orders.order_purchase_timestamp' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.orders WHERE order_purchase_timestamp IS NULL HAVING COUNT(*) > 0;
SELECT 'orders.order_status' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.orders WHERE order_status IS NULL HAVING COUNT(*) > 0;
SELECT 'product_category_translation.product_category_name' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.product_category_translation WHERE product_category_name IS NULL HAVING COUNT(*) > 0;
SELECT 'product_category_translation.product_category_name_english' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.product_category_translation WHERE product_category_name_english IS NULL HAVING COUNT(*) > 0;
SELECT 'products.product_category_name' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.products WHERE product_category_name IS NULL HAVING COUNT(*) > 0;
SELECT 'products.product_description_lenght' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.products WHERE product_description_lenght IS NULL HAVING COUNT(*) > 0;
SELECT 'products.product_height_cm' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.products WHERE product_height_cm IS NULL HAVING COUNT(*) > 0;
SELECT 'products.product_id' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.products WHERE product_id IS NULL HAVING COUNT(*) > 0;
SELECT 'products.product_length_cm' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.products WHERE product_length_cm IS NULL HAVING COUNT(*) > 0;
SELECT 'products.product_name_lenght' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.products WHERE product_name_lenght IS NULL HAVING COUNT(*) > 0;
SELECT 'products.product_photos_qty' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.products WHERE product_photos_qty IS NULL HAVING COUNT(*) > 0;
SELECT 'products.product_weight_g' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.products WHERE product_weight_g IS NULL HAVING COUNT(*) > 0;
SELECT 'products.product_width_cm' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.products WHERE product_width_cm IS NULL HAVING COUNT(*) > 0;
SELECT 'sellers.seller_city' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.sellers WHERE seller_city IS NULL HAVING COUNT(*) > 0;
SELECT 'sellers.seller_id' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.sellers WHERE seller_id IS NULL HAVING COUNT(*) > 0;
SELECT 'sellers.seller_state' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.sellers WHERE seller_state IS NULL HAVING COUNT(*) > 0;
SELECT 'sellers.seller_zip_code_prefix' AS ColumnCheck, COUNT(*) AS NullCount FROM ecommerce_db.sellers WHERE seller_zip_code_prefix IS NULL HAVING COUNT(*) > 0;

-- This query generator generates a list of queries to check duplicates in each column of each table in dataset

SELECT 
    CONCAT(
        'SELECT ''', TABLE_NAME, ''' AS TableCheck, ',
        'COUNT(*) - COUNT(DISTINCT CONCAT_WS(''|'', ',
        GROUP_CONCAT(COLUMN_NAME ORDER BY ORDINAL_POSITION SEPARATOR ', '),
        ')) AS total_duplicates ',
        'FROM ', TABLE_SCHEMA, '.', TABLE_NAME, ';'
    ) AS DuplicateCheckQuery
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'ecommerce_db'
GROUP BY TABLE_SCHEMA, TABLE_NAME;

-- These are the queries generated from the above query generator to check any duplicate row in each column of each table

SELECT 'customers' AS TableCheck, COUNT(*) - COUNT(DISTINCT CONCAT_WS('|', customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)) AS total_duplicates FROM ecommerce_db.customers;
SELECT 'geolocation' AS TableCheck, COUNT(*) - COUNT(DISTINCT CONCAT_WS('|', geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state)) AS total_duplicates FROM ecommerce_db.geolocation;
SELECT 'order_items' AS TableCheck, COUNT(*) - COUNT(DISTINCT CONCAT_WS('|', order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value)) AS total_duplicates FROM ecommerce_db.order_items;
SELECT 'order_payments' AS TableCheck, COUNT(*) - COUNT(DISTINCT CONCAT_WS('|', order_id, payment_sequential, payment_type, payment_installments, payment_value)) AS total_duplicates FROM ecommerce_db.order_payments;
SELECT 'order_reviews' AS TableCheck, COUNT(*) - COUNT(DISTINCT CONCAT_WS('|', review_id, order_id, review_score, review_comment_title, review_comment_message, review_creation_date, review_answer_timestamp)) AS total_duplicates FROM ecommerce_db.order_reviews;
SELECT 'orders' AS TableCheck, COUNT(*) - COUNT(DISTINCT CONCAT_WS('|', order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date)) AS total_duplicates FROM ecommerce_db.orders;
SELECT 'product_category_translation' AS TableCheck, COUNT(*) - COUNT(DISTINCT CONCAT_WS('|', product_category_name, product_category_name_english)) AS total_duplicates FROM ecommerce_db.product_category_translation;
SELECT 'products' AS TableCheck, COUNT(*) - COUNT(DISTINCT CONCAT_WS('|', product_id, product_category_name, product_name_lenght, product_description_lenght, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm)) AS total_duplicates FROM ecommerce_db.products;
SELECT 'sellers' AS TableCheck, COUNT(*) - COUNT(DISTINCT CONCAT_WS('|', seller_id, seller_zip_code_prefix, seller_city, seller_state)) AS total_duplicates FROM ecommerce_db.sellers;

-- =====================================================
-- Step 3: Cleaning the datasets
-- =====================================================

-- =====================================================
-- 3.1 Remove Duplicate Rows
-- =====================================================
-- We will deduplicate each table based on all columns.
-- Strategy: copy distinct rows into a temp table, then replace original.

-- Customers
CREATE TABLE tmp_customers AS
SELECT DISTINCT * FROM customers;
TRUNCATE TABLE customers;
INSERT INTO customers SELECT * FROM tmp_customers;
DROP TABLE tmp_customers;

-- Geolocation
CREATE TABLE tmp_geolocation AS
SELECT DISTINCT * FROM geolocation;
TRUNCATE TABLE geolocation;
INSERT INTO geolocation SELECT * FROM tmp_geolocation;
DROP TABLE tmp_geolocation;

-- Orders
CREATE TABLE tmp_orders AS
SELECT DISTINCT * FROM orders;
TRUNCATE TABLE orders;
INSERT INTO orders SELECT * FROM tmp_orders;
DROP TABLE tmp_orders;

-- Order Items
CREATE TABLE tmp_order_items AS
SELECT DISTINCT * FROM order_items;
TRUNCATE TABLE order_items;
INSERT INTO order_items SELECT * FROM tmp_order_items;
DROP TABLE tmp_order_items;

-- Order Payments
CREATE TABLE tmp_order_payments AS
SELECT DISTINCT * FROM order_payments;
TRUNCATE TABLE order_payments;
INSERT INTO order_payments SELECT * FROM tmp_order_payments;
DROP TABLE tmp_order_payments;

-- Order Reviews
CREATE TABLE tmp_order_reviews AS
SELECT DISTINCT * FROM order_reviews;
TRUNCATE TABLE order_reviews;
INSERT INTO order_reviews SELECT * FROM tmp_order_reviews;
DROP TABLE tmp_order_reviews;

-- Products
CREATE TABLE tmp_products AS
SELECT DISTINCT * FROM products;
TRUNCATE TABLE products;
INSERT INTO products SELECT * FROM tmp_products;
DROP TABLE tmp_products;

-- Sellers
CREATE TABLE tmp_sellers AS
SELECT DISTINCT * FROM sellers;
TRUNCATE TABLE sellers;
INSERT INTO sellers SELECT * FROM tmp_sellers;
DROP TABLE tmp_sellers;

-- Product Category Translation
CREATE TABLE tmp_pct AS
SELECT DISTINCT * FROM product_category_translation;
TRUNCATE TABLE product_category_translation;
INSERT INTO product_category_translation SELECT * FROM tmp_pct;
DROP TABLE tmp_pct;

-- =====================================================
-- 3.2 Handle NULL values
-- =====================================================
-- Categorical columns → replace NULL with 'unknown'
-- Date/Number columns → leave as NULL (useful for analysis)

-- Customers
UPDATE customers
SET customer_city = 'unknown'
WHERE customer_city IS NULL;

UPDATE customers
SET customer_state = 'unknown'
WHERE customer_state IS NULL;

-- Orders
UPDATE orders
SET order_status = 'unknown'
WHERE order_status IS NULL;

-- Products
UPDATE products
SET product_category_name = 'unknown'
WHERE product_category_name IS NULL;

-- Sellers
UPDATE sellers
SET seller_city = 'unknown'
WHERE seller_city IS NULL;

UPDATE sellers
SET seller_state = 'unknown'
WHERE seller_state IS NULL;

-- Order Payments
UPDATE order_payments
SET payment_type = 'unknown'
WHERE payment_type IS NULL;

-- Product Category Translation
UPDATE product_category_translation
SET product_category_name_english = 'unknown'
WHERE product_category_name_english IS NULL;

-- =====================================================
-- 3.3 Fix Numeric Anomalies
-- =====================================================
-- Replace impossible product dimensions with NULL (then can impute or ignore).
UPDATE products
SET product_weight_g = NULL
WHERE product_weight_g <= 0;

UPDATE products
SET product_length_cm = NULL
WHERE product_length_cm <= 0;

UPDATE products
SET product_height_cm = NULL
WHERE product_height_cm <= 0;

UPDATE products
SET product_width_cm = NULL
WHERE product_width_cm <= 0;

-- =====================================================
-- 3.4 Standardize Text Columns
-- =====================================================
-- Cities, states, product categories often have inconsistent casing.
-- We will lowercase them for consistency.

UPDATE customers
SET customer_city = LOWER(customer_city);

UPDATE customers
SET customer_state = UPPER(customer_state);

UPDATE geolocation
SET geolocation_city = LOWER(geolocation_city);

UPDATE geolocation
SET geolocation_state = UPPER(geolocation_state);

UPDATE sellers
SET seller_city = LOWER(seller_city);

UPDATE sellers
SET seller_state = UPPER(seller_state);

UPDATE products
SET product_category_name = LOWER(product_category_name);

UPDATE product_category_translation
SET product_category_name = LOWER(product_category_name),
    product_category_name_english = LOWER(product_category_name_english);

-- =====================================================
-- 3.5 Date Consistency Checks
-- =====================================================
-- Ensure delivered date is after purchase date
UPDATE orders
SET order_delivered_customer_date = NULL
WHERE order_delivered_customer_date < order_purchase_timestamp;

-- Ensure approved_at is not before purchase date
UPDATE orders
SET order_approved_at = NULL
WHERE order_approved_at < order_purchase_timestamp;

-- =====================================================
-- 3.6 Remove Orphan Records (Integrity Cleaning)
-- =====================================================
-- Remove order_items with no matching order
DELETE oi
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Remove order_payments with no matching order
DELETE op
FROM order_payments op
LEFT JOIN orders o ON op.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Remove order_reviews with no matching order
DELETE orv
FROM order_reviews orv
LEFT JOIN orders o ON orv.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Remove orders with no matching customer
DELETE o
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- =====================================================
--  Analysis of the data
-- =====================================================

-- Q1: Do late deliveries reduce review scores?

SELECT 
    CASE 
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date 
            THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,
    ROUND(AVG(r.review_score),2) AS avg_review_score,
    COUNT(*) AS total_orders
FROM orders o
JOIN order_reviews r ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY delivery_status;


-- Q2: Do late deliveries reduce revenue?

SELECT 
    CASE 
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date 
            THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,
    ROUND(SUM(oi.price + oi.freight_value),2) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY delivery_status;


-- Q3: Do product types affect customer satisfaction?

SELECT 
    pct.product_category_name_english AS category,
    ROUND(AVG(r.review_score),2) AS avg_review_score,
    COUNT(*) AS total_reviews
FROM order_reviews r
JOIN orders o ON r.order_id = o.order_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_translation pct ON p.product_category_name = pct.product_category_name
GROUP BY pct.product_category_name_english
HAVING total_reviews > 100 -- ignore very rare categories
ORDER BY avg_review_score ASC
LIMIT 10;


-- Q4: Which products bring the most money?

SELECT 
    pct.product_category_name_english AS category,
    ROUND(SUM(oi.price + oi.freight_value),2) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_translation pct ON p.product_category_name = pct.product_category_name
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY pct.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;

-- Q5: Who are the top sellers by revenue?

SELECT 
    s.seller_id,
    s.seller_city,
    s.seller_state,
    ROUND(SUM(oi.price + oi.freight_value),2) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_id, s.seller_city, s.seller_state
ORDER BY total_revenue DESC
LIMIT 10;

-- Q6: What’s the trend of orders over time (monthly)?
SELECT 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price + oi.freight_value),2) AS total_revenue
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY month;


-- Q7: Which states have the most customers?
SELECT 
    customer_state,
    COUNT(DISTINCT customer_id) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC
LIMIT 10;

-- Q8: Which states bring the most revenue?
SELECT 
    c.customer_state,
    ROUND(SUM(oi.price + oi.freight_value),2) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 10;


