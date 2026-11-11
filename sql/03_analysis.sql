-- Q1: Total product revenue
SELECT SUM(price) AS total_revenue
FROM olist.order_items;

-- Q2: Orders per month
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(*) AS total_orders
FROM olist.orders
GROUP BY order_month
ORDER BY order_month;

-- Q3: Top 10 product categories by revenue
SELECT
    COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
    ROUND(SUM(oi.price), 2) AS revenue
FROM olist.order_items oi
JOIN olist.products p ON oi.product_id = p.product_id
LEFT JOIN olist.product_category_name_translation t
       ON p.product_category_name = t.product_category_name
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;

-- Q4: Orders by customer state
SELECT
    c.customer_state,
    COUNT(*) AS total_orders
FROM olist.orders o
JOIN olist.customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC
LIMIT 5;

-- Q5: Average delivery time (delivered orders only)
SELECT
    ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 1) AS avg_delivery_days,
    COUNT(*) AS orders_counted
FROM olist.orders
WHERE order_delivered_customer_date IS NOT NULL;
