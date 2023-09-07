
--5.Criar um script PL/SQL para implementar um procedimento, designado LivrosEditados, que gera uma
--lista com os títulos dos livros editados por uma dada editora cujo nome é passado num argumento.
--Testar adequadamente o procedimento implementado, através de blocos anónimos.

create or replace procedure LivrosEditados(p_nome editora.nome%type)
    is
    cursor c is
        select distinct a.titulo, c.nredicao
        from livro a, editora b, edicaolivro c
        where a.idlivro = c.idlivro and c.ideditora = b.ideditora
          and b.nome = p_nome;
    v_titulo c%rowtype;
begin
    open c;
    loop
        fetch c into v_titulo;
        exit when c%notfound;
        dbms_output.put_line(v_titulo.titulo);
    end loop;
    close c;
end;

--
create or replace procedure LivrosEditados(p_nome editora.nome%type)
    is
    v_titulo livro.titulo%type;
    cursor c is
        select distinct titulo
        from livro a, editora b, edicaolivro c
        where a.idlivro = c.idlivro and c.ideditora = b.ideditora
          and b.nome = p_nome;
begin
    open c;
    fetch c into v_titulo;
    while c%found loop
            dbms_output.put_line(v_titulo);
            fetch c into v_titulo;
        end loop;
    close c;
end;

--

create or replace procedure LivrosEditados(p_nome editora.nome%type)
    is
    --v_titulo livro.titulo%type;
begin
    for v_titulo in (
        select distinct titulo
        from livro a, editora b, edicaolivro c
        where a.idlivro = c.idlivro and c.ideditora = b.ideditora
          and b.nome = p_nome
        )
        loop
            dbms_output.put_line(v_titulo.titulo);
        end loop;
end;

--
begin
    LivrosEditados('Bertrand');
end;

--

--SQL
select * from edicaolivro;
select * from editora;
select * from livro;

select distinct titulo
from livro a, editora b, edicaolivro c
where a.idlivro = c.idlivro and c.ideditora = b.ideditora
  and b.nome = 'Bertrand';