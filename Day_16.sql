-- Day 16 of 100 days challenge

--write a query to find users whose transactions has breached their credit limit
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS transactions;

create table users
(
	user_id int,
	user_name varchar(20),
	credit_limit int
);

create table transactions
(
	trans_id int,
	paid_by int,
	paid_to int,
	amount int,
	trans_date date
);

insert into users(user_id,user_name,credit_limit)values
(1,'Peter',100),
(2,'Roger',200),
(3,'Jack',10000),
(4,'John',800);

insert into transactions(trans_id,paid_by,paid_to,amount,trans_date)values
(1,1,3,400,'01-01-2024'),
(2,3,2,500,'02-01-2024'),
(3,2,1,200,'02-01-2024');


--write a query to find users whose transactions has breached their credit limit

-- find money sent by each user
-- find money received by each user
-- add credit limit + money received by each user as new limit
-- if money spent is > new limit then limit breached!

SELECT * FROM users;
SELECT * FROM transactions;

WITH money_sent_cte AS (
SELECT
    paid_by AS user_id,
    SUM(amount) AS total_amount
FROM
    transactions
GROUP BY
    user_id
)
, money_received_cte AS(
SELECT
    paid_to AS user_id,
    SUM(amount) AS money_received
FROM
    transactions
GROUP BY
    user_id
),

limit_breach_cte AS(
SELECT 
    u.user_id,
    u.user_name,
    u.credit_limit,
    COALESCE(ms.total_amount,0) AS money_spent,
    COALESCE(mr.money_received,0) AS money_received,
    COALESCE(credit_limit + money_received,0) AS new_limit
FROM
    users AS u
    LEFT JOIN
    money_sent_cte AS ms
    ON
    ms.user_id = u.user_id
    LEFT JOIN
    money_received_cte AS mr
    ON
    mr.user_id = ms.user_id)
SELECT
    user_id,
    user_name,
    money_spent,
    new_limit
FROM
    limit_breach_cte
WHERE
    money_spent > new_limit;

