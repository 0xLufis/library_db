SET SERVEROUTPUT ON;
PROMPT === LOADING DATA VIA PACKAGES & LOOKUPS ===

DECLARE
  v_dummy_id      NUMBER;
  v_emp_id        NUMBER;
  v_cust_id       NUMBER;
  v_auth_id       NUMBER;
  v_book_id       NUMBER;

BEGIN
  -- 1. SETUP REFERENCE DATA
  DBMS_OUTPUT.PUT_LINE('1. Setting up Reference Data...');
  
  pkg_category_manager.add_category('Fiction', v_dummy_id);
  pkg_category_manager.add_category('Non-Fiction', v_dummy_id);
  pkg_category_manager.add_category('Sci-Fi', v_dummy_id);
  pkg_category_manager.add_category('Fantasy', v_dummy_id);
  pkg_category_manager.add_category('History', v_dummy_id);
  pkg_category_manager.add_category('Mystery', v_dummy_id);
  pkg_category_manager.add_category('Romance', v_dummy_id);
  pkg_category_manager.add_category('Horror', v_dummy_id);
  pkg_category_manager.add_category('Technology', v_dummy_id);

  pkg_role_manager.add_role('MANAGER', 'Library Manager', v_dummy_id);
  pkg_role_manager.add_role('LIBRARIAN', 'Front Desk Staff', v_dummy_id);
  pkg_role_manager.add_role('INTERN', 'Student Intern', v_dummy_id);
  pkg_role_manager.add_role('SECURITY', 'Security Guard', v_dummy_id);

  -- 2. CREATE EMPLOYEES
  DBMS_OUTPUT.PUT_LINE('2. Creating Employees...');

  pkg_employee_manager.add_employee('Alice', 'Smith', v_emp_id);
  pkg_employee_manager.assign_role(v_emp_id, pkg_role_manager.get_role_id('MANAGER'));

  pkg_employee_manager.add_employee('Bob', 'Jones', v_emp_id);
  pkg_employee_manager.assign_role(v_emp_id, pkg_role_manager.get_role_id('LIBRARIAN'));

  pkg_employee_manager.add_employee('Diana', 'Prince', v_emp_id);
  pkg_employee_manager.assign_role(v_emp_id, pkg_role_manager.get_role_id('SECURITY'));

  pkg_employee_manager.add_employee('Evan', 'Wright', v_emp_id);
  pkg_employee_manager.assign_role(v_emp_id, pkg_role_manager.get_role_id('INTERN'));

  -- 3. CREATE CUSTOMERS
  DBMS_OUTPUT.PUT_LINE('3. Creating Customers...');
  pkg_customer_manager.add_customer('John', 'Doe', v_cust_id);
  pkg_customer_manager.add_customer('Jane', 'Reader', v_cust_id);
  pkg_customer_manager.add_customer('Michael', 'Johnson', v_cust_id);

  -- 4. CREATE BOOKS
  DBMS_OUTPUT.PUT_LINE('4. Creating Books...');

  -- Book 1
  pkg_author_manager.add_author('Stephen', 'King', v_auth_id);
  pkg_book_manager.add_book('978-001', 'The Shining', 1977, v_auth_id, 5, v_book_id);
  pkg_book_manager.add_book_category(v_book_id, pkg_category_manager.get_category_id('Horror'));

  -- Book 2
  pkg_author_manager.add_author('J.K.', 'Rowling', v_auth_id);
  pkg_book_manager.add_book('978-002', 'Harry Potter', 1997, v_auth_id, 10, v_book_id);
  pkg_book_manager.add_book_category(v_book_id, pkg_category_manager.get_category_id('Fantasy'));

  -- Book 3
  pkg_author_manager.add_author('George', 'Orwell', v_auth_id);
  pkg_book_manager.add_book('978-003', '1984', 1949, v_auth_id, 8, v_book_id);
  pkg_book_manager.add_book_category(v_book_id, pkg_category_manager.get_category_id('Fiction'));
  pkg_book_manager.add_book_category(v_book_id, pkg_category_manager.get_category_id('Sci-Fi'));

  -- Book 4
  pkg_author_manager.add_author('Frank', 'Herbert', v_auth_id);
  pkg_book_manager.add_book('978-004', 'Dune', 1965, v_auth_id, 12, v_book_id);
  pkg_book_manager.add_book_category(v_book_id, pkg_category_manager.get_category_id('Sci-Fi'));

  -- Book 5
  pkg_author_manager.add_author('J.R.R.', 'Tolkien', v_auth_id);
  pkg_book_manager.add_book('978-005', 'The Hobbit', 1937, v_auth_id, 15, v_book_id);
  pkg_book_manager.add_book_category(v_book_id, pkg_category_manager.get_category_id('Fantasy'));

  -- Book 6
  pkg_author_manager.add_author('Jane', 'Austen', v_auth_id);
  pkg_book_manager.add_book('978-006', 'Pride and Prejudice', 1813, v_auth_id, 5, v_book_id);
  pkg_book_manager.add_book_category(v_book_id, pkg_category_manager.get_category_id('Romance'));
  pkg_book_manager.add_book_category(v_book_id, pkg_category_manager.get_category_id('Fiction'));

  -- Book 7
  pkg_author_manager.add_author('F. Scott', 'Fitzgerald', v_auth_id);
  pkg_book_manager.add_book('978-007', 'The Great Gatsby', 1925, v_auth_id, 8, v_book_id);
  pkg_book_manager.add_book_category(v_book_id, pkg_category_manager.get_category_id('Fiction'));
  pkg_book_manager.add_book_category(v_book_id, pkg_category_manager.get_category_id('History'));

  -- Book 8
  pkg_author_manager.add_author('Agatha', 'Christie', v_auth_id);
  pkg_book_manager.add_book('978-008', 'Murder on Orient Express', 1934, v_auth_id, 6, v_book_id);
  pkg_book_manager.add_book_category(v_book_id, pkg_category_manager.get_category_id('Mystery'));

  -- Book 9
  pkg_author_manager.add_author('Isaac', 'Asimov', v_auth_id);
  pkg_book_manager.add_book('978-009', 'Foundation', 1951, v_auth_id, 9, v_book_id);
  pkg_book_manager.add_book_category(v_book_id, pkg_category_manager.get_category_id('Sci-Fi'));

  -- Book 10
  pkg_author_manager.add_author('Ernest', 'Hemingway', v_auth_id);
  pkg_book_manager.add_book('978-010', 'Old Man and Sea', 1952, v_auth_id, 4, v_book_id);
  pkg_book_manager.add_book_category(v_book_id, pkg_category_manager.get_category_id('Fiction'));

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('=== Data Load Complete ===');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/