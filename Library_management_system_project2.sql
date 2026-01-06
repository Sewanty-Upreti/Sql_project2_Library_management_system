create database library_sql_project_p2;

-- creating branch table
create table branch(
branch_id varchar(10) primary key,
manager_id varchar(10),
branch_address varchar (50),
contact_no varchar(10)
);

-- creating employess table
create table employees(
emp_id varchar(10) primary key,
emp_name varchar(25),
position varchar (20),
salary float,
branch_id varchar(25)
);

-- creating books table
CREATE TABLE books (
    isbn VARCHAR(20) PRIMARY KEY,
    book_title VARCHAR(55),
    category VARCHAR(10),
    rental_price FLOAT,
    status ENUM('yes', 'no'),
    author VARCHAR(35),
    publisher VARCHAR(55)
);

-- creating members table
CREATE TABLE members (
    member_id VARCHAR(10) PRIMARY KEY,
    member_name VARCHAR(25),
    member_address VARCHAR(55),
    reg_date date
);
-- creating issued table
CREATE TABLE issued_status(
issued_id VARCHAR(10) PRIMARY KEY,
issued_member_id VARCHAR (10), 
issued_book_name VARCHAR (75),
issued_date DATE, 
issued_book_isbn VARCHAR (25),
issued_emp_id VARCHAR (10)
);
-- creating table return_status
CREATE TABLE return_status(
return_id VARCHAR (10) PRIMARY KEY,
issued_id VARCHAR (10) ,
return_book_name VARCHAR (75), 
return_date DATE, 
return_book_isbn VARCHAR (20)
) ;

-- foreign key
alter table  issued_status
add constraint fk_members
foreign key(issued_member_id)
references members (member_id);

alter table issued_status
add constraint fk_books
foreign key(issued_book_isbn)
references books(isbn);

alter table issued_status
add constraint fk_employees
foreign key(issued_emp_id)
references employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

-- we gotta alter table branch as the data is too lomg for the column contact 
alter table branch modify contact_no varchar(30);

-- we gotta alter table books as the data is too lomg for the column category
alter table books modify category varchar(75);


