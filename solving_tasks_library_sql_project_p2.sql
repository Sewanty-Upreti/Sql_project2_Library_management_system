select * from books;
select * from return_status;
select * from issued_status;
select * from members;
select * from branch;
select * from employees;



-- Tasks to do 
-- CRUD OPRETAIONS
-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 
-- 'J.B. Lippincott & Co.')" 

INSERT INTO BOOKS (isbn, book_title, category, rental_price, status, author, publisher) values
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- Task 2: Update an Existing Member's Address
update members set member_address ='Southern California' where member_id = 'C109';

-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
Delete from issued_status where issued_id = 'IS121' ;

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
select * from issued_status where issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
select issued_emp_id , count(issued_id) from issued_status group by issued_emp_id having count(issued_id)>1;

-- CTAS (Create Table As Select)
-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
select b.isbn, b.book_title, count(ist.issued_id) as total_book_issued from issued_status ist join books b on ist.issued_book_isbn = b.isbn
group by b.isbn, ist.issued_id;

-- Data Analysis & Findings
-- Task 7. Retrieve All Books in a Specific Category:

-- Task 8: Find Total Rental Income by Category:
select  b.category, sum(b.rental_price) as total_rental_income, count(*)
from issued_status ist join books b on ist.issued_book_isbn = b.isbn
group by b.category;

-- Task 9: List Members Who Registered in the Last 180 Days:
select member_name from members where
    reg_date >= DATE_SUB(CURDATE(), INTERVAL 180 DAY); -- no members in out current record 

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:
select e.emp_id, e.emp_name, e.position, e.salary, b.*, e2.emp_name as manager
from branch b join employees e on b.branch_id=e.branch_id
JOIN
employees as e2
ON e2.emp_id = b.manager_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:
CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 10.00;

-- Task 12: Retrieve the List of Books Not Yet Returned
select ist.issued_book_name
from issued_status ist left join return_status rts on ist.issued_id = rts.issued_id
where rts.return_id is null;

-- Advanced SQL Operations
/*
Task 13: Identify Members with Overdue Books 
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
*/

select m.member_id, m.member_name, ist.issued_book_name , ist.issued_date , DATEDIFF(CURRENT_DATE, ist.issued_date) - 30 AS days_overdue from
members m join issued_status ist on m.member_id=ist.issued_member_id
WHERE DATEDIFF(CURRENT_DATE, ist.issued_date) > 30;

/*
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned 
(based on entries in the return_status table).
*/ 

create procedure add_return_books( 
DELIMITER $$

CREATE PROCEDURE add_return_records(
    IN p_return_id VARCHAR(10),
    IN p_issued_id VARCHAR(10),
    IN p_book_quality VARCHAR(10)
)
BEGIN
    DECLARE v_isbn VARCHAR(50);
    DECLARE v_book_name VARCHAR(80);

    -- 1. Insert return record
    INSERT INTO return_status (return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURDATE(), p_book_quality);

    -- 2. Get book ISBN and name from issued_status
    SELECT issued_book_isbn, issued_book_name
    INTO v_isbn, v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    -- 3. Update book status to YES (available)
    UPDATE books
    SET status = 'YES'
    WHERE isbn = v_isbn;

    -- 4. Confirmation message
    SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS message;

END$$

DELIMITER ;
-- testing the procedure
CALL add_return_records('RS138', 'IS135', 'Good');

/*
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, showing the number of books issued, 
the number of books returned, and the total revenue generated from book rentals.
*/

create table Branch_Reports
As 
select 
		b.branch_id,
        b.manager_id,
        sum(bk.rental_price) as total_revenue,
        count(ist.issued_id) as no_of_book_issued,
        count(rs.return_id) as no_of_book_returned
from issued_status ist
join 
employees as e
on e.emp_id =ist.issued_emp_id
join 
branch as b 
on e.branch_id=b.branch_id
left join 
return_status as rs
on rs.issued_id = ist.issued_id
join books as bk
on ist.issued_book_isbn= bk.isbn
group by b.branch_id, b.manager_id;
select * from branch_reports;

/*
Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued 
at least one book in the last 2 months.
*/

CREATE VIEW Active_members AS
SELECT m.*
FROM members m
JOIN issued_status i
  ON m.member_id = i.issued_member_id
WHERE i.issued_date >= CURDATE() - INTERVAL 2 MONTH;

select * from Active_members;

/*
Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. 
Display the employee name, number of books processed, and their branch.
*/
select ist.issued_emp_id, count(*) as no_of_book_processed, e.emp_name, b.branch_id
from issued_status as ist
join employees e on
ist.issued_emp_id= e.emp_id
join
branch b on 
e.branch_id = b.branch_id
group by ist.issued_emp_id
ORDER BY no_of_book_processed DESC
LIMIT 3;

/*
Task 18: Identify Members Issuing High-Risk Books
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. 
Display the member name, book title, and the number of times they've issued damaged books.
*/

SELECT 
    m.member_name,
    b.book_title,
    COUNT(*) AS times_issued
FROM issued_status ist
JOIN books b ON ist.issued_book_isbn = b.isbn
JOIN members m ON ist.issued_member_id = m.member_id
WHERE b.status = 'Damaged'
GROUP BY m.member_name, b.book_title
HAVING COUNT(*) > 2;

/*
Task 19: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system. 
Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 
The procedure should function as follows: The stored procedure should take the book_id as an input parameter. 
The procedure should first check if the book is available (status = 'yes'). 
If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
*/
Delimiter $$
CREATE PROCEDURE issued_book( in book_id VARCHAR(20))
	begin
	declare book_status varchar(10);
    
    -- get the current book status
    select status into book_status
    from books 
    where isbn = book_id;
    
    if book_status = 'yes'
    then 
        -- Update status to 'no' because it's being issued
        UPDATE books
        SET status = 'no'
        WHERE isbn = book_id;
	
    select concat ('Book',' ', book_id ,' ',' has been issued sucessfully!') as message;
    else
    -- book not available
    select concat ('Book',' ', book_id ,' ', 'is not available!') as message;
	end if;
end $$
Delimiter ;

-- testing 
CALL issued_book('978-0-14-118776-1');



/*
task 20 Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. 
The table should include: The number of overdue books. The total fines, with each day's fine calculated at $0.50. 
The number of books issued by each member. 
The resulting table should show: Member ID Number of overdue books Total fines
*/

CREATE TABLE overdue_summary AS
SELECT 
    m.member_id,
    m.member_name,
    COUNT(CASE 
            WHEN DATEDIFF(CURRENT_DATE, ist.issued_date) > 30 
                 AND rst.issued_id IS NULL 
            THEN 1 
         END) AS number_of_overdue_books,
    SUM(CASE 
            WHEN DATEDIFF(CURRENT_DATE, ist.issued_date) > 30 
                 AND rst.issued_id IS NULL 
            THEN (DATEDIFF(CURRENT_DATE, ist.issued_date) - 30) * 0.5
            ELSE 0
        END) AS total_fines,
    COUNT(ist.issued_id) AS total_books_issued
FROM members m
JOIN issued_status ist ON m.member_id = ist.issued_member_id
LEFT JOIN return_status rst ON ist.issued_id = rst.issued_id
GROUP BY m.member_id, m.member_name;

select * from overdue_summary;













