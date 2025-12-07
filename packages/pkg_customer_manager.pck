CREATE OR REPLACE PACKAGE pkg_customer_manager IS
  PROCEDURE add_customer(p_first_name  IN customers.first_name%TYPE
                        ,p_last_name   IN customers.last_name%TYPE
                        ,o_customer_id OUT customers.customer_id%TYPE);

  FUNCTION get_customer_name(p_customer_id IN NUMBER) RETURN VARCHAR2;
END pkg_customer_manager;
/
CREATE OR REPLACE PACKAGE BODY pkg_customer_manager IS
  PROCEDURE add_customer(p_first_name  IN customers.first_name%TYPE
                        ,p_last_name   IN customers.last_name%TYPE
                        ,o_customer_id OUT customers.customer_id%TYPE) IS
  BEGIN
    SELECT seq_customer_id.nextval INTO o_customer_id FROM dual;
  
    INSERT INTO customers
      (customer_id
      ,first_name
      ,last_name
      ,joined_at
      ,vip)
    VALUES
      (o_customer_id
      ,p_first_name
      ,p_last_name
      ,SYSDATE
      ,'N');
  
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(-20002,
                              'Error creating customer: ' || SQLERRM);
  END add_customer;

  FUNCTION get_customer_name(p_customer_id IN NUMBER) RETURN VARCHAR2 IS
    v_name VARCHAR2(200);
  BEGIN
    SELECT first_name || ' ' || last_name
      INTO v_name
      FROM customers
     WHERE customer_id = p_customer_id;
    RETURN v_name;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN NULL;
  END get_customer_name;

END pkg_customer_manager;
/
