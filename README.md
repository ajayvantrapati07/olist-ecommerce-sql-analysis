# Olist E-Commerce SQL Analysis

SQL analysis of ~100,000 orders from Olist, a Brazilian online marketplace
(2016-2018), using MySQL 8 and DBeaver.

## Business questions
1. How much revenue did the marketplace generate?
2. How did order volume change over time?
3. Which product categories earn the most?

## Dataset
Brazilian E-Commerce Public Dataset by Olist (Kaggle):
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

Nine tables: customers, orders, order items, payments, reviews, products,
sellers, geolocation and category translations.

## Key findings
- Total product revenue: R$13.6M across ~112,650 items sold.
- Order volume peaked in November 2017 (7,544 orders), likely Black Friday.
- Top categories by revenue: health_beauty (R$1.26M), watches_gifts
  (R$1.21M), bed_bath_table (R$1.04M).

## Data cleaning
- Removed line breaks, quote characters and backslashes from review text so
  it would load.
- Converted blank product categories to NULL.
- Left missing delivery dates as NULL (orders never delivered).
- Used LEFT JOIN for category names so products with no category are kept.

## Files
- sql/01_schema.sql: table definitions
- sql/02_cleaning.sql: cleaning steps
- sql/03_analysis.sql: analysis queries
