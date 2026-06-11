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
    itens TEXT[] NOT NULL,
    quantidade_itens INTEGER NOT NULL CHECK (quantidade_itens > 0),

    data_versao DATE DEFAULT CURRENT_DATE,
    nota_tecnica TEXT,

    ramo_conhecimento_id INTEGER NOT NULL,
    CONSTRAINT fk_ramo_conhecimento
        FOREIGN KEY (ramo_conhecimento_id)
        REFERENCES ramosConhecimento(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

SELECT * FROM especialidades;

CREATE TABLE usuarioEspecialidades (
    id SERIAL PRIMARY KEY,

    usuario_id INTEGER REFERENCES usuarios(id),

    especialidade_id INTEGER REFERENCES especialidades(id),

    data_conquista VARCHAR(10) NOT NULL,
    itens_concluidos INT[] NOT NULL DEFAULT '{}',
    nivel INT NOT NULL
        CHECK (nivel BETWEEN 1 AND 3),
    CONSTRAINT uk_usuario_especialidade
        UNIQUE (usuario_id, especialidade_id)
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

-- Inserção de dados
INSERT INTO ramosconhecimento (id, nome, descricao) VALUES
    (1, 'Ciência e Tecnologia', 'Desenvolve o interesse pela pesquisa, inovação e compreensão do funcionamento do mundo, estimulando o raciocínio lógico, a criatividade e o uso responsável da tecnologia.'),
    (2, 'Cultura', 'Incentiva a valorização das artes, da história, das tradições e da diversidade cultural, promovendo o respeito e o conhecimento sobre diferentes povos e costumes.'),
    (3, 'Desportos', 'Estimula a prática de atividades físicas e esportivas, contribuindo para a saúde, o trabalho em equipe, a disciplina e o espírito de superação.'),
    (4, 'Habilidades Escoteiras', 'Reúne conhecimentos e técnicas próprias do escotismo, como orientação, pioneiria, campismo e sobrevivência, fortalecendo a autonomia.'),
    (5, 'Serviços', 'Promove a solidariedade, a cidadania e o compromisso com a comunidade, incentivando ações de voluntariado e o desenvolvimento do espírito de servir ao próximo.');

SELECT * FROM ramosconhecimento;

-- Inserção de especialidades é muito longa, por isso não coloquei aqui. Vale ressaltar que cadastrei apenas 10 de cada ramo de conhecimento, com exceção do ramo 4, que coloquei 13 (todas)

SELECT * FROM especialidades;