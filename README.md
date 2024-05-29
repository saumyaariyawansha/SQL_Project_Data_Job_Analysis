# Introduction
This Project explores interesting trends of Data Analyst job market. It helps to identify the top demand and high paying skills for Data Analyst job roles.

SQL Queries? Click here to find out [project_sql folder](/project_sql/)

# Background
This study was developed to answer a set of questions that would be useful to any data analyst. Those questions are as follows:

1. What are the to paying data analyst jobs
2. What skills are required for those jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I used
- **SQL** Most important tool which I used to query the database and uncover meaningful insights.
- **PostgreSQL** Used as the database management system.
- **VisualStudioCode** Used as the code editor for database management and execution of SQL queries.
- **Git & Github:** Essential for version control and sharing my SQL scripts and analysis, ensuring project tracking.

# The Analysis
### 1. Top Paying Data Analyst jobs
To identify highest paying 'Data Analyst' jobs in the market, I filtered the Data Analyst positioins by average yearly salary, further focusing on the working from any remote location.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS Company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE   
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```
### 2. Skills for top paying Data Analyst jobs
To investigate which are the relevant skills needed for top paying 'Data Analyst' jobs that can be performed from remote locations.

```
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS Company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE   
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT top_paying_jobs.*, skills_dim.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```
### 3. Most in demand skills for all Data Analyst job roles
To identify the skills in highest demand for 'Data Analyst', remote job opportunities.

```
SELECT 
    skills, 
    COUNT(skills_job_dim.job_id) AS demand_number_of_jobs
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_postings_fact.job_title_short = 'Data Analyst' AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY demand_number_of_jobs DESC
LIMIT 5;
```

### 4. Top skills based on salary for Data Analysts
The objective was to reveal how different skills impact salary levels for Data Analysts, and to identify the most financially rewarding skills to acquire or improve.

Hence I have calculated the average salary associated with each skill relevant for Data Analyst positions, focusing on salaries with specified roles regardless of the location. 

```
SELECT 
    skills, 
    ROUND(AVG(salary_year_avg),0) AS yearly_avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_postings_fact.job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE

GROUP BY skills
ORDER BY yearly_avg_salary DESC
LIMIT 20;
```

### 5. Optimal skills to learn as Data Analysts
The objective was to identify the high demand and high paying skiils. I have filtered the skills with highest no of job postings and highest avg salaries for Data Analyst role, focusing further on remote job positions with specified salaries.

This analysis provides us with strategic insights for career development in Data Analysis uncovering target skills that offer both job security (high demand) and financial benefits (high salary) in the long run.

```
With skills_demand AS (
    SELECT 
    skills_dim.skill_id,
    skills, 
    COUNT(skills_job_dim.job_id) AS demand_number_of_jobs
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_postings_fact.job_title_short = 'Data Analyst' AND 
    job_work_from_home = TRUE AND
    salary_year_avg IS NOT NULL
GROUP BY skills_dim.skill_id
--ORDER BY demand_number_of_jobs DESC
), avg_salary AS(
    SELECT 
    skills_dim.skill_id,
    skills, 
    ROUND(AVG(salary_year_avg),0) AS yearly_avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_postings_fact.job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE

GROUP BY skills_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_number_of_jobs,
    yearly_avg_salary

FROM skills_demand
INNER JOIN avg_salary ON skills_demand.skill_id = avg_salary.skill_id
WHERE demand_number_of_jobs >10
ORDER BY 
        yearly_avg_salary DESC,
    demand_number_of_jobs DESC;
```




# What I learned
# Conclusions