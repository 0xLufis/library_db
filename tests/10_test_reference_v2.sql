SET SERVEROUTPUT ON;
PROMPT === LOADING DATA VIA STORED PROCEDURES ===

DECLARE
  -- ID Variables
  v_cat_fiction   NUMBER;
  v_cat_nonfic    NUMBER;
  v_cat_scifi     NUMBER;
  v_cat_fantasy   NUMBER;
  v_cat_mystery   NUMBER;
  v_cat_romance   NUMBER;
  v_cat_tech      NUMBER;
  v_cat_horror    NUMBER;
  v_cat_history   NUMBER;
  
  v_role_mgr      NUMBER;
  v_role_lib      NUMBER;
  v_role_intern   NUMBER;
  v_role_sec      NUMBER;
  
  v_emp_id        NUMBER;
  v_cust_id       NUMBER;
  v_auth_id       NUMBER;
  v_book_id       NUMBER;

BEGIN
  DBMS_OUTPUT.PUT_LINE('1. Creating Categories...');
  pkg_category_manager.add_category('Fiction', v_cat_fiction);
  pkg_category_manager.add_category('Non-Fiction', v_cat_nonfic);
  pkg_category_manager.add_category('Sci-Fi', v_cat_scifi);
  pkg_category_manager.add_category('Fantasy', v_cat_fantasy);
  pkg_category_manager.add_category('History', v_cat_history);
  pkg_category_manager.add_category('Mystery', v_cat_mystery);
  pkg_category_manager.add_category('Romance', v_cat_romance);
  pkg_category_manager.add_category('Horror', v_cat_horror);
  pkg_category_manager.add_category('Technology', v_cat_tech);

  DBMS_OUTPUT.PUT_LINE('2. Creating Roles...');
  pkg_role_manager.add_role('MANAGER', 'Library Manager', v_role_mgr);
  pkg_role_manager.add_role('LIBRARIAN', 'Front Desk Staff', v_role_lib);
  pkg_role_manager.add_role('INTERN', 'Student Intern', v_role_intern);
  pkg_role_manager.add_role('SECURITY', 'Security Guard', v_role_sec);

  DBMS_OUTPUT.PUT_LINE('3. Creating Employees...');
  -- We create employees and manually link roles because the simple package didn't take role_id
  pkg_employee_manager.add_employee('Alice', 'Smith', v_emp_id);
  UPDATE employees SET role_id = v_role_mgr WHERE employee_id = v_emp_id;

  pkg_employee_manager.add_employee('Bob', 'Jones', v_emp_id);
  UPDATE employees SET role_id = v_role_lib WHERE employee_id = v_emp_id;

  pkg_employee_manager.add_employee('Diana', 'Prince', v_emp_id);
  UPDATE employees SET role_id = v_role_sec WHERE employee_id = v_emp_id;

  DBMS_OUTPUT.PUT_LINE('4. Creating Customers...');
  pkg_customer_manager.add_customer('John', 'Doe', v_cust_id);
  pkg_customer_manager.add_customer('Jane', 'Reader', v_cust_id); -- Important: 'Reader' used in tests
  pkg_customer_manager.add_customer('Michael', 'Johnson', v_cust_id);

  DBMS_OUTPUT.PUT_LINE('5. Creating Books...');
  -- Book 1
  pkg_author_manager.add_author('Stephen', 'King', v_auth_id);
  pkg_book_manager.add_book('978-001', 'The Shining', 1977, v_auth_id, 5, v_book_id);
  pkg_book_manager.add_book_category(v_book_id, v_cat_horror);

  -- Book 2
  pkg_author_manager.add_author('J.K.', 'Rowling', v_auth_id);
  pkg_book_manager.add_book('978-002', 'Harry Potter', 1997, v_auth_id, 10, v_book_id);
  pkg_book_manager.add_book_category(v_book_id, v_cat_fantasy);

  -- Book 3 (For scenarios)
  pkg_author_manager.add_author('George', 'Orwell', v_auth_id);
  pkg_book_manager.add_book('978-003', '1984', 1949, v_auth_id, 8, v_book_id);
  pkg_book_manager.add_book_category(v_book_id, v_cat_fiction);

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('=== Data Load Complete ===');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('ERROR LOADING DATA: ' || SQLERRM);
    RAISE; -- Fails the script so you notice
END;
/
