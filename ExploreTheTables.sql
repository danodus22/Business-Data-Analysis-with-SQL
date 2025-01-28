/*-------------------------------------------------------------------------------------------------------------
### EXPLORE THE TABLES ###
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------*/

-- Allgemein
SELECT COUNT(DISTINCT seller_id) FROM sellers;
SELECT COUNT(DISTINCT customer_id) FROM orders;
SELECT COUNT(DISTINCT customer_id) FROM customers;

/*---------------------------------------------------
1. How many orders are there in the dataset?
-----------------------------------------------------*/

-- 99.441
SELECT COUNT(order_id)
FROM orders;

/*---------------------------------------------------
2. Are orders actually delivered? 
-----------------------------------------------------*/
SELECT 
	order_status, 
    COUNT(*)
FROM
	orders
GROUP BY order_status;

/*---------------------------------------------------
3. Is Magist having user growth? 
-----------------------------------------------------*/

SELECT 
    YEAR(order_purchase_timestamp) AS Order_Year,
    MONTH(order_purchase_timestamp) AS Order_Month,
    COUNT(customer_id)
FROM
    orders
GROUP BY Order_Year, Order_Month
ORDER BY Order_Year, Order_Month;

/* SELECT
DATE_FORMAT(order_purchase_timestamp,'%Y-%m') AS Order_YEAR_MONTH,
COUNT(customer_id)
FROM orders
GROUP BY 1
ORDER BY 1; */

/*---------------------------------------------------
4. How many products are there in the products table?
	(Make sure that there are no duplicate products.)
-----------------------------------------------------*/
-- 32.951
SELECT COUNT(DISTINCT(product_id))
FROM products;

/*---------------------------------------------------
5. Which are the categories with most products?
-----------------------------------------------------*/

SELECT 
    pcn.product_category_name_english AS Category, 
    COUNT(DISTINCT(p.product_id)) AS NumberofProducts
FROM
    products AS p
INNER JOIN product_category_name_translation AS pcn
ON p.product_category_name = pcn.product_category_name
GROUP BY Category
ORDER BY NumberofProducts DESC;

/*-------------------------------------------------------------------
 6. How many of those products were present in actual transactions?
---------------------------------------------------------------------*/

-- 98.666
SELECT COUNT(DISTINCT(order_id)) AS NumberOfProducts
FROM order_items;

/*------------------------------------------------------------------
7. What’s the price for the most expensive and cheapest products?
--------------------------------------------------------------------*/

-- MIN: 0,85 €
-- MAX: 6.735 €
SELECT 
    MIN(price) AS "Cheapest Product", 
    MAX(price) AS "Most Expensive Product"
FROM 
	order_items;
    
/*---------------------------------------------------
8. What are the highest and lowest payment values?
	What’s the highest someone has paid for an order?
-----------------------------------------------------*/

SELECT 
	MAX(payment_value) AS HighestPayment,
    MIN(payment_value) AS LowestPayment
FROM
	order_payments
    WHERE payment_value <> 0;
    
-- Maximum someone has paid for an order:
SELECT
    SUM(payment_value) AS HighestOrder
FROM
    order_payments
GROUP BY order_id
ORDER BY HighestOrder DESC
LIMIT 1;