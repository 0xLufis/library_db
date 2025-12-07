CREATE OR REPLACE TRIGGER trg_add_emp
  BEFORE INSERT ON employees
  FOR EACH ROW
BEGIN
  IF :new.keycard_number IS NULL
  THEN
    pkg_employee_manager.generate_kc_code(:new.keycard_number);
  END IF;
END trg_assign_emp_keycard_nr;
/
