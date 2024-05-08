--Top paying jobs in Data Analyst job roles.

SELECT
    job_title,
    job_title_short,
    salary_year_avg
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;


--Top paying jobs, and the skills required for those jobs

/*if we do like this and add the limit as the final line, it won't give proper result. 
same job can have more than one skill. so when we truncate by adding a LIMIT we might have one or two jobs only.
BUt our intention is to find the top paying jobs and then list the skills required for those.
best way is to use CTE and then do the JOIN to get related skill*/
SELECT
    job_postings_fact.job_title,
    job_postings_fact.job_title_short,
    job_postings_fact.salary_year_avg,
    skills_dim.skills
FROM job_postings_fact
LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;

----Top paying jobs, and the skills required for those jobs

WITH top_paying_jobs AS(
    SELECT
        job_id,
        job_title,
        job_title_short,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.job_title,
    top_paying_jobs.job_title_short,
    top_paying_jobs.salary_year_avg,
    skills_dim.skills
FROM top_paying_jobs
LEFT JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id


-- most in demand skills for Data Analyst roles

SELECT
    skills,
    COUNT(job_postings_fact.job_id) AS number_of_jobs
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY number_of_jobs DESC
LIMIT 10;


--top skills based on salary for Data Analyst roles

SELECT
    skills,
    ROUND(AVG(salary_year_avg),0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE salary_year_avg IS NOT NULL AND job_title_short = 'Data Analyst'
GROUP BY skills
ORDER BY average_salary DESC
LIMIT 10;

-- optimal skills to learn. top skills based on demand and salary for Data Analyst roles
--combine the above two tables

SELECT
    skills,
    COUNT(job_postings_fact.job_id) AS number_of_jobs,
    ROUND(AVG(salary_year_avg),0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE salary_year_avg IS NOT NULL AND job_title_short = 'Data Analyst'
GROUP BY skills
HAVING COUNT(job_postings_fact.job_id) >10
ORDER BY average_salary DESC, number_of_jobs DESC
LIMIT 20;