CREATE OR REPLACE PACKAGE pkg_author_manager IS
  PROCEDURE add_author(p_first_name IN authors.first_name%TYPE
                      ,p_last_name  IN authors.last_name%TYPE
                      ,o_author_id  OUT authors.author_id%TYPE);

  FUNCTION get_author_name(p_author_id IN NUMBER) RETURN VARCHAR2;

END pkg_author_manager;
/
CREATE OR REPLACE PACKAGE BODY pkg_author_manager IS

  PROCEDURE add_author(p_first_name IN authors.first_name%TYPE
                      ,p_last_name  IN authors.last_name%TYPE
                      ,o_author_id  OUT authors.author_id%TYPE) IS
  BEGIN
    SELECT seq_authors_id.nextval INTO o_author_id FROM dual;
  
    INSERT INTO authors
      (author_id
      ,first_name
      ,last_name)
    VALUES
      (o_author_id
      ,p_first_name
      ,p_last_name);
  
    COMMIT;
  EXCEPTION
    WHEN dup_val_on_index THEN
      raise_application_error(-20001, 'Author already exists.');
    WHEN other THEN
      raise_application_error(-20002, 'Error creating author: ' || SQLERRM);
  END add_author;

  FUNCTION get_author_name(p_author_id IN NUMBER) RETURN VARCHAR2 IS
    v_name VARCHAR2(200);
  BEGIN
    SELECT first_name || ' ' || last_name
      INTO v_name
      FROM authors
     WHERE author_id = p_author_id;
  
    RETURN v_name;
  EXCEPTION
    WHEN no_data_found THEN
      RETURN NULL;
  END get_author_name;

END pkg_author_manager;
/
