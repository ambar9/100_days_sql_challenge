/*
Advanced Flipkart Sales Analysis Question
Question:
Flipkart wants to identify seasonal sales trends and understand customer purchasing behavior during different times of the year. You have the following tables: Sales, Products, and Customers.
*/
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS customers3;

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(100),
    price DECIMAL(10, 2)
);

INSERT INTO Products (product_id, product_name, category, price) VALUES
(1, 'Laptop', 'Electronics', 999.99),
(2, 'Smartphone', 'Electronics', 799.99),
(3, 'Headphones', 'Electronics', 199.99),
(4, 'Refrigerator', 'Appliances', 1499.99),
(5, 'Microwave', 'Appliances', 299.99),
(6, 'T-shirt', 'Clothing', 19.99),
(7, 'Jeans', 'Clothing', 49.99),
(8, 'Blender', 'Appliances', 99.99),
(9, 'Coffee Maker', 'Appliances', 79.99),
(10, 'Shoes', 'Clothing', 89.99);




CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    sale_date DATE,
    quantity INT,
    amount DECIMAL(10, 2),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Sales (sale_id, product_id, customer_id, sale_date, quantity, amount) VALUES
(1, 1, 101, '2023-01-15', 1, 999.99),
(2, 2, 102, '2023-02-16', 2, 1599.98),
(3, 3, 103, '2023-03-17', 3, 599.97),
(4, 4, 104, '2023-04-18', 1, 1499.99),
(5, 5, 105, '2023-05-19', 2, 599.98),
(6, 6, 101, '2023-06-20', 5, 99.95),
(7, 7, 102, '2023-07-21', 3, 149.97),
(8, 8, 103, '2023-08-22', 1, 99.99),
(9, 9, 104, '2023-09-23', 2, 159.98),
(10, 10, 105, '2023-10-24', 1, 89.99),
(11, 1, 101, '2023-11-24', 1, 999.99),
(12, 2, 102, '2023-11-25', 2, 1599.98),
(13, 3, 103, '2023-11-26', 3, 599.97),
(14, 4, 104, '2023-11-27', 1, 1499.99),
(15, 5, 105, '2023-11-28', 2, 599.98);





CREATE TABLE Customers3 (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_city VARCHAR(100),
    customer_state VARCHAR(100)
);

INSERT INTO Customers3 (customer_id, customer_name, customer_city, customer_state) VALUES
(101, 'Alice', 'New York', 'NY'),
(102, 'Bob', 'Los Angeles', 'CA'),
(103, 'Charlie', 'Chicago', 'IL'),
(104, 'David', 'Houston', 'TX'),
(105, 'Eve', 'Phoenix', 'AZ');



/*
Interview Question
Tasks:
1 Write a query to calculate the average monthly sales for each category!
return category that has highest average sale in each month!


2. Write a query to identify the customers who spent the most 
money during the Big Billion Days Sale (November 24-27) in 2023.

return customer name, id and total spent
*/

SELECT * FROM Products;
SELECT * FROM  Sales;
SELECT * FROM Customers3;




-- 1 Write a query to calculate the average monthly sales for each category!
-- return category that has highest average sale in each month!

WITH CTE AS (
SELECT
    EXTRACT(MONTH FROM s.sale_date) AS month_number,
    p.category,
    ROUND(AVG(amount), 2) AS average_sales,
    DENSE_RANK() OVER(PARTITION BY EXTRACT(MONTH FROM s.sale_date) ORDER BY AVG(amount) DESC) AS dn
FROM
    Products AS p
    JOIN
    Sales AS s
    ON
    p.product_id = s.product_id
GROUP BY
    month_number,
    p.category
)
    
SELECT
    month_number,
    category,
    average_sales
FROM
    CTE
WHERE
    dn = 1;





-- 2. Write a query to identify the customers who spent the most 
-- money during the Big Billion Days Sale (November 24-27) in 2023.

-- return customer name, id and total spent


SELECT
    c.customer_name,
    c.customer_id,
    SUM(s.quantity * s.amount) AS total_spent
FROM
    Sales AS s
    JOIN
    Customers3 AS c
    ON
    s.customer_id = c.customer_id
WHERE
    EXTRACT(MONTH FROM s.sale_date) = 11
    AND
    EXTRACT(YEAR FROM s.sale_date) = 2023
    AND
    EXTRACT(DAY FROM s.sale_date) BETWEEN 24 AND 27
GROUP BY
    c.customer_name,
    c.customer_id
ORDER BY
    total_spent DESC
LIMIT 1;



