-- ** eliminar tabelas se existentes **
-- CASCADE CONSTRAINTS para eliminar as restricoes de integridade das chaves primarias e chaves unicas
-- PURGE elimina a tabela da base de dados e da "reciclagem"
DROP TABLE cd       CASCADE CONSTRAINTS PURGE;
DROP TABLE musica   CASCADE CONSTRAINTS PURGE;
DROP TABLE editora  CASCADE CONSTRAINTS PURGE;

-- tabela Editora
CREATE TABLE editora (
    idEditora  INTEGER      CONSTRAINT pkEditoraIdEditora PRIMARY KEY,
    nome        VARCHAR(20) CONSTRAINT nnEditoraNome NOT NULL 
);

-- tabela CD
CREATE TABLE cd (
    codCd       INTEGER     CONSTRAINT pkCdCodCd PRIMARY KEY,
    idEditora   INTEGER,
    titulo      VARCHAR(40) CONSTRAINT nnCdTitulo NOT NULL,
    dataCompra  DATE,
    valorPago   NUMERIC(5,2),
    localCompra VARCHAR(20)
);

-- tabela musica 
CREATE TABLE musica (
    nrMusica    INTEGER,
    codCd       INTEGER,
    titulo      VARCHAR(40) CONSTRAINT nnMusicaTitulo NOT NULL,
    interprete  VARCHAR(30) CONSTRAINT nnMusicaInterprete NOT NULL,
    duracao     NUMERIC(5,2),
    CONSTRAINT pkMusicaNrMusicaCodCd  PRIMARY KEY (codCd, nrMusica)
);

-- ** alterar tabelas para definicao de chaves estrangeiras **
ALTER TABLE cd      ADD CONSTRAINT fkCdIdEditora    FOREIGN KEY (codCd)  REFERENCES editora(idEditora);
ALTER TABLE musica  ADD CONSTRAINT fkMusicaCodCd    FOREIGN KEY (codCd)  REFERENCES cd(codCd);

-- ** guardar em DEFINITIVO as alteraCOes na base de dados, se a opcao Autocommit do SQL Developer nao estiver ativada **
COMMIT;
