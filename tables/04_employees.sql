create sequence seq_employee_id start with 1 increment by 1;
create table employees (
       employee_id number(10) not null ,
       first_name varchar2(100) not null,
       last_name varchar2(100) not null,
       role_id number(10),
       keycard_number number(10), 
       constraint pk_employees primary key (employee_id),
       constraint fk_employees_role_id foreign key (role_id) references employee_roles (role_id),
       constraint uk_employees_kc_number unique (keycard_number)
) tablespace users;
/
