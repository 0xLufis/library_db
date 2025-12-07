SET SERVEROUTPUT ON;
PROMPT === INSERTING BULK TEST DATA ===
-- 0. For the purposes of this instance IDs 1 - 10 will be test data and IDs 100 - whatever the datatype allows will be "Prod Data"
DECLARE
  v_count NUMBER;
BEGIN
  -- 1. AUTHORS
  INSERT INTO authors (author_id, first_name, last_name) VALUES (1, 'Stephen', 'King');
  INSERT INTO authors (author_id, first_name, last_name) VALUES (2, 'J.K.', 'Rowling');
  INSERT INTO authors (author_id, first_name, last_name) VALUES (3, 'George', 'Orwell');
  INSERT INTO authors (author_id, first_name, last_name) VALUES (4, 'J.R.R.', 'Tolkien');
  INSERT INTO authors (author_id, first_name, last_name) VALUES (5, 'Agatha', 'Christie');
  INSERT INTO authors (author_id, first_name, last_name) VALUES (6, 'Isaac', 'Asimov');
  INSERT INTO authors (author_id, first_name, last_name) VALUES (7, 'Frank', 'Herbert');
  INSERT INTO authors (author_id, first_name, last_name) VALUES (8, 'Ernest', 'Hemingway');
  INSERT INTO authors (author_id, first_name, last_name) VALUES (9, 'Jane', 'Austen');
  INSERT INTO authors (author_id, first_name, last_name) VALUES (10, 'Mark', 'Twain');

  -- 2. CATEGORIES
  INSERT INTO categories (category_id, category_name) VALUES (1, 'Fiction');
  INSERT INTO categories (category_id, category_name) VALUES (2, 'Non-Fiction');
  INSERT INTO categories (category_id, category_name) VALUES (3, 'Sci-Fi');
  INSERT INTO categories (category_id, category_name) VALUES (4, 'Fantasy');
  INSERT INTO categories (category_id, category_name) VALUES (5, 'Biography');
  INSERT INTO categories (category_id, category_name) VALUES (6, 'History');
  INSERT INTO categories (category_id, category_name) VALUES (7, 'Mystery');
  INSERT INTO categories (category_id, category_name) VALUES (8, 'Romance');
  INSERT INTO categories (category_id, category_name) VALUES (9, 'Horror');
  INSERT INTO categories (category_id, category_name) VALUES (10, 'Technology');

  -- 3. ROLES
  INSERT INTO employee_roles (role_id, role_name, role_desc) VALUES (1, 'MANAGER', 'Library Manager');
  INSERT INTO employee_roles (role_id, role_name, role_desc) VALUES (2, 'LIBRARIAN', 'Front Desk Staff');
  INSERT INTO employee_roles (role_id, role_name, role_desc) VALUES (3, 'INTERN', 'Student Intern');
  INSERT INTO employee_roles (role_id, role_name, role_desc) VALUES (4, 'SECURITY', 'Security Guard');
  INSERT INTO employee_roles (role_id, role_name, role_desc) VALUES (5, 'JANITOR', 'Maintenance Staff');
  INSERT INTO employee_roles (role_id, role_name, role_desc) VALUES (6, 'IT_ADMIN', 'System Administrator');
  INSERT INTO employee_roles (role_id, role_name, role_desc) VALUES (7, 'HR', 'Human Resources');
  INSERT INTO employee_roles (role_id, role_name, role_desc) VALUES (8, 'ARCHIVIST', 'Old Book Keeper');
  INSERT INTO employee_roles (role_id, role_name, role_desc) VALUES (9, 'VOLUNTEER', 'Community Helper');
  INSERT INTO employee_roles (role_id, role_name, role_desc) VALUES (10, 'DIRECTOR', 'Board Director');

  -- 4. EMPLOYEES (Linked to Role IDs 1-10)
  -- Note: No need for keycard_number the trigger creates it automatically
  INSERT INTO employees (employee_id, first_name, last_name, role_id) VALUES (1, 'Alice', 'Smith', 1);
  INSERT INTO employees (employee_id, first_name, last_name, role_id) VALUES (2, 'Bob', 'Jones', 2);
  INSERT INTO employees (employee_id, first_name, last_name, role_id) VALUES (3, 'Charlie', 'Brown', 2);
  INSERT INTO employees (employee_id, first_name, last_name, role_id) VALUES (4, 'Diana', 'Prince', 2);
  INSERT INTO employees (employee_id, first_name, last_name, role_id) VALUES (5, 'Evan', 'Wright', 3);
  INSERT INTO employees (employee_id, first_name, last_name, role_id) VALUES (6, 'Fiona', 'Green', 3);
  INSERT INTO employees (employee_id, first_name, last_name, role_id) VALUES (7, 'George', 'Black', 4);
  INSERT INTO employees (employee_id, first_name, last_name, role_id) VALUES (8, 'Hannah', 'White', 6);
  INSERT INTO employees (employee_id, first_name, last_name, role_id) VALUES (9, 'Ian', 'Gray', 5);
  INSERT INTO employees (employee_id, first_name, last_name, role_id) VALUES (10, 'Julia', 'Roberts', 2);

  -- 5. CUSTOMERS
  INSERT INTO customers (customer_id, first_name, last_name) VALUES (1, 'John', 'Doe');
  INSERT INTO customers (customer_id, first_name, last_name) VALUES (2, 'Jane', 'Smith');
  INSERT INTO customers (customer_id, first_name, last_name) VALUES (3, 'Michael', 'Johnson');
  INSERT INTO customers (customer_id, first_name, last_name) VALUES (4, 'Emily', 'Davis');
  INSERT INTO customers (customer_id, first_name, last_name) VALUES (5, 'Chris', 'Brown');
  INSERT INTO customers (customer_id, first_name, last_name) VALUES (6, 'Sarah', 'Wilson');
  INSERT INTO customers (customer_id, first_name, last_name) VALUES (7, 'David', 'Taylor');
  INSERT INTO customers (customer_id, first_name, last_name) VALUES (8, 'Laura', 'Anderson');
  INSERT INTO customers (customer_id, first_name, last_name) VALUES (9, 'Robert', 'Thomas');
  INSERT INTO customers (customer_id, first_name, last_name) VALUES (10, 'Jennifer', 'Jackson');

  -- 6. BOOKS (Link to Author IDs 1-10)
  INSERT INTO books (book_id, isbn, title, publish_year, stock, author_id) VALUES (1, '978-001', 'The Shining', 1977, 5, 1);
  INSERT INTO books (book_id, isbn, title, publish_year, stock, author_id) VALUES (2, '978-002', 'Harry Potter 1', 1997, 10, 2);
  INSERT INTO books (book_id, isbn, title, publish_year, stock, author_id) VALUES (3, '978-003', '1984', 1949, 8, 3);
  INSERT INTO books (book_id, isbn, title, publish_year, stock, author_id) VALUES (4, '978-004', 'The Hobbit', 1937, 12, 4);
  INSERT INTO books (book_id, isbn, title, publish_year, stock, author_id) VALUES (5, '978-005', 'Murder on Orient Express', 1934, 6, 5);
  INSERT INTO books (book_id, isbn, title, publish_year, stock, author_id) VALUES (6, '978-006', 'Foundation', 1951, 7, 6);
  INSERT INTO books (book_id, isbn, title, publish_year, stock, author_id) VALUES (7, '978-007', 'Dune', 1965, 9, 7);
  INSERT INTO books (book_id, isbn, title, publish_year, stock, author_id) VALUES (8, '978-008', 'Old Man and Sea', 1952, 4, 8);
  INSERT INTO books (book_id, isbn, title, publish_year, stock, author_id) VALUES (9, '978-009', 'Pride and Prejudice', 1813, 5, 9);
  INSERT INTO books (book_id, isbn, title, publish_year, stock, author_id) VALUES (10, '978-010', 'Tom Sawyer', 1876, 15, 10);

  -- 7. BOOK CATEGORIES (Link Books to Categories)
  INSERT INTO book_categories (book_id, category_id) VALUES (1, 9); -- Shining -> Horror
  INSERT INTO book_categories (book_id, category_id) VALUES (2, 4); -- HP -> Fantasy
  INSERT INTO book_categories (book_id, category_id) VALUES (3, 1); -- 1984 -> Fiction
  INSERT INTO book_categories (book_id, category_id) VALUES (4, 4); -- Hobbit -> Fantasy
  INSERT INTO book_categories (book_id, category_id) VALUES (5, 7); -- Orient -> Mystery
  INSERT INTO book_categories (book_id, category_id) VALUES (6, 3); -- Foundation -> SciFi
  INSERT INTO book_categories (book_id, category_id) VALUES (7, 3); -- Dune -> SciFi
  INSERT INTO book_categories (book_id, category_id) VALUES (8, 1); -- Old Man -> Fiction
  INSERT INTO book_categories (book_id, category_id) VALUES (9, 8); -- Pride and Prejudice -> Romance
  INSERT INTO book_categories (book_id, category_id) VALUES (10, 1); -- Tom Sawyer -> Fiction

  -- 8. ADJUST SEQUENCES 
  -- Manually inserted IDs 1-10. We must tell Oracle to start counting from 100 now.
  -- If this snippet is for any reason not ran, all sequnces are to start at 1 and increment by 1
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_authors_id';
  EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_authors_id START WITH 100 INCREMENT BY 1';
  
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_categories_id';
  EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_categories_id START WITH 100 INCREMENT BY 1';
  
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_role_id';
  EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_role_id START WITH 100 INCREMENT BY 1';
  
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_customer_id';
  EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_customer_id START WITH 100 INCREMENT BY 1';
  
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_employee_id';
  EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_employee_id START WITH 100 INCREMENT BY 1';
  
  EXECUTE IMMEDIATE 'DROP SEQUENCE seq_book_id';
  EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_book_id START WITH 100 INCREMENT BY 1';

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Bulk data inserted and sequences reset.');
END;
/
