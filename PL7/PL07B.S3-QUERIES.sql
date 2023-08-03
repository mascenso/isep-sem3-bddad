--1) Mostrar a quantidade de CD comprados em cada um dos locais de compra registados
SELECT NVL(LOCALCOMPRA, 'desconhecido') "LOCAL_COMPRA", COUNT(distinct CODCD) "QUANTIDADE_CD" from CD
GROUP BY LOCALCOMPRA;

--2) Copiar e alterar o comando da alínea anterior, de forma a mostrar o resultado por ordem decrescente da
--quantidade de CD comprados.
SELECT NVL(LOCALCOMPRA, 'desconhecido') "LOCAL_COMPRA", COUNT(distinct CODCD) "QUANTIDADE_CD" from CD
GROUP BY LOCALCOMPRA
ORDER BY QUANTIDADE_CD DESC;

--3)Mostrar a quantidade de editoras diferentes que produziram os CD comprados, em cada um dos locais de compra.
SELECT NVL(LOCALCOMPRA, 'desconhecido') "LOCAL_COMPRA", COUNT(distinct IDEDITORA) "QUANTIDADE_EDITORAS" from CD
GROUP BY LOCALCOMPRA;

--4) Copiar e alterar o comando da alínea 2, de forma a mostrar também, para cada local de compra conhecido,
--o valor total pago e o maior valor pago.
SELECT NVL(LOCALCOMPRA, 'desconhecido') "LOCAL_COMPRA", COUNT(distinct CODCD) "QUANTIDADE_CD", SUM(VALORPAGO) "TOTAL", MAX(VALORPAGO) "MAIOR"
FROM CD
GROUP BY LOCALCOMPRA
ORDER BY QUANTIDADE_CD DESC;

--5)Mostrar, para cada CD e respetivos intérpretes, a quantidade de músicas do CD em que o intérprete
--participa. Além da quantidade referida, também deve ser apresentado o código do CD e o intérprete.
SELECT CODCD "CODIGO_CD", INTERPRETE, COUNT(distinct TITULO) "QUANTIDADE_MUSICAS"
from MUSICA
GROUP BY CODCD, INTERPRETE
ORDER BY CODCD;

--6)Copiar o comando da alínea 1 e alterar de modo a mostrar apenas os locais de compra com a quantidade superior a 2.
SELECT NVL(LOCALCOMPRA, 'desconhecido') "LOCAL_COMPRA", COUNT(distinct CODCD) "QUANTIDADE_CD" from CD
GROUP BY LOCALCOMPRA
HAVING COUNT(DISTINCT CODCD) > 2;

--7) Mostrar os locais de compra, cuja média do valor pago por CD é inferior a 10, juntamente com o respetivo
--total do valor pago.
SELECT NVL(LOCALCOMPRA, 'desconhecido') "LOCAL_COMPRA", SUM(distinct VALORPAGO) "TOTAL_PAGO" from CD
GROUP BY LOCALCOMPRA
HAVING AVG(DISTINCT VALORPAGO) < 10;

--8) Mostrar o valor total pago nos locais de compra, cuja quantidade de CD comprados é superior a 2. O local
--de compra também deve ser visualizado.
SELECT NVL(LOCALCOMPRA, 'desconhecido') "LOCAL_COMPRA", SUM(distinct VALORPAGO) "TOTAL_PAGO" from CD
GROUP BY LOCALCOMPRA
HAVING COUNT(distinct CODCD) > 2;

--9) Copiar o comando da alínea 5 e alterar de modo a mostrar apenas o intérprete e o código do CD em que
--o intérprete participa apenas em 1 música. O resultado deve ser apresentado por ordem crescente do
--código do CD e, em caso de igualdade, por ordem alfabética do intérprete.
SELECT CODCD "CODIGO_CD", INTERPRETE -- COUNT(distinct TITULO) "QUANTIDADE_MUSICAS"
from MUSICA
GROUP BY CODCD, INTERPRETE
HAVING COUNT(distinct TITULO) = 1
ORDER BY CODCD, INTERPRETE;

