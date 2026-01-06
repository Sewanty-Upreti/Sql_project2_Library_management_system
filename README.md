# Sql_project2_Library_management_system

Overview
This is my 2nd project of the data analysis which implements a comprehensive Library Management System using MySQL. The system models a library with multiple branches, employees, books, members, issued books, and return records. It includes database creation, table definitions with constraints (primary keys, foreign keys), data insertions, and a series of 20 tasks that demonstrate CRUD operations, data analysis, advanced SQL queries, stored procedures, views, and performance reporting.
The project is divided into separate SQL files for clarity:

create_tables.sql: Contains scripts for creating the database, tables, foreign key constraints, and necessary alterations (e.g., increasing column lengths for contact numbers and categories).
insert_data.sql: Includes all INSERT statements for populating the tables with sample data (members, branches, employees, books, issued_status, and return_status).
tasks.sql: Solves the 20 specified tasks, including CRUD operations, data analysis, CTAS (Create Table As Select), views, stored procedures, and advanced queries for insights like overdue books, branch performance, and member activity.

The database simulates a real-world library scenario, handling book rentals, member registrations, employee management across branches, and tracking issuances/returns. Data is inserted for demonstration, including books from various categories (e.g., Classic, History, Fantasy), members, and issuance records spanning 2021–2024.
Key features:

Relational Integrity: Foreign keys ensure data consistency (e.g., issued books reference valid ISBNs from the books table).
Data Validation: Enumerations (e.g., book status as 'yes'/'no') and alterations to handle longer data values.
Analysis & Reporting: Queries for revenue, overdue books, active members, and employee performance.
Advanced SQL: Stored procedures for book issuance and returns, views for active members, and CTAS for summary tables.

This project serves as a practical example of SQL for database design, manipulation, and querying in a business context like library operations.
Database Schema
The database (library_sql_project_p2) consists of 6 main tables:

branch:
branch_id (VARCHAR(10), PRIMARY KEY)
manager_id (VARCHAR(10))
branch_address (VARCHAR(50))
contact_no (VARCHAR(30))  // Altered to handle longer values

employees:
emp_id (VARCHAR(10), PRIMARY KEY)
emp_name (VARCHAR(25))
position (VARCHAR(20))
salary (FLOAT)
branch_id (VARCHAR(25), FOREIGN KEY references branch.branch_id)

books:
isbn (VARCHAR(20), PRIMARY KEY)
book_title (VARCHAR(55))
category (VARCHAR(75))  // Altered to handle longer values
rental_price (FLOAT)
status (ENUM('yes', 'no'))
author (VARCHAR(35))
publisher (VARCHAR(55))

members:
member_id (VARCHAR(10), PRIMARY KEY)
member_name (VARCHAR(25))
member_address (VARCHAR(55))
reg_date (DATE)

issued_status:
issued_id (VARCHAR(10), PRIMARY KEY)
issued_member_id (VARCHAR(10), FOREIGN KEY references members.member_id)
issued_book_name (VARCHAR(75))
issued_date (DATE)
issued_book_isbn (VARCHAR(25), FOREIGN KEY references books.isbn)
issued_emp_id (VARCHAR(10), FOREIGN KEY references employees.emp_id)

return_status:
return_id (VARCHAR(10), PRIMARY KEY)
issued_id (VARCHAR(10), FOREIGN KEY references issued_status.issued_id)
return_book_name (VARCHAR(75))
return_date (DATE)
return_book_isbn (VARCHAR(20))


Additional tables/views created via tasks:

expensive_books: CTAS for books with rental_price > 10.00.
branch_reports: CTAS for branch performance (revenue, issued/returned books).
active_members: View for members who issued books in the last 2 months.
overdue_summary: CTAS for members with overdue books, fines, and issuance counts.

Setup Instructions

Prerequisites:
MySQL Server (version 8.0+ recommended).
A MySQL client (e.g., MySQL Workbench, command-line mysql).

Installation:
Create the database by running create_tables.sql first. This sets up the schema, foreign keys, and alterations.
Populate the data by running insert_data.sql. This inserts sample records into all tables.
Execute tasks.sql to perform the 20 tasks, which include queries, updates, procedures, and new table creations.

Running Queries:
Connect to MySQL: mysql -u <username> -p.
Use the database: USE library_sql_project_p2;.
Run SELECT statements (e.g., SELECT * FROM books;) to verify data.


Note: Some tasks assume a 30-day return period for overdue calculations. The current date in queries is based on CURDATE(), so results may vary by execution date.
Tasks Solved
The project solves 20 tasks, categorized below:
CRUD Operations (Tasks 1–5)

Task 1: Insert a new book (e.g., "To Kill a Mockingbird").
Task 2: Update a member's address.
Task 3: Delete an issued record.
Task 4: Retrieve books issued by a specific employee.
Task 5: List employees who issued more than one book (using GROUP BY and HAVING).

CTAS and Data Summaries (Tasks 6, 11, 16, 20)

Task 6: CTAS for a summary of books with issuance counts.
Task 11: CTAS for expensive books (rental_price > 10.00).
Task 16: View for active members (issued books in last 2 months).
Task 20: CTAS for overdue summaries, calculating fines ($0.50/day after 30 days) and total issuances.

Data Analysis & Findings (Tasks 7–10, 12)

Task 7: Retrieve books by category.
Task 8: Total rental income by category (using JOIN and GROUP BY).
Task 9: Members registered in the last 180 days.
Task 10: Employees with branch and manager details (multi-table JOIN).
Task 12: Books not yet returned (LEFT JOIN to find unmatched issuances).

Advanced SQL Operations (Tasks 13–15, 17–19)

Task 13: Identify overdue books (>30 days), showing member details and days overdue (DATEDIFF).
Task 14: Stored procedure add_return_records to insert returns, update book status to 'yes', and fetch book details.
Task 15: CTAS for branch reports (revenue, issued/returned counts via multi-JOIN and GROUP BY).
Task 17: Top 3 employees by books processed (GROUP BY, ORDER BY, LIMIT).
Task 18: Members who issued damaged books >2 times (JOIN, GROUP BY, HAVING).
Task 19: Stored procedure issued_book to check/update book status on issuance (IF-ELSE logic).

These tasks demonstrate efficient querying, data integrity maintenance, and automation via procedures.
Advanced Features

Stored Procedures:
add_return_records: Handles returns, updates book availability, and provides confirmation messages.
issued_book: Checks availability before issuing and updates status accordingly.

Views: active_members for quick access to recent activity without repeated complex queries.
Performance Considerations: GROUP BY for aggregations, JOINs for relational insights, and LIMIT for top-N results. Queries are optimized for small datasets but scalable.
Error Handling: Procedures include conditional checks (e.g., book availability).
Date Functions: Extensive use of DATEDIFF, DATE_SUB, and CURDATE() for time-based analysis (e.g., overdues, recent registrations).

Conclusion
This project provides a complete end-to-end SQL solution for a library system, from schema design to advanced analytics. It highlights best practices in relational database management, ensuring data consistency and enabling actionable insights (e.g., revenue reports, overdue tracking). The separation of files makes it modular and easy to maintain. For questions or extensions, refer to the SQL files or adjust sample data as needed.
