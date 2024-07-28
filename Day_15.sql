-- day 15/100 days challenge

DROP TABLE IF EXISTS restaurants;
DROP TABLE IF EXISTS orders;


CREATE TABLE Restaurants (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100)
);

CREATE TABLE Orders (
    id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES Restaurants(id),
    order_time TIMESTAMP,
    dispatch_time TIMESTAMP
);

INSERT INTO Restaurants (name, location) VALUES
('Restaurant A', 'Delhi'),
('Restaurant B', 'Delhi'),
('Restaurant C', 'Delhi'),
('Restaurant D', 'Delhi'),
('Restaurant E', 'Delhi');

INSERT INTO Orders (restaurant_id, order_time, dispatch_time) VALUES
(1, '2024-07-23 12:00:00', '2024-07-23 12:14:00'),
(1, '2024-07-23 12:30:00', '2024-07-23 12:48:00'),
(1, '2024-07-23 13:00:00', '2024-07-23 13:16:00'),
(2, '2024-07-23 13:30:00', '2024-07-23 13:50:00'),
(2, '2024-07-23 14:00:00', '2024-07-23 14:14:00'),
(3, '2024-07-23 14:30:00', '2024-07-23 14:49:00'),
(3, '2024-07-23 15:00:00', '2024-07-23 15:16:00'),
(3, '2024-07-23 15:30:00', '2024-07-23 15:40:00'),
(4, '2024-07-23 16:00:00', '2024-07-23 16:10:00'),
(4, '2024-07-23 16:30:00', '2024-07-23 16:50:00'),
(5, '2024-07-23 17:00:00', '2024-07-23 17:25:00'),
(5, '2024-07-23 17:30:00', '2024-07-23 17:55:00'),
(5, '2024-07-23 18:00:00', '2024-07-23 18:19:00'),
(1, '2024-07-23 18:30:00', '2024-07-23 18:44:00'),
(2, '2024-07-23 19:00:00', '2024-07-23 19:13:00');


/*
You are given two tables: Restaurants and Orders. After receiving an order, 
each restaurant has 15 minutes to dispatch it. Dispatch times are categorized as follows:

on_time_dispatch: Dispatched within 15 minutes of order received.
late_dispatch: Dispatched between 15 and 20 minutes after order received.
super_late_dispatch: Dispatched after 20 minutes.
Task: Write an SQL query to count the number of dispatched orders in each category for each restaurant.*/



SELECT * FROM Restaurants;
SELECT * FROM Orders;

-- Method 1:

WITH CTE AS (
SELECT
    r.id AS restaurant_id,
    r.name AS restaurant_name,
    o.id AS order_id,
    o.order_time,
    o.dispatch_time,
    EXTRACT(MINUTE FROM o.dispatch_time - o.order_time) AS minutes_took,
    CASE
        WHEN EXTRACT(MINUTE FROM o.dispatch_time - o.order_time) <= 15 THEN 'on_time_dispatch'
        WHEN EXTRACT(MINUTE FROM o.dispatch_time - o.order_time) <= 20 THEN 'late_dispatch'
        WHEN EXTRACT(MINUTE FROM o.dispatch_time - o.order_time) > 20 THEN 'super_late_dispatch'
    END AS dispatch_category
FROM
    Restaurants AS r
    JOIN
    Orders AS o
    ON
    r.id = o.restaurant_id)

SELECT
    restaurant_id,
    restaurant_name,
    dispatch_category,
    COUNT(order_id)
FROM
    CTE
GROUP BY
    restaurant_id,
    restaurant_name,
    dispatch_category
ORDER BY
    restaurant_id,
    restaurant_name;




-- Method 2:


WITH CTE AS (
SELECT
    r.id AS restaurant_id,
    r.name AS restaurant_name,
    o.id AS order_id,
    o.dispatch_time - o.order_time AS time_took_to_dispatch,
    CASE
        WHEN o.dispatch_time <= o.order_time + INTERVAL '15 MINUTES' THEN 'on_time_dispatch'
        WHEN o.dispatch_time > o.order_time + INTERVAL '15 MINUTES' AND o.dispatch_time <= o.order_time + INTERVAL '20 MINUTES'THEN 'late_dispatch'
        ELSE
            'super_late_dispatch'
        END AS dispatch_category
FROM
    Restaurants AS r
    JOIN
    Orders AS o
    ON
    o.restaurant_id = r.id
)

SELECT
    restaurant_id,
    restaurant_name,
    COUNT(CASE WHEN dispatch_category = 'on_time_dispatch' THEN 1 END) AS on_time_dispatch,
    COUNT(CASE WHEN dispatch_category = 'late_dispatch' THEN 1 END) AS late_dispatch,
    COUNT(CASE WHEN dispatch_category = 'super_late_dispatch' THEN 1 END) AS super_late_dispatch
FROM
    CTE
GROUP BY
    restaurant_id,
    restaurant_name
ORDER BY
    restaurant_id,
    restaurant_name;