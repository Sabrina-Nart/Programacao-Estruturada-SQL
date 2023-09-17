DECLARE 
	l_codigo integer; 
	l_nome varchar(100);
BEGIN
	SELECT i_pessoa, nome
	  INTO l_codigo, l_nome 
	  FROM pessoas
	 WHERE i_pessoa = 1;
END;

POSTGRES

DO $$ 
DECLARE 
	l_codigo INTEGER := 0;
	l_nome VARCHAR(100) := '';
BEGIN
	SELECT i_pessoa, nome 
	  INTO l_codigo, l_nome 
	  FROM pessoas
	 WHERE pessoas.i_pessoa = 1;
	
	RAISE NOTICE 'Código: % - Nome: %', l_codigo, l_nome;
END $$;

Mostra Também no Postegres
DO $$ 
DECLARE 
	l_codigo INTEGER := 0;
	l_nome VARCHAR(100) := '';
BEGIN
	SELECT i_pessoa, nome 
	  INTO l_codigo, l_nome
	  FROM pessoas;

	RAISE NOTICE 'Código: % - Nome: %', l_codigo, l_nome;
END $$;

///////////////////////////////////////////////////

ATIVIDADE 1

Criar um bloco de Programação Estruturada para retornar uma pessoa,
nome de pessoa, nome da cidade da pessoa e a somatória dos valores 
de venda realizados para aquela pessoa.
Mostrar 

DO $$
DECLARE
	l_nome_pes VARCHAR(100) := '';
	l_nome_cid VARCHAR(100) := '';
	l_valor NUMERIC(12,2) := 0;
BEGIN
	SELECT pessoas.nome, cidades.nome,
		   SUM (vendas.valor)
		INTO l_nome_pes, l_nome_cid, l_valor  
		FROM vendas INNER JOIN pessoas 
			ON (vendas.i_pessoa = pessoas.i_pessoa)
			INNER JOIN cidades
			ON(pessoas.i_cidade = cidades.i_cidade)
		WHERE pessoas.i_pessoa = 1
		GROUP BY 1, 2; 
			
	RAISE NOTICE 'Pessoa: % - Cidade: % - Valor: %', l_nome_pes, l_nome_cid, l_valor;
END $$;

--GROUP BY - refere ao select que eu estou
--ORDER BY - é para toda a listagem

/////////////////////////////////////////////////////

ATIVIDADE 2

Criar um bloco de Programação Estruturada para retornar uma pessoa, nome 
de pessoa e a somatória dos valores de venda realizados para aquela pessoa.
Informar via mensagem se o valor de compra do cliente está acima ou 
abaixo da média de valor de compras por cliente;

Soma todas as compras e divide

PESQUISA:
POSTGRESQL = Estruturas Condicionais - IF

/*IF ... THEN ... END IF

IF ... THEN ... ELSE ... END IF

IF ... THEN ... ELSIF ... THEN ... ELSE ... END IF

and two forms of CASE:

CASE ... WHEN ... THEN ... ELSE ... END CASE

CASE WHEN ... THEN ... ELSE ... END CASE*/

DO $$
DECLARE
	l_nome_pes VARCHAR(100) := '';
	l_valor NUMERIC(12,2) := 0;     
	l_media NUMERIC(12,2) := 0;
BEGIN
	SELECT pessoas.nome, SUM (vendas.valor)
		INTO l_nome_pes, l_valor  
		FROM vendas INNER JOIN pessoas 
			ON (vendas.i_pessoa = pessoas.i_pessoa)
		WHERE pessoas.i_pessoa = 1
		GROUP BY 1; 
	
	RAISE NOTICE 'Pessoa: % - valor: % ', l_nome_pes, l_valor;
	
	SELECT AVG(valor)
		INTO l_media
		FROM vendas;
	
	IF l_valor > l_media THEN
		RAISE NOTICE 'As compras de: % estão acima da média: % ', l_nome_pes, l_media;
	ELSE
		RAISE NOTICE 'As compras de: % estão abaixo da média: % ', l_nome_pes, l_media;
	END IF;
END $$;

/////////////////////////////////////////////////////

ATIVIDADE 3

