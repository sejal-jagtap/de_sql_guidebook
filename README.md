# 📘 SQL Guidebook Project — Research Paper Database


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

NOTE:
**Why use primary and foreign keys?**
- Primary and foreign key constraints ensure **referential integrity**.

**Why use 'NOT NULL'?**
- `NOT NULL` constraints prevent missing critical information.

**Why use 'CHECK'?**
- CHECK constraints enforce valid values for paper status and review scores.

## ⚙️ SQL Operations

**1. Update Command**

Updates the country name from 'USA' to 'United States' to ensure data consistency. Use SELECT to view if the UPDATE was successful.

```sql
UPDATE institutions
SET country = 'United States'
WHERE country = 'USA';

SELECT * 
FROM institutions
WHERE country = 'United States';
```

Q. Which are the top 5 highest-rated papers? 

**2. LIMIT Command**

```sql
SELECT p.title, AVG(r.score) AS avg_score
FROM papers p
LEFT JOIN reviews r ON p.paper_id = r.paper_id
GROUP BY p.paper_id
ORDER BY avg_score DESC
LIMIT 5;
```

Q. How to combine Accepted and Rejected papers into a single list? 

**3. UNION Command**

```sql
SELECT title, paper_status FROM papers WHERE paper_status = 'Accepted'
UNION
SELECT title, paper_status FROM papers WHERE paper_status = 'Rejected';
```

Q. Which authors are affiliated with which institutions? 

**4. JOIN and ORDER BY Command**

```sql
SELECT a.author_id, a.full_name, a.field_of_research, i.name AS institution
FROM authors a
JOIN institutions i ON a.inst_id = i.inst_id
ORDER BY a.full_name;
```

Q. What are the details of each paper along with its author and institution? 

**5. Multi-table JOIN Command**

```sql 
SELECT p.paper_id, p.title, p.paper_status, p.submission_date,
       a.full_name AS author, i.name AS institution
FROM papers p
JOIN authors a ON p.author_id = a.author_id
JOIN institutions i ON a.inst_id = i.inst_id
ORDER BY p.submission_date;
```

Q. How many papers has each institution published? 

**6. LEFT JOIN, COUNT, GROUP BY Command**

```sql
SELECT i.name AS institution,
       COUNT(p.paper_id) AS total_papers
FROM institutions i
LEFT JOIN authors a ON i.inst_id = a.inst_id
LEFT JOIN papers p ON a.author_id = p.author_id
GROUP BY i.inst_id
ORDER BY total_papers DESC;
```

Q. How many papers has each author written?  

**7. HAVING, GROUP BY Command**

```sql
SELECT a.full_name AS author,
       COUNT(p.paper_id) AS num_papers
FROM authors a
LEFT JOIN papers p ON a.author_id = p.author_id
GROUP BY a.author_id
HAVING COUNT(p.paper_id) > 0
ORDER BY num_papers DESC;
```

Q. What are the average review scores for each paper?  

**8. AVG, COUNT, GROUP BY Command**

```sql
SELECT p.title, AVG(r.score) AS avg_score, COUNT(r.review_id) AS num_reviews
FROM papers p
LEFT JOIN reviews r ON p.paper_id = r.paper_id
GROUP BY p.paper_id
ORDER BY avg_score DESC;
```

Q. Which papers are currently under review?  

**9. WHERE, ORDER BY Command**

```sql
SELECT p.title, a.full_name AS author,p.paper_status, i.name AS institution
FROM papers p
JOIN authors a ON p.author_id = a.author_id
JOIN institutions i ON a.inst_id = i.inst_id
WHERE p.paper_status = 'Under Review'
ORDER BY p.submission_date;
```

Q. How can papers be categorized by their average score? 

**10. CASE WHEN, GROUP BY Command**

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

What is the ranking of papers based on review scores? 

**11. RANK() OVER, Window Functions**
 
```sql
SELECT 
    p.title,
    AVG(r.score) AS avg_score,
    RANK() OVER (ORDER BY AVG(r.score) DESC) AS ranking
FROM papers p
LEFT JOIN reviews r ON p.paper_id = r.paper_id
GROUP BY p.paper_id;
```

Q. How can authors be sequentially ordered? 

**12. ROW_NUMBER(), Window Functions**

```sql
SELECT 
    ROW_NUMBER() OVER (ORDER BY full_name) AS row_num,
    full_name,
    field_of_research,
    inst_id
FROM authors;
```

Q. Which institutions have the highest average paper ratings?  

**13. CTE (WITH), Aggregates, HAVING**

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

Q. How to handle missing review data gracefully? 

**14. COALESCE Command**

```sql
SELECT 
    p.title,
    COALESCE(AVG(r.score), 0) AS avg_score
FROM papers p
LEFT JOIN reviews r ON p.paper_id = r.paper_id
GROUP BY p.paper_id;
```

#### Q. How to extract month and year from paper submission dates?  

**Date functions (`strftime`)**

```sql
SELECT 
    title,
    submission_date,
    strftime('%m', submission_date) AS submission_month,
    strftime('%Y', submission_date) AS submission_year
FROM papers
ORDER BY submission_date;
```
