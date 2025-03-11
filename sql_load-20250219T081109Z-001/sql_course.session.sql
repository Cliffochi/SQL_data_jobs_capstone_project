SELECT job_posted_date
FROM job_postings_fact
LIMIT 10;

-- casting as a date
SELECT job_title_short AS title,
    job_location AS location,
    job_posted_date ::DATE AS date
FROM
job_postings_fact
LIMIT 10;

-- at time zone converts timestamp to a different time zone
-- NOTE for this data set we have to specify the time zone before conversion
SELECT job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EAT' AS date_time
FROM
job_postings_fact
LIMIT 10;

-- EXTRACT - used to get a field from a date/time value e.g year/month/day
SELECT job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EAT' AS date_time,
    TO_CHAR(job_posted_date, 'Day') AS day_name,
    TO_CHAR(job_posted_date, 'Month') AS month_name,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year,
    EXTRACT(DAY FROM job_posted_date) AS date_day
FROM
job_postings_fact
LIMIT 10;

-- example 6 - extracting tables from tables
CREATE TABLE january_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

CREATE TABLE april_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 4;

CREATE TABLE may_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 5;

CREATE TABLE june_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 6;

CREATE TABLE july_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 7;

CREATE TABLE august_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 8;

CREATE TABLE september_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 9;

CREATE TABLE october_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 10;

CREATE TABLE november_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 11;

CREATE TABLE december_jobs AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 12;

-- Case statement
SELECT 
    job_title_short,
    job_location,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New Yor, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact;

 -- using group by to aggregate results from the query above
  SELECT 
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New Yor, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
GROUP BY
    location_category;

-- subquery
SELECT* 
FROM(
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;

--CTES
WITH january_jobs_cte AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)
SELECT *
FROM january_jobs_cte;

SELECT
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT
            company_id
    FROM
            job_postings_fact
    WHERE 
            job_no_degree_mention = true
)

--cte
WITH company_job_count AS (
    SELECT
        company_id,
        COUNT(*) AS number_of_company_jobs
    FROM
        job_postings_fact
    GROUP BY
        company_id
)

-- left join
SELECT 
company_dim.name AS company_name,
company_job_count.number_of_company_jobs
FROM company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY number_of_company_jobs desc;

-- inner join
WITH remote_job_skills AS(
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact as job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE 
        job_postings.job_work_from_home = True AND
        job_postings.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id)

SELECT
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 10;

-- union

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    february_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    march_jobs;

-- union all

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    february_jobs

UNION ALL

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    march_jobs;

SELECT 
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date:: DATE,
    quarter1_job_postings.salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter1_job_postings
WHERE
    quarter1_job_postings.salary_year_avg > 70000 AND
    quarter1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    quarter1_job_postings.salary_year_avg DESC;

-- alternatively

SELECT 
    job_location,
    job_via,
    job_posted_date:: DATE,
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
WHERE
    salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC;

