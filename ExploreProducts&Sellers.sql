/*-------------------------------------------------------------------------------------------------------------
### ANSWER BUSINESS QUESTIONS   ###
### In relation to the products ###
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------*/

/* ---------------------------------------------------
1. What categories of tech products does Magist have?
-----------------------------------------------------*/

-- 74 categories
SELECT count(product_category_name_english)
FROM product_category_name_translation;

-- List all categories
SELECT product_category_name_english
FROM product_category_name_translation
ORDER BY product_category_name_english;

-- 16 Tech categories
SELECT product_category_name_english
FROM product_category_name_translation
WHERE product_category_name_english IN
('air_conditioning',
'audio',
'auto',
'computers',
'computers_accessories',
'consoles_games',
'electronics',
'fixed_telephony',
'home_appliances',
'home_appliances_2',
'pc_gamer',
'security_and_services',
'signaling_and_security',
'small_appliances',
'small_appliances_home_oven_and_coffee',
'telephony')
ORDER BY product_category_name_english;

/*--------------------------------------------------------------------------------------------------------------
How many products of these tech categories have been sold (within the time window of the database snapshot)?
What percentage does that represent from the overall number of products sold?
---------------------------------------------------------------------------------------------------------------*/

-- 32.951 products have been sold
SELECT COUNT(DISTINCT product_id)
FROM order_items;

-- 6.655 tech products have been sold
SELECT COUNT(DISTINCT oi.product_id) AS tech_products_sold
FROM order_items oi
INNER JOIN products p
ON oi.product_id = p.product_id 
INNER JOIN product_category_name_translation pcnt
ON pcnt.product_category_name = p.product_category_name
WHERE product_category_name_english IN
('air_conditioning',
'audio',
'auto',
'computers',
'computers_accessories',
'consoles_games',
'electronics',
'fixed_telephony',
'home_appliances',
'home_appliances_2',
'pc_gamer',
'security_and_services',
'signaling_and_security',
'small_appliances',
'small_appliances_home_oven_and_coffee',
'telephony');

/* Percentage of overall number of products sold */
-- 6.655 tech products have been sold
-- 32.951 products have been sold
-- 20.1967% ~ 20,2% are tech products
SELECT (6655/32951)*100;

/*--------------------------------------------------------------------------------------------------------------
What’s the average price of the products being sold?
---------------------------------------------------------------------------------------------------------------*/

-- 120.65
SELECT ROUND(AVG(price), 2) AS AveragePrice
FROM order_items;

-- List of all Products with (Amount Price / Number of Products = Average Price)
SELECT product_id, SUM(price) AS AmountPrice, COUNT(product_id) AS NumberofProducts, AVG(price) AS AveragePrice
FROM order_items
GROUP BY product_id
ORDER BY AmountPrice DESC;

/*--------------------------------------------------------------------------------------------------------------
Are expensive tech products popular? *
* Look at the function CASE WHEN to accomplish this task.
---------------------------------------------------------------------------------------------------------------*/

SELECT COUNT(oi.product_id), 
CASE 
WHEN price > 1000 THEN "Expensive"
WHEN price > 100 THEN "Mid-range"
ELSE "Cheap"
END AS "price_range"
FROM order_items oi
LEFT JOIN products p
ON p.product_id = oi.product_id
LEFT JOIN product_category_name_translation pt
USING (product_category_name)
WHERE pt.product_category_name_english IN
('air_conditioning',
'audio',
'auto',
'computers',
'computers_accessories',
'consoles_games',
'electronics',
'fixed_telephony',
'home_appliances',
'home_appliances_2',
'pc_gamer',
'security_and_services',
'signaling_and_security',
'small_appliances',
'small_appliances_home_oven_and_coffee',
'telephony')
GROUP BY price_range
ORDER BY 1 DESC;

-- 15831 Cheap
-- 7433	 Mid-range
-- 349	 Expensive

/*-------------------------------------------------------------------------------------------------------------
### ANSWER BUSINESS QUESTIONS ###
### In relation to the seller ###
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------*/

/*--------------------------------------------------------------------------------------------------------------
How many months of data are included in the magist database?
???
---------------------------------------------------------------------------------------------------------------*/

-- 25 Month of data are in the database
SELECT
	TIMESTAMPDIFF(MONTH,
	MIN(order_purchase_timestamp),
	MAX(order_purchase_timestamp))
FROM
	orders;

/*----------------------------------------------------------------------------------------------------------------
How many sellers are there?
How many Tech sellers are there?
What percentage of overall sellers are Tech sellers?
-----------------------------------------------------------------------------------------------------------------*/

-- 3.095 sellers are in the database
SELECT COUNT(DISTINCT seller_id) FROM sellers;

-- 929 Tech sellers are in the database
SELECT COUNT(DISTINCT oi.seller_id)
FROM sellers s
INNER JOIN order_items oi
ON s.seller_id = oi.seller_id
INNER JOIN products p
ON oi.product_id = p.product_id 
INNER JOIN product_category_name_translation pcnt
ON pcnt.product_category_name = p.product_category_name
WHERE product_category_name_english IN
('air_conditioning',
'audio',
'auto',
'computers',
'computers_accessories',
'consoles_games',
'electronics',
'fixed_telephony',
'home_appliances',
'home_appliances_2',
'pc_gamer',
'security_and_services',
'signaling_and_security',
'small_appliances',
'small_appliances_home_oven_and_coffee',
'telephony');

