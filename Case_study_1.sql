use op_analytics;

SELECT ds as review_date, (SUM(time_spent)/3600) AS review_per_hour, COUNT(*) AS job_count
FROM job_data
WHERE MONTH(ds) = '11' 
GROUP BY review_date
ORDER BY review_date, review_per_hour;
