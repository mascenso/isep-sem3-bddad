-- ** eliminar tabelas se existentes **
-- CASCADE CONSTRAINTS para eliminar as restricoes de integridade das chaves primarias e chaves unicas
-- PURGE elimina a tabela da base de dados e da "reciclagem"

DROP TABLE cd CASCADE CONSTRAINTS PURGE ;
DROP TABLE musica CASCADE CONSTRAINTS PURGE ;

-- ** criar tabelas **

CREATE TABLE cd (
    codCd          INTEGER CONSTRAINT pkCdCod PRIMARY KEY,
    titulo         VARCHAR(40) CONSTRAINT nnCdTitulo NOT NULL,
    dataCompra     DATE,
    valorPago      NUMERIC(5,2),
    localCompra    VARCHAR(20)
);

CREATE TABLE musica (
    nrMusica    INTEGER,
    codCd       INTEGER,    
    titulo      VARCHAR(40) CONSTRAINT nnMusicaNome NOT NULL,
    interprete  VARCHAR(30) CONSTRAINT nnMusicaInterprete NOT NULL,
    duracao     NUMERIC(4,2),
    CONSTRAINT pkMusicaNrMusicaCodCd  PRIMARY KEY (codCd, nrMusica)
);

ALTER TABLE musica ADD CONSTRAINT fkMusicaCodCd FOREIGN KEY (codCd) REFERENCES cd (codCd);

-- ** guardar em DEFINITIVO as alteracoes na base de dados, se a opcao Autocommit nao estiver ativada **
COMMIT;
