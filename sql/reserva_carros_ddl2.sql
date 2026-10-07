CREATE DATABASE concessionaria;
USE concessionaria;

CREATE TABLE sedes (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    endereco VARCHAR(80) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    nomeGerente VARCHAR(50) NOT NULL,
    multa DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE classesCarro (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(20) NOT NULL,
    valorDiaria DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE clientes (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    cnh VARCHAR(20) NOT NULL,
    validadeCnh DATE NOT NULL,
    categoriaCnh VARCHAR(3) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE carros (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    placa VARCHAR(10) NOT NULL,
    modelo VARCHAR(40) NOT NULL,
    ano VARCHAR(40) NOT NULL,
    cor VARCHAR(9) NOT NULL,
    quilometragem DECIMAL(8,2) NOT NULL,
    descricao VARCHAR(100) NOT NULL,
    situacao VARCHAR(30) NOT NULL,
    origemCarro INT UNSIGNED NOT NULL,
    localizacaoCarro INT UNSIGNED NOT NULL,
    classeCarro INT UNSIGNED NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE reservas (
    numero INT UNSIGNED NOT NULL AUTO_INCREMENT,
    diarias INT UNSIGNED NOT NULL,
    dataLocacao DATE NOT NULL,
    dataRetorno DATE,
    quilometrosRodados DECIMAL(8,2),
    multa DECIMAL(8,2),
    situacao VARCHAR(15) NOT NULL,
    total DECIMAL(8,2),
    carros_reserva INT UNSIGNED NOT NULL,
    cliente_reserva INT UNSIGNED NOT NULL,
    sedeLocacao INT UNSIGNED NOT NULL,
    sedeDevolucao INT UNSIGNED NOT NULL,
    PRIMARY KEY (numero)
);

ALTER TABLE carros
ADD FOREIGN KEY (origemCarro) REFERENCES sedes (id);

ALTER TABLE carros
ADD FOREIGN KEY (localizacaoCarro) REFERENCES sedes (id);

ALTER TABLE carros
ADD FOREIGN KEY (classeCarro) REFERENCES classesCarro (id);

ALTER TABLE reservas
ADD FOREIGN KEY (sedeLocacao) REFERENCES sedes (id);

ALTER TABLE reservas
ADD FOREIGN KEY (sedeDevolucao) REFERENCES sedes (id);

ALTER TABLE reservas
ADD FOREIGN KEY (carros_reserva) REFERENCES carros (id);

ALTER TABLE reservas
ADD FOREIGN KEY (cliente_reserva) REFERENCES clientes (id);
