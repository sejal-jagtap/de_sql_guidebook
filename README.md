# 📘 SQL Guidebook — Research Paper Database

## 🧩 Overview  
This project demonstrates **SQL fundamentals and advanced data manipulation** using a research publication dataset.  
The database models relationships between institutions, authors, research papers, and reviews.

The SQL work explores:
- Database creation, population, and updates.  
- Core query operations (SELECT, WHERE, ORDER BY, GROUP BY, HAVING).  
- Aggregations and JOINs.  
- Data cleaning and transformation (CASE WHEN, COALESCE). 
- Analytical SQL using window functions and CTEs. 
- Independently explored features (Date functions, Window LAG/LEAD, LIMIT, UNION).

---

## 📁 Project Structure

    de_sql_guidebook/
         |-- Dataset.sql
         |-- Queries.sql
         `-- README.md

---

## 🗂 Dataset Creation

For this project, a **sample dataset** was manually created to simulate a research publication environment. Four related tables were designed following **database design best practices**:

1. **Institutions**
   
   - Each institution has a unique `inst_id` (auto-incremented primary key), a name, and a country.  
   - Explicit `inst_id` values were inserted to ensure that foreign key references from authors are never NULL.
  
```sql
           CREATE TABLE IF NOT EXISTS institutions (
             inst_id   INTEGER PRIMARY KEY AUTOINCREMENT, -- cannot be NULL
             name      VARCHAR(150) NOT NULL,
             country   VARCHAR(100) NOT NULL
         );

            INSERT INTO institutions (inst_id, name, country) VALUES
            (1, 'Massachusetts Institute of Technology', 'USA'),
            (2, 'Stanford University', 'USA'),
            (3, 'Harvard University', 'USA'),
            (4, 'Indian Institute of Technology Bombay', 'India'),
            (5, 'Indian Institute of Science', 'India'),
            (6, 'University of Oxford', 'United Kingdom'),
            (7, 'University of Cambridge', 'United Kingdom'),
            (8, 'ETH Zurich', 'Switzerland'),
            (9, 'National University of Singapore', 'Singapore'),
            (10, 'Tsinghua University', 'China');
```

<img width="330" height="182" alt="create_institutions" src="https://github.com/user-attachments/assets/0ac59b06-a33d-4f15-9c7e-aa30731c9dbe" />


2. **Authors**
   
   - Authors are linked to institutions via `inst_id` (foreign key).  
   - Each author has a unique `author_id`, full name, and field of research.  
   - Sample authors cover various research domains such as Machine Learning, Computer Vision, NLP, Robotics, and AI Ethics.
  
```sql
         CREATE TABLE IF NOT EXISTS authors (
          author_id         INTEGER PRIMARY KEY AUTOINCREMENT,
          full_name         VARCHAR(100) NOT NULL,
          field_of_research VARCHAR(100) NOT NULL,
          inst_id           INTEGER NOT NULL,
          FOREIGN KEY (inst_id) REFERENCES institutions(inst_id)
         );
         
         -- inserts referencing explicit inst_id
         INSERT INTO authors (full_name, field_of_research, inst_id) VALUES
         ('Alice Kim', 'Machine Learning', 1),
         ('Rohan Mehta', 'Computer Vision', 4),
         ('Lina Zhao', 'Natural Language Processing', 6),
         ('Ethan Ross', 'Robotics', 2),
         ('Sofia Martinez', 'AI Ethics', 3),
         ('Chen Wei', 'Computer Vision', 10);
```

<img width="392" height="116" alt="create_authors" src="https://github.com/user-attachments/assets/79f0f838-6ee2-4aea-aa30-e9d6669b27b3" />


3. **Papers**
   
   - Papers are associated with authors using `author_id` as a foreign key.  
   - Each paper has a unique `paper_id`, title, submission date, and status (`Under Review`, `Accepted`, or `Rejected`).  
   - This table models research output for each author.

```sql
         CREATE TABLE IF NOT EXISTS papers (
             paper_id        INTEGER PRIMARY KEY AUTOINCREMENT,
             title           VARCHAR(200) NOT NULL,
             submission_date DATE NOT NULL,
             paper_status    VARCHAR(50) NOT NULL CHECK (paper_status IN ('Under Review','Accepted','Rejected')),
             author_id       INTEGER NOT NULL,
             FOREIGN KEY (author_id) REFERENCES authors(author_id)
         );
         
         INSERT INTO papers (title, submission_date, paper_status, author_id) VALUES
         ('Quantum-Inspired Neural Networks', '2024-01-15', 'Accepted', 1),
         ('Self-Supervised Learning for Images', '2024-02-01', 'Under Review', 2),
         ('AI Ethics in Language Models', '2024-02-10', 'Rejected', 3),
         ('Autonomous Drone Navigation', '2024-03-01', 'Accepted', 4),
         ('Prompt Engineering for LLMs', '2024-03-12', 'Under Review', 3),
         ('Ethical AI for Social Media', '2024-03-20', 'Under Review', 5),
         ('Vision Transformers in Action', '2024-03-25', 'Accepted', 6);
