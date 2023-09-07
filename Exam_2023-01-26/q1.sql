-- ## bootstrap ##
DROP TABLE bank_account              CASCADE CONSTRAINTS PURGE;
DROP TABLE movements                 CASCADE CONSTRAINTS PURGE;

-- ## tabela bank_account ##
CREATE TABLE bank_account (
    client_id           INTEGER,
    bank_account        INTEGER CONSTRAINT pkBankAccountId PRIMARY KEY,
    balance             INTEGER,
    incidents           INTEGER,
    client_since        DATE
);

-- ## tabela movements ##
CREATE TABLE movements (
    movement_id          INTEGER CONSTRAINT pkMovementId PRIMARY KEY,
    bank_account         INTEGER,
    amount               INTEGER,
    type                 VARCHAR2(20),
    transfer_bank        INTEGER,
    date_mov             DATE
);

-- ** alterar tabelas para definicaoo de chaves estrangeiras **
ALTER TABLE movements ADD CONSTRAINT fkBankAccount FOREIGN KEY (bank_account) REFERENCES bank_account(bank_account);
-- COMMIT;

insert into bank_account values (123, 870350248, 220, 1, TO_DATE('02-01-1987', 'DD-MM-YYYY'));
insert into bank_account values (543, 980100145, 210, 0, TO_DATE('23-11-1988', 'DD-MM-YYYY'));
insert into bank_account values (543, 988478233, 220, 2, TO_DATE('23-11-1998', 'DD-MM-YYYY'));
insert into bank_account values (760, 935468210, 500, 1, TO_DATE('13-10-1993', 'DD-MM-YYYY'));
insert into bank_account values (815, 990100145, -75, 3, TO_DATE('22-01-1999', 'DD-MM-YYYY'));
insert into bank_account values (190, 20170187, 350, 0,  TO_DATE('20-08-2002', 'DD-MM-YYYY'));

insert into movements values (2209811, 870350248, 1522,'withdrawal',    NULL,      TO_DATE('21/11/2022', 'DD-MM-YYYY'));
insert into movements values (2200522, 980100145, 235, 'deposit',       NULL,      TO_DATE('25/11/2022', 'DD-MM-YYYY'));
insert into movements values (2209812, 870350248, 1245,'transfer to',   20170187,  TO_DATE('28/12/2022', 'DD-MM-YYYY'));
insert into movements values (2202544, 20170187,  235, 'transfer from', 870350248, TO_DATE('28/12/2022', 'DD-MM-YYYY'));
insert into movements values (2300001, 980100145, 75,  'withdrawal',    NULL,      TO_DATE('01/01/2023', 'DD-MM-YYYY'));
insert into movements values (2300002, 870350248, 2357,'withdrawal',    NULL,      TO_DATE('01/01/2023', 'DD-MM-YYYY'));

-- # queries #

-- a) [30] Crie uma VIEW, de nome v_oldies, que permite obter as contas de clientes com mais de 10 anos,
-- disponibilizando a seguinte informação: código do cliente (cliente_id), número da conta
-- (bank_account), saldo (balance), há quanto tempo é cliente (desde cliente_since) e a data do último
-- movimento (date).

CREATE OR REPLACE VIEW v_oldies AS
SELECT client_id,
       b.bank_account,
       balance,
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM client_since)  AS years_since_client,
       MAX(date_mov) AS last_date
FROM bank_account b, movements m
WHERE client_since < SYSDATE - 3650
AND b.bank_account = m.bank_account
GROUP BY client_id, b.bank_account, balance, client_since;

SELECT * FROM v_oldies;


CREATE  OR REPLACE VIEW v_oldies AS
SELECT client_id, bank_account, balance,
       EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM client_since)  AS years_since_client,
       (SELECT MAX(date_mov)
        FROM movements
        WHERE bank_account = a.bank_account) AS last_date
FROM bank_account a;

SELECT * FROM v_oldies;
