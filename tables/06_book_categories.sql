create table book_categories (
       book_id number(10) not null,
       category_id number(10) not null,
       
       constraint fk_bc_book foreign key (book_id) references books (book_id) ON DELETE CASCADE, --Ha nincs konyv nincs kategoria
       constraint fk_bc_category foreign key (category_id) references categories (category_id),
       constraint pk_book_categories primary key (book_id, category_id)
);
