SET DEFINE OFF;
PROMPT ==================================================
PROMPT   LIBRARY PROJECT - REFACTORED STRUCTURE BUILD
PROMPT ==================================================

-- 1. SAFE CLEANUP (Drops existing objects to prevent conflicts runs everytime but as LIBRARY_MANAGER)
ALTER SESSION SET CURRENT_SCHEMA=library_manager;
DECLARE
  PROCEDURE drop_table(p_name VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE ' || p_name ||
                      ' CASCADE CONSTRAINTS PURGE';
    dbms_output.put_line('Dropped table: ' || p_name);
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  PROCEDURE drop_seq(p_name VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE ' || p_name;
    dbms_output.put_line('Dropped sequence: ' || p_name);
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;
BEGIN
 -- PROMPT Cleaning old objects...
  -- Drop Link Tables First (Children)
  drop_table('book_categories');
  drop_table('loan_books');
  drop_table('loans');

  -- Drop Main Tables
  drop_table('books');
  drop_table('books_history');
  drop_table('employees');
  drop_table('customers');
  drop_table('employee_roles');
  drop_table('categories');
  drop_table('authors');

  -- Drop Sequences
  drop_seq('seq_authors_id');
  drop_seq('seq_categories_id');
  drop_seq('seq_book_id');
  drop_seq('seq_role_id');
  drop_seq('seq_employee_id');
  drop_seq('seq_customer_id');
  drop_seq('seq_loan_id');
  drop_seq('seq_history_id');
END;
/

PROMPT ==================================================
PROMPT              1: CREATE SEQUENCES
PROMPT ==================================================

ALTER SESSION SET CURRENT_SCHEMA=library_manager;
CREATE sequence seq_authors_id START
  WITH 1 increment BY 1;
CREATE sequence seq_categories_id START
  WITH 1 increment BY 1;
CREATE sequence seq_book_id START
  WITH 1 increment BY 1;
CREATE sequence seq_role_id START
  WITH 1 increment BY 1;
CREATE sequence seq_employee_id START
  WITH 1 increment BY 1;
CREATE sequence seq_customer_id START
  WITH 1 increment BY 1;
CREATE sequence seq_loan_id START
  WITH 100 increment BY 1 minvalue 100;
CREATE sequence seq_history_id START
  WITH 1 increment BY 1;

PROMPT ==================================================
PROMPT            2: CREATE TABLES (Columns Only)
PROMPT =================================================

ALTER SESSION SET CURRENT_SCHEMA=library_manager;
-- 1. Authors
CREATE TABLE authors(author_id NUMBER(10) NOT NULL,
                     first_name VARCHAR2(100) NOT NULL,
                     last_name VARCHAR2(100) NOT NULL,
                     created_at DATE DEFAULT SYSDATE) tablespace users;

-- 2. Categories
CREATE TABLE categories(category_id NUMBER(5) NOT NULL,
                        category_name VARCHAR2(50) NOT NULL) tablespace users;

-- 3. Books
CREATE TABLE books(book_id NUMBER(10) NOT NULL,
                   isbn VARCHAR2(13) NOT NULL,
                   title VARCHAR2(200) NOT NULL,
                   publish_year NUMBER(5),
                   stock        NUMBER(5) DEFAULT 0 NOT NULL,
                   author_id NUMBER(10) NOT NULL,
                   created_at   DATE DEFAULT SYSDATE) tablespace users;

-- 4. Roles
CREATE TABLE employee_roles(role_id NUMBER(3) NOT NULL,
                            role_name VARCHAR2(10) NOT NULL,
                            role_desc VARCHAR2(200) NOT NULL) tablespace users;

-- 5. Employees
CREATE TABLE employees(employee_id NUMBER(10) NOT NULL,
                       first_name VARCHAR2(100) NOT NULL,
                       last_name VARCHAR2(100) NOT NULL,
                       role_id NUMBER(10),
                       keycard_number NUMBER(10)) tablespace users;

-- 6. Customers
CREATE TABLE customers(customer_id NUMBER(10) NOT NULL,
                       first_name VARCHAR2(100) NOT NULL,
                       last_name VARCHAR2(100) NOT NULL,
                       joined_at   DATE DEFAULT SYSDATE NOT NULL,
                       vip         CHAR(1) DEFAULT 'N') tablespace users;

-- 7. Book Categories (Link Table)
CREATE TABLE book_categories(book_id NUMBER(10) NOT NULL,
                             category_id NUMBER(10) NOT NULL) tablespace users;

-- 8. Loans
CREATE TABLE loans(loan_id NUMBER(10) NOT NULL,
                   customer_id NUMBER(10) NOT NULL,
                   loan_date        DATE DEFAULT SYSDATE,
                   return_by_date DATE NOT NULL,
                   employee_id NUMBER(10) NOT NULL,
                   returned_at_date DATE,
                   fine_amount      NUMBER(8, 2) DEFAULT 0) tablespace users;

-- 9. Loan Books (Link Table)
CREATE TABLE loan_books(book_id NUMBER(10) NOT NULL,
                        loan_id NUMBER(10) NOT NULL) tablespace users;

-- 10. Book History
CREATE TABLE books_history(history_id NUMBER NOT NULL,
                           book_id NUMBER,
                           old_stock NUMBER,
                           new_stock NUMBER,
                           changed_by VARCHAR2(50),
                           changed_at DATE DEFAULT SYSDATE);

PROMPT ==================================================
PROMPT          3: APPLY CONSTRAINTS (Alter Table)
PROMPT ==================================================
ALTER SESSION SET CURRENT_SCHEMA=library_manager;

-- 1. Authors
ALTER TABLE authors add CONSTRAINT pk_authors primary key(author_id);

-- 2. Categories
ALTER TABLE categories add CONSTRAINT pk_categories primary key(category_id);
ALTER TABLE categories add CONSTRAINT uk_category_name UNIQUE(category_name);

-- 3. Books
ALTER TABLE books add CONSTRAINT pk_books primary key(book_id);
ALTER TABLE books add CONSTRAINT uk_books_isbn UNIQUE(isbn);
ALTER TABLE books add CONSTRAINT chk_stock_not_negative CHECK(stock >= 0);
ALTER TABLE books add CONSTRAINT fk_books_author foreign key(author_id) references authors(author_id);

-- 4. Roles
ALTER TABLE employee_roles add CONSTRAINT pk_employee_roles primary key(role_id);
ALTER TABLE employee_roles add CONSTRAINT uk_role_name UNIQUE(role_name);

-- 5. Employees
ALTER TABLE employees add CONSTRAINT pk_employees primary key(employee_id);
ALTER TABLE employees add CONSTRAINT uk_employees_kc_number UNIQUE(keycard_number);
-- FK: Link to Roles
ALTER TABLE employees add CONSTRAINT fk_employees_role_id foreign key(role_id) references employee_roles(role_id);

-- 6. Customers
ALTER TABLE customers add CONSTRAINT pk_customers primary key(customer_id);

-- 7. Book Categories (Link)
ALTER TABLE book_categories add CONSTRAINT pk_book_categories primary key(book_id,
                                                                          category_id);
ALTER TABLE book_categories add CONSTRAINT fk_bc_book foreign key(book_id) references books(book_id) ON DELETE cascade;
ALTER TABLE book_categories add CONSTRAINT fk_bc_category foreign key(category_id) references categories(category_id);

-- 8. Loans
ALTER TABLE loans add CONSTRAINT pk_loan primary key(loan_id);
ALTER TABLE loans add CONSTRAINT fk_loan_customer_id foreign key(customer_id) references customers(customer_id);
ALTER TABLE loans add CONSTRAINT fk_loan_employee_id foreign key(employee_id) references employees(employee_id);

-- 9. Loan Books (Link)
ALTER TABLE loan_books add CONSTRAINT pk_loan_books primary key(book_id, loan_id);
ALTER TABLE loan_books add CONSTRAINT fk_loan_books_book_id foreign key(book_id) references books(book_id);
ALTER TABLE loan_books add CONSTRAINT fk_loan_books_loan_id foreign key(loan_id) references loans(loan_id) ON DELETE cascade;

-- 10. Book History
ALTER TABLE books_history add CONSTRAINT pk_books_history primary key(history_id);

PROMPT ==================================================
PROMPT   STRUCTURE BUILD COMPLETE
PROMPT ==================================================
SET DEFINE ON;
/
