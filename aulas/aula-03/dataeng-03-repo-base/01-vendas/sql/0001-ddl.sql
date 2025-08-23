DROP TABLE IF EXISTS public.item_venda CASCADE;
DROP TABLE IF EXISTS public.venda CASCADE;
DROP TABLE IF EXISTS public.produto CASCADE;
DROP TABLE IF EXISTS public.cliente CASCADE;
DROP TABLE IF EXISTS public.cidade CASCADE;
DROP TABLE IF EXISTS public.pais CASCADE;

CREATE TABLE public.pais (
    pais_id SERIAL PRIMARY KEY,
    pais varchar(60) NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.cidade (
    cidade_id SERIAL PRIMARY KEY,
    cidade_desc varchar(60) NOT NULL,
    cidade_uf varchar(2) NULL,
    pais_id int4 NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cidade_pais FOREIGN KEY (pais_id) REFERENCES public.pais(pais_id)
);

CREATE TABLE public.cliente (
    cliente_id SERIAL PRIMARY KEY,
    nome varchar(60) NOT NULL,
    data_nasc date NULL,
    data_cad date NULL,
    cpf varchar(15) NULL,
    cidade_id int4 NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cliente_cidade FOREIGN KEY (cidade_id) REFERENCES public.cidade(cidade_id)
);

CREATE TABLE public.produto (
    produto_id SERIAL PRIMARY KEY,
    nome varchar(100) NOT NULL,
    descricao text NULL,
    preco_base decimal(10,2) NULL,
    ativo boolean DEFAULT true,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.venda (
    venda_id SERIAL PRIMARY KEY,
    cliente_id int4 NULL,
    "data" date NULL,
    entregue bpchar(1) NULL,
    valor_total decimal(10,2) NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_venda_cliente FOREIGN KEY (cliente_id) REFERENCES public.cliente(cliente_id)
);

CREATE TABLE public.item_venda (
    item_id SERIAL PRIMARY KEY,
    venda_id int4 NULL,
    produto_id int4 NULL,
    valor_unitario decimal(10,2) NULL,
    quantidade int4 NULL,
    valor_total decimal(10,2) NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_item_venda_venda FOREIGN KEY (venda_id) REFERENCES public.venda(venda_id),
    CONSTRAINT fk_item_venda_produto FOREIGN KEY (produto_id) REFERENCES public.produto(produto_id)
);

CREATE INDEX idx_cidade_pais ON public.cidade(pais_id);
CREATE INDEX idx_cliente_cidade ON public.cliente(cidade_id);
CREATE INDEX idx_venda_cliente ON public.venda(cliente_id);
CREATE INDEX idx_item_venda_venda ON public.item_venda(venda_id);
CREATE INDEX idx_item_venda_produto ON public.item_venda(produto_id);
CREATE INDEX idx_venda_data ON public.venda("data");

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_pais_updated_at BEFORE UPDATE ON public.pais FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_cidade_updated_at BEFORE UPDATE ON public.cidade FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_cliente_updated_at BEFORE UPDATE ON public.cliente FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_produto_updated_at BEFORE UPDATE ON public.produto FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_venda_updated_at BEFORE UPDATE ON public.venda FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_item_venda_updated_at BEFORE UPDATE ON public.item_venda FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();