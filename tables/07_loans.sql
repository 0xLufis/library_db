create sequence seq_loan_id start with 100 increment by 1 minvalue 100;
create table loans (
       loan_id number(10) not null,
       customer_id number(10) not null,
       loan_date date default sysdate,
       return_by_date date not null,
       employee_id number(10) not null,
       returned_at_date date,
       fine_amount number(8,2) default 0,
       constraint pk_loan primary key (loan_id),
       constraint fk_loan_customer_id foreign key (customer_id) references customers (customer_id),
       constraint fk_loan_employee_id foreign key (employee_id) references employees (employee_id)
) tablespace users;
/
