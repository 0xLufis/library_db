# Library Management System (Oracle 11g)

This project is a PL/SQL backend solution for a library management system designed for Oracle Database 11g. It utilizes PL/SQL packages for business logic, triggers for automation, and views for reporting. The system handles book inventory, customer memberships, employee roles, and loan processing with fine calculation.

## System Overview

The system is composed of the following functional areas:

### Core Logic (Packages)
* **Book Management:** Procedures to add books, authors, and categories. Handles many-to-many relationships between books and categories.
* **Customer Management:** Logic for registering customers and tracking membership details.
* **Employee Management:** Manages staff records and role assignments.
* **Loan Processing:** Handles the lifecycle of a loan (creation, return) including stock adjustments and fine calculation based on due dates.

### Automation (Triggers)
* **Keycard Generation:** Automatically generates a unique 10-digit code for new employees upon insertion.
* **VIP Status Update:** Automatically promotes customers to 'VIP' status once they exceed 5 successful loans.
* **Audit Logging:** Tracks changes to book stock levels in a separate history table (`books_history`), recording the old value, new value, user, and timestamp.
* **Business Rules:** Prevents loan creation if a customer has outstanding fines exceeding the limit.

### Reporting (Views)
* **view_library_catalog:** specific view joining books, authors, and categories for inventory checks.
* **view_loan_status:** Tracks active and overdue loans, calculating days late dynamically.
* **view_customer_history:** A comprehensive history of all customer activity, including inactive users.

## Prerequisites

* **Database:** Oracle Database 11g Express Edition (XE) or higher.
* **IDE:** PL/SQL Developer (Allround Automations) is recommended for running the command scripts.
* **Permissions:** Initial setup requires a user with `SYSTEM` or `DBA` privileges to create the project user.

# Directory Structure

```
├── packages
│   ├── pkg_author_manager.pck
│   ├── pkg_book_manager.pck
│   ├── pkg_category_manager.pck
│   ├── pkg_customer_manager.pck
│   ├── pkg_employee_manager.pck
│   ├── pkg_loan_manager.pck
│   └── pkg_role_manager.pck
├── tests
│   ├── 10_test_reference_v2.sql
│   ├── 10_test_reference.sql
│   ├── 11_test_entities.sql
│   └── 12_test_scenarios_v2.sql
├── triggers
│   ├── trg_add_emp.trg
│   ├── trg_audit_book_stock.trg
│   ├── trg_books_history_id.trg
│   ├── trg_low_stock_alert.trg
│   ├── trg_prevent_loan_if_debt.trg
│   └── trg_update_vip_status.trg
├── views
│   ├── 23_basic_views.sql
│   └── 24_views_demo.sql
├── .gitignore
├── 00_cleanup.sql
├── 01_user.sql
├── 02_tables_v2.sql
├── 03_packages.sql
├── 04_triggers.sql
├── README.md
└── SETUP.sql
```
## Installation

### 1. For a clean build
1.  Connect to the database as `SYSTEM` (or another DBA account).
2.  Run the setup script:
    `@SETUP.sql`
    This creates the user `LIBRARY_MANAGER`
    and runs all further scripts.

This script will perform a full build cycle:
1.  Clean existing objects.
2.  Create tables and sequences.
3.  Compile packages and triggers.
4.  Load reference and test data.
5.  Execute validation scenarios.

## Usage and Testing

### Reporting Views
The following views and are available for querying system status:

```sql
-- Inventory check
SELECT * FROM view_library_catalog;

-- Overdue loans check
SELECT * FROM view_loan_status WHERE "Status" = 'OVERDUE!';

-- Staff details
SELECT * FROM view_staff_roster;





