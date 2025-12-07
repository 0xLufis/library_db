CREATE SEQUENCE seq_history_id START WITH 1 INCREMENT BY 1;
CREATE TABLE books_history (
    history_id NUMBER NOT NULL,
    book_id NUMBER,
    old_stock NUMBER,
    new_stock NUMBER,
    changed_by VARCHAR2(50),
    changed_at DATE DEFAULT SYSDATE,
    CONSTRAINT pk_books_history PRIMARY KEY (history_id)
);
/
