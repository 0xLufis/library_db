CREATE OR REPLACE PACKAGE pkg_book_manager IS

  PROCEDURE add_book(p_isbn      IN books.isbn%TYPE
                    ,p_title     IN books.title%TYPE
                    ,p_pub_year  IN books.publish_year%TYPE
                    ,p_author_id IN books.author_id%TYPE
                    ,p_stock     IN books.stock%TYPE
                    ,o_book_id   OUT books.book_id%TYPE);

  PROCEDURE add_book_category(p_book_id     IN book_categories.book_id%TYPE
                             ,p_category_id IN book_categories.category_id%TYPE);
END pkg_book_manager;
/
CREATE OR REPLACE PACKAGE BODY pkg_book_manager IS

  PROCEDURE add_book(p_isbn      IN books.isbn%TYPE
                    ,p_title     IN books.title%TYPE
                    ,p_pub_year  IN books.publish_year%TYPE
                    ,p_author_id IN books.author_id%TYPE
                    ,p_stock     IN books.stock%TYPE
                    ,o_book_id   OUT books.book_id%TYPE) IS
  BEGIN
    SELECT seq_book_id.nextval INTO o_book_id FROM dual;
  
    INSERT INTO books
      (book_id
      ,isbn
      ,title
      ,publish_year
      ,stock
      ,author_id
      ,created_at)
    VALUES
      (o_book_id
      ,p_isbn
      ,p_title
      ,p_pub_year
      ,p_stock
      ,p_author_id
      ,SYSDATE);
  
    COMMIT;
  EXCEPTION
    WHEN dup_val_on_index THEN
      raise_application_error(-20001,
                              'Book with this ISBN already exists.');
    WHEN OTHERS THEN
      raise_application_error(-20002, 'Error creating book: ' || SQLERRM);
  END add_book;

  PROCEDURE add_book_category(p_book_id     IN book_categories.book_id%TYPE
                             ,p_category_id IN book_categories.category_id%TYPE) IS
  BEGIN
    INSERT INTO book_categories
      (book_id
      ,category_id)
    VALUES
      (p_book_id
      ,p_category_id);
    COMMIT;
  EXCEPTION
    WHEN dup_val_on_index THEN
      NULL; -- Ignore if link already exists
    WHEN OTHERS THEN
      raise_application_error(-20002,
                              'Error linking category: ' || SQLERRM);
  END add_book_category;
END pkg_book_manager;
/
