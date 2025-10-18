--------------------------------------- CRUD Operations ----------------------------
UPDATE institutions
SET country = 'United States'
WHERE country = 'USA';

Select * 
from institutions
where country = 'United States';


-- Add LIMIT example (top 5 papers by average score)
SELECT p.title, AVG(r.score) AS avg_score
FROM papers p
LEFT JOIN reviews r ON p.paper_id = r.paper_id
GROUP BY p.paper_id
ORDER BY avg_score DESC
LIMIT 5;

-- Add UNION example (papers that are Accepted or Rejected)
SELECT title, paper_status FROM papers WHERE paper_status = 'Accepted'
UNION
SELECT title, paper_status FROM papers WHERE paper_status = 'Rejected';

/*
 * List all authors with their institution
 */

SELECT a.author_id, a.full_name, a.field_of_research, i.name AS institution
FROM authors a
JOIN institutions i ON a.inst_id = i.inst_id
ORDER BY a.full_name;


/*
 * List all papers with author name and institution
 * 
 * Combines 3 tables
   Can be used to see full hierarchy: paper → author → institution
 */
SELECT p.paper_id, p.title, p.paper_status, p.submission_date,
       a.full_name AS author, i.name AS institution
FROM papers p
JOIN authors a ON p.author_id = a.author_id
JOIN institutions i ON a.inst_id = i.inst_id
ORDER BY p.submission_date;

/*
 * 
 * Count papers per institution
LEFT JOIN: shows institutions even if they have no papers
COUNT: total papers
GROUP BY: aggregates by institution
ORDER BY: largest number of papers first
 */

SELECT i.name AS institution,
       COUNT(p.paper_id) AS total_papers
FROM institutions i
LEFT JOIN authors a ON i.inst_id = a.inst_id
LEFT JOIN papers p ON a.author_id = p.author_id
GROUP BY i.inst_id
ORDER BY total_papers DESC;

/*
 * Count papers per author
 * 
 * HAVING: filters after aggregation (authors with at least 1 paper)
 */

SELECT a.full_name AS author,
       COUNT(p.paper_id) AS num_papers
FROM authors a
LEFT JOIN papers p ON a.author_id = p.author_id
GROUP BY a.author_id
HAVING COUNT(p.paper_id) > 0
ORDER BY num_papers DESC;

/*
 * Average review score per paper
 * 
 * AVG: average review score

COUNT: number of reviews

Shows which papers are highly rated
 */
SELECT p.title, AVG(r.score) AS avg_score, COUNT(r.review_id) AS num_reviews
FROM papers p
LEFT JOIN reviews r ON p.paper_id = r.paper_id
GROUP BY p.paper_id
ORDER BY avg_score DESC;

/*Papers under review */
SELECT p.title, a.full_name AS author,p.paper_status, i.name AS institution
FROM papers p
JOIN authors a ON p.author_id = a.author_id
JOIN institutions i ON a.inst_id = i.inst_id
WHERE p.paper_status = 'Under Review'
ORDER BY p.submission_date;

/* Categorize papers by average review score */
SELECT 
    p.title,
    AVG(r.score) AS avg_score,
    CASE 
        WHEN AVG(r.score) >= 9 THEN 'Outstanding'
        WHEN AVG(r.score) BETWEEN 7 AND 8.99 THEN 'Strong'
        WHEN AVG(r.score) BETWEEN 5 AND 6.99 THEN 'Moderate'
        ELSE 'Needs Improvement'
    END AS review_category
FROM papers p
LEFT JOIN reviews r ON p.paper_id = r.paper_id
GROUP BY p.paper_id
ORDER BY avg_score DESC;


/* Rank papers by their average review score (RANK() Window Function) 
 * Purpose:
Uses RANK() to assign ranking positions based on review performance.
Window functions are calculated without collapsing data like GROUP BY. */
SELECT 
    p.title,
    AVG(r.score) AS avg_score,
    RANK() OVER (ORDER BY AVG(r.score) DESC) AS ranking
FROM papers p
LEFT JOIN reviews r ON p.paper_id = r.paper_id
GROUP BY p.paper_id;


/* Assign row numbers to authors */
SELECT 
    ROW_NUMBER() OVER (ORDER BY full_name) AS row_num,
    full_name,
    field_of_research,
    inst_id
FROM authors;


/* Common Table Expression (CTE) — Find institutions with average paper score above 8   */
WITH paper_scores AS (
    SELECT 
        p.paper_id,
        a.inst_id,
        AVG(r.score) AS avg_score
    FROM papers p
    JOIN authors a ON p.author_id = a.author_id
    LEFT JOIN reviews r ON p.paper_id = r.paper_id
    GROUP BY p.paper_id
)
SELECT 
    i.name AS institution,
    ROUND(AVG(ps.avg_score), 2) AS institution_avg_score
FROM paper_scores ps
JOIN institutions i ON ps.inst_id = i.inst_id
GROUP BY i.inst_id
HAVING institution_avg_score > 8
ORDER BY institution_avg_score DESC;

/* Null handling 
 * If a paper has no reviews, its average score shows as 0 instead of NULL.*/
SELECT 
    p.title,
    COALESCE(AVG(r.score), 0) AS avg_score
FROM papers p
LEFT JOIN reviews r ON p.paper_id = r.paper_id
GROUP BY p.paper_id;

/* Date function example */
SELECT 
    title,
    submission_date,
    strftime('%m', submission_date) AS submission_month,
    strftime('%Y', submission_date) AS submission_year
FROM papers
ORDER BY submission_date;







