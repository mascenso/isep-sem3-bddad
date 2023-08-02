--Mostrar todos os dados da tabela CD;
select * from cd;

--Mostrar todos os dados da tabela Musica.
select * from musica;

--PROJECAO - Mostrar o titulo e a data de compra de todos os CD;
select titulo, datacompra from cd;

--PROJECAO - Mostrar todas as datas de compra, sem valores repetidos.
select distinct datacompra from cd;

--PROJECAO - Mostrar o codigo dos CD e os respetivos interpretes, sem registos repetidos;
select distinct codcd, interprete from musica;

--PROJECAO - Mostrar o resultado anterior com a primeira coluna intitulada "Codigo do CD";
select distinct codcd "Codigo do CD", interprete from musica;

--PROJECAO - Mostrar o titulo, o valor pago e o respetivo valor do IVA de todos os CD.
--O valor do IVA é calculado de acordo com a seguinte formula: valor do IVA = (valor pago * 0.23) / 1.23.
select titulo, valorpago, round((valorpago * 0.23) / 1.23, 2) from cd;

--SELECAO - Mostrar todos os dados das musicas do CD com o codigo 2
select * from musica where codcd = 2;

--SELECAO - Mostrar todos os dados das musicas que nao pertencem ao CD com o codigo 2
select * from musica where codcd != 2;

--SELECAO - Mostrar todos os dados das musicas do CD com o codigo 2 cuja duracao pertenca ao intervalo [4,6];
select * from musica where codcd = 2 and duracao >= 4 and duracao <= 6;
select * from musica where codcd = 2 and duracao between 4 and 6;

--SELECAO - Mostrar todos os dados das musicas do CD com o codigo 2 cuja duracao seja inferior a 4 ou superior a 6;
select * from musica where codcd = 2 and (duracao < 4 or duracao > 6);
select * from musica where codcd = 2 and duracao not between 4 and 6;

--SELECAO - Mostrar todos os dados das musicas com o numero: 1, 3, 5 ou 6;
select * from musica where nrmusica in (1, 3, 5, 6);

--SELECAO - Mostrar todos os dados das musicas com o numero diferente de 1, 3, 5 e 6;
select * from musica where nrmusica not in (1, 3, 5, 6);

--SELECAO - Mostrar todos os dados das musicas cujo interprete e uma orquestra;
select * from musica where lower(interprete) like '%orquestra%';

--SELECAO - Mostrar todos os dados das musicas cujo nome do interprete tem a letra Y;
select * from musica where lower(interprete) like '%y%';

--SELECAO - Mostrar todos os dados das musicas cujo nome termina com DAL?, sendo ? qualquer careter;
select * from musica where lower(interprete) like '%dal_';

--SELECAO - Mostrar todos os dados das musicas cujo titulo tem o carater %;
select * from musica where lower(titulo) like '%\%%' escape '\';
--Pode ser resolvido usando expressses reguklares que no oracle é feito com a funcao REGEXP_LIKE

--SELECAO - Mostrar todos os dados das musicas cujo titulo é iniciado pela letra B, D ou H
select * from musica where regexp_like (titulo, '^(B|D|H)(*)');

--SELECAO - Mostrar todos os dados dos CD sem o local de compra registado;
select * from cd where localcompra is null;

--SELECAO - Mostrar todos os dados dos CD com o local de compra registado.
select * from cd where localcompra is not null;

--PROJECAO E SELECAO - Mostrar os titulos dos CD comprados na FNAC;
select titulo from cd where localcompra = 'FNAC';

--PROJECAO E SELECAO - Mostrar os titulos dos CD que nao foram comprados na FNAC.
select titulo from cd where nvl(localcompra, ' ') != 'FNAC';
select titulo from cd where localcompra is null or localcompra != 'FNAC';

--ORDENACAO - Mostrar os titulos dos CD que nao foram comprados na FNAC, por ordem alfabetica inversa;
select titulo from cd where nvl(localcompra, ' ') != 'FNAC' order by titulo desc;

--ORDENACAO - Mostrar o titulo e a data de compra dos CD, por ordem descendente da data de compra do CD;
select titulo, datacompra from cd order by datacompra desc;

--ORDENACAO - Mostrar o titulo e o local de compra dos CD, por ordem ascendente do local de compra do CD;
select titulo, localcompra from cd order by localcompra;

--ORDENACAO - Mostrar o titulo, o valor pago e o respetivo valor do IVA dos CD, por ordem decrescente do IVA;
select titulo, valorpago, round((valorpago * 0.23) / 1.23, 2) from cd order by round((valorpago * 0.23) / 1.23, 2) desc;
select titulo, valorpago, round((valorpago * 0.23) / 1.23, 2) from cd order by 3;
select titulo, valorpago, round((valorpago * 0.23) / 1.23, 2) iva from cd order by iva desc;
select * from (select titulo, valorpago, round((valorpago * 0.23) / 1.23, 2) iva from cd) order by iva;

--ORDENACAO - Mostrar o titulo do CD por ordem descendente da data de compra e, no caso da igualdade de datas, por ordem alfabetica do titulo.
select titulo from cd order by datacompra desc, titulo;

--FUNCOES AGREGACAO - 1) Mostrar a quantidade de locais de compra distintos;
select count(distinct localcompra) qtd_locais_compra from cd;

--FUNCOES AGREGACAO - 2) Mostrar o total gasto com a compra de todos os CD, o maior e o menor valor pago por um CD;
select sum(valorpago) total, max(valorpago) maior, min(valorpago) menor from cd;

--FUNCOES AGREGACAO - 3) Mostrar a media da duracao de todas as musicas;
select round(avg(duracao), 2) "duracao media" from musica;

--FUNCOES AGREGACAO - 4) Mostrar o total do valor pago na FNAC;
select sum(valorpago) total_fnac from cd where localcompra = 'FNAC';

--FUNCOES AGREGACAO - 5) Mostrar a diferenca entre o maior e o menor valor pago na FNAC.
select max(valorpago)-min(valorpago) diferenca_fnac from cd where localcompra = 'FNAC';