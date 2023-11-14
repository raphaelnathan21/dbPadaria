show databases;

create database dbPadaria;

use dbPadaria;

create table fornecedores (
idFornecedor int primary key auto_increment ,
nomeFornecedor varchar(50) not null,
cnpjFornecedor varchar(20) not null,
telefoneFornecedor varchar(20),
emailFornecedor varchar(50) not null unique,
cep varchar(9),
enderecoFornecedor varchar(100),
numeroEndereco varchar(10),
bairro varchar(40),
cidade varchar(40),
estado varchar(2)
);

insert into fornecedores(nomeFornecedor, cnpjFornecedor, emailFornecedor, telefoneFornecedor, cep, enderecoFornecedor, numeroEndereco, bairro, cidade, estado) values ("Emily", "56.649.102/0001-97", "contato@emily.com.br", "(11) 2757-6155", "13306-050", "Rua Luiz Morato Castanho", "631", "Rancho Grande", "Itu", "SP");

select * from fornecedores;

create table produtos (
idProduto int primary key auto_increment,
nomeProduto varchar(50) not null,
descricaoProduto text,
precoProduto decimal (10,2) not null,
estoqueProduto int not null,
categoriaProduto enum ("Pães", "Bolos", "Confeteira", "Salgados"),
idFornecedor int not null,
foreign key (idFornecedor) references fornecedores(idFornecedor)
);

insert into produtos(nomeProduto, descricaoProduto, precoProduto, estoqueProduto, categoriaProduto, idFornecedor) values ("Salsichão", "SALSICHAO FGO TOM SECO EDER FAT 100G", "2.50", 12, "Salgados", 1);

insert into produtos(nomeProduto, descricaoProduto, precoProduto, estoqueProduto, categoriaProduto, idFornecedor) values ("Empadão", "salgadinho de massa recheada de galinha, queijo, camarão, palmito etc., assada ao forno em fôrma.", "14.50", 8, "Salgados", 1);

insert into produtos(nomeProduto, descricaoProduto, precoProduto, estoqueProduto, categoriaProduto, idFornecedor) values ("Cacetão", "Alimento feito de massa de farinha de cereais cozida num forno", "0.50", 100, "Pães", 1);

insert into produtos(nomeProduto, descricaoProduto, precoProduto, estoqueProduto, categoriaProduto, idFornecedor, validadeProduto, pesoProduto, ingredientesProduto) values ("Pão de queijo", "iguaria oriunda de Minas Gerais, muito difundida em todo o Brasil", "2.50", 12, "Pães", 1, "2024-04-02", "30.00", "polvilho e queijo parmesão");

insert into produtos(nomeProduto, descricaoProduto, precoProduto, estoqueProduto, categoriaProduto, idFornecedor, validadeProduto, pesoProduto, ingredientesProduto) values ("Quibe", "prato típico do Oriente Médio que consiste em um bolinho de massa de triguilho ou semolina, recheado com carne, temperada com ervas", "2.50", 20, "Salgados", 1, "2024-06-02", "50.00", "carne moída e farinha");

select * from produtos where categoriaProduto = "Pães";

select * from produtos where precoProduto < 50.00 order by precoProduto asc;

create table clientes (
idCliente int primary key auto_increment,
nomeCliente varchar(50),
cpfCliente varchar(15) not null unique,
telefoneCliente varchar(20),
emailCliente varchar(50) unique,
cep varchar(9),
enderecoCliente varchar(100),
numeroEndereco varchar(10),
bairro varchar(40), 
cidade varchar(40),
estado varchar(2)
);

insert into clientes (nomeCliente, cpfCliente, telefoneCliente, emailCliente, cep, enderecoCliente, numeroEndereco, bairro, cidade, estado) values ("Melissa Heloisa", "919.810.370-98", "(61) 3728-7811", "melissa@universo3d.com.br", "72260-807", "Quadra QNO 18 Conjunto 7", "779", "Ceilândia Norte", "Brasília", "DF");

select * from clientes;

create table pedidos (
idPedido int primary key auto_increment,
dataPedido timestamp default current_timestamp,
statusPedido enum ("Pendente", "Finalizado", "Cancelado"),
idCliente int not null,
foreign key (idCliente) references clientes(idCliente)
);

insert into pedidos (statusPedido, idCliente) values ("Finalizado", 1);

select * from pedidos inner join clientes on pedidos.idCliente = clientes.idCliente;

create table itensPedidos (
idItensPedidos int primary key auto_increment,
idPedido int not null,
foreign key (idPedido) references pedidos(idPedido),
idProduto int not null,
foreign key (idProduto) references produtos(idProduto),
quantidade int not null
);

insert into itensPedidos (idPedido, idProduto, quantidade) values (1, 1, 2);

insert into itensPedidos (idPedido, idProduto, quantidade) values (1, 2, 1);

select pedidos.idPedido, produtos.idProduto, clientes.nomeCliente, produtos.nomeProduto, quantidade, produtos.precoProduto 
from pedidos inner join clientes on pedidos.idCliente = clientes.idCliente inner join 
itensPedidos on pedidos.idPedido = itensPedidos.idPedido inner join 
produtos on produtos.idProduto = itensPedidos.idProduto;

alter table produtos add column validadeProduto date;
alter table produtos add column pesoProduto decimal (10, 2);
alter table produtos add column ingredientesProduto text;

alter table produtos drop column validadeProduto;

describe produtos;

select sum(produtos.precoProduto * itensPedidos.quantidade) as Total from produtos inner join itensPedidos on produtos.idProduto = itensPedidos.idProduto where idPedido = 1;

/* ATIVIDADE: POSSÍVEIS FILTROS PARA PADARIA */

/* Filtrar produtos por validade (por exemplo, produtos com validade maior do que a data atual) */
 select * from produtos where validadeProduto > curdate();
 
 /*Filtrar produtos que contenham um ingrediente específico */
 select * from produtos where ingredientesProduto like '%farinha%';
 
 /*ATIVIDADE: FILTRAR PÃES NÃO QUE SEJAM FEITOS À BASE DE FARINHA DE TRIGO, COM VALOR ATÉ 7.90*/
 
 select * from produtos where categoriaProduto = 'Pães' and ingredientesProduto not like '%farinha de trigo%' and precoProduto <= 7.90;