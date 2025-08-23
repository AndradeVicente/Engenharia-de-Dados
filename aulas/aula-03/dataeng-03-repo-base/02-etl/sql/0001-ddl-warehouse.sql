DROP TABLE IF EXISTS dw.fato_item_venda CASCADE;
DROP TABLE IF EXISTS dw.fato_venda CASCADE;
DROP TABLE IF EXISTS dw.dim_produto CASCADE;
DROP TABLE IF EXISTS dw.dim_cliente CASCADE;
DROP TABLE IF EXISTS dw.dim_cidade CASCADE;
DROP TABLE IF EXISTS dw.dim_pais CASCADE;

-- Criar esquema do DW, se necessário
CREATE SCHEMA IF NOT EXISTS dw;

-- Dimensão País
CREATE TABLE dw.dim_pais (
    pais_id INT PRIMARY KEY,
    pais VARCHAR(60)
);

-- Dimensão Cliente
CREATE TABLE dw.dim_cidade (
    cidade_id INT PRIMARY KEY,
    cidade_desc VARCHAR(60),
    cidade_uf VARCHAR(2),
    pais_id INT
);

-- Dimensão Cliente
CREATE TABLE dw.dim_cliente (
    cliente_id INT PRIMARY KEY,
    nome VARCHAR(60),
    data_nasc DATE,
    data_cad DATE,
    cpf VARCHAR(15),
    cidade_id INT
);

-- Dimensão Produto
CREATE TABLE dw.dim_produto (
    produto_id INT PRIMARY KEY,
    nome VARCHAR(100),
    descricao TEXT,
    preco_base DECIMAL(10,2),
    ativo BOOLEAN
);

-- Fato Venda
CREATE TABLE dw.fato_venda (
    venda_id INT PRIMARY KEY,
    cliente_id INT,
    data DATE,
    entregue CHAR(1),
    valor_total DECIMAL(10,2)
);


-- Fato Item de Venda
CREATE TABLE dw.fato_item_venda (
    item_id INT PRIMARY KEY,
    venda_id INT,
    produto_id INT,
    valor_unitario DECIMAL(10,2),
    quantidade INT,
    valor_total DECIMAL(10,2)
);


