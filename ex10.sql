create database ex10

go 

use ex10

go 

create table medicamentos(

codigo int not null,
nome varchar(70) not null,
apresentacao varchar(50) not null,
unidade_de_cadastro varchar(30) not null, 
preco_proposto float not null

primary key (codigo) 
)

go

create table cliente(

cpf varchar(12) not null,
nome varchar (50) not null,
rua varchar(50) not null, 
numero int not null, 
bairro varchar(50) not null,
telefone varchar(9) not null

primary key(cpf) 
)

go

create table venda (

nota_fiscal int not null,
cpf_cliente varchar(12) not null,
codigo_medicamentos int not null, 
qtde int not null,
valor_total float not null, 
data_venda date not null

primary key(nota_fiscal, cpf_cliente, codigo_medicamentos) 
foreign key(cpf_cliente) references cliente (cpf),
foreign key(codigo_medicamentos) references medicamentos(codigo)

)


-- Nome, apresenta��o, unidade e valor unit�rio dos rem�dios que ainda n�o foram vendidos.
--Caso a unidade de cadastro seja comprimido, mostrar Comp.
select m.nome, m.apresentacao,
case when m.unidade_de_cadastro like '%Comprimido%'then 
	'comp.'
else 
	m.unidade_de_cadastro
end as unidade_de_cadastro,
m.preco_proposto
from medicamentos m left outer join venda v
on m.codigo = v.codigo_medicamentos
where v.nota_fiscal is null


-- Nome dos clientes que compraram Amiodarona
select nome 
from cliente
where cpf in 
(
	select cpf_cliente 
	from venda
	where codigo_medicamentos in 
	(
		select codigo 
		from medicamentos 
		where nome like '%Amiodarona%'
	)
)

-- CPF do cliente, endere�o concatenado, nome do medicamento (como nome de rem�dio), 
--apresenta��o do rem�dio, unidade, pre�o proposto,
--quantidade vendida e valor total dos rem�dios vendidos a Maria Z�lia

select c.cpf, c.rua +' - '+CONVERT(char(10) ,c.numero)+ ' '+ c.bairro as enderco_completo,
m.nome as nome_de_remedio, m.apresentacao, m.unidade_de_cadastro, m.preco_proposto
from cliente c, medicamentos m, venda v
	where c.cpf = v.cpf_cliente
	and v.codigo_medicamentos = m.codigo
	and c.nome like 'Maria Z�lia'


-- Data de compra, convertida, de Carlos Campos
select CONVERT(char(10),v.data_venda,103) as data_da_venda
from cliente c, venda v
where c.cpf = v.cpf_cliente
	and c.nome like 'Carlos campos'