create table loan_books (
       book_id number(10) not null,
       loan_id number(10) not null,    
       constraint pk_loan_books primary key (book_id, loan_id),
       constraint fk_loan_books_book_id foreign key (book_id) references books (book_id),
       constraint fk_loan_books_loan_id foreign key (loan_id) references loans (loan_id) on delete cascade
) tablespace users;
/
