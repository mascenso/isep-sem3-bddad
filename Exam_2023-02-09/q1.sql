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

-- ########################## 1. ##########################
-- ##########################    ##########################

-- a)[20] Escreva uma query para retornar a lista de itens vendidos em cada dia ordenada pela quantidade total de
-- vendas. A query deve devolver nome do item, nome da família do item, data e quantidade vendida (qty).

SELECT
    i.name  Item_name,
    f.name Family_name,
    so.order_date Sales_order_date,
    sum(s.qty) total_qty
FROM sales s, item i, item_family f, sales_order so
WHERE s.item_id = i.id AND i.family = f.id AND s.sales_order_id = so.id
GROUP BY so.order_date, f.name, i.name
ORDER BY 4 DESC;

--or:

SELECT
    i.name Item_name,
    f.name Family_name,
    so.order_date Sales_order_date,
    sum(s.qty) total_qty
FROM sales s
INNER JOIN item i ON s.item_id = i.id
INNER JOIN item_family f ON i.family = f.id
INNER JOIN sales_order so ON s.sales_order_id = so.id
GROUP BY so.order_date, f.name, i.name
ORDER BY 4 DESC;

-- b)[20] Crie uma única View Sales_Qty para mostrar a distribuição da quantidade de vendas por item e mês,
-- bem como por família e ano, conforme exemplificado abaixo. A view deve indicar o tipo (type) de cada tuplo:
-- item ou family. Explique resumidamente a estrutura da query.

CREATE OR REPLACE VIEW Sales_Qty AS
-- item e mes
SELECT i.id product, EXTRACT(MONTH FROM so.order_date) time, 'Item' Type, sum(s.qty) as total_qty FROM sales s, item i, sales_order so
WHERE s.item_id = i.id AND s.sales_order_id = so.id
GROUP BY i.id, EXTRACT(MONTH FROM so.order_date)
UNION
-- family e ano
SELECT f.id, EXTRACT(YEAR FROM so.order_date) time, 'Family' Type, sum(s.qty) as total_qty FROM sales s, item i, item_family f, sales_order so
WHERE s.sales_order_id = so.id AND f.id = i.family AND s.item_id = i.id
GROUP BY f.id, EXTRACT(YEAR FROM so.order_date);

-- alternative, with inner join:
CREATE OR REPLACE VIEW Sales_Qty AS
SELECT i.id product, EXTRACT(MONTH FROM so.order_date) time, 'Item' Type, sum(s.qty)  as total_qty
FROM sales s
INNER JOIN item i ON s.item_id = i.id
INNER JOIN sales_order so ON s.sales_order_id = so.id
GROUP BY i.id, EXTRACT(MONTH FROM so.order_date)
UNION
SELECT f.id, EXTRACT(YEAR FROM so.order_date) time, 'Family' Type, sum(s.qty) as total_qty
FROM sales s
INNER JOIN item i ON s.item_id = i.id
INNER JOIN item_family f ON i.family = f.id
INNER JOIN sales_order so ON s.sales_order_id = so.id
GROUP BY f.id, EXTRACT(YEAR FROM so.order_date);


select * from SALES_QTY;

-- c)[20] Altere a View criada em b) para mostrar a quantidade de vendas de todos os itens por mês e de todas as
-- famílias por ano para os períodos em que tenha havido vendas, mesmo para os itens que não tenham sido
-- vendidos. Neste último caso, considerar a quantidade de vendas igual a 0.

CREATE OR REPLACE VIEW Sales_Qty_Periods AS
SELECT i.id AS product, EXTRACT(MONTH FROM so.order_date) AS time, 'Item' AS Type, NVL(SUM(s.qty), 0) AS total_qty
FROM sales_order so
         CROSS JOIN item i
         LEFT OUTER JOIN sales s ON s.item_id = i.id AND s.sales_order_id = so.id
GROUP BY i.id, EXTRACT(MONTH FROM so.order_date)
UNION ALL
SELECT f.id AS product, EXTRACT(YEAR FROM so.order_date) AS time, 'Family' AS Type, NVL(SUM(s.qty), 0) AS total_qty
FROM sales_order so
         CROSS JOIN item_family f
         LEFT OUTER JOIN item i ON i.family = f.id
         LEFT OUTER JOIN sales s ON s.item_id = i.id AND s.sales_order_id = so.id
GROUP BY f.id, EXTRACT(YEAR FROM so.order_date);

select * from Sales_Qty_Periods

-- ########################## 2. ##########################
-- ##########################    ##########################

-- 2. [20] Dada a relação R(a, b, c), escreva um SELECT para testar se a dependência funcional b → c se
-- verifica na relação R. Justifique a sua resposta.

-- SELECT * FROM R r1, R r2
-- WHERE r1.b = r2.b AND r1.c <> r2.c;

-- Se a dependencia funcional b -> c se verificar, então a query devolve tuplos, caso contrário não devolve tuplos.

-- demonstração com a tabela sales:
select *
from sales s1, sales s2
where s1.item_id = s2.item_id and s1.qty <> s2.qty;
--dependencia funcional: item_id -> qty nao se verifica, pois a query devolve tuplos