```

<img width="560" height="133" alt="create_papers" src="https://github.com/user-attachments/assets/7872c89f-feb7-46f2-9b4e-19eb4de007a7" />

4. **Reviews**
   
   - Reviews are linked to papers via `paper_id`.  
   - Each review contains a reviewer's name, a score (1–10), and optional comments.  
   - Multiple reviews per paper were included to support aggregation and ranking queries.

```sql
         CREATE TABLE IF NOT EXISTS reviews (
             review_id     INTEGER PRIMARY KEY AUTOINCREMENT,
             paper_id      INTEGER NOT NULL,
             reviewer_name VARCHAR(100) NOT NULL,
             score         INTEGER NOT NULL CHECK (score BETWEEN 1 AND 10),
             comments      TEXT,
             FOREIGN KEY (paper_id) REFERENCES papers(paper_id)
         );
         
         INSERT INTO reviews (paper_id, reviewer_name, score, comments) VALUES
         (1, 'Dr. Smith', 9, 'Innovative work with strong theoretical foundations.'),
         (1, 'Dr. Brown', 8, 'Solid contribution and clear presentation.'),
         (2, 'Dr. Clark', 7, 'Interesting results, needs more ablation studies.'),
         (3, 'Dr. Kim', 5, 'Important ethical perspective, but lacks depth.'),
         (4, 'Dr. Lee', 10, 'Outstanding work, highly recommended for acceptance.'),
         (4, 'Dr. Adams', 9, 'Strong experimental design and clarity.'),
         (5, 'Dr. White', 8, 'Promising idea, worth exploring further.'),
         (6, 'Dr. Johnson', 7, 'Important societal angle, minor revisions needed.'),
         (7, 'Dr. Green', 9, 'Excellent experimental setup, clear results.');
```

<img width="560" height="133" alt="create_papers" src="https://github.com/user-attachments/assets/32b72c69-d14f-458a-a104-e4347eb3f52f" />

### Key Considerations:

**Why use primary and foreign keys?**
- Primary and foreign key constraints ensure **referential integrity**.

**Why use 'NOT NULL'?**
- `NOT NULL` constraints prevent missing critical information.

**Why use 'CHECK'?**
- CHECK constraints enforce valid values for paper status and review scores.

---

## ⚙️ SQL Operations

### Q1. How to update institution names and confirm changes?

**Update Command**

Explanation:
The UPDATE statement is used to modify existing records in a table. In this case, we correct the country names labeled “USA” to “United States.” The WHERE clause ensures only rows meeting this condition are affected (avoid running updates without WHERE, or all rows will change). After updating, use a SELECT query to verify that the changes were applied correctly.

✅ Note: Always back up data or test updates using SELECT first to confirm the filter is accurate.

```sql
UPDATE institutions
SET country = 'United States'
WHERE country = 'USA';

