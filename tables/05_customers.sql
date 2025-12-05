create sequence seq_employee_id start with 1 increment by 1;

create table customers(
       customer_id number(10) not null,
       first_name varchar2(100) not null,
       last_name varchar2(100) not null,
       joined_at date default SYSDATE not null,
       vip char default 'N', --x kolcsonzes utan triggerlt
       
       constraint pk_customers primary key (customer_id)
)
