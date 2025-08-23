INSERT INTO public.pais (pais) VALUES
	('Brasil'),
	('Argentina'),
	('Chile');

INSERT INTO public.cidade (cidade_desc, cidade_uf, pais_id) VALUES
	('São Paulo', 'SP', 1),
	('Campinas', 'SP', 1),
	('Santos', 'SP', 1),
	('Rio de Janeiro', 'RJ', 1),
	('Niterói', 'RJ', 1),
	('Petrópolis', 'RJ', 1),
	('Belo Horizonte', 'MG', 1),
	('Uberlândia', 'MG', 1),
	('Juiz de Fora', 'MG', 1),
	('Contagem', 'MG', 1);

INSERT INTO public.cliente (nome, data_nasc, data_cad, cpf, cidade_id) VALUES
	('Ana Paula Souza', '1985-03-12', '2023-01-10', '123.456.789-00', 1),
	('Carlos Eduardo Silva', '1990-07-25', '2023-02-15', '234.567.890-11', 2),
	('Fernanda Lima', '1978-11-05', '2023-03-20', '345.678.901-22', 3),
	('João Pedro Alves', '1982-05-18', '2023-04-12', '456.789.012-33', 4),
	('Mariana Oliveira', '1995-09-30', '2023-05-08', '567.890.123-44', 5),
	('Rafael Costa', '1988-12-22', '2023-06-17', '678.901.234-55', 6),
	('Patrícia Gomes', '1975-04-14', '2023-07-21', '789.012.345-66', 7),
	('Lucas Martins', '1992-08-03', '2023-08-30', '890.123.456-77', 8),
	('Juliana Pereira', '1980-01-27', '2023-09-14', '901.234.567-88', 9),
	('Bruno Henrique', '1987-06-19', '2023-10-05', '012.345.678-99', 10),
	('Gabriela Ramos', '1993-10-11', '2023-11-23', '111.222.333-44', 1),
	('Felipe Rocha', '1984-02-16', '2023-12-01', '222.333.444-55', 2),
	('Camila Duarte', '1979-07-29', '2024-01-18', '333.444.555-66', 3),
	('Rodrigo Almeida', '1991-05-06', '2024-02-27', '444.555.666-77', 4),
	('Isabela Freitas', '1986-09-13', '2024-03-15', '555.666.777-88', 5);

INSERT INTO public.produto (nome, descricao, preco_base, ativo) VALUES
	('Notebook Dell Inspiron', 'Notebook 15.6" Intel i5, 8GB RAM, 256GB SSD', 3500.00, true),
	('Smartphone Samsung Galaxy S21', 'Celular Android, 128GB, 8GB RAM', 4200.00, true),
	('Fone de Ouvido JBL', 'Fone Bluetooth, cancelamento de ruído', 650.00, true),
	('Monitor LG 24"', 'Monitor LED Full HD, HDMI', 900.00, true),
	('Teclado Mecânico Logitech', 'Teclado RGB, switches azuis', 450.00, true),
	('Mouse Gamer Razer', 'Mouse óptico, 16000 DPI', 350.00, true),
	('Cadeira Gamer ThunderX3', 'Cadeira ergonômica, ajuste lombar', 1200.00, true),
	('Impressora HP Deskjet', 'Impressora multifuncional Wi-Fi', 700.00, true),
	('Tablet Apple iPad', 'iPad 10.2" 64GB Wi-Fi', 3800.00, true),
	('HD Externo Seagate 2TB', 'Disco rígido portátil USB 3.0', 480.00, true),
	('Smartwatch Xiaomi Mi Band 6', 'Pulseira inteligente, monitor cardíaco', 350.00, true),
	('Echo Dot 4ª Geração', 'Assistente virtual Alexa', 400.00, true),
	('Câmera GoPro Hero 9', 'Câmera de ação 5K', 2500.00, true),
	('Roteador TP-Link Archer', 'Roteador Wi-Fi Dual Band', 320.00, true),
	('TV Samsung 50" 4K', 'Smart TV LED UHD', 3200.00, true),
	('Microfone Blue Yeti', 'Microfone USB condensador', 900.00, true),
	('Caixa de Som Bose', 'Caixa Bluetooth portátil', 1100.00, true),
	('Kindle Paperwhite', 'Leitor de livros digitais', 600.00, true),
	('SSD Kingston 480GB', 'SSD SATA III 2.5"', 350.00, true),
	('Webcam Logitech C920', 'Webcam Full HD', 420.00, true);
