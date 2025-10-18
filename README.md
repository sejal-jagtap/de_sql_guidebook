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

