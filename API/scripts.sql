-- Oberservação: Tire os comentários que estão na frente de um comando, se não não irá funcionar.

-- Criando o banco de dados
create database theMidway 
default character set utf8mb4;


-- Criando a tabela
use theMidway;                                    
create table encontros (                             
    id int not null auto_increment PRIMARY KEY,         -- Chave primária
    data_post datetime default CURRENT_TIMESTAMP,       -- Data da adição do dado
    data date,                                          -- Data do encontro
    hora time,                                          -- Hora do Encontro
    nome varchar(100),                                  -- Nome do Local
    tipo varchar(20),                                   -- Tipo do local (restaurante, bar..)
    longitude float,
    latitude float,
    pais char(3),
    cidade char(2),
    bairro varchar(60),
    endereco varchar(100),
    numero varchar(20)
) default character set utf8mb4 ;


-- Ver todos valores
use theMidway; 
select * from encontros;


-- Apagar o banco de dados
use theMidway; 
drop database theMidway;


-- Apagar todos os dados de uma tabela
use theMidway; 
truncate table encontros;