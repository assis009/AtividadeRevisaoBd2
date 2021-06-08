create database ex09

go

use ex09 


create table editora(

codigo int not null,
nome varchar(30) not null,
site varchar(40) default(null)

primary key(codigo)

)

create table autor (

codigo int not null,
nome varchar(50) not null,
biografia varchar(100) not null, 

primary key(codigo)

)


create table estoque(

codigo int not null,
nome varchar(40) unique not null,
quantidade int not null, 
valor float not null check(valor>0), 
cod_editora int not null,
cod_autor int not null

primary key(codigo)
foreign key(cod_editora) references editora(codigo),
foreign key(cod_autor) references autor(codigo)
)


create table compras(

codigo int not null,
cod_estoque int not null,
qtde_comprada int not null check(qtde_comprada >0),
valor float not null check(valor>0),
data_comprada date not null

primary key(codigo, cod_estoque)
foreign key(cod_estoque) references estoque (codigo)

)


-- Consultar nome, valor unitário, nome da editora e nome do
--autor dos livros do estoque que foram vendidos. Não podem haver repetições.

select distinct es.nome, es.valor,ed.nome, a.nome
from estoque es, autor a, editora ed, compras c
where es.cod_autor = a.codigo
	and es.cod_editora = ed.codigo
	and c.cod_estoque = es.codigo
	and c.cod_estoque is not null


-- Consultar Nome do livro e site da editora dos 
--livros da Makron books (Caso o site tenha mais de 10 dígitos, remover o www.).

select es.nome, 
case when len(ed.site) > 10 then 
	replace(ed.site, 'www.','')
else
	ed.site
end as site_editora
from estoque es, editora ed
where es.cod_editora = ed.codigo
	and ed.nome like 'Makron%'

-- Consultar nome do livro e Breve Biografia do David Halliday

select es.nome, a.biografia
from estoque es, autor a
where es.cod_autor = a.codigo
	and a.nome like 'David%'


-- Consultar código de compra e quantidade comprada do livro Sistemas Operacionais Modernos

select c.codigo, c.qtde_comprada
from compras c, estoque es
where c.cod_estoque = es.codigo
	and es.nome like 'Sistemas Operacionais%'

-- Consultar quais livros não foram vendidos
select es.nome
from estoque es left outer join  compras c
on  c.cod_estoque = es.codigo
where c.cod_estoque is null


-- Consultar quais livros foram vendidos e não estão cadastrados
select es.nome
from compras c  left outer join  estoque es
on  c.cod_estoque = es.codigo
where c.cod_estoque is not null
	and es.codigo is null

-- Consultar Nome e site da editora que não tem Livros no estoque 
--(Caso o site tenha mais de 10 dígitos, remover o www.)

select ed.nome, 
case when len(ed.site) > 10 then 
	replace(ed.site, 'www.','')
else 
	ed.site
end as site_editora
from editora ed left outer join estoque es 
on es.cod_editora = ed.codigo
where es.cod_editora is null

-- Consultar Nome e biografia do autor que não tem Livros no estoque 
--(Caso a biografia inicie com Doutorado, substituir por Ph.D.)

select a.nome, replace(a.biografia, 'Doutorado', 'Ph.D')
from autor a left outer join estoque es
on es.cod_autor = a.codigo
where es.cod_autor is null

-- Consultar o nome do Autor, e o maior valor de Livro no estoque.
--Ordenar por valor descendente

select top 1 a.nome, es.valor
from autor a, estoque es
where es.cod_autor = a.codigo
group by a.nome, es.valor
order by es.valor desc

-- Consultar o código da compra, o total de livros comprados e a soma dos valores gastos. Ordenar por Código da Compra ascendente.

select c.codigo, sum(c.qtde_comprada) as  total_comprado, sum(c.valor) as total_de_gastos
from compras c
group by c.codigo
order by c.codigo 

-- Consultar o nome da editora e a média de preços dos livros em estoque.Ordenar pela Média de Valores ascendente.

select ed.nome, cast(avg(es.valor) as decimal(7,2))as media_valores
from editora ed, estoque es 
where es.cod_editora = ed.codigo
group by ed.nome 

-- Consultar o nome do Livro, a quantidade em estoque o nome da editora,
--o site da editora (Caso o site tenha mais de 10 dígitos, remover o www.), criar uma coluna status onde:

select es.nome, 
case when es.quantidade<5 then 
	'Ponto de pedido'
else
	case when es.quantidade>=5 and es.quantidade<=10 then
		'Produto acabando'
	else 
		case when es.quantidade>10 then
			'Estoque suficiente'
		end 
	end
end as status, 
ed.nome, 
case when len(ed.site) > 10 then 
	replace(ed.site, 'www.','')
else 
	ed.site
end as site_editora
from estoque es, editora ed
where es.cod_editora = ed.codigo

-- Para montar um relatório, é necessário montar uma consulta com a seguinte saída:
-- Código do Livro, Nome do Livro, Nome do Autor, Info Editora (Nome da Editora + Site) de todos os livros

select es.codigo, es.nome, a.nome,
case when ed.site is not null then 
	ed.nome+ ' '+ed.site 
else 
	ed.nome + ' (sem site)'
end as info_editora
from estoque es, editora ed, autor a
where es.cod_autor = a.codigo
	and es.cod_editora = ed.codigo


-- Consultar Codigo da compra, quantos dias da compra até hoje e quantos meses da compra até hoje
select c.codigo, datediff(day, c.data_comprada, GETDATE()) as dias_da_compra_ate_hoje,
datediff(MONTH, c.data_comprada, GETDATE()) as meses_da_compra_ate_hoje
from compras c 

-- Consultar o código da compra e a soma dos valores gastos das compras que somam mais de 200.00

select c.codigo, sum(c.valor) as valor_total_acima_de_200
from compras c
group by codigo
having sum(c.valor)>200

