SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date,
    EXTRACT(MONTH FROM job_posted_date) AS column_month,
    EXTRACT(YEAR FROM job_posted_date) AS column_month
FROM 
    job_postings_fact
LIMIT 5;



SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date:: DATE AS date
FROM 
    job_postings_fact
LIMIT 5;

/* how job postings are trending from month to month*/
SELECT 
    job_id,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
LIMIT 5;

SELECT 
    COUNT(job_id),
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
GROUP BY month;
-- LIMIT 5;

SELECT 
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY month
ORDER BY job_posted_count DESC;

SELECT 
    EXTRACT(MONTH FROM job_posted_date) AS month,
    COUNT(job_id) AS job_posted_count
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY month
ORDER BY month ASC;

SELECT *
FROM job_postings_fact
LIMIT 5;

/* for jobs posted after June 1 2023, avg salary for year, avg salary for hour
group by job schedule type*/

SELECT
    --job_posted_date AS date,
    job_schedule_type,
    AVG(salary_year_avg) AS yearly_avg_salary,
    AVG(salary_hour_avg) AS hourly_avg_salary
FROM
    job_postings_fact
WHERE
    job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type;

/* for each month in 2023, count the no.of job postings.
change job posted date to be in AMerica/NewYork' Time zone
extact month from job posted date (assume original date is in UTC)
Group by and order by month
*/

SELECT
    --job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date,
    EXTRACT(MONTH FROM (job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST')) AS month,
    COUNT(job_id)

FROM job_postings_fact
GROUP BY month
ORDER BY month;


/* find companies (company name) posted jobs with health insuarnce 
posted date second quarter 

1- filter by Apr-Jun, 4 5 6
2- filter by health insurance
3- get company name for relevant company id

*/

SELECT
    job_postings_fact.company_id,
    company_dim.name,
    job_title_short
    --job_posted_date,
    --EXTRACT(MONTH FROM job_posted_date) AS month,
    --job_health_insurance

FROM job_postings_fact

LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

WHERE 
    EXTRACT(MONTH FROM job_posted_date) IN (4,5,6) AND
    job_health_insurance = TRUE

GROUP BY job_postings_fact.company_id, company_dim.name
ORDER BY job_postings_fact.company_id;


SELECT *
FROM company_dim
LIMIT 5;
    
