use op_analytics;

/*
User Engagement: To measure the activeness of a user. Measuring if the user finds quality in a product/service.
Your task: Calculate the weekly user engagement?

*/
SELECT
	Weeks,
    Num_active_user,
    (
    Num_active_user/LAG(Num_active_user,1) OVER (ORDER BY Weeks) - 1
    )*100 as growth_weekly

FROM
	(SELECT 
		extract(WEEK FROM e.occurred_at) AS Weeks, 
		COUNT( distinct e.user_id) AS Num_active_user
	FROM 
		users u
	INNER JOIN 
		events e ON u.user_id = e.user_id
	where 
		e.event_type = 'engagement' 
	GROUP BY 
		Weeks) sub;
 


/*
User Growth: Amount of users growing over time for a product.
Your task: Calculate the user growth for product?
*/
SELECT
Month,
device,
Num_users,
 (
    Num_users/LAG(Num_users,1) OVER (ORDER BY device, Month) - 1
    )*100 as growth_Monthly
FROM
	(SELECT 
		distinct extract(MONTH FROM occurred_at) as Month , 
		device,
		count(distinct user_id) as Num_users
	FROM
		events 
	WHERE
		event_type = 'engagement'
	GROUP BY 
		Month, device
	ORDER BY 
		device asc
        ) sub
	;


/*
Weekly Retention: Users getting retained weekly after signing-up for a product.
Your task: Calculate the weekly retention of users-sign up cohort?
*/


SELECT
    cohort.signup_week,
    cohort.cohort_size,
    COUNT(DISTINCT CASE WHEN EXTRACT(WEEK FROM e.occurred_at) = cohort.signup_week THEN e.user_id END) AS retained_users,
    ROUND((COUNT(DISTINCT CASE WHEN EXTRACT(WEEK FROM e.occurred_at) = cohort.signup_week THEN e.user_id END) / cohort.cohort_size) * 100, 2) AS retention_rate
FROM
    (
    SELECT
        EXTRACT(WEEK FROM activated_at) AS signup_week,
        COUNT(DISTINCT user_id) AS cohort_size
    FROM
        users
    WHERE
        activated_at IS NOT NULL
    GROUP BY
        signup_week
    ) AS cohort
LEFT JOIN
    events AS e ON EXTRACT(WEEK FROM e.occurred_at)= cohort.signup_week
GROUP BY
    cohort.signup_week, cohort.cohort_size
ORDER BY
    cohort.signup_week;

/*
Weekly Engagement: To measure the activeness of a user. 
Measuring if the user finds quality in a product/service weekly.
Your task: Calculate the weekly engagement per device?
*/
SELECT
    AU.week,
    AU.device,
    AU.Active_users,
    COALESCE(PE.Active_Engagements, 0) AS Active_Engagements
FROM
    (SELECT
        EXTRACT(WEEK FROM occurred_at) AS week,
        device,
        COUNT(DISTINCT user_id) AS Active_users
    FROM
        events
    GROUP BY
        week,
        device) AU
LEFT JOIN
    (SELECT
        EXTRACT(WEEK FROM occurred_at) AS weeks,
        device,
        COUNT(*) AS Active_Engagements
    FROM
        events
    WHERE
        event_type = 'engagement'
        AND (event_name = 'like_message' OR event_name = 'send_message')
    GROUP BY
        weeks,
        device) PE ON AU.week = PE.weeks AND AU.device = PE.device
ORDER BY
    AU.week,
    AU.device;


/*
Email Engagement: Users engaging with the email service.
Your task: Calculate the email engagement metrics?
*/
select
	action,
	100*count(user_id)/(select count(user_id) from email_events) as Engagement_metrics
FROM 
	email_events ee
GROUP BY 
	action;
