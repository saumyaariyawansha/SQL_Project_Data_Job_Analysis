/* find job postings from First quarter, JAN-MAR, with salary >70,000 
    -combine job postings from first quarter of 2023 
    -get job postings with avg yearly salary > 70,000 */

SELECT 
    --job_title_short,
    job_location,
    job_via,
    job_posted_date::DATE,
    salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
)
AS quarter1_job_postings

WHERE salary_year_avg >70000 AND job_title_short = 'Data Analyst'
ORDER BY salary_year_avg DESC;

/* get the skill and skill type for each job posting in JAN-MAR
    including the job postings wihtout any skills too
    look at the skill and type for each job posting with salary >70,000 */

WITH quarter1_jobs AS (
    SELECT 
        job_id,
        job_title_short,
        salary_year_avg
    FROM (
        SELECT *
        FROM january_jobs
        UNION ALL
        SELECT *
        FROM february_jobs
        UNION ALL
        SELECT *
        FROM march_jobs
    )
    WHERE salary_year_avg >70000
    ORDER BY salary_year_avg DESC
)

SELECT quarter1_jobs.job_title_short, skills_dim.skills, skills_dim.type, quarter1_jobs.salary_year_avg
FROM quarter1_jobs
LEFT JOIN skills_job_dim ON quarter1_jobs.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id;