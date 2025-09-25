CREATE DATABASE IF NOT EXISTS hospital;

USE hospital;

CREATE TABLE IF NOT EXISTS paciente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255),
    cpf VARCHAR(14),
    data_nascimento VARCHAR(10),
    sexo VARCHAR(20),
    telefone VARCHAR(20),
    quarto_leito VARCHAR(50),
    queixa_principal TEXT,
    observacoes TEXT,
    tipo_avc VARCHAR(50)
);
