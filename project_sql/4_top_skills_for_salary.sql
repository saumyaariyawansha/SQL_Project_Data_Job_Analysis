/* What are the top skills based on salary for Data Analysts
    1.look at the avg salary associated with each skill  for Data Analyst positions
    2.Focus on salaries with specified roles regardless of the location 
    3. WHY? it reveals how different skills impact salary levels for Data Analysts 
        and helps identify the most financially rewarding skills to acquire or improve*/


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