CREATE DATABASE IF NOT EXISTS universus;
USE universus;
CREATE TABLE instituicao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    nota_mec DECIMAL(3,2),
    nota_enade DECIMAL(3,2),
    mensalidade_media DECIMAL(10,2)
);
INSERT INTO instituicao (nome, nota_mec, nota_enade, mensalidade_media)
VALUES 
('Universidade Católica de Brasília', 4.5, 4.2, 1200.00),
('UDF Centro Universitário', 3.8, 3.5, 950.00),
('UNICEPLAC Centro Universitário', 4.0, 3.9, 1100.00);

-- Cria a tabela exatamente como seu login.php e cadastro.php precisam
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL, -- O seu código PHP usa este nome!
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insere um usuário de teste (Senha é 123456)
-- O valor longo abaixo é o "hash" da senha 123456
INSERT INTO usuarios (email, senha_hash) 
VALUES ('teste@universus.com', '$2y$10$8Wk6mN9U9Y.zK1M/p.f2De5vFvXzM6f6zY6R6r6Z6e6q6v6f6u6y6');

CREATE TABLE comentarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    faculdade VARCHAR(50) NOT NULL,
    comentario TEXT NOT NULL,
    data_comentario TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);
-- 1. Cria a coluna 'logo' na tabela
ALTER TABLE `instituicao` ADD `logo` VARCHAR(255) NULL AFTER `mensalidade_media`;

-- 2. Atualiza os caminhos das imagens para cada faculdade
UPDATE `instituicao` SET `logo` = 'logos/ucb.png' WHERE `id` = 1;
UPDATE `instituicao` SET `logo` = 'logos/udf.png' WHERE `id` = 2;
UPDATE `instituicao` SET `logo` = 'logos/uniceplac.png' WHERE `id` = 3;

CREATE TABLE avaliacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    faculdade_id INT NOT NULL,
    nota INT NOT NULL CHECK (nota >= 1 AND nota <= 5),
    UNIQUE KEY (usuario_id, faculdade_id), -- Garante que o usuário só vote uma vez por faculdade
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (faculdade_id) REFERENCES instituicao(id)
);
ALTER TABLE instituicao
ADD COLUMN soma_notas INT DEFAULT 0,
ADD COLUMN total_votos INT DEFAULT 0;