SELECT * 
FROM institutions
WHERE country = 'United States';
```

<img width="329" height="71" alt="update_1" src="https://github.com/user-attachments/assets/09b7352b-80b6-4b48-b88f-0371c8c6b620" />

### Q2. Which are the top 5 highest-rated papers? 

**LIMIT Command**

Explanation:
We calculate the average review score for each paper by joining the papers and reviews tables on their paper_id. The AVG() function computes the mean score, while ORDER BY DESC sorts the results from highest to lowest. The LIMIT 5 ensures only the top 5 papers appear.

✅ Note: Use LEFT JOIN so papers with missing reviews don’t get excluded.

```sql
SELECT p.title, AVG(r.score) AS avg_score
FROM papers p
LEFT JOIN reviews r ON p.paper_id = r.paper_id
GROUP BY p.paper_id
ORDER BY avg_score DESC
LIMIT 5;
```

<img width="247" height="104" alt="top 5 papers based on avg score" src="https://github.com/user-attachments/assets/bad60de6-12da-43fc-ab08-d3947d9e2369" />


### Q3. How to combine Accepted and Rejected papers into a single list? 

**UNION Command**

Explanation:
UNION merges results from multiple queries and automatically removes duplicates. Here, it combines “Accepted” and “Rejected” papers into one unified list.

✅ Note: If you want to include duplicates, use UNION ALL.

```sql
SELECT title, paper_status FROM papers WHERE paper_status = 'Accepted'
UNION
SELECT title, paper_status FROM papers WHERE paper_status = 'Rejected';
```

<img width="256" height="89" alt="papers accepted and rejected" src="https://github.com/user-attachments/assets/6aaf8ee3-bc3e-4e18-972f-8387142a1040" />

### Q4. How to display each author’s institution and research field?

**JOIN and ORDER BY Command**

Explanation:
The INNER JOIN connects authors with their respective institutions via inst_id. It displays each author’s name, field of research, and affiliated institution, sorted alphabetically by author.

✅ Note: INNER JOIN excludes authors with no institution; use LEFT JOIN if you want to include them.

```sql
SELECT a.author_id, a.full_name, a.field_of_research, i.name AS institution
FROM authors a
JOIN institutions i ON a.inst_id = i.inst_id
ORDER BY a.full_name;
```

<img width="468" height="117" alt="q4" src="https://github.com/user-attachments/assets/f3a4c301-cb52-4b20-97da-5d0938918e11" />

### Q5. How to list all papers with author names and their institutions? 

**Multi-table JOIN Command**

Explanation:
By joining papers, authors, and institutions, this query builds a complete paper record with author and institution details. Sorting by submission_date helps track chronological order.

✅ Note: Ensure that the join keys (author_id, inst_id) have matching data types.

```sql 
SELECT p.paper_id, p.title, p.paper_status, p.submission_date,
       a.full_name AS author, i.name AS institution
FROM papers p
JOIN authors a ON p.author_id = a.author_id
JOIN institutions i ON a.inst_id = i.inst_id
ORDER BY p.submission_date;
```

<img width="608" height="135" alt="List all papers with author name and institution" src="https://github.com/user-attachments/assets/db1ed402-e053-4944-b1c3-ce037ca17a16" />

### Q6. How to count total papers published per institution?

**LEFT JOIN, COUNT, GROUP BY Command**

Explanation:
This query counts papers per institution, even if some institutions have zero papers. The double LEFT JOIN ensures all institutions are listed.

✅ Note: COUNT(column) ignores NULLs; use COUNT(*) if you want to count all rows.

```sql
SELECT i.name AS institution,
       COUNT(p.paper_id) AS total_papers
FROM institutions i
LEFT JOIN authors a ON i.inst_id = a.inst_id
LEFT JOIN papers p ON a.author_id = p.author_id
GROUP BY i.inst_id
ORDER BY total_papers DESC;
```

<img width="265" height="179" alt="total_papers" src="https://github.com/user-attachments/assets/05409a5e-3086-482f-848a-fc3d2b5df0b0" />

### Q7. How to count how many papers each author has written?

**HAVING, GROUP BY Command**

Explanation:
Grouping by each author, we count how many papers they’ve written. The HAVING clause filters out authors with zero papers.

✅ Note: HAVING is used for conditions on aggregated data (unlike WHERE).

```sql
SELECT a.full_name AS author,
       COUNT(p.paper_id) AS num_papers
