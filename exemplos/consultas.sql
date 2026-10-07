-- =============================================================
-- Consultas de verificação e exemplos de uso
-- Rode DEPOIS de sql/reserva_carros_ddl.sql e exemplos/dados_exemplo.sql
-- =============================================================
USE AcdnRentalCar;

-- 1) Estrutura: tabelas criadas e colunas de uma delas
SHOW TABLES;
DESCRIBE reservas;

-- 2) Os 7 relacionamentos (chaves estrangeiras) do modelo lógico
SELECT TABLE_NAME, CONSTRAINT_NAME, COLUMN_NAME,
       REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'AcdnRentalCar'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, CONSTRAINT_NAME;

-- 3) Frota com classe, valor da diária e onde cada carro está agora
SELECT c.placa, c.modelo, cc.nome AS classe, cc.valorDiaria,
       c.situacao,
       origem.nome                         AS sede_origem,
       COALESCE(atual.nome, '(alugado)')   AS localizacao_atual
FROM carros c
JOIN classesCarro cc  ON cc.id = c.classeCarro
JOIN sedes origem     ON origem.id = c.origemCarro
LEFT JOIN sedes atual ON atual.id = c.localizacaoCarro
ORDER BY cc.valorDiaria;

-- 4) Reservas com cliente, carro, sede de retirada e de devolução
SELECT r.numero, cl.nome AS cliente, ca.modelo,
       sl.nome AS retirada, sd.nome AS devolucao,
       r.diarias, r.multa, r.total, r.situacao
FROM reservas r
JOIN clientes cl ON cl.id = r.cliente_reserva
JOIN carros   ca ON ca.id = r.carro_reserva
JOIN sedes    sl ON sl.id = r.sedeLocacao
JOIN sedes    sd ON sd.id = r.sedeDevolucao
ORDER BY r.numero;

-- 5) Faturamento por sede de retirada (reservas finalizadas)
SELECT s.nome AS sede, COUNT(*) AS reservas, SUM(r.total) AS faturamento
FROM reservas r
JOIN sedes s ON s.id = r.sedeLocacao
WHERE r.situacao = 'finalizada'
GROUP BY s.nome;

-- 6) Clientes com CNH vencida (regra de negócio: não podem alugar)
SELECT nome, cnh, validadeCnh
FROM clientes
WHERE validadeCnh < CURDATE();

-- =============================================================
-- Testes de integridade: cada comando abaixo DEVE FALHAR.
-- Descomente um por vez para ver o banco recusando dados inválidos.
-- =============================================================

-- FK: cliente 99 não existe              -> ERROR 1452
-- INSERT INTO reservas (diarias, dataLocacao, situacao, carro_reserva, cliente_reserva, sedeLocacao, sedeDevolucao)
-- VALUES (1, '2026-10-07', 'ativa', 1, 99, 1, 1);

-- UNIQUE: placa repetida                  -> ERROR 1062
-- INSERT INTO carros (placa, modelo, ano, cor, quilometragem, descricao, situacao, origemCarro, localizacaoCarro, classeCarro)
-- VALUES ('JKL1A23', 'Fiat Uno', '2010/2010', 'Vermelho', 90000, 'Teste', 'disponivel', 1, 1, 1);

-- CHECK: situação fora da lista          -> ERROR 3819 (MySQL) / 4025 (MariaDB)
-- UPDATE carros SET situacao = 'quebrado' WHERE id = 1;

-- CHECK: diárias precisa ser > 0         -> ERROR 3819 (MySQL) / 4025 (MariaDB)
-- INSERT INTO reservas (diarias, dataLocacao, situacao, carro_reserva, cliente_reserva, sedeLocacao, sedeDevolucao)
-- VALUES (0, '2026-10-07', 'ativa', 1, 1, 1, 1);
