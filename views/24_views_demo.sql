SET LINESIZE 200; -- Makes the output wider so columns don't wrap ugly
SET PAGESIZE 100;

PROMPT ========================================================
PROMPT   LIBRARY SYSTEM - VIEW SHOWCASE
PROMPT ========================================================

-- ============================================================
-- SCENARIO 1: INVENTORY MANAGEMENT
-- ============================================================
PROMPT      
PROMPT [Query 1] Showing all Sci-Fi books and their availability...
SELECT "Book Title", "Author", "Availability"
  FROM view_library_catalog
 WHERE "Category" = 'Sci-Fi';


-- ============================================================
-- SCENARIO 2: OVERDUE ALERTS
-- Question: "Who is late returning books right now?"
PROMPT       
PROMPT [Query 2] ALERT: List of currently OVERDUE loans...
SELECT "Customer Name", "Book Borrowed", "Days Late", "Fine Due"
  FROM view_loan_status
 WHERE "Status" = 'OVERDUE!';


-- ============================================================
-- SCENARIO 3: STAFF DIRECTORY
-- ============================================================
PROMPT      
PROMPT [Query 3] Staff List: Front Desk Librarians...
SELECT "Employee Name", "Keycard ID"
  FROM view_staff_roster
 WHERE "Job Title" = 'LIBRARIAN';


-- ============================================================
-- SCENARIO 4: VIP ANALYSIS
-- ============================================================
PROMPT      
PROMPT [Query 4] Auditing VIP Member Activity...
SELECT "Customer Name", "Book Title", "Borrowed Date", "Status"
  FROM view_customer_history
 WHERE "Membership" = 'VIP'
 ORDER BY "Customer Name", "Borrowed Date" DESC;


-- ============================================================
-- SCENARIO 5: FINANCIAL REPORT
-- ============================================================
PROMPT      
PROMPT [Query 5] Financial Report: Outstanding Fines...
SELECT "Customer Name", "Fine"
  FROM view_customer_history
 WHERE "Fine" > 0;


-- ============================================================
-- SCENARIO 6: MARKETING TARGETS
-- ============================================================
PROMPT      
PROMPT [Query 6] Marketing List: Inactive Customers...
SELECT "Customer Name", "Membership"
  FROM view_customer_history
 WHERE "Status" = 'No Activity';

PROMPT          
PROMPT ========================================================
PROMPT   SHOWCASE COMPLETE
PROMPT ========================================================
