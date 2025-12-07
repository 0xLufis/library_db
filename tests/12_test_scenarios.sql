DECLARE
  v_cust_id  NUMBER;
  v_emp_id   NUMBER;
  v_book_id1 NUMBER; -- Book for Scenario 1
  v_book_id2 NUMBER; -- Book for Scenario 2
  v_loan_id  NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- RUNNING TEST SCENARIOS ---');

  -- Get Data
  SELECT customer_id INTO v_cust_id FROM customers WHERE last_name = 'Reader';
  SELECT employee_id INTO v_emp_id FROM employees WHERE rownum = 1;
  
  -- Get TWO different books
  SELECT book_id INTO v_book_id1 FROM books WHERE rownum = 1; 
  SELECT book_id INTO v_book_id2 FROM books WHERE book_id != v_book_id1 AND rownum = 1;

  -- ========================================================
  -- SCENARIO 1: VIP Test (Uses Book 1)
  -- ========================================================
  DBMS_OUTPUT.PUT_LINE('1. Testing VIP Trigger...');

  FOR i IN 1..5 LOOP
    pkg_loan_manager.create_loan(v_cust_id, v_emp_id, 14, v_loan_id);
    pkg_loan_manager.add_book_to_loan(v_loan_id, v_book_id1); -- Uses Book 1
  END LOOP;

  -- Verify VIP
  FOR r IN (SELECT vip FROM customers WHERE customer_id = v_cust_id) LOOP
    IF r.vip = 'Y' THEN
      DBMS_OUTPUT.PUT_LINE('SUCCESS: Jane is now a VIP!');
    ELSE
      DBMS_OUTPUT.PUT_LINE('FAIL: Jane is still normal status.');
    END IF;
  END LOOP;

  -- ========================================================
  -- SCENARIO 2: LATE Return Test (Uses Book 2)
  -- ========================================================
  DBMS_OUTPUT.PUT_LINE('2. Testing Late Return Logic...');

  -- Create a loan using the SECOND book (which still has stock)
  pkg_loan_manager.create_loan(v_cust_id, v_emp_id, 14, v_loan_id);
  pkg_loan_manager.add_book_to_loan(v_loan_id, v_book_id2); -- Uses Book 2

  -- Force Date Change (Simulate 5 days late)
  UPDATE loans SET return_by_date = SYSDATE - 5 WHERE loan_id = v_loan_id;
  COMMIT;

  -- Return
  pkg_loan_manager.return_loan(v_loan_id);

  -- Verify Fine
  FOR r IN (SELECT fine_amount FROM loans WHERE loan_id = v_loan_id) LOOP
    DBMS_OUTPUT.PUT_LINE('   Loan Returned. Fine calculated: ' || r.fine_amount);
  END LOOP;

  -- ========================================================
  -- SCENARIO 3: Stock Audit
  -- ========================================================
  DBMS_OUTPUT.PUT_LINE('3. Testing Audit Log...');

  FOR r IN (SELECT COUNT(*) as cnt FROM books_history) LOOP
    DBMS_OUTPUT.PUT_LINE('   History entries found: ' || r.cnt);
  END LOOP;

END;
/
