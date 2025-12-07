SELECT * FROM view_library_catalog;
SELECT * FROM view_loan_status;
SELECT * FROM view_staff_roster;
SELECT * FROM view_customer_history;
SELECT * FROM view_customer_history 
 WHERE "Status" = 'OVERDUE' OR "Fine" > 0;
SELECT * FROM view_customer_history 
 WHERE "Status" = 'No Activity';
