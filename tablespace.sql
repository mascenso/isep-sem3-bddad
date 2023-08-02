--ORACLE 21C
--XEPDB1
SELECT CON_ID, NAME FROM V$CONTAINERS;
alter session set "_ORACLE_SCRIPT"=TRUE;

-- criacao tablespaces
CREATE TABLESPACE study
    DATAFILE '/opt/oracle/oradata/XE/tablespace1.dbf' SIZE 100M
    online
    extent management local autoallocate
    segment space management auto;

SELECT tablespace_name
FROM dba_tablespaces
WHERE tablespace_name = 'STUDY';

-- criacao utilizador
create user mariana identified by mypassword
    default tablespace study
    temporary tablespace TEMP;
grant create session, create table, create view, create procedure, create trigger, create
    sequence to mariana;
alter user mariana quota unlimited on study;

--eliminar utilizador
drop user mariana;
--eliminar tablespace
DROP TABLESPACE study
    INCLUDING CONTENTS and  DATAFILES
    CASCADE CONSTRAINTS;