-- Day 03/100 

-- Create the student_details table
CREATE TABLE students (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Gender CHAR(1)
);

-- Insert the data into the student_details table
INSERT INTO students (ID, Name, Gender) VALUES
(1, 'Gopal', 'M'),
(2, 'Rohit', 'M'),
(3, 'Amit', 'M'),
(4, 'Suraj', 'M'),
(5, 'Ganesh', 'M'),
(6, 'Neha', 'F'),
(7, 'Isha', 'F'),
(8, 'Geeta', 'F');


/*
Given table student_details, 
write a query which displays names 
alternately by gender and sorted 
by ascending order of column ID.
*/

-- Method 1:

WITH CTE AS(SELECT
    *,
    ROW_NUMBER() OVER(PARTITION BY Gender ORDER BY ID) AS rn
FROM
    students)
    
SELECT
    id,
    name,
    gender
FROM
    CTE
ORDER BY
    rn,id;


-- Method 2:

SELECT
    *
FROM
    students
ORDER BY
    ROW_NUMBER() OVER(PARTITION BY GENDER ORDER BY ID) ,
    CASE    
        WHEN gender = 'M' THEN 1
        ELSE 2
        END;


-- Method 3:

WITH CTE AS (
SELECT
    *,
    ROW_NUMBER() OVER(PARTITION BY Gender ORDER BY id) AS RN
FROM
    students
)

SELECT
    id,
    name,
    gender
FROM
    CTE
ORDER BY
    RN,
    CASE 
        WHEN gender = 'M' THEN 1
        ELSE 2
        END;




