CREATE OR REPLACE PACKAGE pkg_role_manager IS

  PROCEDURE add_role(p_role_name IN employee_roles.role_name%TYPE
                    ,p_role_desc IN employee_roles.role_desc%TYPE
                    ,o_role_id   OUT employee_roles.role_id%TYPE);

  TYPE role_with_desc IS RECORD(
     t_name employee_roles.role_name%TYPE
    ,t_desc employee_roles.role_desc%TYPE);

  FUNCTION get_role_name_with_desc(p_role_id IN NUMBER) RETURN role_with_desc;
  FUNCTION get_role_id(p_role_name IN VARCHAR2) RETURN NUMBER;

END pkg_role_manager;
/
CREATE OR REPLACE PACKAGE BODY pkg_role_manager IS
  PROCEDURE add_role(p_role_name IN employee_roles.role_name%TYPE
                    ,p_role_desc IN employee_roles.role_desc%TYPE
                    ,o_role_id   OUT employee_roles.role_id%TYPE) IS
  BEGIN
    SELECT seq_role_id.nextval INTO o_role_id FROM dual;
  
    INSERT INTO employee_roles
      (role_id
      ,role_name
      ,role_desc)
    VALUES
      (o_role_id
      ,p_role_name
      ,p_role_desc);
  
    COMMIT;
  EXCEPTION
    WHEN dup_val_on_index THEN
      raise_application_error(-20001, 'role already exists.');
    WHEN OTHERS THEN
      raise_application_error(-20002,
                              'Error creating category: ' || SQLERRM);
  END add_role;

  FUNCTION get_role_name_with_desc(p_role_id IN NUMBER) RETURN role_with_desc IS
    v_rec role_with_desc;
  BEGIN
    SELECT e.role_name
          ,e.role_desc
      INTO v_rec.t_name
          ,v_rec.t_desc
      FROM employee_roles e
     WHERE e.role_id = p_role_id;
  
    RETURN v_rec;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN NULL;
    
  END get_role_name_with_desc;

  FUNCTION get_role_id(p_role_name IN VARCHAR2) RETURN NUMBER IS
    v_id NUMBER;
  BEGIN
    SELECT role_id
      INTO v_id
      FROM employee_roles
     WHERE role_name = p_role_name;
    RETURN v_id;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN NULL;
  END get_role_id;

END pkg_role_manager;
/
