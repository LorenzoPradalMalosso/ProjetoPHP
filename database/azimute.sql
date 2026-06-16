-- Script de estrutura e dados iniciais do Azimute.
-- Crie o banco antes de executar este arquivo:
-- createdb azimute

CREATE TABLE IF NOT EXISTS ramos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    idade_min INT NOT NULL,
    idade_max INT NOT NULL,
    descricao TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    categoria VARCHAR(30) NOT NULL,
    data_integracao VARCHAR(10) NOT NULL,
    data_nascimento VARCHAR(10) NOT NULL,
    ramo_id INTEGER REFERENCES ramos(id)
);

CREATE TABLE IF NOT EXISTS ramosconhecimento (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    descricao TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS especialidades (
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
        REFERENCES ramosconhecimento(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS usuarioespecialidades (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id),
    especialidade_id INTEGER REFERENCES especialidades(id),
    data_conquista VARCHAR(10) NOT NULL,
    itens_concluidos INT[] NOT NULL DEFAULT '{}',
    nivel INT NOT NULL CHECK (nivel BETWEEN 1 AND 3),
    CONSTRAINT uk_usuario_especialidade
        UNIQUE (usuario_id, especialidade_id)
);

CREATE TABLE IF NOT EXISTS progressoes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    descricao TEXT NOT NULL,
    ramo_id INTEGER REFERENCES ramos(id)
);

CREATE TABLE IF NOT EXISTS usuarioprogressoes (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id),
    progressao_id INTEGER REFERENCES progressoes(id),
    status VARCHAR(30) NOT NULL DEFAULT 'pendente',
    data_conclusao VARCHAR(10) NOT NULL,
    CONSTRAINT chk_status
        CHECK (status IN ('pendente', 'concluída', 'rejeitada'))
);

INSERT INTO ramos (id, nome, idade_min, idade_max, descricao) VALUES
    (1, 'Ramo Lobinho', 6, 10, 'Destinado a crianças de 6,5 a 10 anos, com atividades voltadas ao desenvolvimento pessoal por meio do ambiente da Jângal.'),
    (2, 'Ramo Escoteiro', 11, 14, 'Destinado a jovens de 11 a 14 anos, focado em vida ao ar livre, trabalho em equipe e sistema de patrulhas.'),
    (3, 'Ramo Sênior', 15, 17, 'Destinado a adolescentes de 15 a 17 anos, incentivando autonomia, liderança e superação de desafios.'),
    (4, 'Ramo Pioneiro', 18, 21, '	Destinado a jovens de 18 a 21 anos, com foco em projetos, serviço à comunidade e desenvolvimento da cidadania.')
ON CONFLICT (id) DO UPDATE SET
    nome = EXCLUDED.nome,
    idade_min = EXCLUDED.idade_min,
    idade_max = EXCLUDED.idade_max,
    descricao = EXCLUDED.descricao;

INSERT INTO ramosconhecimento (id, nome, descricao) VALUES
    (1, 'Ciência e Tecnologia', 'Desenvolve o interesse pela pesquisa, inovação e compreensão do funcionamento do mundo, estimulando o raciocínio lógico, a criatividade e o uso responsável da tecnologia.'),
    (2, 'Cultura', 'Incentiva a valorização das artes, da história, das tradições e da diversidade cultural, promovendo o respeito e o conhecimento sobre diferentes povos e costumes.'),
    (3, 'Desportos', 'Estimula a prática de atividades físicas e esportivas, contribuindo para a saúde, o trabalho em equipe, a disciplina e o espírito de superação.'),
    (4, 'Habilidades Escoteiras', 'Reúne conhecimentos e técnicas próprias do escotismo, como orientação, pioneiria, campismo e sobrevivência, fortalecendo a autonomia.'),
    (5, 'Serviços', 'Promove a solidariedade, a cidadania e o compromisso com a comunidade, incentivando ações de voluntariado e o desenvolvimento do espírito de servir ao próximo.')
ON CONFLICT (id) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao;

