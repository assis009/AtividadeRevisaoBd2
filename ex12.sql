CREATE DATABASE ativi12
GO
USE ativi12
GO
CREATE TABLE planos
(
	codPlano		INT				NOT NULL,
	nomePlano		VARCHAR(40)		NOT NULL,
	valorPlano		FLOAT			NOT NULL
	PRIMARY KEY(codPlano)
)
GO
CREATE TABLE servicos
(
	codServico		INT				NOT NULL,
	nomeServico		VARCHAR(40)		NOT NULL,
	valorServico	FLOAT			NOT NULL
	PRIMARY KEY(codServico)
)
GO
CREATE TABLE cliente
(
	codCliente		INT				NOT NULL,
	nomeCliente		VARCHAR(40)		NOT NULL,
	dataInicio		DATE			NOT NULL
	PRIMARY KEY(codCliente)
)
GO
CREATE TABLE contratos
(
	codCliente		INT				NOT NULL,
	codPlano		INT				NOT NULL,
	codServico		INT				NOT NULL,
	status			CHAR(1)			NOT NULL,
	data			DATE			NOT NULL
	FOREIGN KEY(codCliente) REFERENCES cliente(codCliente),
	FOREIGN KEY(codPlano) REFERENCES planos(codPlano),
	FOREIGN KEY(codServico) REFERENCES servicos(codServico),
	PRIMARY KEY(codCliente, codPlano, codServico, status)
)

-- Consultar o nome do cliente, o nome do plano, a quantidade de estados de contrato (sem repeti��es)
-- por contrato, dos planos cancelados, ordenados pelo nome do cliente
SELECT cli.nomeCliente, pln.nomePlano, COUNT(DISTINCT con.status) AS quantidade_de_estados_de_contrato
FROM cliente cli, planos pln, contratos con
WHERE con.codCliente = cli.codCliente AND con.codPlano = pln.codPlano
GROUP BY cli.nomeCliente, pln.nomePlano, con.codPlano
HAVING con.codPlano IS NULL
ORDER BY cli.nomeCliente

-- Consultar o nome do cliente, o nome do plano, a quantidade de estados de contrato (sem repeti��es)
-- por contrato, dos planos n�o cancelados, ordenados pelo nome do cliente
SELECT cli.nomeCliente, pln.nomePlano, COUNT(DISTINCT con.status) AS quantidade_de_estados_de_contrato
FROM cliente cli, planos pln, contratos con
WHERE con.codCliente = cli.codCliente AND con.codPlano = pln.codPlano
GROUP BY cli.nomeCliente, pln.nomePlano, con.codPlano
HAVING con.codPlano IS NOT NULL
ORDER BY cli.nomeCliente

-- Consultar o nome do cliente, o nome do plano, e o valor da conta de cada contrato que est� ou esteve ativo,
-- sob as seguintes condi��es:
--		A conta � o valor do plano, somado � soma dos valores de todos os servi�os
--		Caso a conta tenha valor superior a R$400.00, dever� ser inclu�do um desconto de 8%
--		Caso a conta tenha valor entre R$300,00 a R$400.00, dever� ser inclu�do um desconto de 5%
--		Caso a conta tenha valor entre R$200,00 a R$300.00, dever� ser inclu�do um desconto de 3%
--		Contas com valor inferiores a R$200,00 n�o tem desconto
SELECT cli.nomeCliente, pln.nomePlano, 
	CASE
		WHEN pln.valorPlano + SUM(ser.valorServico) > 400 THEN
			((pln.valorPlano + SUM(ser.valorServico)) - ((pln.valorPlano + SUM(ser.valorServico))* 0.08))
		ELSE
			CASE
				WHEN pln.valorPlano + SUM(ser.valorServico) > 300 AND pln.valorPlano + SUM(ser.valorServico) <= 400 THEN
					((pln.valorPlano + SUM(ser.valorServico)) - ((pln.valorPlano + SUM(ser.valorServico))* 0.05))
				ELSE
					CASE
						WHEN pln.valorPlano + SUM(ser.valorServico) > 200 AND pln.valorPlano + SUM(ser.valorServico) <= 300 THEN
							((pln.valorPlano + SUM(ser.valorServico)) - ((pln.valorPlano + SUM(ser.valorServico))* 0.03))
						ELSE
							(pln.valorPlano + SUM(ser.valorServico))
					END
			END
	END AS valor_da_conta
FROM cliente cli, planos pln, contratos con, servicos ser
WHERE con.codCliente = cli.codCliente AND con.codPlano = pln.codPlano AND con.codServico = ser.codServico
GROUP BY cli.nomeCliente, pln.nomePlano, pln.valorPlano, con.codPlano
HAVING con.codPlano IS NOT NULL

-- Consultar o nome do cliente, o nome do servi�o, e a dura��o, em meses (at� a data de hoje) do servi�o,
-- dos cliente que nunca cancelaram nenhum plano
SELECT cli.nomeCliente, ser.nomeServico, DATEDIFF(MONTH, con.data, GETDATE()) AS dura��o
FROM cliente cli, planos pln, contratos con, servicos ser
WHERE con.codCliente = cli.codCliente AND con.codPlano = pln.codPlano AND con.codServico = ser.codServico
GROUP BY cli.nomeCliente, ser.nomeServico, con.codServico, con.data
HAVING con.codServico IS NOT NULL