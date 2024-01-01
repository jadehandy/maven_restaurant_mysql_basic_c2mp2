USE restaurant_db;

-- 1.1 View the menu_items table.

SELECT *
FROM menu_items;

-- 1.2 Find the number of items on the menu.

SELECT COUNT(*)
FROM menu_items

-- 1.3. What are the least and most expensive items on the menu?

SELECT * 
FROM menu_items 
WHERE price = (SELECT MIN(price) FROM menu_items)

SELECT * 
FROM menu_items 
WHERE price = (SELECT MAX(price) FROM menu_items)

-- 1.4 How many Italian dishes are on the menu? 

SELECT COUNT(*)
FROM menu_items
WHERE category = 'Italian';

-- 1.5 What are the least and most expensive Italian dishes on the menu?

SELECT menu_item_id, item_name, category, price
FROM menu_items
WHERE category = 'Italian'
ORDER BY price
LIMIT 1;

SELECT *
FROM menu_items
WHERE category = 'Italian'
ORDER BY price DESC
LIMIT 1;

-- 1.6 How many dishes are in each category?

SELECT category, COUNT(*)
FROM menu_items
GROUP BY category; 

-- 1.7 What is the average dish price within each category?

SELECT category, AVG(price)
FROM menu_items
GROUP BY category;

-- 2.1 View the order_details table. 

SELECT *
FROM order_details;

-- 2.2 What is the date range of the table?

SELECT * 
FROM order_details
ORDER BY order_date;

SELECT * 
FROM order_details
ORDER BY order_date DESC;

-- 2.3 How many orders were made within this date range? 

SELECT COUNT(DISTINCT order_id) 
FROM order_details

-- 2.4 How many items were ordered within this date range?

SELECT COUNT(DISTINCT order_details_id)
FROM order_details

-- 2.5 Which orders had the most number of items?

SELECT order_id, COUNT(order_details_id)
FROM order_details
GROUP BY order_id
ORDER BY COUNT(order_details_id) DESC

-- 3.1 Combine the menu_items and order_details tables into a single table.

SELECT *
FROM order_details
LEFT OUTER JOIN menu_items ON order_details.item_id = menu_items.menu_item_id;

-- 3.2  What were the least and most ordered items? What categories were they in?

SELECT
	menu_items.menu_item_id,
	menu_items.item_name,
	COUNT(order_details.order_id) AS order_count
FROM
	menu_items
LEFT JOIN
	order_details ON menu_items.menu_item_id = order_details.item_id
GROUP BY
	menu_items.menu_item_id, menu_items.item_name
ORDER BY
	order_count ASC, menu_items.menu_item_id

SELECT
	menu_items.menu_item_id,
	menu_items.item_name,
	COUNT(order_details.order_id) AS order_count
FROM
	menu_items
LEFT JOIN
	order_details ON menu_items.menu_item_id = order_details.item_id
GROUP BY
	menu_items.menu_item_id, menu_items.item_name
ORDER BY	
	order_count DESC, menu_items.menu_item_id

SELECT
	menu_items.menu_item_id,
	menu_items.item_name,
	menu_items.category,
	COUNT(order_details.order_id) AS order_count
FROM
	menu_items
LEFT JOIN
	order_details ON menu_items.menu_item_id = order_details.item_id
GROUP BY
	menu_items.menu_item_id, 
	menu_items.item_name
ORDER BY
	order_count ASC, menu_items.menu_item_id

-- 3.3 What were the top 5 orders that spent the most money?

SELECT
	order_details.order_id,
	SUM(menu_items.price) AS total_spent
FROM
	order_details
JOIN
	menu_items ON order_details.item_id = menu_items.menu_item_id
GROUP BY
	order_details.order_id
ORDER BY
	total_spent DESC
LIMIT 5;

-- 3.4 View the details of the highest spend order. Which specific items were purchased?

SELECT
	order_details.order_id,
	menu_items.item_name,
	SUM(menu_items.price) AS total_spent
FROM
	order_details
JOIN
	menu_items ON order_details.item_id = menu_items.menu_item_id
WHERE
	order_details.order_id = '440'
GROUP BY    
	order_details.order_id, menu_items.item_name
    
-- 3.5 View the details of the top 5 highest spend orders.

SELECT
	order_details.order_id,
	GROUP_CONCAT(menu_items.item_name ORDER BY menu_items.item_name) AS ordered_items,
	SUM(menu_items.price) AS total_spent
FROM
	order_details
JOIN
	menu_items ON order_details.item_id = menu_items.menu_item_id
GROUP BY    
	order_details.order_id
ORDER BY
	total_spent DESC
LIMIT 5;
    
