create database ex11

go 

use ex11

create table plano(

codigo int not null,
nome varchar(30) not null,
telefone varchar(8) not null

primary key(codigo)

)

go

create table paciente(

cpf varchar(11) not null,
nome varchar(30) not null,
rua varchar (40) not null,
numero int not null, 
bairro varchar(20) not null,
telefone varchar(8) not null, 
codigo_plano int not null

primary key(cpf)
foreign key(codigo_plano) references plano (codigo)
)

go

create table medico(

codigo int not null, 
nome varchar(20) not null,
especialidade varchar(30) not null, 
codigo_plano int not null

primary key(codigo) 
foreign key(codigo_plano) references plano(codigo)


)

go 

create table consulta(

codigo_medico int not null, 
cpf_paciente varchar(11) not null, 
data_consulta date not null,
hora time not null,
diagnostico varchar(50) not null

primary key(codigo_medico, cpf_paciente, data_consulta)

foreign key(codigo_medico)references medico(codigo),
foreign key(cpf_paciente) references paciente(cpf)
)



-- Nome e especialidade dos m�dicos da Amil

select m.nome, m.especialidade
from medico m, plano p
where m.codigo_plano = p.codigo
	and p.nome like 'Amil'

-- Nome, Endere�o concatenado, Telefone e Nome do Plano de Sa�de de todos os pacientes

select p.nome, p.rua + ' - '+ CONVERT(char(3), p.numero) + ' '+  p.bairro as endereco_completo,
pl.nome
from paciente p, plano pl
where p.codigo_plano = pl.codigo

-- Telefone do Plano de  Sa�de de Ana J�lia

select telefone
from plano
where codigo in (
	
	select codigo_plano
	from paciente
	where nome like 'Ana%'

)

-- Plano de Sa�de que n�o tem pacientes cadastrados

select pl.nome
from plano pl left outer join paciente p
on pl.codigo = p.codigo_plano
where p.cpf is null

-- Planos de Sa�de que n�o tem m�dicos cadastrados

select pl.nome
from plano pl left outer join medico m
on pl.codigo = m.codigo_plano
where m.codigo is null

-- Data da consulta, Hora da consulta, nome do m�dico, nome do paciente e diagn�stico de todas as consultas

select c.data_consulta, c.hora, m.nome, p.nome, c.diagnostico
from consulta c, medico m, paciente p 
where c.codigo_medico = m.codigo
	and p.cpf = c.cpf_paciente


-- Nome do m�dico, data e hora de consulta e diagn�stico de Jos� Lima

select m.nome, c.data_consulta, c.hora, c.diagnostico
from medico m, consulta c, paciente p
where m.codigo = c.codigo_medico
	and c.cpf_paciente = p.cpf
	and p.nome = 'Jos� Lima'


-- Alterar o nome de Jo�o Carlos para Jo�o Carlos da Silva

update paciente
set nome = 'Jo�o Carlos da Silva'
where nome = 'Jo�o Carlos'

select*from paciente 

-- Deletar o plano de Sa�de Unimed
delete plano where nome = 'Unimed'

select*from plano

-- Renomear a coluna Rua da tabela Paciente para Logradouro

sp_rename 'paciente.rua', 'logradouro', 'COLUMN'

select*from paciente

-- Inserir uma coluna, na tabela Paciente, de nome idade e inserir os valores (28,39,14 e 33) respectivamente

alter table paciente 
add idade int default(null)