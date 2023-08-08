-- ## bootstrap ##
DROP TABLE sales              CASCADE CONSTRAINTS PURGE;
DROP TABLE sales_order         CASCADE CONSTRAINTS PURGE;
DROP TABLE item        CASCADE CONSTRAINTS PURGE;
DROP TABLE item_family                CASCADE CONSTRAINTS PURGE;

-- ## tabela sales ##
CREATE TABLE sales (
    sales_order_id  INTEGER,
    item_id         INTEGER,
    qty             INTEGER,
    CONSTRAINT pkSales PRIMARY KEY (sales_order_id, item_id)
);

-- ## tabela sales order##
CREATE TABLE sales_order (
    id          INTEGER      CONSTRAINT pkSalesOrderId PRIMARY KEY,
    order_date  DATE
);

-- ## tabela item ##
CREATE TABLE item (
    id       INTEGER            CONSTRAINT pkItemId PRIMARY KEY,
    name     VARCHAR2(20),
    family   INTEGER
);

-- ## tabela item family ##
CREATE TABLE item_family (
    id     INTEGER         CONSTRAINT pkItemFamilyNr PRIMARY KEY,
    name  VARCHAR2(20)
);

-- ** alterar tabelas para definicaoo de chaves estrangeiras **
ALTER TABLE sales             ADD CONSTRAINT fkSalesOrderId           FOREIGN KEY (sales_order_id)    REFERENCES sales_order(id);
ALTER TABLE sales             ADD CONSTRAINT fkItemId                 FOREIGN KEY (item_id)           REFERENCES item(id);
ALTER TABLE item              ADD CONSTRAINT fkItemFamilyId           FOREIGN KEY (family)            REFERENCES item_family(id);

-- COMMIT;

INSERT INTO item_family (ID, NAME) VALUES (43, 'Fruit');
INSERT INTO item_family (ID, NAME) VALUES (44, 'Pasta');
INSERT INTO item_family (ID, NAME) VALUES (45, 'Meat');
INSERT INTO item_family (ID, NAME) VALUES (46, 'Fish');

INSERT INTO item (ID, NAME, FAMILY) VALUES (342, 'Apple', 43);
INSERT INTO item (ID, NAME, FAMILY) VALUES (343, 'Orange', 43);
INSERT INTO item (ID, NAME, FAMILY) VALUES (344, 'Strawberry', 43);
INSERT INTO item (ID, NAME, FAMILY) VALUES (345, 'Spagueti', 44);

INSERT INTO sales_order (ID, ORDER_DATE) VALUES (12, TO_DATE('2023-01-30', 'YYYY-MM-DD'));
INSERT INTO sales_order (ID, ORDER_DATE) VALUES (13, TO_DATE('2023-01-30', 'YYYY-MM-DD'));
INSERT INTO sales_order (ID, ORDER_DATE) VALUES (14, TO_DATE('2023-02-01', 'YYYY-MM-DD'));
INSERT INTO sales_order (ID, ORDER_DATE) VALUES (15, TO_DATE('2023-02-03', 'YYYY-MM-DD'));

INSERT INTO sales (SALES_ORDER_ID, ITEM_ID, QTY) VALUES (12, 344, 12);
INSERT INTO sales (SALES_ORDER_ID, ITEM_ID, QTY) VALUES (12, 342, 24);
INSERT INTO sales (SALES_ORDER_ID, ITEM_ID, QTY) VALUES (13, 345, 18);
INSERT INTO sales (SALES_ORDER_ID, ITEM_ID, QTY) VALUES (14, 345, 24);

-- # queries #

-- a)[20] Escreva uma query para retornar a lista de itens vendidos em cada dia ordenada pela quantidade total de
-- vendas. A query deve devolver nome do item, nome da família do item, data e quantidade vendida (qty).

SELECT i.name  "Item_name", f.name "Family_name", so.order_date, s.qty FROM sales s, item i, item_family f, sales_order so
WHERE s.item_id = i.id AND i.family = f.id AND s.sales_order_id = so.id
ORDER BY s.qty DESC;

--or:

SELECT i.name "Item_name", f.name "Family_name", so.order_date, s.qty FROM sales s
INNER JOIN item i ON s.item_id = i.id
INNER JOIN item_family f ON i.family = f.id
INNER JOIN sales_order so ON s.sales_order_id = so.id
ORDER BY s.qty DESC;

-- b)[20] Crie uma única View Sales_Qty para mostrar a distribuição da quantidade de vendas por item e mês,
-- bem como por família e ano, conforme exemplificado abaixo. A view deve indicar o tipo (type) de cada tuplo:
-- item ou family. Explique resumidamente a estrutura da query.

CREATE OR REPLACE VIEW Sales_Qty AS
-- item e mes
SELECT i.id product, TO_CHAR(so.order_date, 'MM') time, 'Item' Type, sum(s.qty) as total_qty FROM sales s, item i, sales_order so
WHERE s.item_id = i.id AND s.sales_order_id = so.id
GROUP BY i.id, TO_CHAR(so.order_date, 'MM')
UNION
-- family e ano
SELECT f.id, TO_CHAR(so.order_date, 'YYYY') time, 'Family' Type, sum(s.qty) as total_qty FROM sales s, item i, item_family f, sales_order so
WHERE s.sales_order_id = so.id AND f.id = i.family AND s.item_id = i.id
GROUP BY f.id, TO_CHAR(so.order_date, 'YYYY');

select * from SALES_QTY;