-- 3.095 sellers are in the database
-- 929 Tech sellers are in the database
-- 30.0162 % of Sellers are Tech sellers
SELECT ROUND(929/3095, 2)*100;

/*--------------------------------------------------------------------------------------------------------------
What is the total amount earned by all sellers?
What is the total amount earned by all Tech sellers?
---------------------------------------------------------------------------------------------------------------*/

-- Total amount earned by all sellers: 13.494.400,741870522€
SELECT SUM(oi.price) AS Total_Amount
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_status NOT IN ('unavailable' , 'canceled');

-- Total amount earned by all Tech sellers: 2.960.539,716867447 €
SELECT SUM(oi.price) AS Total_Amount
FROM order_items oi
INNER JOIN orders o
ON oi.order_id = o.order_id
INNER JOIN products p
ON oi.product_id = p.product_id 
INNER JOIN product_category_name_translation pcnt
ON pcnt.product_category_name = p.product_category_name
WHERE o.order_status NOT IN ('unavailable' , 'canceled') AND product_category_name_english IN
('air_conditioning',
'audio',
'auto',
'computers',
'computers_accessories',
'consoles_games',
'electronics',
'fixed_telephony',
'home_appliances',
'home_appliances_2',
'pc_gamer',
'security_and_services',
'signaling_and_security',
'small_appliances',
'small_appliances_home_oven_and_coffee',
'telephony');

-- Total amount earned by all sellers: 13.494.400,741870522€
-- Total amount earned by all Tech sellers: 2.960.539,716867447 €
-- 21.94 % 
SELECT Round(2960539.716867447/13494400.741870522*100, 2) AS "Percentage of Tech Sellers";

/*------------------------------------------------------------------------------------------------------------------------
Can you work out the average monthly income of all sellers?
Can you work out the average monthly income of Tech sellers?
--------------------------------------------------------------------------------------------------------------------------*/

-- Average monthly income of all sellers: 174,40 €
SELECT ROUND(13494400.74 / 3095 / 25, 2);

-- Average monthly income of Tech sellers: 127,47 €
SELECT ROUND(2960539.716867447 / 929 / 25, 2);

/*-------------------------------------------------------------------------------------------------------------
### ANSWER BUSINESS QUESTIONS		 ###
### In relation to the delivery time ###
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------------------------------------------------
What’s the average time between the order being placed and the product being delivered?
--------------------------------------------------------------------------------------------------------------------------*/

-- 12.0960 ~ 12 Days 
SELECT 
    AVG(TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date)) AS AVG_Delivery_Time_Days
FROM orders;

-- 12.5035 ~ 12,5 Days
SELECT 
    AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS AVG_Delivery_Time_Days
FROM orders;

/*------------------------------------------------------------------------------------------------------------------------
How many orders are delivered on time vs orders delivered with a delay?
--------------------------------------------------------------------------------------------------------------------------*/

SELECT 
   COUNT(order_id) AS Total_Orders,  
-- On Time    
    SUM(CASE 
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1 
        ELSE 0 
    END) AS On_Time,
-- Percentage of On Time   
    (SUM(CASE 
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1 
        ELSE 0 
    END) / COUNT(*)) * 100 AS On_Time_Percentage,
-- Delayed    
    SUM(CASE 
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 
        ELSE 0 
    END) AS Delayed_,
-- Percentage of Delayed    
    (SUM(CASE 
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 
        ELSE 0 
    END) / COUNT(*)) * 100 AS delayed_percentage
FROM 
    orders
WHERE
	order_status = 'delivered' AND
    order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL;
    
SELECT 
    CASE
        WHEN DATE(order_delivered_customer_date) <= DATE(order_estimated_delivery_date) THEN 'On time'
        ELSE 'Delayed'
    END AS delivery_status,
    COUNT(order_id) AS orders_count
FROM
    orders
WHERE
    order_status = 'delivered'
GROUP BY delivery_status;
	-- on time 89805
    -- delayed 6673

/*------------------------------------------------------------------------------------------------------------------------
Is there any pattern for delayed orders, e.g. big products being delayed more often?
--------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    CASE
        WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 100
        THEN '> 100 day Delay'
        WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) >= 8
			 AND DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) < 100
        THEN '1 week to 100 day delay'
        WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 3
			 AND DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) < 8
        THEN '3-7 day delay'
        WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 1
        THEN '1 - 3 days delay'
        ELSE '<= 1 day delay'
    END AS 'delay_range',
   AVG(product_weight_g) AS weight_avg,
   /* MAX(product_weight_g) AS max_weight,
    MIN(product_weight_g) AS min_weight,
    SUM(product_weight_g) AS sum_weight, */
    COUNT(*) AS product_count
FROM orders a
LEFT JOIN order_items b ON a.order_id = b.order_id
LEFT JOIN products c ON b.product_id = c.product_id
WHERE DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) > 0
GROUP BY delay_range
ORDER BY weight_avg DESC;