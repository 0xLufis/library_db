PROMPT Creating users, assigning grants...

--Create User
CREATE USER LIBRARY_MANAGER 
  IDENTIFIED BY "12345678" 
  DEFAULT TABLESPACE users
  QUOTA UNLIMITED ON users
;

--Grants
GRANT CREATE TRIGGER to library_manager;
GRANT CREATE SESSION TO library_manager;
GRANT CREATE TABLE TO library_manager;
GRANT CREATE VIEW TO library_manager;
GRANT CREATE SEQUENCE TO library_manager;
GRANT CREATE PROCEDURE TO library_manager;
GRANT CREATE TYPE TO library_manager;
GRANT CREATE JOB TO library_manager;

ALTER SESSION SET CURRENT_SCHEMA=library_manager;
/
