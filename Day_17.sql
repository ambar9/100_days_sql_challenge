-- day 17/100 days challenge


DROP TABLE IF EXISTS user_activities;

CREATE TABLE user_activities (
    user_id INT,
    activity VARCHAR(10), -- Either 'Login' or 'Logout'
    activity_time TIMESTAMP
);



INSERT INTO user_activities (user_id, activity, activity_time) VALUES
(1, 'Login', '2024-01-01 08:00:00'),
(1, 'Logout', '2024-01-01 12:00:00'),
(1, 'Login', '2024-01-01 13:00:00'),
(1, 'Logout', '2024-01-01 17:00:00'),
(2, 'Login', '2024-01-01 09:00:00'),
(2, 'Logout', '2024-01-01 11:00:00'),
(2, 'Login', '2024-01-01 14:00:00'),
(2, 'Logout', '2024-01-01 18:00:00'),
(3, 'Login', '2024-01-01 08:30:00'),
(3, 'Logout', '2024-01-01 12:30:00');

SELECT * FROM user_activities;


-- Find out each users and productivity time in hour!
-- productivity time = login - logout time

-- basically we need to minute logout - login
-- we need to make login and logout time in same row so can find difference amoung them but it should be group by user_id with earlist time activity
-- lag function activity which should be partition by userid
-- lag function activity time to bring logout time in same row as log in time but should order it by earliest
-- use Epoch funcrion to convert to seconds and convert set to hours


-- Method 1: 


WITH previous_activity_stuff AS(
SELECT
    *,
    LAG(activity) OVER(PARTITION BY user_id) AS previous_activity,
    LAG(activity_time) OVER(PARTITION BY user_id ORDER BY activity_time) AS previous_activity_time
FROM
    user_activities
),
hour_count AS (
SELECT
    user_id,
    previous_activity,
    previous_activity_time,
    activity,
    activity_time,
    ROUND(EXTRACT(EPOCH FROM (activity_time - previous_activity_time))/ 3600,1)AS hours
FROM
    previous_activity_stuff
WHERE
    previous_activity = 'Login'
    AND
    Activity = 'Logout')

SELECT
    user_id,
    SUM(hours) AS productivity_time
FROM
    hour_count
GROUP BY
    user_id;


-- Method 2:

select 
    user_id ,
    sum(extract (hour from logout_time_new) - extract (hour from activity_time)) as productivity_time
from 
(
SELECT 
    * , 
    lead(activity) over(partition by user_id order by activity_time) as activity_new,
    lead(activity_time) over(partition by user_id order by activity_time) as logout_time_new
FROM 
    user_activities
)  as  subquery
where 
    activity ='Login' and activity_new='Logout' 
group by 
    user_id;