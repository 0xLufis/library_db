create or replace package pkg_categories_manager is
PROCEDURE add_category(p_category_name IN categories.category_name%TYPE,
                      ,o_category_id  OUT categories.category_id%TYPE)
                      
  FUNCTION get_category_name(p_author_id IN NUMBER) RETURN VARCHAR2

end pkg_categories_manager;
/
CREATE OR REPLACE PACKAGE BODY pkg_category_manager IS

  PROCEDURE add_category(p_category_name IN categories.category_name%TYPE
                        ,
                        ,o_category_id   OUT categories.category_id%TYPE) IS
  BEGIN
    SELECT seq_categories_id.nextval INTO o_category_id FROM dual;
  
    INSERT INTO categories
      (category_id
      ,category_name)
    VALUES
      (o_category_id
      ,p_category_name);
  
    COMMIT;
  EXCEPTION
    WHEN dup_val_on_index THEN
      raise_application_error(-20001, 'category already exists.');
    WHEN other THEN
      raise_application_error(-20002,
                              'Error creating category: ' || SQLERRM);
  END add_category;

  FUNCTION get_category_name(p_category_id IN NUMBER) RETURN VARCHAR2 IS
    v_name VARCHAR2(200);
  BEGIN
    SELECT category_name
      INTO v_name
      FROM categories
     WHERE category_id = p_category_id;
  
    RETURN v_name;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN NULL;
  END get_category_name;

END pkg_category_manager;
/
