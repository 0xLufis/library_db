DECLARE
  CURSOR cur IS
    SELECT 'alter system kill session ''' || sid || ',' || serial# || '''' AS command
      FROM v$session
     WHERE username = 'LIBRARY_MANAGER';
BEGIN
  FOR c IN cur
  LOOP
    EXECUTE IMMEDIATE c.command;
  END LOOP;
END;
/
DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*)
    INTO v_count
    FROM dba_users t
   WHERE t.username = 'LIBRARY_MANAGER';
  IF v_count != 0
  THEN
    EXECUTE IMMEDIATE ' DROP USER LIBRARY_MANAGER CASCADE ';
  END IF;
END;
/
