CREATE OR REPLACE TRIGGER trg_books_history_id
  BEFORE INSERT ON books_history
  FOR EACH ROW
BEGIN
  IF :new.history_id IS NULL
  THEN
    SELECT seq_history_id.nextval INTO :new.history_id FROM dual;
  END IF;
END;
/
