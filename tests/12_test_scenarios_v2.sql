SET SERVEROUTPUT ON;
DECLARE
  v_cust_id  NUMBER;
  v_emp_id   NUMBER;
  v_book_id1 NUMBER; 
  v_book_id2 NUMBER; 
  v_loan_id  NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- RUNNING TEST SCENARIOS ---');

  -- 1. Get Data Handles
  BEGIN
    SELECT customer_id INTO v_cust_id FROM customers WHERE last_name = 'Reader' AND rownum = 1;
    SELECT employee_id INTO v_emp_id FROM employees WHERE rownum = 1;
    -- Get two distinct books
    SELECT min(book_id) INTO v_book_id1 FROM books;
    SELECT max(book_id) INTO v_book_id2 FROM books WHERE book_id != v_book_id1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('CRITICAL ERROR: Test data not found. Did 10_test_data.sql run successfully?');
      RETURN; -- Stop the script
  END;

  -- ========================================================
  -- SCENARIO 1: VIP Test
  -- Rent 5 books to Jane Reader
  -- ========================================================
  DBMS_OUTPUT.PUT_LINE('1. Testing VIP Trigger (Target: Jane Reader)...');

  FOR i IN 1..5 LOOP
    pkg_loan_manager.create_loan(v_cust_id, v_emp_id, 14, v_loan_id);
    pkg_loan_manager.add_book_to_loan(v_loan_id, v_book_id1); 
  END LOOP;

  -- Verify
  FOR r IN (SELECT vip FROM customers WHERE customer_id = v_cust_id) LOOP
    IF r.vip = 'Y' THEN
      DBMS_OUTPUT.PUT_LINE('   [PASS] Jane is now a VIP.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('   [FAIL] Jane is still normal status.');
    END IF;
  END LOOP;

  -- ========================================================
  -- SCENARIO 2: Late Return & Fine
  -- ========================================================
  DBMS_OUTPUT.PUT_LINE('2. Testing Late Return Logic...');

  -- Create a loan for the second book
  pkg_loan_manager.create_loan(v_cust_id, v_emp_id, 14, v_loan_id);
  pkg_loan_manager.add_book_to_loan(v_loan_id, v_book_id2);

  -- Force Update: Make due date 5 days ago
  UPDATE loans SET return_by_date = SYSDATE - 5 WHERE loan_id = v_loan_id;
  COMMIT;

  -- Return the loan
  pkg_loan_manager.return_loan(v_loan_id);

  -- Verify Fine
  FOR r IN (SELECT fine_amount FROM loans WHERE loan_id = v_loan_id) LOOP
    IF r.fine_amount > 0 THEN
       DBMS_OUTPUT.PUT_LINE('   [PASS] Loan Returned. Fine calculated: ' || r.fine_amount);
    ELSE
       DBMS_OUTPUT.PUT_LINE('   [FAIL] No fine calculated.');
    END IF;
  END LOOP;

  -- ========================================================
  -- SCENARIO 3: Stock Audit
  -- ========================================================
  DBMS_OUTPUT.PUT_LINE('3. Checking Audit Log...');
  FOR r IN (SELECT COUNT(*) as cnt FROM books_history) LOOP
    DBMS_OUTPUT.PUT_LINE('   History entries found: ' || r.cnt);
  END LOOP;
  
  -- ========================================================
  -- SCENARIO 4: Create Active Overdue Loan (For View Demo)
  -- ========================================================
  DBMS_OUTPUT.PUT_LINE('4. Creating a lingering Overdue Loan...');

  -- 1. Find a new customer (Michael Johnson) and a book (Dune)
  SELECT customer_id INTO v_cust_id FROM customers WHERE first_name = 'Michael' AND last_name = 'Johnson';
  
  -- Get book ID for 'Dune' (or any book not currently rented)
  SELECT book_id INTO v_book_id1 
    FROM books 
   WHERE title = 'Dune' 
     AND rownum = 1;

  -- 2. Create the loan
  pkg_loan_manager.create_loan(v_cust_id, v_emp_id, 14, v_loan_id);
  pkg_loan_manager.add_book_to_loan(v_loan_id, v_book_id1);

  -- 3. TIME TRAVEL HACK: Set the due date to 10 days ago
  -- This makes it "Overdue" right now
  UPDATE loans 
     SET return_by_date = SYSDATE - 10 
   WHERE loan_id = v_loan_id;
   
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('   [SUCCESS] Loan ID ' || v_loan_id || ' is now artificially overdue by 10 days.');
  
  -- ========================================================
  -- SCENARIO 5: Create Inactive User (For View Demo)
  -- ========================================================
  DBMS_OUTPUT.PUT_LINE('5. Creating Inactive User...');

  -- We simply create him and DO NOT create a loan.
  -- We reuse the v_cust_id variable just to hold the output ID.
  pkg_customer_manager.add_customer('Gary', 'Ghost', v_cust_id);

  DBMS_OUTPUT.PUT_LINE('   [SUCCESS] Customer "Gary Ghost" created. He has 0 loans.');

END;
/
