SET SERVEROUTPUT ON;
PROMPT =============================================================
PROMPT The Following script WILL, DROP all data associated with the 
PROMPT user named "LIBRARY_MANAGER"
PRMOPT if you wish NOT to touch the db input any PATH that is NOT the db
PROMPT =============================================================


    PROMPT =============================================================
    PROMPT Please enter the directory path where your files are.
    PROMPT You can use forward slashes (/) on Windows too!
    PROMPT Example: C:/Users/User/Documents/Oracle/db/project/
    PROMPT (IMPORTANT: You must end the path with a slash /)
    PROMPT =============================================================
    ACCEPT p_cwd CHAR PROMPT 'Working Directory: '
  
    PROMPT
    PROMPT === Path set to: &p_cwd ===
    PROMPT
    -- I could porbably write a script that runs vereything from each folder, but it might actually be safer for the purposes to just manulally type the script out
    PROMPT === Running cleanup script ===
    @&p_cwd.00_cleanup
    PROMPT === BUILDING USERS ===
    @&p_cwd.01_user
    PROMPT === BUILDING TABLES ===
    @&p_cwd.02_tables_v2
    PROMPT === BUILDING PACKAGES ===
    @&p_cwd.03_packages
    PROMPT === BUILDING TRIGGERS ===
    @&p_cwd.04_triggers
  
    PROMPT === LOADING TEST DATA ===
    @&p_cwd./tests/10_test_reference_v2.sql
    @&p_cwd./tests/11_test_entities.sql
    @&p_cwd./tests/12_test_scenarios_v2.sql
  
    PROMPT === PROJECT READY ===
