CREATE OR REPLACE TRIGGER trg_prevent_loan_if_debt
  BEFORE INSERT ON loans
  FOR EACH ROW
DECLARE
  v_total_fine NUMBER;
BEGIN
  --Check if the customer has any unpaid fines in their history
  SELECT nvl(SUM(fine_amount), 0)
    INTO v_total_fine
    FROM loans
   WHERE customer_id = :new.customer_id
     AND fine_amount > 0;

  --If debt exists, block the new loan
  IF v_total_fine > 0
  THEN
    raise_application_error(-20010,
                            'Cannot create loan: Customer has outstanding fines of ' ||
                            v_total_fine);
  END IF;
END;
/
/
