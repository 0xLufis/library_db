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

END;
/
