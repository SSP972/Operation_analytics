Create database op_analytics;

CREATE TABLE op_analytics.job_data (
  ds VARCHAR(10),
  job_id  INT,
  actor_id INT,
  event VARCHAR(20),
  language VARCHAR(50),
  time_spent INT,
  org VARCHAR(50)  
);
CREATE TABLE op_analytics.users (
  user_id INT ,
  created_at DATETIME,
  company_id INT,
  language VARCHAR(50),
  activated_at DATETIME,
  state VARCHAR(50)
);
CREATE TABLE op_analytics.events (
  user_id INT,
  occurred_at DATETIME,
  event_type VARCHAR(255),
  event_name VARCHAR(255),
  location VARCHAR(255),
  device VARCHAR(255),
  user_type VARCHAR(255)
);

CREATE TABLE op_analytics.email_events (
  user_id INT,
  occurred_at DATETIME,
  action VARCHAR(255),
  user_type VARCHAR(255)
);

use op_analytics;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/SQL Project-1_Table.csv'
INTO TABLE job_data
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 rows
;



LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Table-2 events.csv'
INTO TABLE events
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 rows
(user_id, 	occurred_at,	event_type,	 event_name,	 location, 	device,	 user_type)
;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Table-3 email_events.csv'
INTO TABLE email_events
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
IGNORE 1 rows
(user_id, occurred_at, action, user_type)
;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Table-1 users.csv'
INTO TABLE users
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'

IGNORE 1 rows
(user_id,	created_at,	company_id,	language,	@activated_at,	state)
SET activated_at = NULLIF(@activated_at, '')
;Z