# SQL Project 2: Library Management System



## Overview

This is my **2nd SQL project** in data analysis, implementing a comprehensive **Library Management System** using MySQL.

The system models a real-world library with multiple branches, employees, books, members, issued books, and return records. It includes:

- Database creation
- Table definitions with constraints (primary keys, foreign keys)
- Sample data insertion
- 20 tasks demonstrating CRUD operations, advanced queries, stored procedures, views, and analytics

The project is organized into separate files for clarity:

- `Library_management_system_project2.sql` → Database, tables, constraints, and column alterations
- `insert_queries.sql` → All INSERT statements for sample data
- `solving_tasks_library_sql_project_p2.sql` → Solutions to all 20 tasks (CRUD, CTAS, procedures, analysis)

**Key Features**
- **Relational Integrity**: Foreign keys ensure consistent data
- **Data Validation**: ENUM for book status, column alterations for longer values
- **Analysis & Reporting**: Revenue by category, overdue tracking, branch performance
- **Advanced SQL**: Stored procedures for issuing/returning books, views, CTAS summaries

## Database Schema (ER Diagram)

<img width="837" height="803" alt="Screenshot 2026-01-06 at 6 10 27 pm" src="https://github.com/user-attachments/assets/2a7af654-0ada-419a-91bd-ec38ed56a0e6" />


### Main Tables

| Table            | Key Columns & Description                                                                 |
|------------------|-------------------------------------------------------------------------------------------|
| **branch**       | `branch_id` (PK), `manager_id`, `branch_address`, `contact_no` (altered to VARCHAR(30))   |
| **employees**    | `emp_id` (PK), `emp_name`, `position`, `salary`, `branch_id` (FK → branch)                |
| **books**        | `isbn` (PK), `book_title`, `category` (VARCHAR(75)), `rental_price`, `status` (yes/no), `author`, `publisher` |
| **members**      | `member_id` (PK), `member_name`, `member_address`, `reg_date`                             |
| **issued_status**| `issued_id` (PK), `issued_member_id` (FK → members), `issued_book_isbn` (FK → books), `issued_emp_id` (FK → employees) |
| **return_status**| `return_id` (PK), `issued_id` (FK → issued_status)                                        |

**Additional objects created in tasks**:
- `expensive_books` (CTAS)
- `branch_reports` (CTAS)
- `active_members` (VIEW)
- `overdue_summary` (CTAS)

## Setup & Running

### Prerequisites
- MySQL Server (8.0+ recommended)
- MySQL client (Workbench or command line)

### Steps
1. Run `Library_management_system_project2.sql` → creates database and schema
2. Run `insert_queries.sql` → populates with realistic sample data
3. Run `solving_tasks_library_sql_project_p2.sql` → executes all 20 tasks and creates additional objects


## Tasks Solved

### CRUD Operations (Tasks 1–5)
- Insert new book record
- Update member address
- Delete issued status record
- Books issued by specific employee
- Employees with multiple issuances (GROUP BY + HAVING)

### CTAS & Summaries (Tasks 6, 11, 16, 20)
- Book issuance count summary
- Expensive books table (> $10)
- Active members view (last 2 months)
- Overdue summary with fines ($0.50/day after 30 days)

### Analysis & Findings (Tasks 7–10, 12)
- Books by category
- Total rental income by category
- Recent member registrations
- Employee details with branch & manager
- Books not yet returned (LEFT JOIN)

### Advanced Operations (Tasks 13–15, 17–19)
- Overdue members report (DATEDIFF)
- Stored procedure: `add_return_records` (updates book status)
- Branch performance report (revenue + counts)
- Top 3 employees by issuances
- Members issuing damaged books >2 times
- Stored procedure: `issued_book` (availability check)

## Advanced Features

- **Stored Procedures**  
  - `add_return_records`: Inserts return, updates book to available, confirmation message  
  - `issued_book`: Checks status before issuing
- **View**: `active_members` for quick recent activity
- **Date Functions**: DATEDIFF, CURDATE(), INTERVAL for time-based analysis
- **Aggregations**: GROUP BY, HAVING, multi-table JOINs for insights

## Conclusion

This project demonstrates end-to-end SQL skills: schema design, data integrity, manipulation, automation with procedures, and business insights (revenue, performance, overdues).

