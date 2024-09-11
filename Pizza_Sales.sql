-- Basic 

-- 1) Retrieve the total number of orders placed. 
SELECT COUNT(order_id) AS Total_orders FROM orders;

-- 2) Calculate total revenue generated from Pizza sales. 
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;
    
-- 3)Identify the highest priced pizza
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- 4)Identify the most common pizza size ordered 
SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC
LIMIT 1;

-- 5)List the top 5 most ordered pizza types along with their quantities 
SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
    GROUP BY pizza_types.name
    ORDER BY quantity DESC 
    LIMIT 5;
    
-- 6) Join the necessary table to find total quantity of each pizza category ordered. 
SELECT pizza_types.category, sum(order_details.quantity) AS quantity
FROM pizza_types
JOIN 
pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
    GROUP BY pizza_types.category
    ORDER BY quantity DESC;
    
-- 7) Determine the distribution of orders by hours of the day
SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY hour;

-- 8) Join relevant tables to find category wise distribution of pizzas. 
SELECT 
    category, COUNT(name) AS pizza_types
FROM
    pizza_types
GROUP BY category;

-- 9) Group the orders by date and calculate the average number of pizzas ordered per day
SELECT 
    ROUND(AVG(quantity), 0)
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;
    
-- 10)Determine the top 3 most order pizza type based on revenue. 
SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;

-- 11) Calculate the percentage contribution of each pizza type to total revenue 
SELECT pizza_types.category, ROUND((SUM(order_details.quantity * pizzas.price) / (SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id)) * 100, 2) AS revenue 

FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;

-- 12)Analyse cumulative revenue generated over time. 
SELECT order_date, sum(revenue) over(order by order_date) AS cum_revenue 
FROM 
(SELECT orders.order_date, sum(order_details.quantity * pizzas.price) AS revenue 
FROM order_details JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id 
JOIN orders ON orders.order_id = order_details.order_id
GROUP BY orders.order_date) AS sales;

-- 13) Determine the top 3 most ordered pizza types based on revenue for each pizza category. 
SELECT 
	name, revenue
FROM 
(SELECT 
	category, name, revenue, 
    rank() over(partition by category order by revenue desc) AS rn
FROM 
(SELECT 
	pizza_types.category, pizza_types.name, 
    sum((order_details.quantity) * pizzas.price) AS revenue 
FROM 
	pizza_types JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id 
    JOIN order_details ON order_details.pizza_id = pizzas.pizza_id 
GROUP BY pizza_types.category, pizza_types.name) AS a) AS b 
where rn<=3;
    
