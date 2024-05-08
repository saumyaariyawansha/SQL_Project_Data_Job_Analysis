/* What are the optimal skiils to learn
    Optimal = high demand and high paying 
        1.identify skills with highest no of job postings and highest avg salaries for Data Analyst roles
        2. concentrate on remote positions with specified salaries
        3. WHY? Targets skills that offer job security (high demand) and financial benefits (high salary),
            offering strategic insights for career development in Data Analysis */

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
--ORDER BY yearly_avg_salary DESC
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



