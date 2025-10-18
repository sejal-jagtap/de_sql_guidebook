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

     <img width="330" height="182" alt="create_institutions" src="https://github.com/user-attachments/assets/0ac59b06-a33d-4f15-9c7e-aa30731c9dbe" />


2. **Authors**  
   - Authors are linked to institutions via `inst_id` (foreign key).  
   - Each author has a unique `author_id`, full name, and field of research.  
   - Sample authors cover various research domains such as Machine Learning, Computer Vision, NLP, Robotics, and AI Ethics.



3. **Papers**  
   - Papers are associated with authors using `author_id` as a foreign key.  
   - Each paper has a unique `paper_id`, title, submission date, and status (`Under Review`, `Accepted`, or `Rejected`).  
   - This table models research output for each author.

4. **Reviews**  
   - Reviews are linked to papers via `paper_id`.  
   - Each review contains a reviewer's name, a score (1–10), and optional comments.  
   - Multiple reviews per paper were included to support aggregation and ranking queries.

**Why use primary and foreign keys?**
- Primary and foreign key constraints ensure **referential integrity**.

**Why use 'NOT NULL'?**
- `NOT NULL` constraints prevent missing critical information.

**Why use 'CHECK'?**
- CHECK constraints enforce valid values for paper status and review scores.