Criar um bloco de Programação Estruturada para retornar uma pessoa, nome 
de pessoa e a somatória dos valores de venda realizados para aquela pessoa.
Informar via mensagem se o valor de compra do cliente está acima, abaixo da média,
ou igual ao valor médio compras por cliente;

DO $$
DECLARE
	l_nome_pes VARCHAR(100) := '';
	l_valor NUMERIC(12,2) := 0;     
	l_media NUMERIC(12,2) := 0;
BEGIN
	SELECT pessoas.nome, SUM (vendas.valor)
		INTO l_nome_pes, l_valor  
		FROM vendas INNER JOIN pessoas 
			ON (vendas.i_pessoa = pessoas.i_pessoa)
		WHERE pessoas.i_pessoa = 1
		GROUP BY 1; 
	
	RAISE NOTICE 'Pessoa: % - valor: % ', l_nome_pes, l_valor;
	
	SELECT AVG(valor)
		INTO l_media
		FROM vendas;
	
	IF l_valor > l_media THEN
		RAISE NOTICE 'As compras de: % estão acima da média: % ', l_nome_pes, l_media;
	ELSIF l_valor < l_media THEN 
		RAISE NOTICE 'As compras de: % estão abaixo da média: % ', l_nome_pes, l_media;
	ELSE
		RAISE NOTICE 'As compras de: % estão iguais a media: % ', l_nome_pes, l_media;
	END IF;
END $$;


/////////////////////////////////////////////////////

ATIVIDADE 4

CRIAR UM BLOCO DE PROGRAMAÇÃO ESTRUTURADA PARA RETORNAR O NOME DAS PESSOAS, E A
SOMATÓRIA DOS VALORES DE VENDA REALIZADOS PARA AQUELA PESSOA.
INFORMAR VIA MENSAGEM SE O VALOR DE COMPRA DO CLIENTE ESTÁ ACIMA, ABAIXO DA MÉDIA,
OU IGUAL AO VALOR MÉDIO DE COMPRAS POR CLIENTE.


DO $$
DECLARE

	l_codigo INTEGER := 0;
	l_codigo_ant INTEGER := 0;
	l_nome_pes VARCHAR(100) := '';
	l_valor NUMERIC(12,2) := 0;     
	l_media NUMERIC(12,2) := 0;
BEGIN
	
	WHILE l_codigo_ant = 0 OR l_codigo_ant <> l_codigo LOOP
	
		l_codigo_ant := l_codigo;
			
		SELECT pessoas.i_pessoa, pessoas.nome, SUM (vendas.valor)
			INTO l_codigo, l_nome_pes, l_valor  
			FROM vendas INNER JOIN pessoas 
				ON (vendas.i_pessoa = pessoas.i_pessoa)
			WHERE pessoas.i_pessoa = (SELECT MIN(p.i_pessoa)
										  FROM pessoas p
									    WHERE p.i_pessoa > l_codigo)
			GROUP BY 1, pessoas.i_pessoa 
			ORDER BY pessoas.i_pessoa; 
			
		RAISE NOTICE 'l_codigo_ant: % - l_codigo: % ', l_codigo_ant, l_codigo;	
		
		RAISE NOTICE 'Pessoa: % - valor: % ', l_nome_pes, l_valor;
		
		SELECT AVG(valor) -
			INTO l_media
			FROM vendas;
		
		IF l_valor > l_media THEN
			RAISE NOTICE 'As compras de: % estão acima da média: % ', l_nome_pes, l_media;
		ELSIF l_valor < l_media THEN
			RAISE NOTICE 'As compras de: % estão abaixo da média: % ', l_nome_pes, l_media;
		ELSE
			RAISE NOTICE 'As compras de: % estão iguais a média: % ', l_nome_pes, l_media;
		END IF;
		
	END LOOP;
END $$;

/////////////////////////////////////////////////////

CREATE TABLE PRODUTOS(
	I_PRODUTO INTEGER NOT NULL,
	NOME VARCHAR(100) NOT NULL,
	VALOR DECIMAL(12,2) NOT NULL,
	CONSTRAINT PK_PRODUTOS PRIMARY KEY(I_PRODUTO)
);

INSERT INTO PRODUTOS VALUES(1, 'PARAFUSOS', 1.00);
INSERT INTO PRODUTOS VALUES(2, 'TINTAS', 10.00);
INSERT INTO PRODUTOS VALUES(3, 'PINCEL', 5.50);
INSERT INTO PRODUTOS VALUES(4, 'LÁPIS', 1.20);

