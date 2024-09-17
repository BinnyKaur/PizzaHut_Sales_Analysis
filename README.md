# PizzaHut_Sales_Analysis
This project involves analyzing operational data for a PizzaHut Store. The goal of the project is to derive actionable insights by solving key business questions related to its key product performance and sales trend. 

## Dataset 
In this project my database consist of 4 tables. 
1) Order_Details
   
   4 Columns, 48620 Rows
   <img width="1147" alt="Screenshot 2024-09-16 at 11 22 55 AM" src="https://github.com/user-attachments/assets/6c8d459e-b577-4e86-8684-691400a964c7">

2) Orders
   
   3 Columns, 21350 Rows
   <img width="1146" alt="Screenshot 2024-09-16 at 11 37 45 AM" src="https://github.com/user-attachments/assets/14634944-b3df-4e11-b1e2-cdb2c52c9711">

3) Pizzas
   
   4 Columns, 97 Rows
   <img width="1144" alt="Screenshot 2024-09-16 at 11 42 16 AM" src="https://github.com/user-attachments/assets/dcd3f861-68c8-4895-b507-6560ccb01029">

4) Pizza_types
   
   4 Columns, 32 Rows
   <img width="1162" alt="Screenshot 2024-09-16 at 11 44 14 AM" src="https://github.com/user-attachments/assets/5f91566e-bb4a-4d27-8043-baae7ec28036">

## Questions Answered 
1) Retrieve the total number of orders placed.
   
SELECT COUNT(order_id) AS Total_orders FROM orders;
<img width="497" alt="Screenshot 2024-09-16 at 12 05 49 PM" src="https://github.com/user-attachments/assets/49e3ecfa-7f05-432b-a449-7dc34c5914ec">

2) Calculate total revenue generated from Pizza sales.
   
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),2) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id;
<img width="442" alt="Screenshot 2024-09-16 at 12 08 56 PM" src="https://github.com/user-attachments/assets/bf8a36ee-e92b-4ac7-ae51-081c5fbd13c0">

-- 3)Identify the highest priced pizza

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

<img width="344" alt="Screenshot 2024-09-17 at 10 39 06 AM" src="https://github.com/user-attachments/assets/a39d4060-1894-4d85-bf5d-16f40f3870e4">

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

<img width="345" alt="Screenshot 2024-09-17 at 10 40 31 AM" src="https://github.com/user-attachments/assets/4cacf802-0191-4a8c-b16f-30011756171c">

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
    
<img width="328" alt="Screenshot 2024-09-17 at 10 42 05 AM" src="https://github.com/user-attachments/assets/df358b90-c7c1-4805-8c36-c1e34bc173cb">


-- 6) Join the necessary table to find total quantity of each pizza category ordered. 

SELECT pizza_types.category, sum(order_details.quantity) AS quantity
FROM pizza_types
JOIN 
pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
    GROUP BY pizza_types.category
    ORDER BY quantity DESC;
    
<img width="414" alt="Screenshot 2024-09-17 at 10 43 46 AM" src="https://github.com/user-attachments/assets/1f5656aa-1e85-4101-9bd8-ece1b280fa8f">
   
-- 7) Determine the distribution of orders by hours of the day

SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY hour;

<img width="451" alt="Screenshot 2024-09-17 at 10 44 36 AM" src="https://github.com/user-attachments/assets/953ab8b2-a925-4d16-bfa4-70730313614d">

-- 8) Join relevant tables to find category wise distribution of pizzas. 

SELECT 
    category, COUNT(name) AS pizza_types
FROM
    pizza_types
GROUP BY category;

<img width="349" alt="Screenshot 2024-09-17 at 10 48 09 AM" src="https://github.com/user-attachments/assets/97331eb2-c239-4f2c-a40d-5a16f5c00334">

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
    
 <img width="437" alt="Screenshot 2024-09-17 at 10 47 26 AM" src="https://github.com/user-attachments/assets/3d06fe9f-b39e-43f0-be58-0253dcd6d13e">
   
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

<img width="348" alt="Screenshot 2024-09-17 at 10 50 09 AM" src="https://github.com/user-attachments/assets/3158c48d-2b95-40f4-8cbb-e8608c99889c">

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


<img width="434" alt="Screenshot 2024-09-17 at 10 50 30 AM" src="https://github.com/user-attachments/assets/3ee90c43-55c5-4669-b3d3-efdadd784285">

-- 12)Analyse cumulative revenue generated over time. 

SELECT order_date, sum(revenue) over(order by order_date) AS cum_revenue 
FROM 
(SELECT orders.order_date, sum(order_details.quantity * pizzas.price) AS revenue 
FROM order_details JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id 
JOIN orders ON orders.order_id = order_details.order_id
GROUP BY orders.order_date) AS sales;

<img width="549" alt="Screenshot 2024-09-17 at 10 51 33 AM" src="https://github.com/user-attachments/assets/418e76a5-5787-48a5-8681-cdb73f00ac46">

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
    
<img width="455" alt="Screenshot 2024-09-17 at 10 52 58 AM" src="https://github.com/user-attachments/assets/ab494a7f-5d80-4d19-b8af-4aab88840cd5">

    

    


