CREATE OR REPLACE PACKAGE pkg_employee_manager IS
  PROCEDURE add_employee(p_first_name  IN employees.first_name%TYPE
                        ,p_last_name   IN employees.last_name%TYPE
                        ,o_employee_id OUT employees.employee_id%TYPE);

  FUNCTION get_employee_name(p_employee_id IN NUMBER) RETURN VARCHAR2;

  PROCEDURE generate_kc_code(p_generated_code OUT VARCHAR2);

  PROCEDURE assign_role(p_employee_id IN employees.employee_id%TYPE
                       ,p_role_id     IN employee_roles.role_id%TYPE);

END pkg_employee_manager;
/
/
CREATE OR REPLACE PACKAGE BODY pkg_employee_manager IS

  -- Existing add_employee
  PROCEDURE add_employee(p_first_name  IN employees.first_name%TYPE
                        ,p_last_name   IN employees.last_name%TYPE
                        ,o_employee_id OUT employees.employee_id%TYPE) IS
  BEGIN
    SELECT seq_employee_id.nextval INTO o_employee_id FROM dual;
    INSERT INTO employees
      (employee_id
      ,first_name
      ,last_name) -- role_id is initially NULL
    VALUES
      (o_employee_id
      ,p_first_name
      ,p_last_name);
    COMMIT;
  EXCEPTION
    WHEN dup_val_on_index THEN
      raise_application_error(-20001, 'Employee already exists.');
    WHEN OTHERS THEN
      raise_application_error(-20002,
                              'Error creating employee: ' || SQLERRM);
  END add_employee;

  -- Existing get_employee_name
  FUNCTION get_employee_name(p_employee_id IN NUMBER) RETURN VARCHAR2 IS
    v_emp_name VARCHAR2(100);
  BEGIN
    SELECT first_name || ' ' || last_name
      INTO v_emp_name
      FROM employees
     WHERE employee_id = p_employee_id;
    RETURN v_emp_name;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN NULL;
  END get_employee_name;

  -- Existing generate_kc_code
  PROCEDURE generate_kc_code(p_generated_code OUT VARCHAR2) IS
    v_random_code VARCHAR2(10);
    v_count       NUMBER;
  BEGIN
    LOOP
      v_random_code := lpad(trunc(dbms_random.value(0, 9999999999)),
                            10,
                            '0');
      SELECT COUNT(*)
        INTO v_count
        FROM employees e
       WHERE e.keycard_number = v_random_code;
      EXIT WHEN v_count = 0;
    END LOOP;
    p_generated_code := v_random_code;
  END generate_kc_code;

  PROCEDURE assign_role(p_employee_id IN employees.employee_id%TYPE
                       ,p_role_id     IN employee_roles.role_id%TYPE) IS
    v_check NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO v_check
      FROM employee_roles
     WHERE role_id = p_role_id;
    IF v_check = 0
    THEN
      raise_application_error(-20007,
                              'Role ID ' || p_role_id || ' does not exist.');
    END IF;
  
    UPDATE employees
       SET role_id = p_role_id
     WHERE employee_id = p_employee_id;
  
    IF SQL%ROWCOUNT = 0
    THEN
      raise_application_error(-20006,
                              'Employee ID ' || p_employee_id ||
                              ' not found.');
    END IF;
  
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      IF SQLCODE BETWEEN - 20999 AND - 20000
      THEN
        RAISE;
      END IF;
      raise_application_error(-20002, 'Error assigning role: ' || SQLERRM);
  END assign_role;

END pkg_employee_manager;
/
/
