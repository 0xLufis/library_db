CREATE SEQUENCE seq_authors_id START WITH 1 INCREMENT BY 1;
create table authors (
       author_id number(10),
       first_name varchar2(100) NOT NULL,
       last_name varchar2(100) not null,
       created_at DATE DEFAULT SYSDATE,
       constraint pk_authors primary key (author_id)
) tablespace users;
/

