SET SERVEROUTPUT ON;
PROMPT === LOADING DATA VIA PACKAGES & LOOKUPS ===

DECLARE
  -- We only need basic holders now, we don't need to remember every single ID
  v_dummy_id      NUMBER;
  v_emp_id        NUMBER;
  v_cust_id       NUMBER;
  v_auth_id       NUMBER;
  v_book_id       NUMBER;

BEGIN
  -- 1. SETUP REFERENCE DATA (Categories & Roles)
  DBMS_OUTPUT.PUT_LINE('1. Setting up Reference Data...');
  
  -- Create Categories
  pkg_category_manager.add_category('Fiction', v_dummy_id);
  pkg_category_manager.add_category('Non-Fiction', v_dummy_id);
  pkg_category_manager.add_category('Sci-Fi', v_dummy_id);
  pkg_category_manager.add_category('Fantasy', v_dummy_id);
  pkg_category_manager.add_category('History', v_dummy_id);
  pkg_category_manager.add_category('Mystery', v_dummy_id);
  pkg_category_manager.add_category('Romance', v_dummy_id);
  pkg_category_manager.add_category('Horror', v_dummy_id);
  pkg_category_manager.add_category('Technology', v_dummy_id);

  -- Create Roles
  pkg_role_manager.add_role('MANAGER', 'Library Manager', v_dummy_id);
  pkg_role_manager.add_role('LIBRARIAN', 'Front Desk Staff', v_dummy_id);
  pkg_role_manager.add_role('INTERN', 'Student Intern', v_dummy_id);
  pkg_role_manager.add_role('SECURITY', 'Security Guard', v_dummy_id);


  -- 2. CREATE EMPLOYEES & ASSIGN ROLES
  DBMS_OUTPUT.PUT_LINE('2. Creating Employees...');

  -- Alice (Manager)
  pkg_employee_manager.add_employee('Alice', 'Smith', v_emp_id);
  pkg_employee_manager.assign_role(v_emp_id, pkg_role_manager.get_role_id('MANAGER'));

  -- Bob (Librarian)
  pkg_employee_manager.add_employee('Bob', 'Jones', v_emp_id);
  pkg_employee_manager.assign_role(v_emp_id, pkg_role_manager.get_role_id('LIBRARIAN'));

  -- Diana (Security)
  pkg_employee_manager.add_employee('Diana', 'Prince', v_emp_id);
  pkg_employee_manager.assign_role(v_emp_id, pkg_role_manager.get_role_id('SECURITY'));

  -- Evan (Intern)
  pkg_employee_manager.add_employee('Evan', 'Wright', v_emp_id);
  pkg_employee_manager.assign_role(v_emp_id, pkg_role_manager.get_role_id('INTERN'));


  -- 3. CREATE CUSTOMERS
  DBMS_OUTPUT.PUT_LINE('3. Creating Customers...');
  pkg_customer_manager.add_customer('John', 'Doe', v_cust_id);
  pkg_customer_manager.add_customer('Jane', 'Reader', v_cust_id); -- Important for tests
  pkg_customer_manager.add_customer('Michael', 'Johnson', v_cust_id);


  -- 4. CREATE BOOKS (With simple category linking)
  DBMS_OUTPUT.PUT_LINE('4. Creating Books...');
  
  -- Helper block to make adding books cleaner
  DECLARE
    -- Local helper to get category ID by name (simulating a lookup like we did for roles)
    FUNCTION get_cat(p_name VARCHAR2) RETURN NUMBER IS
      v_c_id NUMBER;
    BEGIN
      SELECT category_id INTO v_c_id FROM categories WHERE category_name = p_name;
      RETURN v_c_id;
    END;
  BEGIN
      -- Book 1
      pkg_author_manager.add_author('Stephen', 'King', v_auth_id);
      pkg_book_manager.add_book('978-001', 'The Shining', 1977, v_auth_id, 5, v_book_id);
      pkg_book_manager.add_book_category(v_book_id, get_cat('Horror'));

      -- Book 2
      pkg_author_manager.add_author('J.K.', 'Rowling', v_auth_id);
      pkg_book_manager.add_book('978-002', 'Harry Potter', 1997, v_auth_id, 10, v_book_id);
      pkg_book_manager.add_book_category(v_book_id, get_cat('Fantasy'));

      -- Book 3
      pkg_author_manager.add_author('George', 'Orwell', v_auth_id);
      pkg_book_manager.add_book('978-003', '1984', 1949, v_auth_id, 8, v_book_id);
      pkg_book_manager.add_book_category(v_book_id, get_cat('Fiction'));
      pkg_book_manager.add_book_category(v_book_id, get_cat('Sci-Fi'));
  END;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('=== Data Load Complete ===');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/