INSERT INTO progressoes (id, nome, descricao, ramo_id) VALUES
    (1, 'Lobo Pata-Tenra', 'Primeira etapa da progressão do Ramo Lobinho, voltada para a integração à alcateia, ao conhecimento da Lei e Promessa do Lobinho e dos símbolos do Movimento Escoteiro.', 1),
    (2, 'Lobo Saltador', 'Etapa em que o lobinho amplia suas descobertas, desenvolvendo autonomia, convivência em grupo e habilidades básicas por meio das atividades da progressão pessoal.', 1),
    (3, 'Lobo Rastreador', 'Fase que incentiva a consolidação dos conhecimentos e competências adquiridos, estimulando a curiosidade, a observação e o compromisso com a vida em alcateia.', 1),
    (4, 'Lobo Caçador', 'Última etapa do desenvolvimento no Ramo Lobinho, marcada pelo aprofundamento das habilidades, participação ativa na alcateia e preparação para novos desafios no Movimento Escoteiro.', 1),
    (5, 'Pista', 'Primeira etapa da progressão do Ramo Escoteiro, destinada à adaptação à vida em patrulha, ao entendimento dos valores escoteiros e ao desenvolvimento das primeiras habilidades.', 2),
    (6, 'Trilha', 'Etapa que estimula o escoteiro a explorar novos conhecimentos, fortalecer o trabalho em equipe e ampliar sua autonomia por meio das atividades e desafios da tropa.', 2),
    (7, 'Rumo', 'Fase voltada ao aperfeiçoamento das competências pessoais, à liderança e ao protagonismo juvenil, incentivando a participação ativa na patrulha e na comunidade.', 2),
    (8, 'Travessia', 'Última etapa da progressão do Ramo Escoteiro, em que o jovem demonstra maturidade, espírito de serviço e preparo para a passagem ao Ramo Sênior.', 2),
    (9, 'Escalada', 'Primeira etapa da progressão do Ramo Sênior, focada na integração à tropa, no fortalecimento da autonomia e na superação de desafios pessoais e coletivos.', 3),
    (10, 'Conquista', 'Etapa intermediária do Ramo Sênior que incentiva o desenvolvimento da liderança, da responsabilidade e do planejamento de projetos e atividades.', 3),
    (11, 'Azimute', 'Etapa final do Ramo Sênior, caracterizada pela consolidação das competências adquiridas, pelo protagonismo juvenil e pela preparação para o Ramo Pioneiro.', 3),
    (12, 'Insígnia do Comprometimento', 'Reconhecimento concedido ao jovem do Ramo Pioneiro que demonstra dedicação, responsabilidade e compromisso contínuo com seus objetivos pessoais e com os valores escoteiros.', 4),
    (13, 'Insígnia da Cidadania', 'Reconhecimento do Ramo Pioneiro destinado ao jovem que participa ativamente da comunidade, exercendo a cidadania, o serviço voluntário e a transformação social.', 4);
ON CONFLICT (id) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    ramo_id = EXCLUDED.ramo_id;

