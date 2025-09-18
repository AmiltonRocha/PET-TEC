CREATE DATABASE HGF;
USE hospital;

CREATE TABLE paciente (
    nome VARCHAR(150) NOT NULL,
    cpf CHAR(11) PRIMARY KEY NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    sexo ENUM('Masculino', 'Feminino') NOT NULL,
    telefone VARCHAR(20),
    quarto_leito VARCHAR(20),
    queixa_principal TEXT,
    observacoes TEXT,
    tipo_avc ENUM('Isquêmico', 'Hemorrágico')
);
