--Most demanding skills for Data Analyst jobs. most demanding = highest no of job postings

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