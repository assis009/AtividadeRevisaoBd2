create database ex08

go

use ex08

go 

create table cliente(

codigo int not null,
nome varchar(35) not null,
endereco varchar(90) not null,
telefone varchar(9) not null,
telefone_comercial varchar(9) default (null)


primary key(codigo) 
)

go

create table tipo_mercadoria(

codigo int not null,
nome varchar(30) not null

primary key(codigo) 
)

go 

create table corredores(

codigo int not null,
codigo_tipo int not null,
nome varchar(30) default(null)

primary key(codigo)
foreign key(codigo_tipo) references tipo_mercadoria(codigo)
)

go 

create table mercadoria (

codigo int not null,
nome varchar(30) not null,
codigo_corredor int not null,
codigo_tipo int not null, 
valor float not null

primary key(codigo)
foreign key(codigo_corredor) references corredores(codigo),
foreign key(codigo_tipo) references tipo_mercadoria (codigo)


)

go 

create table compra(

nota_fiscal int not null, 
codigo_cliente int not null,
valor float not null

primary key(nota_fiscal)
foreign key(codigo_cliente) references cliente(codigo)

)


-- Valor da Compra de Luis Paulo
select co.valor 
from cliente cl, compra co
where cl.codigo = co.codigo_cliente
	and cl.nome like 'Luis%'


-- Valor da Compra de Marcos Henrique
select co.valor 
from cliente cl, compra co
where cl.codigo = co.codigo_cliente
	and cl.nome like 'Marcos%'


--Endereço e telefone do comprador de Nota Fiscal = 4567
select cl.nome, cl.telefone, cl.endereco
from cliente cl, compra co
where cl.codigo = co.codigo_cliente
	and co.nota_fiscal = 4567


-- Valor da mercadoria cadastrada do tipo " Pães"

select m.valor 
from mercadoria m, tipo_mercadoria tm
where m.codigo_tipo = tm.codigo
	and tm.nome like 'Pães%'

-- Nome do corredor onde está a Lasanha
select nome 
from corredores
where codigo in 
(
	select codigo_corredor
	from mercadoria
	where nome like 'Lasanha'
)


--  Nome do corredor onde estão os clorados
select nome 
from corredores
where codigo_tipo in 
(
	select codigo 
	from tipo_mercadoria
	where nome like 'Clorados'
)

