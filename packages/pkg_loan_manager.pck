CREATE OR REPLACE PACKAGE pkg_loan_manager IS

  PROCEDURE create_loan(p_customer_id  IN loans.customer_id%TYPE
                       ,p_employee_id  IN loans.employee_id%TYPE
                       ,p_days_to_rent IN NUMBER DEFAULT 14 -- Default 2 het
                       ,o_loan_id      OUT loans.loan_id%TYPE);

  PROCEDURE add_book_to_loan(p_loan_id IN loan_books.loan_id%TYPE
                            ,p_book_id IN loan_books.book_id%TYPE);

  PROCEDURE return_loan(p_loan_id IN loans.loan_id%TYPE);

END pkg_loan_manager;
/
CREATE OR REPLACE PACKAGE BODY pkg_loan_manager IS

  PROCEDURE create_loan(p_customer_id  IN loans.customer_id%TYPE
                       ,p_employee_id  IN loans.employee_id%TYPE
                       ,p_days_to_rent IN NUMBER DEFAULT 14
                       ,o_loan_id      OUT loans.loan_id%TYPE) IS
    v_active_loan_count NUMBER;
  BEGIN
    -- 1. Get new ID
    SELECT seq_loan_id.nextval INTO o_loan_id FROM dual;
  
    -- 2. Insert the new loan first
    INSERT INTO loans
      (loan_id
      ,customer_id
      ,employee_id
      ,loan_date
      ,return_by_date
      ,fine_amount)
    VALUES
      (o_loan_id
      ,p_customer_id
      ,p_employee_id
      ,SYSDATE
      ,SYSDATE + p_days_to_rent
      ,0);
  
    -- 3. LOGIC: Check for VIP Status
    SELECT COUNT(*)
      INTO v_active_loan_count
      FROM loans
     WHERE customer_id = p_customer_id
       AND returned_at_date IS NULL;
  
    -- FIXED: Changed 'is_vip' to 'vip' to match your table column
    IF v_active_loan_count >= 5
    THEN
      UPDATE customers
         SET vip = 'Y' -- <--- THIS WAS THE ERROR
       WHERE customer_id = p_customer_id;
    END IF;
  
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      raise_application_error(-20002, 'Error creating loan: ' || SQLERRM);
  END create_loan;

  -- (Rest of the package remains the same) --
  PROCEDURE add_book_to_loan(p_loan_id IN loan_books.loan_id%TYPE
                            ,p_book_id IN loan_books.book_id%TYPE) IS
    v_stock NUMBER;
  BEGIN
    SELECT stock INTO v_stock FROM books WHERE book_id = p_book_id;
  
    IF v_stock > 0
    THEN
      INSERT INTO loan_books
        (loan_id
        ,book_id)
      VALUES
        (p_loan_id
        ,p_book_id);
      UPDATE books SET stock = stock - 1 WHERE book_id = p_book_id;
      COMMIT;
    ELSE
      raise_application_error(-20003, 'Book out of stock.');
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20002,
                              'Error adding book to loan: ' || SQLERRM);
  END add_book_to_loan;

  PROCEDURE return_loan(p_loan_id IN loans.loan_id%TYPE) IS
    v_due_date      loans.return_by_date%TYPE;
    v_returned_date loans.returned_at_date%TYPE;
    v_fine          loans.fine_amount%TYPE := 0;
    v_days_late     NUMBER;
    c_daily_fine CONSTANT NUMBER := 500;
  BEGIN
    SELECT return_by_date
          ,returned_at_date
      INTO v_due_date
          ,v_returned_date
      FROM loans
     WHERE loan_id = p_loan_id
       FOR UPDATE;
  
    IF v_returned_date IS NOT NULL
    THEN
      raise_application_error(-20004, 'Loan has already been returned.');
    END IF;
  
    IF trunc(SYSDATE) > trunc(v_due_date)
    THEN
      v_days_late := trunc(SYSDATE) - trunc(v_due_date);
      v_fine      := v_days_late * c_daily_fine;
    END IF;
  
    UPDATE loans
       SET returned_at_date = SYSDATE
          ,fine_amount      = v_fine
     WHERE loan_id = p_loan_id;
  
    FOR r_book IN (SELECT book_id FROM loan_books WHERE loan_id = p_loan_id)
    LOOP
      UPDATE books SET stock = stock + 1 WHERE book_id = r_book.book_id;
    END LOOP;
  
    COMMIT;
  EXCEPTION
    WHEN no_data_found THEN
      ROLLBACK;
      raise_application_error(-20005, 'Loan ID not found.');
    WHEN OTHERS THEN
      ROLLBACK;
      raise_application_error(-20002, 'Error returning loan: ' || SQLERRM);
  END return_loan;

END pkg_loan_manager;
/
/
