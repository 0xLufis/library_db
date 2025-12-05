----------------------------------
-- 1. Create user, add grants   --
----------------------------------
DECLARE
  CURSORE cur IS
    SELECT 'alter system kill session ''' || sid || ',' || serial# || '''' AS command
      FROM v$session
     WHERE username = 'LIBRARY_MANAGER';
BEGIN
  FOR c IN cur LOOP
    EXECUTE IMMEDIATE c.command;
  END LOOP;
END;


DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM dba_users t WHERE t.username='library_MANAGER';
  IF v_count = 1 THEN 
    EXECUTE IMMEDIATE 'DROP USER library_manager CASCADE';
  END IF;
END;

CREATE USER library_manager 
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
grant CREATE JOB TO library_manager;

ALTER SESSION SET CURRENT_SCHEMA=library_manager;
