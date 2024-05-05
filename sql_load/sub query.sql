-- jobs posted in Jan, Feb and Mar saved as a seperate tables

CREATE TABLE january_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT *
FROM march_jobs;

SELECT
    job_title_short,
    job_location,

    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact;

SELECT
    COUNT(job_id) AS Number_of_jobs,
    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY location_category;


/* define high, standard, low salary ranges and categorize for Data Analysts*/

SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    CASE    
        WHEN salary_year_avg <= 100000 THEN 'low'
        WHEN salary_year_avg > 500000 THEN 'high'
        ELSE 'standard'
    END AS salary_category
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL AND job_title_short = 'Data Analyst'
ORDER BY salary_year_avg ASC;

/* sub queries */
SELECT *
FROM (-- sub query starts
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1 
) AS january_month_jobs;



/* CTE Common Table Expressions*/

WITH jan_jobs AS ( -- CTE starts
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)
SELECT *
FROM jan_jobs;

/* list of companies who DOES NOT require a degree, job_no_degree_mention = true */
SELECT
    company_id,
    name
FROM company_dim

WHERE company_id IN (
SELECT company_id
FROM job_postings_fact
WHERE job_no_degree_mention = TRUE
)
ORDER BY company_id;

/* solve same above using JOINS */

SELECT DISTINCT
    company_dim.company_id,
    name,
    job_postings_fact.job_no_degree_mention
FROM company_dim

LEFT JOIN job_postings_fact ON company_dim.company_id = job_postings_fact.company_id
WHERE job_no_degree_mention = TRUE
ORDER BY company_id;

/*same as above. LEFT join replaced with INNER*/
ELECT DISTINCT
    company_dim.company_id,
    name,
    job_postings_fact.job_no_degree_mention
FROM company_dim

INNER JOIN job_postings_fact ON company_dim.company_id = job_postings_fact.company_id
WHERE job_no_degree_mention = TRUE
ORDER BY company_id;

/* trying to view the jobs with job_no_degree_mention = TRUE */

WITH job_no_degree_required AS ( -- CTE starts
    SELECT *
    FROM job_postings_fact
    WHERE job_no_degree_mention = TRUE AND company_id = 6
)
SELECT *
FROM job_no_degree_required
ORDER BY company_id;

/* find the companies that have most num of job openings
    get total num of job postings per company */

SELECT
    company_id,
    COUNT(job_id) AS number_of_jobs
FROM job_postings_fact
GROUP BY company_id
ORDER BY number_of_jobs DESC;

SELECT
    company_id,
    COUNT(*)
FROM job_postings_fact
GROUP BY company_id;

WITH job_count_table AS(
    SELECT
    company_id,
    COUNT(*)
FROM job_postings_fact
GROUP BY company_id
)
SELECT *
FROM job_count_table;

/* find the companies that have most num of job openings
    get total num of job postings per company
    show the company name too*/

WITH job_count_table AS(
    SELECT
        company_id,
        COUNT(*) AS count_of_jobs
    FROM job_postings_fact
    GROUP BY company_id
)
SELECT
    company_dim.company_id,
    company_dim.name,
    job_count_table.count_of_jobs
FROM company_dim
LEFT JOIN job_count_table ON company_dim.company_id = job_count_table.company_id
ORDER BY count_of_jobs DESC;


SELECT *
FROM skills_job_dim
LIMIT 5;

SELECT *
FROM skills_dim
LIMIT 5;

/* find top 5 skills mentioned in job_postings */

WITH skill_table AS(
        SELECT skill_id, COUNT(job_id) AS count
        FROM skills_job_dim
        GROUP BY skill_id
)

SELECT skills_dim.skills, count
FROM skill_table
LEFT JOIN skills_dim ON skill_table.skill_id = skills_dim.skill_id
ORDER BY count DESC;

SELECT *
FROM job_postings_fact
LIMIT 5;

/*SELECT
    company_id,
    COUNT(job_id) AS count,

    CASE
        WHEN count < 10 THEN 'small'
        WHEN count > 50 THEN 'large'
        ELSE 'medium'
    END AS company_category

FROM job_postings_fact
GROUP BY company_id;*/

WITH company_category_table AS (
    SELECT
    company_id,
    COUNT(job_id) AS count,

    CASE
        WHEN COUNT(job_id) < 10 THEN 'small'
        WHEN COUNT(job_id) > 50 THEN 'large'
        ELSE 'medium'
    END AS company_category

FROM job_postings_fact
GROUP BY company_id
)

SELECT 
    company_category_table.company_id, 
    company_category_table.company_category, 
    company_dim.name, 
    company_category_table.count
FROM company_category_table
LEFT JOIN company_dim ON company_category_table.company_id = company_dim.company_id;


/*WITH remote_jobs_table AS(
    SELECT
    job_id,
    job_title_short
FROM job_postings_fact
WHERE job_work_from_home = TRUE
)

SELECT skills_dim.skills, COUNT(remote_jobs_table.job_id) AS count
FROM skills_job_dim
LEFT JOIN remote_jobs_table ON skills_job_dim.job_id = remote_jobs_table.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY skills_job_dim.skill_id, skills_dim.skills
ORDER BY count DESC;
LIMIT 5;*/

WITH remote_jobs_table AS(
    SELECT
    job_id,
    job_title_short
FROM job_postings_fact
WHERE job_work_from_home = TRUE
)

SELECT skills_dim.skills, COUNT(remote_jobs_table.job_id) AS count
FROM skills_job_dim
INNER JOIN remote_jobs_table ON skills_job_dim.job_id = remote_jobs_table.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY skills_job_dim.skill_id, skills_dim.skills
ORDER BY count DESC;
LIMIT 5;


/* tried to use only sub query and do same as above.
This gives the 'skills' only. can't get any count like previous one above

SELECT skills
FROM skills_dim
WHERE skill_id IN (

    SELECT skill_id 
    FROM skills_job_dim
    WHERE job_id IN (

        SELECT job_id
        FROM job_postings_fact
        WHERE job_work_from_home = TRUE
));*/

SELECT *
FROM january_jobs;