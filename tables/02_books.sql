CREATE SEQUENCE seq_book_id START WITH 1 INCREMENT BY 1;
create table books (
       book_id NUMBER(10) not null,
       isbn VARCHAR2(13) not null,
       title varchar2(200) not null,
       publish_year number(5),
       stock number(5) default 0 not null,
       author_id number(10) not null,
       created_at DATE DEFAULT SYSDATE,
       CONSTRAINT pk_books primary key (book_id),
       constraint uk_books_isbn unique (isbn),
       constraint fk_books_author foreign key (author_id) references authors (author_id),
       constraint chk_stock_not_negative CHECK (stock >= 0)
) tablespace users;
/
