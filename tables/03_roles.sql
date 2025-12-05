create sequence seq_role_id start with 1 increment by 1;

create table (
       role_id number(3) not null primary key,
       role_name varchar2(10)not null unique,
       role_desc varchar2(200) not null
)
