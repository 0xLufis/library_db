SET SERVEROUTPUT ON;
DECLARE
  v_auth_id  NUMBER;
  v_book_id  NUMBER;
  v_cat_id   NUMBER;
  v_emp_id   NUMBER;
  v_cust_id  NUMBER;
BEGIN
  --Technically this file is redundant by now but it can stay for now
  DBMS_OUTPUT.PUT_LINE('--- INSERTING ENTITIES ---');

  -- A. AUTHORS & BOOKS
  -- 1. Create Author: J.K. Rowling
  pkg_author_manager.add_author('J.K.', 'Rowling', v_auth_id);
  
  -- 2. Create Book: Harry Potter (Stock: 10)
  pkg_book_manager.add_book('978-12345', 'Harry Potter', 1997, v_auth_id, 10, v_book_id);
  
  -- 3. Link to Category 
  SELECT category_id INTO v_cat_id FROM categories WHERE category_name = 'Fantasy';
  
  -- B. EMPLOYEES
  pkg_employee_manager.add_employee('Alice', 'Admin', v_emp_id);
  -- (Trigger trg_add_emp will automatically generate her keycard!)

  -- C. CUSTOMERS
  pkg_customer_manager.add_customer('John', 'Doe', v_cust_id);      -- Regular Guy
  pkg_customer_manager.add_customer('Jane', 'Reader', v_cust_id);   -- Future VIP

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Entities loaded successfully.');
END;
/
