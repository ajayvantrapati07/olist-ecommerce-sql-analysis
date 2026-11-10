-- Olist Brazilian E-Commerce: MySQL schema
-- Column names match the CSV headers exactly (including Olist's own
-- spelling "lenght"), so DBeaver's import wizard maps them automatically.

CREATE DATABASE IF NOT EXISTS olist;
USE olist;

-- 1. Customers (~99,441 rows)
CREATE TABLE customers (
    customer_id              VARCHAR(32) PRIMARY KEY,
    customer_unique_id       VARCHAR(32),
    customer_zip_code_prefix INT,
    customer_city            VARCHAR(100),
    customer_state           CHAR(2)
);

-- 2. Sellers (~3,095 rows)
CREATE TABLE sellers (
    seller_id              VARCHAR(32) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city            VARCHAR(100),
    seller_state           CHAR(2)
);

-- 3. Product category translation (71 rows)
CREATE TABLE product_category_name_translation (
    product_category_name         VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

-- 4. Products (~32,951 rows)
-- Some products have no category or measurements, so those columns allow NULL.
CREATE TABLE products (
    product_id                 VARCHAR(32) PRIMARY KEY,
    product_category_name      VARCHAR(100),
    product_name_lenght        INT,
    product_description_lenght INT,
    product_photos_qty         INT,
    product_weight_g           INT,
    product_length_cm          INT,
    product_height_cm          INT,
    product_width_cm           INT
);

-- 5. Orders (~99,441 rows)
-- Delivery dates are NULL for orders that were never delivered.
CREATE TABLE orders (
    order_id                      VARCHAR(32) PRIMARY KEY,
    customer_id                   VARCHAR(32),
    order_status                  VARCHAR(20),
    order_purchase_timestamp      DATETIME,
    order_approved_at             DATETIME,
    order_delivered_carrier_date  DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

-- 6. Order items (~112,650 rows): one row per product in an order
CREATE TABLE order_items (
    order_id            VARCHAR(32),
    order_item_id       INT,
    product_id          VARCHAR(32),
    seller_id           VARCHAR(32),
    shipping_limit_date DATETIME,
    price               DECIMAL(10,2),
    freight_value       DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

-- 7. Order payments (~103,886 rows): an order can be paid in several parts
CREATE TABLE order_payments (
    order_id             VARCHAR(32),
    payment_sequential   INT,
    payment_type         VARCHAR(20),
    payment_installments INT,
    payment_value        DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);

-- 8. Order reviews (~99,224 reviews; the file has multi-line comments, so ~104,719 lines)
-- No primary key: review_id is not strictly unique in the raw data.
CREATE TABLE order_reviews (
    review_id               VARCHAR(32),
    order_id                VARCHAR(32),
    review_score            INT,
    review_comment_title    VARCHAR(255),
    review_comment_message  TEXT,
    review_creation_date    DATETIME,
    review_answer_timestamp DATETIME
);

-- 9. Geolocation (~1,000,163 rows): many rows per zip code, so no primary key.
-- Load this one last; it is big and optional for most questions.
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat             DOUBLE,
    geolocation_lng             DOUBLE,
    geolocation_city            VARCHAR(100),
    geolocation_state           CHAR(2)
);

-- Speed up the joins you will use constantly
CREATE INDEX idx_orders_customer     ON orders (customer_id);
CREATE INDEX idx_items_product       ON order_items (product_id);
CREATE INDEX idx_items_seller        ON order_items (seller_id);
CREATE INDEX idx_reviews_order       ON order_reviews (order_id);
CREATE INDEX idx_products_category   ON products (product_category_name);
