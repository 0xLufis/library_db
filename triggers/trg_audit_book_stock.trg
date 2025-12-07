CREATE OR REPLACE TRIGGER trg_audit_book_stock
  AFTER UPDATE OF stock ON books
  FOR EACH ROW
BEGIN
  IF :old.stock != :new.stock
  THEN
    INSERT INTO books_history
      (book_id
      ,old_stock
      ,new_stock
      ,changed_by)
    VALUES
      (:new.book_id
      ,:old.stock
      ,:new.stock
      ,USER);
  END IF;
END trg_audit_book_stock;
/
