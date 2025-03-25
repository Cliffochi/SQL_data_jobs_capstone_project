/* 
Answer: 
- What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Scientist positions 
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Scientist and
- helps identify the most financially rewarding skills to acquire or improve
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Scientist' AND
    salary_year_avg IS NOT NULL
    -- job_work_from_home = True
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25

/*
Some insights from the results:
As a beginner in data science, here are some key insights you can extract from this dataset:

1. Top-Paying Skills
The highest-paying skill in this dataset is Asana with an average salary of $215,477, followed by Airtable ($201,143) and RedHat ($189,500).
This suggests that proficiency in project management tools (Asana, Airtable), cloud computing (RedHat), and AI platforms (Watson) can lead to high-paying jobs.
2. Emerging & Niche Technologies Pay Well
Skills like Solidity (used in blockchain development) and Elixir (a functional programming language) command high salaries.
Neo4j (a graph database), Hugging Face (AI and NLP), and DynamoDB (a NoSQL database) also show strong earning potential.
This suggests that expertise in specialized or less common technologies can lead to better salaries.
3. The Role of AI & Data Engineering
Hugging Face (a popular NLP library), Airflow (workflow automation), and BigQuery (Google’s data warehouse) are all well-paid, showing the growing importance of AI, automation, and cloud-based data solutions.
If you’re interested in AI and machine learning, learning these tools could be beneficial.
4. Game Development & Web Technologies are Rewarding
Unity ($156,881) and Unreal ($153,278) show that game development skills can be lucrative.
Ruby on Rails ($166,500) remains a high-paying web framework, despite being older.
5. Cloud & DevOps Pay Well
AWS DynamoDB, Google BigQuery, and CodeCommit (AWS Git repository) highlight the importance of cloud computing and DevOps in high-paying roles.
What You Can Learn from This as a Beginner
Pick a high-paying skill to focus on – Python and SQL are great starting points, but you might also explore BigQuery, Hugging Face, or Solidity if you’re interested in specialized fields.
Cloud computing and AI are in demand – Learning AWS, BigQuery, or machine learning libraries (like Hugging Face) can increase your job prospects.
Niche skills command high salaries – Functional programming (Elixir, Haskell), blockchain (Solidity), and graph databases (Neo4j) are great options if you want to stand out.
*/