INSERT INTO especialidades (
    id,
    nome,
    descricao,
    itens,
    quantidade_itens,
    nota_tecnica,
    ramo_conhecimento_id
) VALUES
    (1, 'Astronomia', 'Estudo dos astros, planetas, estrelas, constelações e fenômenos celestes.', ARRAY['Identificar os planetas do Sistema Solar', 'Explicar a diferença entre planeta, estrela e satélite natural', 'Reconhecer constelações no céu', 'Realizar uma observação astronômica', 'Apresentar uma pesquisa sobre exploração espacial'], 5, 'Especialidade voltada à observação e compreensão básica do universo.', 1),
    (2, 'Informática', 'Uso responsável de computadores, sistemas e ferramentas digitais.', ARRAY['Identificar componentes básicos do computador', 'Criar um documento organizado', 'Explicar cuidados com segurança digital', 'Usar armazenamento em nuvem', 'Apresentar uma solução digital simples'], 5, 'Valoriza o uso consciente da tecnologia.', 1),
    (3, 'Robótica', 'Construção e programação de mecanismos simples.', ARRAY['Explicar sensores e atuadores', 'Montar um protótipo simples', 'Programar uma sequência de ações', 'Testar melhorias no protótipo', 'Apresentar o funcionamento do projeto'], 5, 'Pode ser realizada com kits educacionais ou materiais alternativos.', 1),
    (4, 'Meteorologia', 'Observação do clima, tempo e fenômenos atmosféricos.', ARRAY['Diferenciar clima e tempo', 'Registrar variações por uma semana', 'Identificar tipos de nuvens', 'Explicar instrumentos meteorológicos', 'Apresentar uma previsão simples'], 5, 'Estimula observação e registro de dados.', 1),
    (5, 'Química', 'Conhecimentos básicos sobre substâncias, misturas e transformações.', ARRAY['Explicar mistura e solução', 'Realizar experimento seguro', 'Identificar símbolos de segurança', 'Registrar resultados', 'Apresentar conclusão do experimento'], 5, 'Experimentos devem ser seguros e supervisionados.', 1),
    (6, 'Física', 'Noções práticas de força, movimento, energia e máquinas simples.', ARRAY['Explicar uma máquina simples', 'Demonstrar transformação de energia', 'Registrar medidas de um experimento', 'Relacionar física ao cotidiano', 'Apresentar resultados'], 5, 'Prioriza demonstrações práticas.', 1),
    (7, 'Biologia', 'Estudo dos seres vivos e suas relações com o ambiente.', ARRAY['Classificar seres vivos observados', 'Explicar cadeia alimentar', 'Registrar uma observação de campo', 'Identificar cuidados ambientais', 'Apresentar relatório simples'], 5, 'Pode ser feita em trilhas, parques ou jardins.', 1),
    (8, 'Eletrônica', 'Montagem e compreensão de circuitos elétricos simples.', ARRAY['Identificar componentes básicos', 'Montar circuito simples', 'Explicar tensão e corrente', 'Usar pilhas com segurança', 'Apresentar aplicação prática'], 5, 'Usar somente baixa tensão.', 1),
    (9, 'Programação', 'Criação de algoritmos e pequenos programas.', ARRAY['Explicar algoritmo', 'Criar programa simples', 'Usar condição ou repetição', 'Testar e corrigir erro', 'Apresentar o código funcionando'], 5, 'Pode ser feita em qualquer linguagem acessível.', 1),
    (10, 'Energia Sustentável', 'Estudo de fontes renováveis e uso consciente de energia.', ARRAY['Listar fontes renováveis', 'Comparar consumo de equipamentos', 'Propor economia de energia', 'Montar demonstração simples', 'Apresentar plano de melhoria'], 5, 'Relaciona tecnologia e sustentabilidade.', 1),
    (11, 'Cultura Brasileira', 'Conhecimento sobre manifestações culturais, história e diversidade brasileira.', ARRAY['Pesquisar manifestação cultural', 'Apresentar pesquisa', 'Registrar aprendizado', 'Comparar costumes regionais', 'Participar de atividade cultural'], 5, 'Valoriza a diversidade cultural do país.', 2),
    (12, 'História do Escotismo', 'Estudo da origem, valores e desenvolvimento do Movimento Escoteiro.', ARRAY['Pesquisar Baden-Powell', 'Explicar a promessa e a lei', 'Apresentar marcos históricos', 'Relacionar história ao grupo local', 'Registrar fontes consultadas'], 5, 'Ajuda a compreender a identidade escoteira.', 2),
    (13, 'Música', 'Prática musical, ritmo e expressão artística.', ARRAY['Identificar estilos musicais', 'Executar música simples', 'Explicar ritmo e melodia', 'Participar de apresentação', 'Registrar repertório aprendido'], 5, 'Pode envolver canto ou instrumento.', 2),
    (14, 'Teatro', 'Expressão corporal, interpretação e criação de cenas.', ARRAY['Preparar cena curta', 'Criar personagem', 'Trabalhar voz e expressão', 'Ensaiar em grupo', 'Apresentar ao público'], 5, 'Estimula comunicação e criatividade.', 2),
    (15, 'Fotografia', 'Registro visual, composição e narrativa por imagens.', ARRAY['Explicar enquadramento', 'Produzir série fotográfica', 'Organizar seleção de imagens', 'Respeitar autorização de imagem', 'Apresentar o ensaio'], 5, 'Pode usar celular ou câmera.', 2),
    (16, 'Artes Visuais', 'Criação artística usando técnicas visuais diversas.', ARRAY['Conhecer técnica artística', 'Produzir peça autoral', 'Explicar materiais usados', 'Organizar exposição simples', 'Registrar processo criativo'], 5, 'Valoriza expressão e processo.', 2),
    (17, 'Leitura', 'Desenvolvimento de hábito leitor e interpretação de textos.', ARRAY['Ler obra escolhida', 'Fazer resumo', 'Apresentar opinião', 'Relacionar tema ao cotidiano', 'Indicar leitura ao grupo'], 5, 'Pode envolver literatura, poesia ou texto informativo.', 2),
    (18, 'Idiomas', 'Contato com língua estrangeira e comunicação básica.', ARRAY['Aprender saudações', 'Montar vocabulário temático', 'Traduzir texto curto', 'Praticar diálogo simples', 'Apresentar cultura relacionada'], 5, 'Foco em comunicação prática.', 2),
    (19, 'Patrimônio Histórico', 'Reconhecimento e preservação de espaços e memórias locais.', ARRAY['Pesquisar patrimônio local', 'Visitar ou documentar local', 'Registrar importância histórica', 'Propor ação de preservação', 'Apresentar relatório'], 5, 'Conecta cultura e cidadania.', 2),
    (20, 'Dança', 'Expressão corporal, ritmo e cultura por meio da dança.', ARRAY['Pesquisar estilo de dança', 'Aprender passos básicos', 'Ensaiar sequência', 'Apresentar em grupo', 'Explicar origem cultural'], 5, 'Pode ser individual ou coletiva.', 2),
    (21, 'Atletismo', 'Prática de corrida, saltos e arremessos com segurança.', ARRAY['Conhecer modalidades', 'Praticar aquecimento', 'Registrar desempenho', 'Explicar regras básicas', 'Participar de atividade'], 5, 'Prioriza saúde e superação pessoal.', 3),
    (22, 'Natação', 'Desenvolvimento de segurança e técnicas básicas na água.', ARRAY['Explicar regras de segurança', 'Demonstrar flutuação', 'Praticar deslocamento', 'Conhecer sinais de risco', 'Registrar evolução'], 5, 'Deve ocorrer em local seguro e supervisionado.', 3),
    (23, 'Ciclismo', 'Uso seguro da bicicleta e noções de manutenção.', ARRAY['Identificar equipamentos de segurança', 'Revisar bicicleta', 'Planejar trajeto', 'Pedalar em percurso seguro', 'Explicar regras de trânsito'], 5, 'Foco em segurança e mobilidade.', 3),
    (24, 'Futebol', 'Prática esportiva coletiva, regras e espírito de equipe.', ARRAY['Explicar regras básicas', 'Participar de treino', 'Praticar fundamentos', 'Atuar em equipe', 'Refletir sobre fair play'], 5, 'Valoriza cooperação.', 3),
    (25, 'Voleibol', 'Prática de fundamentos e regras do voleibol.', ARRAY['Explicar regras básicas', 'Praticar saque', 'Praticar manchete', 'Participar de jogo', 'Avaliar trabalho em equipe'], 5, 'Pode ser adaptado ao espaço disponível.', 3),
    (26, 'Basquete', 'Prática de fundamentos e estratégia básica do basquete.', ARRAY['Explicar regras básicas', 'Praticar arremesso', 'Praticar passe', 'Participar de jogo', 'Demonstrar espírito esportivo'], 5, 'Estimula coordenação e equipe.', 3),
    (27, 'Xadrez', 'Raciocínio estratégico e prática do jogo de xadrez.', ARRAY['Identificar peças', 'Explicar movimentos', 'Resolver problema simples', 'Jogar partida', 'Analisar jogada'], 5, 'Trabalha concentração e estratégia.', 3),
    (28, 'Corrida de Orientação', 'Atividade esportiva com mapa, percurso e tomada de decisão.', ARRAY['Ler mapa simples', 'Identificar pontos de controle', 'Planejar rota', 'Completar percurso', 'Avaliar decisões'], 5, 'Integra esporte e orientação.', 3),
    (29, 'Artes Marciais', 'Prática disciplinada de técnicas corporais e respeito.', ARRAY['Conhecer regras de segurança', 'Aprender fundamentos', 'Explicar filosofia da modalidade', 'Participar de treino', 'Demonstrar respeito ao colega'], 5, 'Deve ser supervisionada por pessoa capacitada.', 3),
    (30, 'Escalada Esportiva', 'Noções de escalada, equipamentos e segurança.', ARRAY['Conhecer equipamentos', 'Explicar segurança', 'Praticar técnica básica', 'Realizar atividade supervisionada', 'Registrar aprendizados'], 5, 'Somente em ambiente próprio e seguro.', 3),
    (31, 'Acampamento', 'Habilidades de organização, montagem e cuidados em atividades ao ar livre.', ARRAY['Organizar mochila', 'Montar barraca', 'Cuidar do local', 'Planejar rotina de acampamento', 'Avaliar boas práticas'], 5, 'Base para autonomia em campo.', 4),
    (32, 'Orientação', 'Uso de mapa, bússola e referências naturais para deslocamento seguro.', ARRAY['Ler mapa', 'Usar bússola', 'Traçar rota simples', 'Identificar referências naturais', 'Orientar pequeno percurso'], 5, 'Essencial para atividades externas.', 4),
    (33, 'Pioneiria', 'Construção de estruturas simples com nós, amarras e planejamento.', ARRAY['Conhecer amarras básicas', 'Planejar estrutura', 'Selecionar materiais', 'Montar projeto seguro', 'Avaliar estabilidade'], 5, 'Prioriza segurança e técnica.', 4),
    (34, 'Nós e Amarras', 'Aprendizado de nós úteis e suas aplicações.', ARRAY['Fazer nó direito', 'Fazer volta do fiel', 'Fazer lais de guia', 'Aplicar amarra quadrada', 'Explicar usos práticos'], 5, 'Técnica fundamental do escotismo.', 4),
    (35, 'Fogo de Conselho', 'Preparação e condução de momentos culturais escoteiros.', ARRAY['Planejar apresentação', 'Preparar canção ou esquete', 'Organizar sequência', 'Participar da condução', 'Avaliar participação'], 5, 'Valoriza tradição e expressão.', 4),
    (36, 'Cozinha Mateira', 'Preparo de refeições simples em atividades ao ar livre.', ARRAY['Planejar cardápio', 'Organizar ingredientes', 'Preparar alimento com segurança', 'Cuidar da higiene', 'Avaliar resultado'], 5, 'Deve seguir cuidados alimentares.', 4),
    (37, 'Sobrevivência', 'Noções básicas de abrigo, água, sinalização e segurança.', ARRAY['Montar abrigo simples', 'Identificar prioridades', 'Explicar obtenção segura de água', 'Criar sinalização', 'Simular situação controlada'], 5, 'Atividade sempre supervisionada.', 4),
    (38, 'Rastreamento', 'Observação de pistas, pegadas e sinais no ambiente.', ARRAY['Identificar sinais naturais', 'Registrar pistas', 'Seguir trilha curta', 'Diferenciar marcas humanas e naturais', 'Apresentar observações'], 5, 'Estimula atenção ao ambiente.', 4),
    (39, 'Sinalização', 'Comunicação por sinais visuais, sonoros ou códigos simples.', ARRAY['Conhecer sinais básicos', 'Usar código simples', 'Transmitir mensagem curta', 'Receber mensagem', 'Avaliar clareza'], 5, 'Pode incluir semáfora, apito ou códigos.', 4),
    (40, 'Cartografia', 'Leitura e produção de mapas simples.', ARRAY['Identificar legenda', 'Entender escala', 'Desenhar croqui', 'Marcar pontos importantes', 'Apresentar mapa produzido'], 5, 'Relacionada à orientação.', 4),
    (41, 'Ferramentas', 'Uso seguro e manutenção de ferramentas simples.', ARRAY['Identificar ferramenta adequada', 'Explicar segurança', 'Demonstrar uso correto', 'Guardar e limpar material', 'Apresentar cuidados'], 5, 'Sempre com supervisão.', 4),
    (42, 'Camping Sustentável', 'Práticas para reduzir impacto ambiental em acampamentos.', ARRAY['Planejar redução de resíduos', 'Cuidar da água', 'Organizar descarte correto', 'Preservar trilhas', 'Avaliar impacto da atividade'], 5, 'Integra campo e sustentabilidade.', 4),
    (43, 'Segurança em Atividades', 'Prevenção de riscos em atividades escoteiras.', ARRAY['Identificar riscos', 'Montar plano simples', 'Explicar condutas seguras', 'Conhecer contatos de emergência', 'Avaliar uma atividade'], 5, 'Fortalece responsabilidade coletiva.', 4),
    (44, 'Primeiros Socorros', 'Conhecimentos básicos para agir com segurança em situações simples de emergência.', ARRAY['Montar um kit simples', 'Conhecer sinais vitais', 'Simular atendimento básico', 'Explicar acionamento de ajuda', 'Registrar cuidados essenciais'], 5, 'Não substitui atendimento profissional.', 5),
    (45, 'Meio Ambiente', 'Práticas de cuidado com a natureza e redução de impactos ambientais.', ARRAY['Separar resíduos', 'Explicar impacto ambiental', 'Participar de ação ecológica', 'Registrar espécies observadas', 'Propor melhoria local'], 5, 'Promove responsabilidade ambiental.', 5),
    (46, 'Voluntariado', 'Participação responsável em ações de serviço comunitário.', ARRAY['Identificar necessidade local', 'Participar de ação', 'Registrar horas de serviço', 'Avaliar impacto', 'Apresentar aprendizado'], 5, 'Valoriza serviço ao próximo.', 5),
    (47, 'Defesa Civil', 'Noções de prevenção, resposta e cuidado em emergências comunitárias.', ARRAY['Conhecer riscos locais', 'Montar plano familiar simples', 'Identificar canais oficiais', 'Explicar prevenção', 'Participar de simulação'], 5, 'Usar orientações oficiais.', 5),
    (48, 'Comunicação Comunitária', 'Divulgação clara e responsável de informações para a comunidade.', ARRAY['Identificar público', 'Criar mensagem clara', 'Escolher canal adequado', 'Divulgar informação útil', 'Avaliar alcance'], 5, 'Foco em comunicação ética.', 5),
    (49, 'Saúde e Higiene', 'Cuidados pessoais e coletivos para prevenção de doenças.', ARRAY['Explicar higiene das mãos', 'Montar rotina de cuidados', 'Identificar hábitos saudáveis', 'Preparar orientação simples', 'Compartilhar aprendizado'], 5, 'Valoriza prevenção.', 5),
    (50, 'Inclusão', 'Ações de respeito, acessibilidade e convivência com diferenças.', ARRAY['Pesquisar acessibilidade', 'Identificar barreira local', 'Propor adaptação', 'Participar de ação inclusiva', 'Apresentar reflexão'], 5, 'Estimula empatia e respeito.', 5),
    (51, 'Cidadania', 'Participação social, direitos, deveres e vida comunitária.', ARRAY['Explicar direitos e deveres', 'Conhecer serviço público local', 'Participar de ação cidadã', 'Registrar aprendizado', 'Apresentar proposta de melhoria'], 5, 'Conecta escotismo e comunidade.', 5),
    (52, 'Cuidados com Animais', 'Bem-estar animal e responsabilidade no convívio com animais.', ARRAY['Explicar necessidades básicas', 'Conhecer vacinação e cuidados', 'Participar de ação responsável', 'Identificar maus-tratos', 'Apresentar orientação'], 5, 'Foco em cuidado responsável.', 5),
    (53, 'Reciclagem', 'Separação, reaproveitamento e destinação correta de resíduos.', ARRAY['Identificar tipos de resíduos', 'Separar materiais', 'Criar objeto reaproveitado', 'Explicar coleta seletiva', 'Organizar ação educativa'], 5, 'Relaciona serviço e meio ambiente.', 5)
ON CONFLICT (id) DO UPDATE SET
    nome = EXCLUDED.nome,
    descricao = EXCLUDED.descricao,
    itens = EXCLUDED.itens,
    quantidade_itens = EXCLUDED.quantidade_itens,
    nota_tecnica = EXCLUDED.nota_tecnica,
    ramo_conhecimento_id = EXCLUDED.ramo_conhecimento_id;

SELECT setval('ramos_id_seq', COALESCE((SELECT MAX(id) FROM ramos), 1));
SELECT setval('ramosconhecimento_id_seq', COALESCE((SELECT MAX(id) FROM ramosconhecimento), 1));
SELECT setval('progressoes_id_seq', COALESCE((SELECT MAX(id) FROM progressoes), 1));
SELECT setval('especialidades_id_seq', COALESCE((SELECT MAX(id) FROM especialidades), 1));
