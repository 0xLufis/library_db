CREATE SEQUENCE seq_authors_id START WITH 1 INCREMENT BY 1;


create table authors (
       author_id NUMBER(10) PRIMARY KEY,
       first_name varchar2(100) NOT NULL,
       last_name varchar2(100) not null,
       created_at DATE DEFAULT SYSDATE
):

--Nem kell lehetne a PK kulon constraint is de jovanezigy
