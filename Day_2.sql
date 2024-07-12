/*-- 02 of 100 Days Challenge
-- Amazon Interview questions by Abbas


--Considering the below three tables, write a query that would:

i. List out the department wise maximum salary, minimum salary, average salary of the employees. 
ii. List out employee having the third highest salary.
iii. List out the department having at least four employees.
iv. Find out the employees who earn greater than the average salary for their department.
*/


-- Create department table
DROP TABLE IF EXISTS department;
CREATE TABLE department (
    Department_ID INT PRIMARY KEY,
    Department VARCHAR(50),
    Location_ID INT
);

-- Insert data into department table
INSERT INTO department (Department_ID, Department, Location_ID)
VALUES 
    (10, 'Accounting', 122),
    (20, 'Research', 124),
    (30, 'Sales', 123),
    (40, 'Operations', 167);


-- Create emp_fact table
DROP TABLE IF EXISTS emp_fact;
CREATE TABLE emp_fact (
    Employee_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(50),
    Job_ID INT,
    Manager_ID INT,
    Hired_Date DATE,
    Salary DECIMAL(10, 2),
    Department_ID INT,
    FOREIGN KEY (Department_ID) REFERENCES department(Department_ID)
);

-- Insert data into emp_fact table
INSERT INTO emp_fact (Employee_ID, Emp_Name, Job_ID, Manager_ID, Hired_Date, Salary, Department_ID)
VALUES 
    (7369, 'John', 667, 7902, '2006-02-20', 800.00, 10),
    (7499, 'Kevin', 670, 7698, '2008-11-24', 1550.00, 20),
    (7505, 'Jean', 671, 7839, '2009-05-27', 2750.00, 30),
    (7506, 'Lynn', 671, 7839, '2007-09-27', 1550.00, 30),
    (7507, 'Chelsea', 670, 7110, '2014-09-14', 2200.00, 30),
    (7521, 'Leslie', 672, 7698, '2012-02-06', 1250.00, 30);

-- Create jobs table

DROP TABLE IF EXISTS jobs;
CREATE TABLE jobs (
    Job_ID INT PRIMARY KEY,
    Job_Role VARCHAR(50),
    Salary DECIMAL(10, 2)
);

-- Insert data into jobs table
INSERT INTO jobs (Job_ID, Job_Role, Salary)
VALUES 
    (667, 'Clerk', 800.00),
    (668, 'Staff', 1600.00),
    (669, 'Analyst', 2850.00),
    (670, 'Salesperson', 2200.00),
    (671, 'Manager', 3050.00),
    (672, 'President', 1250.00);

SELECT * FROM department;
SELECT * FROM emp_fact;
SELECT * FROM jobs;



-- i. List out the department wise maximum salary, minimum salary, average salary of the employees.

SELECT  
    department,
    MAX(e.salary) AS maximum_salary,
    MIN(e.salary) AS miniimum_salary,
    ROUND(AVG(e.salary),2) AS average_salary
FROM
    emp_fact as e
    JOIN
    department as d
    ON
    e.department_id = d.department_id
GROUP BY
    department;


-- ii. List out employee having the third highest salary.
WITH CTE AS (
SELECT
    employee_id,
    salary,
    DENSE_RANK() OVER(ORDER BY salary) AS rank
FROM 
    emp_fact)

SELECT
    employee_id
FROM
    CTE
WHERE
    rank  = 3;


-- iii. List out the department having at least four employees.


SELECT
    department
    --COUNT(*) AS employees_count
FROM
    emp_fact AS e
    JOIN
    department AS d
    ON
    e.department_id = d.department_id
GROUP BY
    department
HAVING
    COUNT(*) >= 4;



-- iv. Find out the employees who earn greater than the average salary for their department.

-- Method 1:

WITH CTE AS(
SELECT
    employee_id,
    salary,
    AVG(salary) OVER(PARTITION BY department) as avg_sal
FROM
    emp_fact AS e
    JOIN
    department AS d
    ON
    d.department_id = e.department_id)

SELECT
    employee_id
FROM
    CTE
WHERE
    salary > avg_sal;




--Method 2:

WITH AvgSalDep AS (
SELECT
    e.department_id,
    d.department,
    ROUND(AVG(salary),2) AS Avg_sal
FROM
    emp_fact AS e
    JOIN
    department As d
    ON
    d.department_id = e.department_id
GROUP BY
    d.department,e.department_id)

SELECT
    e.employee_id,
    e.salary,
    asd.Avg_sal
FROM
    emp_fact AS e
    JOIN
    department AS d
    ON
    d.department_id = e.department_id
    JOIN
    AvgSalDep As asd
    ON
    asd.department_id = d.department_id
WHERE
    e.Salary > asd.Avg_sal;