FROM authors a
LEFT JOIN papers p ON a.author_id = p.author_id
GROUP BY a.author_id
HAVING COUNT(p.paper_id) > 0
ORDER BY num_papers DESC;
```

<img width="182" height="119" alt="papers per author" src="https://github.com/user-attachments/assets/40521583-9985-4dde-a886-bda17f99ddc7" />

### Q8. How to calculate average review score per paper? 

**AVG, COUNT, GROUP BY Command**

Explanation:
This computes the mean score and total number of reviews per paper. LEFT JOIN keeps papers that may not yet have reviews.

✅ Note: To handle missing reviews, wrap AVG(r.score) in COALESCE() to replace NULLs.

```sql
SELECT p.title, AVG(r.score) AS avg_score, COUNT(r.review_id) AS num_reviews
FROM papers p
LEFT JOIN reviews r ON p.paper_id = r.paper_id
GROUP BY p.paper_id
ORDER BY avg_score DESC;
```
<img width="349" height="136" alt="review score per paper" src="https://github.com/user-attachments/assets/d06946a9-c05f-4631-9ffb-97ea6eb947dc" />


### Q9. Which papers are currently under review?  

**WHERE, ORDER BY Command**

Explanation:
Filters papers with a status of “Under Review,” while joining author and institution data for complete context.

✅ Note: Ensure consistent casing (e.g., ‘Under Review’ vs ‘under review’) since SQL is case-sensitive in some databases.

```sql
SELECT p.title, a.full_name AS author,p.paper_status, i.name AS institution
FROM papers p
JOIN authors a ON p.author_id = a.author_id
JOIN institutions i ON a.inst_id = i.inst_id
WHERE p.paper_status = 'Under Review'
ORDER BY p.submission_date;
```

<img width="502" height="68" alt="papers under review" src="https://github.com/user-attachments/assets/8dec5650-3ac4-4422-9def-7ea471cdf3a1" />

### Q10. How to categorize papers by average score?

**CASE WHEN, GROUP BY Command**

Explanation:
The CASE WHEN expression creates dynamic labels based on score ranges. It groups each paper into performance categories like Outstanding or Needs Improvement.

✅ Note: CASE logic executes top-down — the first true condition is applied.

```sql
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
```

<img width="361" height="137" alt="categ paers by average review score" src="https://github.com/user-attachments/assets/7bbdf8f3-c025-48c2-82b6-6e567c86e4ac" />

### Q11. How to rank papers by their average scores?

**RANK() OVER, Window Functions**

Explanation:
RANK() assigns a rank to each paper based on the average score. Papers with identical scores receive the same rank, and the next rank is skipped accordingly.

✅ Note: Use DENSE_RANK() if you don’t want rank gaps after ties.
 
```sql
SELECT 
    p.title,
    AVG(r.score) AS avg_score,
    RANK() OVER (ORDER BY AVG(r.score) DESC) AS ranking
FROM papers p
LEFT JOIN reviews r ON p.paper_id = r.paper_id
GROUP BY p.paper_id;
```

<img width="331" height="136" alt="rank papers by avg review score" src="https://github.com/user-attachments/assets/987b72e7-aef9-4b90-8a4a-7642ebb8dc60" />

### Q12. How can authors be sequentially ordered? 

**ROW_NUMBER(), Window Functions**

Explanation:
ROW_NUMBER() generates a unique sequential number for each row based on a specified order — useful for pagination or indexing.

✅ Note: Unlike RANK(), ROW_NUMBER() doesn’t handle ties — every row gets a unique number.

```sql
SELECT 
    ROW_NUMBER() OVER (ORDER BY full_name) AS row_num,
    full_name,
    field_of_research,
    inst_id
FROM authors;
```

<img width="392" height="121" alt="assign row numbers to authors" src="https://github.com/user-attachments/assets/261e8946-4b3d-49df-86b2-9420eeac1bb6" />

### Q13. Which institutions have the highest average paper ratings?  

**CTE (WITH), Aggregates, HAVING**

Explanation:
A Common Table Expression (CTE) helps break complex queries into logical steps. First, calculate each paper’s average score inside the CTE. Then, average those scores per institution, showing only those with institutional averages above 8.

✅ Note: Use ROUND() to format decimals neatly and HAVING to filter aggregated results.

```sql
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
```

<img width="296" height="69" alt="papers with score above 8" src="https://github.com/user-attachments/assets/78dd9b12-2f4a-41cd-aee6-021d134126e1" />

### Q14. How to handle missing scores and replace NULL with 0?

**COALESCE Command**

Explanation:
COALESCE() returns the first non-NULL value in its arguments. Replacing NULL scores with 0 avoids issues in calculations and ensures complete reporting.

✅ Note: Use COALESCE() instead of IFNULL() for better portability across databases.

```sql
SELECT 
    p.title,
    COALESCE(AVG(r.score), 0) AS avg_score
FROM papers p
LEFT JOIN reviews r ON p.paper_id = r.paper_id
GROUP BY p.paper_id;
```

<img width="245" height="134" alt="image" src="https://github.com/user-attachments/assets/134ac8f4-95c9-49f6-9ae0-838e8d23afb0" />

### Q15. How to extract month and year from submission dates?

**Date functions (`strftime`)**

Explanation:
SQLite’s strftime() formats dates — here, it extracts submission month (%m) and year (%Y) from the submission_date. This helps group or analyze submissions by time periods.

✅ Note: In other SQL engines, use equivalents like EXTRACT(MONTH FROM date_column) or TO_CHAR() in PostgreSQL.

```sql
SELECT 
    title,
    submission_date,
    strftime('%m', submission_date) AS submission_month,
    strftime('%Y', submission_date) AS submission_year
FROM papers
ORDER BY submission_date;
```

<img width="523" height="131" alt="date function" src="https://github.com/user-attachments/assets/96411f08-3702-4465-b864-964403853d77" />