--10) Copiar o comando da alínea anterior e alterar de modo a mostrar apenas os intérpretes começados por E
--ou L (letras maiúsculas ou minúsculas).
SELECT DISTINCT INTERPRETE from MUSICA
GROUP BY CODCD, INTERPRETE
HAVING COUNT(distinct TITULO) = 1 AND REGEXP_LIKE(lower(INTERPRETE), '^(e|l)(*)')
ORDER BY INTERPRETE;

--11) Mostrar os dias de semana em que foram comprados, em locais conhecidos, pelo menos dois CD.
SELECT to_char(datacompra, 'day') "DIA_SEMANA", COUNT(distinct CODCD) "QTD_CD_COMPRADOS" FROM CD
WHERE localcompra is not null
GROUP BY to_char(datacompra, 'day')
HAVING count(*) >= 2
ORDER BY 2;

--12) Mostrar, para cada CD, o título e a quantidade de músicas.
SELECT cd.TITULO, COUNT(*) "QTD_MUSICAS" FROM CD cd, MUSICA m
WHERE cd.CODCD = m.CODCD
GROUP BY cd.CODCD, cd.TITULO
ORDER BY 2 DESC;

--13) Mostrar, para cada CD, o código, o título e a quantidade de músicas.
SELECT cd.CODCD, cd.TITULO, COUNT(*) "QTD_MUSICAS" FROM CD cd, MUSICA m
WHERE cd.CODCD = m.CODCD
GROUP BY cd.CODCD, cd.TITULO
ORDER BY 3 desc;

--14) Mostrar, para cada CD que tenha músicas com duração superior a 5, o código, o título e a quantidade de
--músicas cuja duração é superior a 5.
select cd.codcd, cd.titulo, count(*)
from cd, musica
where cd.codcd = musica.codcd and musica.duracao > 5
group by cd.codcd, cd.titulo
order by 3 desc;

SELECT cd.CODCD, cd.TITULO, (select count(*) from musica where codcd = cd.codcd and duracao > 5)  "QTD_MUSICAS"
FROM CD cd
WHERE cd.CODCD in (select codcd from musica where duracao > 5)
ORDER BY 3 desc;

--15) Mostrar, para cada CD com menos de 6 músicas, o código, o título e a quantidade de músicas do CD.
SELECT cd.TITULO, COUNT(*) "QTD_MUSICAS" FROM CD cd, MUSICA m
WHERE cd.CODCD = m.CODCD
HAVING COUNT(*) < 6
GROUP BY cd.CODCD, cd.TITULO
ORDER BY 2 DESC;

--16) Mostrar, para cada CD cujas músicas têm uma duração média superior a 4, o código, o título e a
--quantidade de músicas do CD.
SELECT cd.CODCD, cd.TITULO, COUNT(*) "QTD_MUSICAS" FROM CD cd, MUSICA m
WHERE cd.CODCD = m.CODCD
GROUP BY cd.CODCD, cd.TITULO
HAVING AVG(DURACAO) > 4
ORDER BY 3 DESC;

--17) Mostrar, numa coluna, o título de cada uma das músicas e o título de cada CD que tem pelo menos 3
--interpretes.
SELECT TITULO FROM MUSICA
UNION ALL
SELECT TITULO FROM CD
where CODCD IN (select codcd from musica group by codcd having count(distinct interprete) >= 3)
ORDER BY 1;

--18) Copiar e alterar o comando da alínea anterior, de modo a não mostrar os registos repetidos.
SELECT TITULO FROM MUSICA
UNION
SELECT TITULO FROM CD
where CODCD IN (select codcd from musica group by codcd having count(distinct interprete) >= 3)
ORDER BY 1;

--19) Copiar e alterar o comando da alínea anterior, de modo a apresentar também o comprimento de cada
--título e por ordem decrescente.
SELECT TITULO, length(titulo) FROM MUSICA
UNION
SELECT TITULO, length(titulo) FROM CD
WHERE CODCD IN (select codcd from musica group by codcd having count(distinct interprete) >= 3)
ORDER BY 2 desc, 1;

--20) Mostrar os títulos de CD com duração superior a 35 e que são iguais a títulos de músicas.
SELECT a.TITULO FROM (select titulo from musica) a, (select cd.titulo from cd, musica where cd.codcd = musica.codcd group by cd.codcd, cd.titulo having sum(musica.duracao) > 35) b
WHERE a.TITULO = b.TITULO;