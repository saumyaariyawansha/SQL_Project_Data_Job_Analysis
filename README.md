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
- **SQL**
- **PostgreSQL** The database management system
- **VisualStudioCode** database managemtn and execution of SQL queries
- **Git & Github:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
### 1. Top Paying Data Analyst jobs
To identify high paying jobs I filtered the Data Analyst positioins by average yearly salary.

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

# What I learned
# Conclusions