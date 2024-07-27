-- Day 13/100 SQL Challenge

DROP TABLE IF EXISTS employees;
CREATE TABLE Employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    salary DECIMAL(10, 2)
);



INSERT INTO Employees (name, salary) VALUES
('Alice', 60000.00),
('Bob', 75000.00),
('Charlie', 50000.00),
('David', 50000.00),
('Eva', 95000.00),
('Frank', 80000.00),
('Grace', 80000.00),
('Hank', 90000.00),
('Hank', 75000.00);

SELECT * FROM employees;    

-- You have emp table mentioned below
-- Write SQL query to fetch nth highest salary!

-- nth = 3rd highest salary

WITH CTE AS (
SELECT
    name,
    salary,
    DENSE_RANK() OVER(ORDER BY salary DESC ) AS dn
FROM
    employees)
    
SELECT
    name,
    salary
FROM
    CTE
WHERE
    dn = 3;