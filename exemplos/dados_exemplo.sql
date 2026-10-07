-- =============================================================
-- Dados de exemplo (DML) para testar o banco AcdnRentalCar
-- Rode DEPOIS de sql/reserva_carros_ddl.sql
-- =============================================================
USE AcdnRentalCar;

INSERT INTO sedes (nome, endereco, telefone, nomeGerente, multa) VALUES
  ('Sede Asa Norte',  'SEPN 707, Brasília - DF',       '(61) 3333-1000', 'Mariana Lopes',  150.00),
  ('Sede Taguatinga', 'QNA 12, Taguatinga - DF',       '(61) 3333-2000', 'Carlos Pereira', 120.00),
  ('Sede Aeroporto',  'Aeroporto JK, Brasília - DF',   '(61) 3333-3000', 'Fernanda Dias',  200.00);

INSERT INTO classesCarro (nome, valorDiaria) VALUES
  ('Subcompacto',     89.90),
  ('Compacto',       119.90),
  ('Tamanho Médio',  159.90),
  ('Tamanho Grande', 219.90),
  ('Luxo',           399.90);

INSERT INTO clientes (nome, cpf, cnh, validadeCnh, categoriaCnh) VALUES
  ('Ana Souza',     '12345678901', '01234567890', '2029-05-10', 'B'),
  ('Bruno Lima',    '23456789012', '12345678901', '2027-11-22', 'AB'),
  ('Carla Mendes',  '34567890123', '23456789012', '2026-01-15', 'B');  -- CNH vencida

INSERT INTO carros (placa, modelo, ano, cor, quilometragem, descricao, situacao,
                    origemCarro, localizacaoCarro, classeCarro) VALUES
  ('JKL1A23', 'Fiat Mobi',        '2023/2024', 'Branco', 15230.50, 'Ar-condicionado, 4 portas',  'disponivel', 1, 1,    1),
  ('PAB2C34', 'Chevrolet Onix',   '2022/2023', 'Prata',  32100.00, 'Câmbio automático',          'alugado',    1, NULL, 2),
  ('OVD3E45', 'Toyota Corolla',   '2023/2023', 'Preto',  21000.75, 'Sedã, multimídia',            'disponivel', 2, 2,    3),
  ('REX4F56', 'Jeep Commander',   '2024/2025', 'Cinza',   8000.00, 'SUV 7 lugares',               'fora do ponto de origem', 2, 3, 4),
  ('LUX5G67', 'BMW 320i',         '2024/2024', 'Azul',    5000.00, 'Bancos de couro, teto solar', 'disponivel', 3, 3,    5);

INSERT INTO reservas (diarias, dataLocacao, dataRetorno, quilometrosRodados, multa, situacao, total,
                      carro_reserva, cliente_reserva, sedeLocacao, sedeDevolucao) VALUES
  -- finalizada: devolveu na mesma sede, sem multa (3 x 159,90)
  (3, '2026-09-01', '2026-09-04', 420.00, 0.00,   'finalizada', 479.70, 3, 1, 2, 2),
  -- finalizada: devolveu em outra sede, com multa da sede de origem (2 x 219,90 + 120,00)
  (2, '2026-09-20', '2026-09-22', 310.00, 120.00, 'finalizada', 559.80, 4, 2, 2, 3),
  -- ativa: carro ainda com o cliente (sem data de retorno)
  (5, '2026-10-05', NULL, NULL, NULL, 'ativa', NULL, 2, 2, 1, 1);
