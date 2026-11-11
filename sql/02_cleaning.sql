-- Blank product categories were loaded as empty text; convert to NULL
UPDATE olist.products
SET product_category_name = NULL
WHERE product_category_name = '';
