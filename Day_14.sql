-- Day 14/100 

-- Write a SQL query to find the customer IDs who have made purchases consecutively
-- in every month up to the current month (July 2024) of this year.

DROP TABLE IF EXISTS amazon_sales;
-- Create the amazon_sales table
CREATE TABLE amazon_sales (
    customer_id INT,
    purchase_date DATE,
    amount FLOAT
);

-- Insert sample data into the amazon_sales table
INSERT INTO amazon_sales (customer_id, purchase_date, amount) VALUES
(1, '2024-01-15', 150.0),
(1, '2024-02-10', 200.0),
(1, '2024-03-05', 300.0),
(1, '2024-04-01', 400.0),
(1, '2024-03-05', 350.0),
(1, '2024-04-04', 650.0),
(1, '2024-05-11', 500.0),
(1, '2024-06-01', 600.0),
(1, '2024-07-01', 700.0),
(2, '2023-01-20', 250.0),
(2, '2022-02-15', 350.0),
(2, '2024-03-10', 450.0),
(2, '2024-04-05', 550.0),
(2, '2024-04-08', 650.0),
(2, '2024-04-03', 350.0),
(2, '2024-05-12', 650.0),
(2, '2024-06-15', 750.0),
(2, '2024-07-10', 850.0),
(3, '2024-03-12', 500.0),
(3, '2024-04-25', 600.0),
(3, '2024-05-18', 700.0),
(3, '2024-06-22', 800.0),
(3, '2024-07-15', 900.0),
(4, '2024-01-30', 800.0),
(4, '2024-02-28', 900.0),
(4, '2024-03-20', 1000.0),
(4, '2024-04-15', 1100.0),
(4, '2024-05-10', 1200.0),
(4, '2024-06-05', 1300.0),
(4, '2024-07-01', 1400.0),
(5, '2024-01-15', 2200.0),
(5, '2024-02-10', 2300.0),
(5, '2024-03-05', 2400.0),
(5, '2024-04-01', 2500.0),
(5, '2024-05-15', 2600.0),
(5, '2024-06-10', 2700.0),
(5, '2024-07-10', 2200.0);


SELECT * FROM amazon_sales;


-- Write a SQL query to find the customer IDs who have made purchases consecutively
-- in every month up to the current month (July 2024) of this year.

-- Method 1:

WITH CTE AS (
SELECT
    customer_id,
    DATE_TRUNC('MONTH',purchase_date) AS rounding_month
FROM
    amazon_sales
WHERE
    EXTRACT(YEAR FROM purchase_date) = 2024
GROUP BY
    1,2
),

month_count_cte AS
(
    SELECT
        customer_id,
        COUNT(rounding_month) AS month_count
    FROM
        CTE
    GROUP BY
        customer_id
)
SELECT
    DISTINCT(customer_id),
    month_count
FROM
    month_count_cte
WHERE
    month_count = 7;


-- Method 2:


SELECT
    DISTINCT(customer_id)
FROM
    amazon_sales
WHERE
    EXTRACT(YEAR FROM purchase_date) = 2024
GROUP BY
    customer_id
HAVING
    COUNT(DISTINCT(EXTRACT(MONTH FROM purchase_date))) = EXTRACT(MONTH FROM CURRENT_DATE);