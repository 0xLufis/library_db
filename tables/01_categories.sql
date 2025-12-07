CREATE SEQUENCE seq_categories_id START WITH 1 INCREMENT BY 1;
create table categories (
       category_id number(5) NOT NULL,
       category_name VARCHAR2(50) NOT NULL, --50 karakterbe csak belefer minden
       constraint pk_categories primary key (category_id),
       constraint uk_category_name unique (category_name)
) tablespace users;
/