CREATE TABLE ITENS_VENDAS(
	I_VENDA INTEGER NOT NULL,
	I_ITEM INTEGER NOT NULL,
	QUANTIDADE INTEGER NOT NULL,
	I_PRODUTO INTEGER NOT NULL,
	VALOR_VENDA DECIMAL NOT NULL,
	CONSTRAINT PK_ITENS_VENDAS PRIMARY KEY(I_VENDA, I_ITEM),
	CONSTRAINT FK_ITENS_VENDAS_VENDAS FOREIGN KEY(I_VENDA) REFERENCES VENDAS(I_VENDA),
	CONSTRAINT FK_ITENS_VENDA_PRODUTOS FOREIGN KEY(I_PRODUTO) REFERENCES PRODUTOS(I_PRODUTO)
); 

INSERT INTO ITENS_VENDAS VALUES(1, 1, 5, 2, 10);
INSERT INTO ITENS_VENDAS VALUES(1, 2, 50, 1, 1);
INSERT INTO ITENS_VENDAS VALUES(2, 1, 100, 3, 5.50);
INSERT INTO ITENS_VENDAS VALUES(2, 2, 45, 2, 10);
INSERT INTO ITENS_VENDAS VALUES(3, 1, 100, 4, 1.25);
INSERT INTO ITENS_VENDAS VALUES(3, 2, 10, 1, 35);
INSERT INTO ITENS_VENDAS VALUES(4, 1, 60, 1, 10);
INSERT INTO ITENS_VENDAS VALUES(5, 1, 70, 1, 10);
INSERT INTO ITENS_VENDAS VALUES(6, 1, 20, 1, 10);

COMMIT;

/////////////////////////////////////////////////////

ATIVIDADE 5

CRIAR UM BLOCO DE PROGRAMAÇÃO ESTRUTURADA PARA RETORNAR NOME DOS
PRODUTOS, E, A MÉDIA DOS VALORES DE VENDA REALIZADOS PARA AQUELE PRODUTO.
INFORMAR VIA MENSAGEM SE O VALOR MÉDIO DE COMPRA DAQUELE PRODUTO ESTÁ
ACIMA, ABAIXO, OU IGUAL AO VALOR MÉDIO DE COMPRAS POR PRODUTO.

DO $$
DECLARE

	l_codigo INTEGER := 0;
	l_codigo_ant INTEGER := 0;
	l_nome_prod VARCHAR(100) := '';
	l_valor NUMERIC(12,2) := 0;     
	l_media NUMERIC(12,2) := 0;
BEGIN

	SELECT AVG(valor) 
		INTO l_media
		FROM itens_vendas;
			
	WHILE l_codigo_ant = 0 OR l_codigo_ant <> l_codigo LOOP
	
	l_codigo_ant := l_codigo;
			
	SELECT produtos.i_produto, produtos.nome, AVG (itens_vendas.valor_venda)
		INTO l_codigo, l_nome_prod, l_valor  
		FROM itens_vendas INNER JOIN produtos
			ON (itens_vendas.i_produto = produtos.i_produto)
		WHERE produtos.i_produto = (SELECT MIN(p.i_produto)
										FROM produtos p
									   WHERE p.i_produto > l_codigo)
			GROUP BY produtos.i_produto;
			
		IF l_codigo ISNULL THEN	
			EXIT;
		END IF;
		
		RAISE NOTICE 'l_codigo_ant: % - l_codigo: % ', l_codigo_ant, l_codigo;	
		
		RAISE NOTICE 'PRODUTO: % - VALOR: % ', l_nome_prod, l_valor;
		
		IF l_valor > l_media THEN
			RAISE NOTICE 'O valor médio de compras de: % estão acima da média: % ', l_nome_prod, l_media;
		ELSIF l_valor < l_media THEN
			RAISE NOTICE 'O valor médio de compras de: % estão abaixo da média: % ', l_nome_prod, l_media;
		ELSE
			RAISE NOTICE 'As valor médio de compras de: % estão iguais a média de compras por produto: % ', l_nome_prod, l_media;
		END IF;
		
	END LOOP;
END $$;