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
   - Each review contains a reviewer name, a score (1–10), and optional comments.  
   - Multiple reviews per paper were included to support aggregation and ranking queries.