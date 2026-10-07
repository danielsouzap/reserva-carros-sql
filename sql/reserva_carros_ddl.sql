DROP DATABASE IF EXISTS AcdnRentalCar;
CREATE DATABASE AcdnRentalCar
    DEFAULT CHARACTER SET utf8mb4;

USE AcdnRentalCar;

CREATE TABLE sedes (
    id           INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    nome         VARCHAR(50)   NOT NULL,
    endereco     VARCHAR(80)   NOT NULL,
    telefone     VARCHAR(20)   NOT NULL,
    nomeGerente  VARCHAR(50)   NOT NULL,
    multa        DECIMAL(10,2) NOT NULL,  -- multa por entregar o carro em outra sede
    PRIMARY KEY (id)
) ENGINE=InnoDB;

-- CLASSES DE CARRO: Subcompacto, Compacto, Tamanho Médio, Tamanho Grande, Luxo
CREATE TABLE classesCarro (
    id           INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    nome         VARCHAR(20)   NOT NULL,
    valorDiaria  DECIMAL(10,2) NOT NULL,  -- o preço da diária depende da classe
    PRIMARY KEY (id),
    CONSTRAINT uq_classes_nome UNIQUE (nome)
) ENGINE=InnoDB;

-- CLIENTES: quem faz as reservas
CREATE TABLE clientes (
    id           INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    nome         VARCHAR(50)   NOT NULL,
    cpf          CHAR(11)      NOT NULL,  -- está no modelo lógico (Tabela 2), faltava na Listagem 3
    cnh          VARCHAR(20)   NOT NULL,
    validadeCnh  DATE          NOT NULL,  -- regra: só aluga quem tem CNH em dia
    categoriaCnh VARCHAR(3)    NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT uq_clientes_cpf UNIQUE (cpf),  -- dois clientes não podem ter o mesmo CPF
    CONSTRAINT uq_clientes_cnh UNIQUE (cnh)
) ENGINE=InnoDB;

-- CARROS: a frota da empresa
CREATE TABLE carros (
    id               INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    placa            VARCHAR(10)   NOT NULL,
    modelo           VARCHAR(40)   NOT NULL,
    ano              VARCHAR(9)    NOT NULL,  -- ex.: '2009/2010' (ano modelo/fabricação)
    cor              VARCHAR(20)   NOT NULL,
    quilometragem    DECIMAL(10,2) NOT NULL,
    descricao        VARCHAR(100)  NOT NULL,
    situacao         VARCHAR(30)   NOT NULL,
    origemCarro      INT UNSIGNED  NOT NULL,  -- FK -> sedes (ponto de origem, sempre existe)
    localizacaoCarro INT UNSIGNED  NULL,      -- FK -> sedes (NULL enquanto está alugado)
    classeCarro      INT UNSIGNED  NOT NULL,  -- FK -> classesCarro
    PRIMARY KEY (id),
    CONSTRAINT uq_carros_placa UNIQUE (placa),
    CONSTRAINT ck_carros_situacao
        CHECK (situacao IN ('disponivel', 'alugado', 'fora do ponto de origem'))
) ENGINE=InnoDB;

-- RESERVAS: liga cliente + carro + sede de locação + sede de devolução
CREATE TABLE reservas (
    numero             INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    diarias            INT UNSIGNED  NOT NULL,
    dataLocacao        DATE          NOT NULL,
    dataRetorno        DATE          NULL,      -- NULL até o carro ser devolvido
    quilometrosRodados DECIMAL(10,2) NULL,      -- só se sabe na devolução
    multa              DECIMAL(10,2) NULL,
    situacao           VARCHAR(15)   NOT NULL,
    total              DECIMAL(10,2) NULL,      -- diárias x valor da diária + multa
    carro_reserva      INT UNSIGNED  NOT NULL,  -- FK -> carros
    cliente_reserva    INT UNSIGNED  NOT NULL,  -- FK -> clientes
    sedeLocacao        INT UNSIGNED  NOT NULL,  -- FK -> sedes (onde retirou)
    sedeDevolucao      INT UNSIGNED  NOT NULL,  -- FK -> sedes (onde vai devolver)
    PRIMARY KEY (numero),
    CONSTRAINT ck_reservas_diarias  CHECK (diarias > 0),
    CONSTRAINT ck_reservas_situacao CHECK (situacao IN ('ativa', 'atrasada', 'finalizada'))
) ENGINE=InnoDB;

-- Sedes 1 --- 0..* Carros (ponto de origem)
ALTER TABLE carros ADD CONSTRAINT fk_sedesOrigem
    FOREIGN KEY (origemCarro) REFERENCES sedes (id);

-- Sedes 0..1 --- 0..* Carros (localização atual)
ALTER TABLE carros ADD CONSTRAINT fk_sedesLocAtual
    FOREIGN KEY (localizacaoCarro) REFERENCES sedes (id);

-- Classes de Carro 1 --- 0..* Carros (agrupados em)
ALTER TABLE carros ADD CONSTRAINT fk_classes
    FOREIGN KEY (classeCarro) REFERENCES classesCarro (id);

-- Sedes 1 --- 0..* Reservas (sede de locação)
ALTER TABLE reservas ADD CONSTRAINT fk_sedesLocacao
    FOREIGN KEY (sedeLocacao) REFERENCES sedes (id);

-- Sedes 1 --- 0..* Reservas (sede de devolução)
ALTER TABLE reservas ADD CONSTRAINT fk_sedesDevolucao
    FOREIGN KEY (sedeDevolucao) REFERENCES sedes (id);

-- Carros 1 --- 0..* Reservas (locado em)
ALTER TABLE reservas ADD CONSTRAINT fk_carros
    FOREIGN KEY (carro_reserva) REFERENCES carros (id);

-- Clientes 1 --- 0..* Reservas (fazem)
ALTER TABLE reservas ADD CONSTRAINT fk_clientes
    FOREIGN KEY (cliente_reserva) REFERENCES clientes (id);