SET SERVEROUTPUT ON;
PROMPT === CREATING HUMAN-READABLE VIEWS ===
-- NOTE: Not much use for the HUMAN READABLE part but it looks cool in the demo queries
-- 1. CATALOG VIEW (Books + Authors + Categories)
CREATE OR REPLACE VIEW view_library_catalog AS
SELECT b.book_id
      ,b.title AS "Book Title"
      ,a.first_name || ' ' || a.last_name AS "Author"
      ,c.category_name AS "Category"
      ,b.publish_year AS "Year"
      ,b.isbn AS "ISBN"
      ,CASE 
         WHEN b.stock > 0 THEN 'In Stock (' || b.stock || ')'
         ELSE 'OUT OF STOCK'
       END AS "Availability"
  FROM books b
  JOIN authors a ON b.author_id = a.author_id
  JOIN book_categories bc ON b.book_id = bc.book_id
  JOIN categories c ON bc.category_id = c.category_id
 ORDER BY b.title, c.category_name;

-- 2. LOAN STATUS VIEW 
CREATE OR REPLACE VIEW view_loan_status AS
SELECT l.loan_id
      ,cust.first_name || ' ' || cust.last_name AS "Customer Name"
      ,b.title AS "Book Borrowed"
      ,TO_CHAR(l.loan_date, 'YYYY-MM-DD') AS "Borrowed On"
      ,TO_CHAR(l.return_by_date, 'YYYY-MM-DD') AS "Due Date"
      ,CASE 
         WHEN l.returned_at_date IS NOT NULL THEN 'Returned'
         WHEN SYSDATE > l.return_by_date THEN 'OVERDUE!'
         ELSE 'Active' 
       END AS "Status"
      ,CASE 
         WHEN l.returned_at_date IS NULL AND SYSDATE > l.return_by_date 
         THEN FLOOR(SYSDATE - l.return_by_date) 
         ELSE 0 
       END AS "Days Late"
      ,TRIM(TO_CHAR(l.fine_amount, '99990.00')) AS "Fine Due"
  FROM loans l
  JOIN loan_books lb ON l.loan_id = lb.loan_id
  JOIN books b ON lb.book_id = b.book_id
  JOIN customers cust ON l.customer_id = cust.customer_id
 ORDER BY l.loan_id DESC;

-- 3. STAFF ROSTER
CREATE OR REPLACE VIEW view_staff_roster AS
SELECT e.employee_id
      ,e.first_name || ' ' || e.last_name AS "Employee Name"
      ,r.role_name AS "Job Title"
      ,r.role_desc AS "Job Description"
      ,e.keycard_number AS "Keycard ID"
  FROM employees e
  JOIN employee_roles r ON e.role_id = r.role_id
 ORDER BY r.role_name, e.last_name;
 
-- 4. CUSTOMERS
CREATE OR REPLACE VIEW view_customer_history AS
SELECT c.customer_id
      ,c.first_name || ' ' || c.last_name AS "Customer Name"
      ,CASE 
         WHEN c.vip = 'Y' THEN 'VIP' 
         ELSE 'Standard' 
       END AS "Membership"
      ,b.title AS "Book Title"
      ,a.first_name || ' ' || a.last_name AS "Author"
      ,TO_CHAR(l.loan_date, 'YYYY-MM-DD') AS "Borrowed Date"
      ,TO_CHAR(l.returned_at_date, 'YYYY-MM-DD') AS "Returned Date"
      ,CASE 
         WHEN l.loan_id IS NULL THEN 'No Activity'
         WHEN l.returned_at_date IS NOT NULL THEN 'Returned'
         WHEN SYSDATE > l.return_by_date THEN 'OVERDUE'
         ELSE 'Active Loan'
       END AS "Status"
      ,l.fine_amount AS "Fine"
  FROM customers c
  LEFT JOIN loans l ON c.customer_id = l.customer_id
  LEFT JOIN loan_books lb ON l.loan_id = lb.loan_id
  LEFT JOIN books b ON lb.book_id = b.book_id
  LEFT JOIN authors a ON b.author_id = a.author_id
 ORDER BY c.last_name, l.loan_date DESC;

PROMPT Views updated with formatting.
