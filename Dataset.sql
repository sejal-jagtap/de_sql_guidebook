-- 1.Institutions Table
CREATE TABLE IF NOT EXISTS institutions (
    inst_id   INTEGER PRIMARY KEY AUTOINCREMENT, -- Cannot be NULL
    name      VARCHAR(150) NOT NULL,
    country   VARCHAR(100) NOT NULL
);

/*
INTEGER PRIMARY KEY AUTOINCREMENT → auto-generated unique ID

NOT NULL → value must be provided

IF NOT EXISTS → avoids error if table already exists
 */

-- Now each institution has a fixed inst_id, so any foreign key reference in authors or other tables will never be NULL.

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


-- 2.Authors Table
CREATE TABLE IF NOT EXISTS authors (
    author_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name         VARCHAR(100) NOT NULL,
    field_of_research VARCHAR(100) NOT NULL,
    inst_id           INTEGER NOT NULL,
    FOREIGN KEY (inst_id) REFERENCES institutions(inst_id)
);

-- Example inserts referencing explicit inst_id
INSERT INTO authors (full_name, field_of_research, inst_id) VALUES
('Alice Kim', 'Machine Learning', 1),
('Rohan Mehta', 'Computer Vision', 4),
('Lina Zhao', 'Natural Language Processing', 6),
('Ethan Ross', 'Robotics', 2),
('Sofia Martinez', 'AI Ethics', 3),
('Chen Wei', 'Computer Vision', 10);


-- 3.Papers Table

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

status VARCHAR(50) NOT NULL CHECK (status IN ('Under Review',' Accepted',' Rejected'))


-- 4.Reviews Table
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


