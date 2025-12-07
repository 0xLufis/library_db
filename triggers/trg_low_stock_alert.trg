CREATE OR REPLACE TRIGGER trg_low_stock_alert
  AFTER UPDATE OF stock ON books
  FOR EACH ROW
BEGIN
  -- 1. Check if stock dropped below the threshold (e.g., 3 )
  IF :new.stock < 3
     AND :old.stock >= 3
  THEN
    dbms_output.put_line('WARNING: Low stock for Book ID ' || :new.book_id ||
                         '. Only ' || :new.stock || ' left!');
  END IF;
END;
/
/
