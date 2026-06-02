CREATE DATABASE azimute;

CREATE TABLE ramos(
    id SERIAL PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    idade_min INT NOT NULL,
    idade_max INT NOT NULL,
    descricao TEXT NOT NULL
);

SELECT * FROM ramos;

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    categoria VARCHAR(30) NOT NULL,
    data_integracao VARCHAR(10) NOT NULL,
    data_nascimento VARCHAR(10) NOT NULL,

    ramo_id INTEGER REFERENCES ramos(id)
);

SELECT * FROM usuarios;

CREATE TABLE ramosConhecimento (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    descricao TEXT NOT NULL
);

SELECT * FROM ramosConhecimento;

CREATE TABLE especialidades (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL,

    ramoConhecimento_id INTEGER REFERENCES ramosConhecimento(id)
);

SELECT * FROM especialidades;

CREATE TABLE usuarioEspecialidades (
    id SERIAL PRIMARY KEY,

    usuario_id INTEGER REFERENCES usuarios(id),

    especialidade_id INTEGER REFERENCES especialidades(id),

    data_conquista VARCHAR(10) NOT NULL,
    itens TEXT[] NOT NULL,
    nivel INT NOT NULL,
    CHECK (nivel BETWEEN 1 AND 3)
);

SELECT * FROM usuarioEspecialidades;

CREATE TABLE progressoes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    descricao TEXT NOT NULL,

    ramo_id INTEGER REFERENCES ramos(id)
);

SELECT * FROM progressoes;

CREATE TABLE usuarioProgressoes (
    id SERIAL PRIMARY KEY,

    usuario_id INTEGER REFERENCES usuarios(id),

    progressao_id INTEGER REFERENCES progressoes(id),

    status VARCHAR(30) NOT NULL DEFAULT 'pendente',
    CONSTRAINT chk_status
    CHECK (status IN ('pendente', 'concluída', 'rejeitada')),
    data_conclusao VARCHAR(10) NOT NULL
);

SELECT * FROM usuarioProgressoes;