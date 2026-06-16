--
-- PostgreSQL database dump
--

\restrict fARaglHcpICLbJpWDvzdjPJL8YeesYNrXtpu67NNp3bRc0jCpYwkfQRZsLWWIfw

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: especialidades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.especialidades (
    id integer NOT NULL,
    nome character varying(255) NOT NULL,
    descricao text NOT NULL,
    itens text[] NOT NULL,
    quantidade_itens integer NOT NULL,
    data_versao date DEFAULT CURRENT_DATE,
    nota_tecnica text,
    ramo_conhecimento_id integer NOT NULL,
    CONSTRAINT especialidades_quantidade_itens_check CHECK ((quantidade_itens > 0))
);


ALTER TABLE public.especialidades OWNER TO postgres;

--
-- Name: especialidades_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.especialidades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.especialidades_id_seq OWNER TO postgres;

--
-- Name: especialidades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.especialidades_id_seq OWNED BY public.especialidades.id;


--
-- Name: progressoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.progressoes (
    id integer NOT NULL,
    nome character varying(30) NOT NULL,
    descricao text NOT NULL,
    ramo_id integer
);


ALTER TABLE public.progressoes OWNER TO postgres;

--
-- Name: progressoes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.progressoes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.progressoes_id_seq OWNER TO postgres;

--
-- Name: progressoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.progressoes_id_seq OWNED BY public.progressoes.id;


--
-- Name: ramos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ramos (
    id integer NOT NULL,
    nome character varying(30) NOT NULL,
    idade_min integer NOT NULL,
    idade_max integer NOT NULL,
    descricao text NOT NULL
);


ALTER TABLE public.ramos OWNER TO postgres;

--
-- Name: ramos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ramos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ramos_id_seq OWNER TO postgres;

--
-- Name: ramos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ramos_id_seq OWNED BY public.ramos.id;


--
-- Name: ramosconhecimento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ramosconhecimento (
    id integer NOT NULL,
    nome character varying(30) NOT NULL,
    descricao text NOT NULL
);


ALTER TABLE public.ramosconhecimento OWNER TO postgres;

--
-- Name: ramosconhecimento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ramosconhecimento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ramosconhecimento_id_seq OWNER TO postgres;

--
-- Name: ramosconhecimento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ramosconhecimento_id_seq OWNED BY public.ramosconhecimento.id;


--
-- Name: usuarioespecialidades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarioespecialidades (
    id integer NOT NULL,
    usuario_id integer,
    especialidade_id integer,
    data_conquista character varying(10) NOT NULL,
    itens_concluidos integer[] DEFAULT '{}'::integer[] NOT NULL,
    nivel integer NOT NULL,
    CONSTRAINT usuarioespecialidades_nivel_check CHECK (((nivel >= 1) AND (nivel <= 3)))
);


ALTER TABLE public.usuarioespecialidades OWNER TO postgres;

--
-- Name: usuarioespecialidades_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarioespecialidades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarioespecialidades_id_seq OWNER TO postgres;

--
-- Name: usuarioespecialidades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarioespecialidades_id_seq OWNED BY public.usuarioespecialidades.id;


--
-- Name: usuarioprogressoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarioprogressoes (
    id integer NOT NULL,
    usuario_id integer,
    progressao_id integer,
    status character varying(30) DEFAULT 'pendente'::character varying NOT NULL,
    data_conclusao character varying(10) NOT NULL,
    CONSTRAINT chk_status CHECK (((status)::text = ANY ((ARRAY['pendente'::character varying, 'concluída'::character varying, 'rejeitada'::character varying])::text[])))
);


ALTER TABLE public.usuarioprogressoes OWNER TO postgres;

--
-- Name: usuarioprogressoes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarioprogressoes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarioprogressoes_id_seq OWNER TO postgres;

--
-- Name: usuarioprogressoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarioprogressoes_id_seq OWNED BY public.usuarioprogressoes.id;


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    nome character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    senha character varying(255) NOT NULL,
    categoria character varying(30) NOT NULL,
    data_integracao character varying(10) NOT NULL,
    data_nascimento character varying(10) NOT NULL,
    ramo_id integer
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_seq OWNER TO postgres;

--
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- Name: especialidades id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialidades ALTER COLUMN id SET DEFAULT nextval('public.especialidades_id_seq'::regclass);


--
-- Name: progressoes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progressoes ALTER COLUMN id SET DEFAULT nextval('public.progressoes_id_seq'::regclass);


--
-- Name: ramos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ramos ALTER COLUMN id SET DEFAULT nextval('public.ramos_id_seq'::regclass);


--
-- Name: ramosconhecimento id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ramosconhecimento ALTER COLUMN id SET DEFAULT nextval('public.ramosconhecimento_id_seq'::regclass);


--
-- Name: usuarioespecialidades id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarioespecialidades ALTER COLUMN id SET DEFAULT nextval('public.usuarioespecialidades_id_seq'::regclass);


--
-- Name: usuarioprogressoes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarioprogressoes ALTER COLUMN id SET DEFAULT nextval('public.usuarioprogressoes_id_seq'::regclass);


--
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- Data for Name: especialidades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.especialidades (id, nome, descricao, itens, quantidade_itens, data_versao, nota_tecnica, ramo_conhecimento_id) FROM stdin;
1	Aeromodelismo	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Demonstrar quais os materiais e ferramentas empregados na construção de 1 (um) aeromodelo e como deve ser a técnica utilizada.","Construir 1 (um) planador lançado à mão que voe pelo menos 5 (cinco) segundos.","Conhecer os principais tipos de sistemas de propulsão utilizados em aeromodelismo, expondo suas vantagens e desvantagens e os respectivos cuidados, relativos à segurança, em sua utilização.","Construir um modelo a elástico que voe pelo menos 7 (sete) segundos.","Operar um modelo U-Control (voo circular) ou R- Control (rádio controlado) com segurança e precisão, demonstrando as manobras básicas de decolagem, aterrissagem, voo reto e nivelado, rasante sobre a pista, loop e tonneau para o caso do R-Control e decolagem, aterrissagem, voo reto e nivelado, wing over, loop e voo a 45 graus para a modalidade U-control.","Participar de pelo menos 1 (um) torneio de aeromodelismo.","Construir um avião em dobradura de papel e fazê-lo voar.","Construir uma réplica em escala de uma aeronave importante para a história, utilizando técnicas de dobradura e colagem de papel.","Montar um modelo simples que reproduza os principais componentes da estrutura interna das asas, ou da fuselagem, ou da empenagem de uma aeronave de pequeno porte utilizando apenas material reaproveitado e explicar a sua tropa o funcionamento da estrutura em questão, seu centro de gravidade e quais as forças de atuação durante o voo."}	9	2022-05-01	O item 5 item poderá ser demonstrado através de um simulador de computador, celular ou videogame.	1
2	Anatomia Humana	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Conhecer a estrutura geral de uma célula humana e criar uma maquete ou modelo com massa de modelar, incluindo seus principais componentes.","Explicar a relação entre as células, os tecidos, os órgãos, os sistemas e o corpo humano.","Apresentar uma pesquisa sobre uma doença escolhida pelo seu examinador, que possa afetar 1 (um) dos sistemas do corpo humano, nomeando as estruturas que podem ser afetadas.","Citar os componentes do sistema respiratório, e apresentar os malefícios que o ar poluído pode ocasionar a este sistema.","Conhecer as estruturas do sistema digestório e apresentar como funciona o processo de digestão dos alimentos e onde os diferentes nutrientes são absorvidos.","Apresentar as classes de nutrientes alimentares e a importância de uma alimentação balanceada para o corpo humano.","Apresentar como é composto o sistema músculo-esquelético e a importância de praticar atividades físicas regularmente.","Conhecer a estrutura e os componentes do aparelho circulatório, nomear as partes do coração, diferenciar as artérias e as veias e saber a localização das principais artérias do organismo.","Conhecer os neurônios envolvidos no processo de percepção da dor e explicar como ocorre o reflexo de retirada da mão de uma superfície quente.","Apresentar as diferenças entre 1 (um) embrião e 1 (um) feto, buscando fotos que ilustrem os diferentes momentos da gestação.","Montar 1 (um) panfleto contendo informações sobre como o cigarro pode fazer mal à saúde, que estruturas do corpo humano podem ser afetadas, e distribuir cópias na sua escola, comunidade ou Grupo Escoteiro.","Conhecer as principais estruturas do aparelho urinário do homem e da mulher, e explicar como a água ingerida pela boca pode ser eliminada do organismo.","Citar os principais estudiosos de anatomia humana e expor, em seu Grupo Escoteiro, desenhos de partes do corpo humano, nomeando cada uma delas.","Fazer uma pesquisa sobre como eram realizadas as primeiras dissecções de cadáveres para o estudo da anatomia humana.","Dissecar uma peça de frango mostrando quais estruturas do corpo é possível reconhecer e nomear cada uma delas."}	15	\N	\N	1
3	Animais Peçonhentos	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Diferenciar e exemplificar animais peçonhentos e venenosos citando os tipos de peçonha.","Identificar pelo menos 3 (três) animais peçonhentos e venenosos de sua região.","Identificar pelo menos 3 (três) animais peçonhentos ou venenosos aquáticos.","Apresentar as características que indicam se as cobras são peçonhentas ou não, ilustrando exemplos que seguem e exemplos que não seguem esses parâmetros.","Apresentar as espécies de escorpiões mais importantes no Brasil, exemplificando e mostrando fotos, imagens ou vídeos.","Identificar, por meio de imagens, pelo menos 5 (cinco) espécies de aranhas venenosas encontradas no Brasil, explicando suas particularidades.","Demonstrar como identificar os sintomas e os procedimentos corretos após 1 (um) acidente com animais peçonhentos de pelo menos 5 (cinco) espécies diferentes, explicando as diferenças em cada caso, tendo pelo menos 1 (um) exemplar de cada um dos seguintes: cobras, escorpiões, aranhas e insetos.","Pesquisar sobre as leis ambientais e o impacto ambiental ao lidar com animais peçonhentos ou venenosos.","Demonstrar como prevenir ataques e evitar acidentes com animais peçonhentos."}	9	\N	\N	1
4	Aquariofilia	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Listar os componentes de 1 (um) aquário e descrever o processo de sua montagem.","Explicar a diferença entre termostato e termômetro.","Citar os diferentes tipos de filtros e oxigenadores, apresentando-os através de figuras, fotos ou desenhos.","Identificar 10 (dez) espécies de peixes de água doce e 10 (dez) de água salgada, apontando inclusive as diferenças entre machos e fêmeas, caso existam.","Elaborar e apresentar uma ficha contendo nome, nome científico, comprimento máximo, tipo de reprodução, PH mais adequado, comportamento, temperatura ideal da água, forma mais comum de convívio e origem de 5 (cinco) espécies diferentes de água doce e 5 (cinco) de água salgada.","Identificar 5 (cinco) espécies de plantas ou invertebrados marinhos.","Listar 5 (cinco) espécies de peixes mais adequadas para 1 (um) aquário de água doce do tipo comunitário e 1 (um) do tipo agressivo.","Listar no mínimo 3 (três) doenças que afetam os peixes de aquários, listando também suas causas, informando a forma de medicar e o método preventivo adequado para cada uma delas.","Tirar cria de qualquer espécie de água doce, apresentando 1 (um) pequeno histórico de desenvolvimento de 1 (um) casal e de seus filhotes.","Montar a estrutura de vidro e 1 (um) sistema elétrico para 1 (um) aquário de água doce de no mínimo trinta litros.","Manter 1 (um) aquário em pleno funcionamento e 1 (um) histórico de acontecimentos por 6 (seis) meses.","Explicar quais as possíveis consequências de introduzir 1 (um) espécime, seja ela peixe, crustáceo ou planta, em 1 (um) habitat estrangeiro (outro estado ou país)."}	12	\N	\N	1
5	Arqueologia	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Apresentar, de maneira ilustrada, o que é arqueologia e qual sua importância.","Apresentar 4 (quatro) diferentes zonas arqueológicas, sendo duas delas brasileiras e duas de outros países.","Preparar e apresentar uma palestra ilustrada, tratando de uma das zonas arqueológicas do país, dando enfoque nos seguintes aspectos: localização, estado atual e importância histórica, social, econômica e turística.","Apresentar a biografia de 2 (dois) arqueólogos importantes na história mundial, destacando seus principais trabalhos, suas descobertas mais importantes e a corrente teórica em que trabalhavam.","Expor as teorias associadas à evolução humana e ao povoamento das Américas, decorrente de estudos arqueológicos, citando as principais descobertas e onde ocorreram.","Apresentar 1 (um) estudo sobre a vida de 1 (um) povo antigo de sua livre escolha, baseado em pesquisas arqueológicas e ilustrando com fotos ou gravuras de escavações, documentos, monumentos ou objetos deixados por ele."}	6	\N	\N	1
6	Arquitetura	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Apresentar uma pesquisa sobre a história e a evolução da arquitetura.","Ter noções de urbanismo e apresentar sua explicação com exemplos reais, por meio de painéis com fotos ou recortes.","Citar 3 (três) exemplos que demonstrem conhecimento de diferentes tipos de construção, adequados ao terreno e ao clima.","Relacionar os diferentes tipos de estruturas utilizadas na construção.","Visitar 1 (um) escritório de arquitetura e reunir informações sobre os objetos utilizados para a elaboração de 1 (um) projeto e sobre a situação atual do mercado de trabalho.","Demonstrar que sabe interpretar 1 (um) projeto de construção de uma residência e relacionar os materiais a serem utilizados na obra.","Apresentar exemplos de arquitetura renascentista, barroca e modernista.","Apresentar projetos em tamanhos diferenciados de residência, edifício de habitação ou de escritórios e edifício público (aeroporto, museu, rodoviária etc.), identificando plantas, cortes e elevações e os símbolos do desenho arquitetônico.","Organizar e apresentar uma palestra, com auxílio de 1 (um) arquiteto ou estudante de arquitetura, com o objetivo de transmitir aos companheiros informações sobre: paisagismo, engenharia, design de interiores, restauração de patrimônio etc., mostrando suas aplicações."}	9	\N	\N	1
7	Astronáutica	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Explicar o princípio de sustentação do voo, demonstrando o efeito do ar sobre as asas com um experimento simples baseado no princípio de Bernoulli.","Identificar as principais partes de uma aeronave (fuselagem, asas, trem de pouso, leme, ailerons e flaps) em um modelo físico ou digital, explicando a função de cada uma.","Em um aeródromo identificar os principais tipos de aeronaves e helicópteros em operação, classificando-os como civis, comerciais, militares, e explicando suas diferenças.","Explicar como funciona o motor a pistão e o motor a jato, mostrando suas diferenças e o impacto de cada um na velocidade e no consumo de combustível.","Demonstrar como o vento interfere no voo e na navegação aérea, simulando, por meio de experimento ou maquete, os efeitos de vento de proa, cauda e través.","Explicar o que significam os números nas pistas de pouso e decolagem, relacionando-os à direção do vento e aos sistemas de iluminação e segurança das pistas.","Organizar um registro de observação aérea, anotando por pelo menos uma semana informações sobre aeronaves vistas em voo (dia, hora, tipo, direção e características observáveis).","Apresentar, com ilustrações ou maquete, os três eixos de movimento de um avião (longitudinal, lateral e vertical), explicando como os comandos da cabine os controlam."}	8	\N	\N	1
8	Astronomia	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Apresentar, usando esferas, lanterna e outros tipos de materiais, os conceitos de: dia e noite, estações, eclipses e fases da lua.","Apontar, em uma noite, pelo menos 3 (três) constelações, o polo celeste e o movimento aparente do céu. Encontrar os pontos cardeais usando constelações.","Apresentar uma palestra ilustrada sobre a evolução estelar.","Conhecer morfologia de galáxias, da Via-Láctea e a posição geral do Sistema Solar na Via-Láctea.","Apresentar a atual teoria para a formação do universo e do Sistema Solar.","Conhecer os métodos de detecção de planetas extra solares.","Construir e expor em seu Grupo Escoteiro 1 (um) relógio de sol, explicando seu funcionamento.","Montar 1 (um) painel ilustrado, que apresente 5 (cinco) missões espaciais. Deve conter: objetivos da missão, destino, ano de lançamento e outras informações relevantes.","Construir uma luneta simples para observar o céu.","Visitar 1 (um) planetário ou observatório ou apresentar domínio de 1 (um) programa de computador que simula o movimento do céu.","Apresentar, usando ilustrações e texto, a biografia de 1 (um) astrônomo a sua escolha.","Utilizando o gnômon, apontar a hora da passagem meridiana do Sol e os pontos cardeais.","Diferenciar as características dos pequenos corpos do Sistema Solar: satélites, anéis, planeta anão, cometa e asteroides.","Conhecer os sistemas de coordenadas horizontal.","Fazer uma análise comparativa de tamanhos e distâncias no universo. Conhecer o significado das principais unidades de distância usadas na astronomia: unidade astronômica, ano-luz e parsec."}	15	\N	\N	1
9	Automobilismo Rádio Controlado	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Explicar as diferenças entre 1 (um) modelo on-road e outro off-road.","Explicar a diferença de caster e cambagem num automodelo e para que servem.","Afinar (ajustar) 1 (um) motor a combustão e, em caso de motor elétrico, trocar 1 (um) par de escovas (carvão).","Montar e apresentar 1 (um) modelo escolhido.","Explicar o funcionamento de 1 (um) diferencial e como montá-lo.","Descrever o processo de limpeza e manutenção de 1 (um) automodelo.","Trimar o rádio de 1 (um) automodelo a combustão e, no caso de automodelo elétrico, ajustar 1 (um) speed control.","Ligar, ajustar (se necessário) e fazer uma demonstração num percurso rabiscado no chão em forma de oito.","Explicar qual a composição do combustível (metanol) para automodelos a combustão e, em casos de elétricos, descrever o processo de carga e descarga de uma bateria elétrica.","Explicar qual a diferença básica entre rádio “stick” e “wheel” (volante).","Pintar, recortar e instalar uma bolha (carroceria).","Ter participado de pelo menos 1 (um) torneio de automodelismo."}	12	\N	\N	1
10	Biologia	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Relatar o que é a Biologia e o que ela estuda.","Descrever a importância das abelhas para o ecossistema mundial.","Apresentar o significado dos principais conceitos: conceito ecológico de espécie, população, comunidade, ecossistema e biosfera.","Escolher uma doença ocasionada por 1 (um) parasita e explicar seus sintomas, tratamento e prevenção.","Apontar as diferenças de células procariontes e eucariontes, e seres autotróficos e seres heterotróficos.","Explicar os 2 (dois) tipos de divisões celulares: mitose e meiose.","Explicar o sistema ABO e como ocorre a herança dos grupos sanguíneos, apresentando exemplos.","Explicar as teorias evolutivas propostas por Lamarck e Darwin, apontando suas diferenças.","Apresentar a explicação dos experimentos de Mendel com ervilhas e sua contribuição na genética.","Conhecer a teoria de geração espontânea e as observações de Francesco Redi, apresentando as ideias e experimentos que contribuíram para anular a abiogênese.","Pesquisar e apresentar o que diziam os primeiros cientistas que tentaram propor uma classificação dos seres vivos até chegar na que é utilizada atualmente.","Apresentar características e principais diferenças entre briófitas, pteridófitas, gimnospermas e angiospermas, montando uma coleção botânica que tenha, no mínimo, 8 (oito) espécies e contemple os 4 (quatro) grupos citados.","Descrever as características principais do Reino Fungi e desenvolver 1 (um) meio de cultura caseiro, detalhando todo o experimento, relatando as observações durante o crescimento dos fungos.","Escolher 1 (um) filo do Reino Animália e explicá-lo com detalhes, dando exemplos de seres que pertençam a ele.","Descrever o processo de formação de gametas masculinos (espermatogênese) e femininos (ovogênese)."}	15	2020-07-01	\N	1
11	Anime	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Escolher 1 (um) anime de sua preferência e apresentá-lo, discorrendo sobre sua trama, personagens, criadores, artistas envolvidos, época de criação, etc.","Realizar uma apresentação sobre a história dos animes, destacando seu surgimento, o desenvolvimento no país de origem, os principais títulos, os principais autores e artistas e sua chegada e exibição no Brasil.","Organizar uma exposição ilustrada com personagens de animes de sua preferência, citando suas características, a que obra pertencem e quem foi seu criador.","Descrever ao menos 5 (cinco) gêneros de anime, explicando as particularidades de cada um.","Explicar a importância da restrição de faixa etária em determinados animes.","Apresentar 1 (um) relato audiovisual contendo ao menos 5 (cinco) animes assistidos por você. O relato deve conter o título original, e se houver o nacional, ano de produção, país de origem, gênero e uma breve sinopse de cada 1 (um) dos animes.","Demonstrar conhecimento sobre as principais tecnologias utilizadas na produção, gravação e reprodução de animes.","Apresentar 1 (um) trabalho sobre 3 (três) grandes festivais de anime pelo mundo, sendo pelo menos 1 (um) brasileiro, e explicar as particularidades de cada 1 (um) deles.","Promover uma sessão de vídeo, preferencialmente para sua seção ou matilha/patrulha, para assistir 1 (um) anime."}	9	\N	\N	2
12	Arte da Marinharia	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Fazer 8 (oito) nós, além dos comumente recomendados nos guias dos ramos.","Fazer falcaças adequadas para os chicotes dos cabos em que estiver laborando.","Fazer em papel machê, madeira ou massa de modelar, peças marítimas para aquários, quadros de nós, maquetes ou objetos de decoração.","Explicar as definições conforme o livro ‘Arte Naval’: bitola, chicote, nós e voltas, alma, costuras, cabo solteiro, seio, engaiar, percintar, forrar, trincafiar, encapar ou emangueirar.","Fazer ao menos 1 (um) trabalho de gaxetas, botões, redes, aboçaduras, percintar ou forrar, costuras mão ou de alça e ter noção de como são os demais.","Fazer trabalhos com cabos no bastão de patrulha, com chaveiros, em corrimões ou outros locais da sua residência, canto de patrulha, embarcação, ou sede do Grupo Escoteiro, que tenham por objetivo embelezar ou fazer campanha financeira com as artes marinheiras.","Confeccionar 3 (três) tipos de coxins.","Embutir uma alma exposta ou uma defensa.","Pesquisar e apresentar sobre o embasamento histórico da arte do marinheiro."}	9	\N	\N	2
13	Arte em Origami	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Apresentar 1 (um) relatório sobre o significado da palavra “origami”, a origem desta arte e do papel, descrevendo seus benefícios.","Montar esquema que apresente a linguagem do origami (símbolos utilizados na dobradura: Linha do vale, linha da montanha, virar, girar, dobrar por dentro, dobrar por fora, plissagem, achatar ou afundar).","Apresentar por escrito bibliografia sobre o Origami: sobre 2 (dois) autores famosos nacionais ou internacionais e possuir pelo menos 1 (um) livro de origami.","Expor seus trabalhos de origami sozinho ou com outros origamistas em outro local, como escola, biblioteca, associações ou exposição internacional.","Visitar uma exposição de origami mostrando fotos ou participar de “workshop” de origami apresentando, posteriormente, as dobraduras feitas.","Utilizar origamis como decoração de 1 (um) evento, preferencialmente, promovido pelo Grupo Escoteiro, seção ou matilha/patrulha."}	6	\N	Pré-Requisitos:\r\n\r\nFazer uma exposição com, no mínimo:\r\n\r\nNível 1: 10 (dez) dobraduras simples de até trinta dobras.\r\n\r\nNível 2: 25 (vinte e cinco) dobraduras, dentre elas algumas peças com mais de trinta dobras, incluindo caixas simples e “kusudama” (bola com peças modulares).\r\n\r\nNível 3: 40 (quarenta) dobraduras, dentre elas alguns mais complexos com mais de cinquenta dobras, “kusudama” com mais de trinta peças e figuras geométricas.	2
14	Artes Cênicas	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Analisar uma peça de teatro que tenha assistido, comentando o valor do roteiro, o trabalho dos artistas, a direção, os efeitos especiais, a maquiagem.","Atuar como ator principal em uma das seguintes apresentações: (1) Teatro musicado – canção ou dueto com dança ou movimentação interpretativa, (2) Comédia – uma comédia de 1 (um) ato ou (3) Drama – 1 (um) monólogo ou cena de peça clássica.","Maquiar-se para representar 1 (um) personagem.","Planejar, organizar e executar uma peça de teatro de, no mínimo, quarenta minutos de duração.","Conhecer o interior de 1 (um) teatro e a terminologia empregada quanto ao palco, cenários, iluminação etc.","Ler uma peça de teatro e comentar seu conteúdo.","Lidar com cenários, ou desempenhar as funções de contrarregra, ou lidar com iluminação e sonoplastia.","Apresentar a história da origem do teatro.","Ter ido ao teatro nos últimos 6 (seis) meses, pelo menos 3 (três) vezes."}	9	\N	Pré-Requisitos:\r\n\r\nEntreter (sozinho ou com companheiros) uma assistência mista de adultos, jovens e crianças, com 1 (um) programa que contenha, por exemplo: mímica, declamação, canções, danças, histórias, anedotas, mágicas, malabarismo, imitações, ventriloquismo, instrumentos musicais, etc.:\r\n\r\nNível 1: por 1 (um) período mínimo de 5 (cinco) minutos.\r\n\r\nNível 2: por 1 (um) período mínimo de 10 (dez) minutos.\r\n\r\nNível 3: por 1 (um) período mínimo de 20 (vinte) minutos.	2
15	Artes Gráficas	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Identificar os vários tipos de impressão.","Citar 3 (três) tipos de letras (fontes) usadas em revistas ou jornais.","Identificar os formatos de papéis.","Visitar 1 (um) parque gráfico, apresentando 1 (um) relatório ilustrado de sua visita.","Compor 1 (um) informativo, jornal ou revista para a seção ou matilha/patrulha.","Relatar como se utiliza máquinas copiadoras (tipo “xerox”) e de offset.","Elaborar 1 (um) folder sobre o Movimento Escoteiro para ser divulgado em sua comunidade.","Trabalhar com 1 (um) software de Desktop Publishing.","Compor e imprimir 1 (um) jornal de 10 (dez) páginas durante 1 (um) mês, com edições semanais.","Explicar o processo de confecção de 1 (um) fotolito.","Apresentar em papel vegetal uma arte final para serigrafia, para impressão em duas cores.","Preparar a arte de 1 (um) distintivo alusivo a 1 (um) evento do Grupo Escoteiro."}	12	\N	\N	2
16	Artesanato	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Pesquisar sobre as ferramentas e as matérias primas empregadas em pelo menos 2 (dois) tipos de trabalho artesanal.","Citar o artesanato predominante em 5 (cinco) cidades do Brasil, explicando sua importância na cultura local.","Visitar uma exposição ou feira de artesanato.","Passar uma manhã ou uma tarde com 1 (um) artesão, elaborando 1 (um) relatório que descreva suas atividades.","Promover uma exposição de pelo menos 3 (três) artesãos onde eles possam demonstrar e debater suas técnicas artesanais.","Ensinar 1 (um) trabalho artesanal para outros jovens."}	6	\N	Pré-Requisitos:\r\n\r\nNível 1: Executar 1 (um) trabalho artesanal com 1 (um) dos materiais abaixo.\r\n\r\nNível 2: Executar 2 (dois) trabalhos artesanais com 1 (um) ou mais dos materiais abaixo.\r\n\r\nNível 3: Executar 3 (três) trabalhos artesanais com 1 (um) ou mais dos materiais abaixo.\r\n\r\nSugestões de materiais: Argila, Corda, Couro, E.V.A., Garrafa PET, Jornal, Madeira, Metal, Papel machê, Pedra, Vidro ou Vime.	2
17	Bateria	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Possuir noções básicas sobre a história da bateria.","Executar ao menos 3 (três) ritmos em diferentes estilos musicais.","Demonstrar conhecimento das técnicas de baqueta como pinça e rebote.","Explicar a diferença entre compasso simples e compasso composto.","Diferenciar os instrumentos que compõem a bateria apenas ouvindo e demonstrar conhecimentos básicos sobre a afinação dos instrumentos.","Demonstrar conhecimento básico na leitura de partitura de bateria, explicando o significado de pulsação, andamento e fórmula de compasso.","Demonstrar conhecimento sobre diferentes tipos de pegada: tradicional (tradicional grip) e moderna (matched grip), levando em consideração as 3 (três) formas da pegada moderna.","Explicar o sistema de divisão rítmica e executar as seguintes figuras musicais em andamento de livre escolha: semínima, colcheia, semicolcheia, fusa e semifusa.","Explicar e executar duínas, tercinas e figuras pontuadas."}	9	\N	Pré-requisitos:\r\n\r\nNível 1: Executar pelo menos 2 (dois) rudimentos.\r\n\r\nNível 2: Executar pelo menos 7 (sete) rudimentos.\r\n\r\nNível 3: Executar pelo menos quinze rudimentos.	2
18	Budismo	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Apresentar a história do Buda Shakyamuni e a origem do budismo.","Apresentar uma breve explicação sobre as 3 (três) grandes linhas de pensamento Budistas, ou 3 (três) Veículos: Hinayana, Mahayana e Tantrayana.","Explicar o que são os Sutras e citar três.","Explicar o que são Mantras, escolher 1 (um) deles e recitar para o examinador.","Definir o que é joia tríplice e o significado de tomar refúgio na jóia tríplice.","Explicar o que são bodisatvas, relatando a história e características de 1 (um) deles.","Apresentar pelo menos 3 (três) preceitos budistas.","Relacionar os fundamentos budistas com 3 (três) artigos da Lei Escoteira.","Visitar 1 (um) templo e participar de uma cerimônia budista."}	9	2020-07-01	Proponente(s): Carlos Alexandre Gomes Lopes\r\nAvaliador(es): Silvio Miyazaki e Sandra Emi (Budistas)	2
19	Canto	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Conhecer e executar no mínimo 5 (cinco) exercícios vocais para aquecer a voz, explicando sua funcionalidade.","Citar e descrever as principais categorias de voz.","Descrever ao menos uma técnica do canto em seu aspecto físico.","Descrever os benefícios do canto para sua saúde.","Escrever, e apresentar ao examinador, uma breve biografia de 1 (um) cantor conhecido internacionalmente, de qualquer gênero musical, descrevendo sua principal característica de técnica vocal.","Apresentar uma música, para o examinador, de qualquer gênero musical.","Apresentar-se, cantando, diante de uma plateia mínima de cinquenta pessoas.","Fazer ou ter feito aula de canto por 1 (um) período mínimo de 6 (seis) meses.","Ter assistido a 1 (um) show de 1 (um) cantor conhecido nacional ou internacionalmente, de qualquer gênero musical."}	9	2020-07-01	Proponente(s): Alice Konrad Hauers\r\nAvaliador(es): Vitinho Manzke (Mestre em Música, Professor e Coordenador do Curso de Música – Universidade de Caxias do Sul)	2
20	Cinefilia	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Apresentar uma pesquisa sobre a história do cinema mundial e brasileiro.","Apresentar 1 (um) relato audiovisual, contendo pelo menos 10 (dez) filmes já assistidos por você. O relato deve conter: o título nacional e original, ano de produção, país de origem e gênero de cada 1 (um) dos filmes. Os filmes deverão ser de pelo menos 7 (sete) gêneros diferentes e terem sido produzidos em, no mínimo, 7 (sete) países diferentes.","Possuir uma cinemateca pessoal, organizá-la e catalogar os filmes informando os títulos nacionais e originais, ano de produção e gênero, de pelo menos vinte filmes.","Demonstrar conhecimento sobre as principais tecnologias utilizadas na produção, gravação e reprodução de filmes desde a criação do cinema.","Apresentar uma pesquisa contendo a biografia e filmografia de pelo menos 5 (cinco) atores, sendo ao menos 3 (três) brasileiros, e 5 (cinco) diretores, sendo ao menos 2 (dois) brasileiros, que atuam ou atuaram no cinema.","Demonstrar conhecimento sobre a história de pelo menos 3 (três) grandes festivais internacionais de cinema, sendo pelo menos 1 (um) brasileiro.","Demonstrar conhecimento sobre 8 (oito) profissões relacionadas com a indústria cinematográfica e analisar a atuação dos profissionais num filme de sua preferência.","Demonstrar conhecimento sobre a legislação que trata do crime de violação de direitos autorais.","Participar da produção e/ou interpretação de 1 (um) filme curta-metragem de quinze minutos, no mínimo, podendo ser uma produção inédita ou encenação de 1 (um) clássico do cinema.","Criar e manter por 3 (três) meses, no mínimo, 1 (um) informativo para a divulgação de produções cinematográficas, incluindo as nacionais, podendo ser produzido em 2 (dois) formatos: impresso para distribuição na sede do Grupo Escoteiro ou digital para divulgação em redes sociais.","Organizar uma sessão para exibição de 1 (um) filme de sua preferência para 10 (dez) convidados, no mínimo, escoteiros ou não, e promover 1 (um) debate sobre o tema apresentado.","Visitar uma sala de cinema ou produtora de filmes e apresentar 1 (um) relatório sobre sua estrutura e equipamentos utilizados para seu funcionamento."}	12	\N	Pré-requisitos:\r\n\r\nTer assistido, no mínimo:\r\n\r\nNível 1: 10 (dez) filmes.\r\n\r\nNível 2: 25 (vinte e cinco) filmes.\r\n\r\nNível 3: 50 (cinquenta) filmes.	2
37	Ferramentas de Corte	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Identificar 6 (seis) tipos de ferramentas de corte e sua finalidade de utilização.","Demonstrar como afiar e conservar 4 (quatro) tipos de ferramentas de corte, entre elas faca e machadinha.","Demonstrar as formas de utilização de 1 (um) canivete multifunção e de uma faca estilo punhal.","Demonstrar a forma de condução de canivetes e facas.","Demonstrar a forma de utilização de 1 (um) facão, machadinha e machado.","Construir uma bainha, em couro ou material similar, para faca e facão.","Demonstrar a forma de condução de facão, machadinha e machado.","Demonstrar a forma de utilização de 1 (um) serrote.","Conhecer as regras de segurança para manuseio de ferramentas de corte e construir 1 (um) canto do lenhador conforme regras de segurança.","Descascar de forma correta, com emprego de canivete e faca, duas laranjas e duas maçãs.","Construir, com emprego da faca, 2 (dois) espetos para assar ovo.","Construir, com emprego de facão e machadinha, no mínimo 4 (quatro) estacas para emprego em toldo, demonstrando a rigidez e utilidade da obra construída."}	12	\N	\N	4
21	Arco e Flecha	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Elaborar 1 (um) trabalho escrito sobre arco e flecha, citando sua origem, evolução histórica e características.","Apresentar 1 (um) trabalho sobre a regulamentação da prática do arco e flecha como atividade esportiva.","Demonstrar o uso de diferentes tipos de arcos, flechas, pontas e tipos de competição na modalidade escolhida.","Demonstrar conhecimento sobre ancoragem, postura, nomenclatura e medidas envolvidas no esporte.","Apresentar as regras de segurança para manejar 1 (um) arco e flecha.","Explicar o que faz a Associação Nacional e Internacional de Arco e Flecha e o tipo de competições desse esporte.","Participar de curso de tiro com arco e flecha, com prática mínima de 6h.","Participar de uma prova simulada de tiro com arco em alvos indoor one-spot (WA ou IFAA) com desempenho de 50% das flechas pontuando a 10 (dez) metros ou 30% das flechas pontuando a 15 (quinze) metros.","Participar de prova com monitoramento de juiz habilitado, item esse que só poderá ser efetuado mediante participação anterior em uma competição de tiro de arco e flecha conforme item 8 (oito)."}	9	2020-05-01	Proponente de revisão: Alexandre Poncinao – GE José de Anchieta – 11/DF\r\nRevisor: Rudner Lauterjung (Competidor federado da Field Brasil – IFAA)	3
22	Artes Marciais	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Apresentar o desenvolvimento histórico e filosófico da arte marcial que você pratica.","Demonstrar juntamente com outro(s) praticante(s), as principais regras que regem as competições da arte marcial que você pratica.","Demonstrar conhecimento dos fundamentos básicos de sua arte marcial, incluindo bases, golpes, defesas e formas.","Apresentar técnicas da arte marcial escolhida, destacando a contribuição da prática dessa arte marcial na sua formação pessoal.","Participar de pelo menos 3 (três) competições da arte marcial escolhida, promovidas por entidade oficial (confederação, federação, liga, órgãos do governo, fundações municipais de desportos, etc.).","Comprovar, através de 1 (um) atestado emitido pela academia, que possui graduação mínima compatível conforme sua idade e tempo de prática da arte marcial escolhida, compreendendo e seguindo seus princípios e normas."}	6	\N	Pré-requisitos:\r\n\r\nComprovar com 1 (um) atestado assinado por seu professor ou treinador:\r\n\r\nNível 1: Prática de no mínimo 6 (seis) meses.\r\n\r\nNível 2: Prática de no mínimo 2 (dois) anos.\r\n\r\nNível 3: Prática de no mínimo 3 (três) anos.	3
23	Basquetebol	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Apresentar a história do basquetebol brasileiro, citando seus principais títulos.","Escrever uma breve biografia sobre 1 (um) jogador de basquetebol, que você considere relevante.","Demonstrar as regras básicas do basquetebol, encenando, quando aplicável.","Apresentar os principais esquemas táticos e a sua necessidade no desenvolvimento do jogo.","Assistir uma partida de basquetebol, com o examinador, e explicar durante o jogo os nomes e funções das posições dos jogadores em quadra.","Apontar os principais fundamentos técnicos usados, durante 1 (um) jogo.","Assistir a 1 (um) jogo de basquetebol televisionado, fazendo anotações, e nos intervalos fazer 1 (um) retrospecto dos melhores lances e assistir a 1 (um) jogo em 1 (um) ginásio, apresentando 1 (um) relatório no término.","Fazer uma visita a 1 (um) ginásio com quadra de basquetebol em 1 (um) dia que não haja jogo, e conhecer suas dependências.","Explicar as regras de segurança ao assistir a uma partida de basquetebol em 1 (um) ginásio, o que deve ser feito para evitar confusões e tumultos, dando sua opinião sobre o que os torcedores devem fazer para promover a paz nos ginásios.","Apresentar o sistema de pontuação de campeonatos regionais e nacionais regulamentados pela FIBA.","Participar de uma competição de basquetebol, sendo capaz de reconhecer os principais gestos efetuados por 1 (um) árbitro.","Organizar 1 (um) torneio de basquetebol, na modalidade de sua preferência, na sua seção ou com outros grupos escoteiros e convidados, com no mínimo 4 (quatro) times, utilizando 1 (um) dos sistemas de pontuação apresentados no item 11"}	12	\N	\N	3
24	Boxe	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Contar a história do boxe – nacional e mundial – para seu examinador.","Descrever suas regras e demonstrar as 5 (cinco) técnicas básicas de golpes no boxe, citando cada golpe e demonstrando com 1 (um) professor e/ou outro praticante juvenil.","Demonstrar 3 (três) tipos de saídas de golpes, 4 (quatro) tipos de defesa de golpes e duas defesas de mão.","Listar, para seu examinador, nomes dos maiores nomes boxeadores da história, destacando suas principais características.","Apresentar todas as federações (brasileiras e internacionais) de boxe e como se organizam suas categorias.","Discorrer sobre os benefícios que o Boxe pode trazer para sua saúde e sua formação pessoal, apontando também os cuidados que se deve ter quanto à sua prática."}	6	\N	Pré-requisitos:\r\n\r\nComprovar com 1 (um) atestado assinado por seu professor ou treinador:\r\n\r\nNível 1: Prática de no mínimo 6 (seis) meses.\r\n\r\nNível 2: Prática de no mínimo 2 (dois) anos.\r\n\r\nNível 3: Prática de no mínimo 3 (três) anos.	3
25	Canoagem	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Explicar quais os tipos de canoas e suas origens.","Preparar uma canoa para esporte e passeio.","Explicar as quais as regras e equipamentos de segurança necessários para uma atividade com canoas.","Demonstrar as manobras de embarque e desembarque com segurança e que sabe governar a canoa em movimento.","Planejar e realizar com sua matilha/patrulha, equipe de competição ou amigos, a sua escolha uma das seguintes alternativas: 1 (um) treinamento na água; uma atividade embarcada com jogo naval; 1 (um) cruzeiro marítimo; uma missão náutica.","Participar de uma competição ou realizar trajeto de 5 (cinco) quilômetros em atividade embarcada."}	6	\N	\N	3
26	Capoeira	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Explicar as diferenças entre os estilos de capoeira, Angola e Regional.","Contar a origem histórica da capoeira através de uma palestra para jovens da mesma faixa etária.","Demonstrar que sabe tocar os instrumentos musicais da capoeira (berimbau e pandeiro) e opcionais (agogô, reco-reco e atabaque).","Cantar 3 (três) músicas de capoeira.","Demonstrar movimentos básicos da capoeira (ginga, meia-lua, benção, esquivas, etc.).","Convidar seu grupo de capoeira para realizar uma roda no seu Grupo Escoteiro e demonstrar seu jogo na mesma."}	6	\N	Pré-requisitos:\r\n\r\nComprovar com 1 (um) atestado assinado por seu professor ou treinador:\r\n\r\nNível 1: Prática de no mínimo 6 (seis) meses.\r\n\r\nNível 2: Prática de no mínimo 2 (dois) anos.\r\n\r\nNível 3: Prática de no mínimo 3 (três) anos.	3
27	Ciclismo	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Demonstrar conhecimento sobre a mecânica das bicicletas.","Apresentar as regras de segurança e o Código de Trânsito para ciclistas, tanto na cidade como no campo.","Participar de 1 (um) evento de ciclismo (em asfalto ou trilha) promovido por uma entidade oficial (confederação, federação, liga, órgãos do governo, fundações municipais de desportos, etc.) de pelo menos quinze quilômetros ou participar de 1 (um) passeio ciclístico, em sua cidade, de pelo menos quinze quilômetros.","Saber efetuar reparos e regulagens em sua bicicleta, tais como: encher pneu, tirar e encaixar a roda do garfo dianteiro, trocar câmaras, etc.","Apresentar uma palestra ilustrada sobre os equipamentos e acessórios de segurança, bem como sua importância, previstos no código de trânsito.","Organizar uma atividade ciclística, levando em conta os aspectos de segurança, escolha dos percursos, equipamentos e acessórios obrigatórios, material e equipamento de primeiros socorros, etc."}	6	\N	Pré-requisitos: Demonstrar que sabe andar de bicicleta, fazendo 1 (um) percurso estabelecido pelo examinador, com o mínimo de quinhentos metros.	3
28	Corrida de Orientação	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Citar as modalidades de orientação.","Explicar as regras básicas dos campeonatos de orientação.","Usar prisma, o mapa e a bússola.","Saber as principais regras oficiais para corridas de orientação.","Ter participado de competições oficiais.","Citar a regra sobre consciência ecológica.","Citar a simbologia usada nos mapas.","Apresentar as imagens do uniforme e material usado nas competições.","Apresentar 1 (um) resumo sobre o esporte.","Montar uma pista azimute para sua seção ou matilha/patrulha com utilização de prismas.","Organizar uma competição que envolva pelo menos uma seção de outro Grupo Escoteiro.","Montar ou integrar uma equipe de membros do movimento escoteiro (selecionando, treinando) para participar de uma competição oficial."}	12	\N	\N	3
29	Corrida de Rua	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Apresentar a história da modalidade, os maiores maratonistas da atualidade e a história do Etíope Abebe Bikila.","Conhecer o seu tipo de pisada e descrever cada uma das existentes: neutro, pronada ou supinada.","Explicar a diferença entre corrida de curta distância, meio-fundo e fundo.","Explicar pelo menos 4 (quatro) benefícios da prática de corrida.","Relatar a importância da hidratação em provas.","Explicar a importância de uma alimentação equilibrada, a ingestão de carboidratos e a preferência por alimentos de fácil digestão antes das provas.","Explicar a importância do aquecimento antes de uma corrida e da desaceleração e do alongamento ao final de uma prova.","Demonstrar conhecimento sobre as lesões mais comuns.","Conhecer uma associação de Corredores de Rua de seu Estado.","Conhecer as maiores corridas de rua de seu país.","Demonstrar conhecimentos sobre o World Major Marathon Series, as 5 (cinco) maiores maratonas do mundo.","Assistir a uma prova com percurso igual ou superior a 10 (dez) quilômetros, relatando sua experiência.","Demonstrar conhecimento sobre os principais tipos de treinos para corridas: Intervalado, Fartlek, Tempo Run, Subidas e Descidas, Longão e Treinamento Regenerativo.","Conhecer planilhas de treinos para uma prova de 10 (dez) quilômetros, uma Meia Maratona e para uma Maratona.","Fazer uma pesquisa sobre a roupa e o calçado mais adequados para este tipo de esporte."}	15	\N	Pré-requisitos:\r\n\r\nParticipar de duas corridas, sendo:\r\n\r\nNível 1: De 1 (um) quilometro.\r\n\r\nNível 2: De 4 (quatro) quilômetros.\r\n\r\nNível 3: Entre 6 (seis) e 10 (dez) quilômetros.	3
30	Cubo Mágico	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Conhecer o mecanismo interno do cubo 3x3x3. Desmontá-lo, remontá-lo e fazer os ajustes necessários e manutenção (limpeza das peças, lubrificação).","Saber o regulamento definido pela WCA (Associação Mundial de Cubo) para participação em campeonatos.","Participar de 1 (um) campeonato homologado pela WCA ou promover 1 (um) com no mínimo 8 ( (oito) participantes.","Conhecer as notificações de movimentos e rotações e aplicá-las ao cubo 3x3x3.","Conhecer o significado das siglas usadas em campeonatos.","Apresentar 1 (um) tutorial elaborado pelo próprio escoteiro com os primeiros passos para a montagem do cubo 3x3x3.","Saber montar outra modalidade de cubo mágico além do 3x3x3.","Demonstrar conhecimentos sobre a criação do cubo mágico e sua trajetória ao longo da história.","Conhecer os recordes nacionais, continentais e mundiais das principais modalidades."}	9	\N	Pré-requisitos:\r\n\r\nNível 1: Resolver o cubo 3x3x3 em até 1 (um) minuto e trinta segundos.\r\n\r\nNível 2: Resolver o cubo 3x3x3 em até 1 (um) minuto.\r\n\r\nNível 3: Resolver o cubo 3x3x3 em até quarenta segundos.	3
31	Acampamento	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Montar, desmontar, dobrar e acondicionar uma barraca.","Escolher as técnicas de conservação de uma barraca, executando pequenos reparos na lona, quarto e varetas.","Escolher locais seguros para montar uma barraca.","Explicar os cuidados a adotar em casos de temporais e alagamentos.","Cuidar e tratar do lixo quando em acampamento.","Montar 1 (um) canto de matilha/patrulha, considerando os padrões de acampamento e com auxílio da matilha/patrulha.","Cozinhar uma refeição simples individual em fogo de lenha, sem utilizar utensílios de cozinha.","Fazer pelo menos 5 (cinco) pioneirias diferentes e úteis em acampamentos, utilizando amarras.","Acampar por 3 (três) noites sem utilizar barraca, dormindo em abrigo natural ou em saco de dormir especial para o relento.","Orientar-se por meio de cartas topográficas, com e sem emprego de bússola.","Improvisar barraca, mochila, espeques, esteios e artigos semelhantes, utilizando-os durante 1 (um) acampamento ou jornada.","Demonstrar uso dos seguintes nós e voltas: de correr, escota duplo, em oito, balso pelo seio, arnês, fiel, ribeira, redonda com cotes e do salteador.","Demonstrar os cuidados para com o material necessário para 1 (um) acampamento.","Elaborar 1 (um) cardápio e lista de gêneros para as refeições da seção durante 1 (um) acampamento e uma jornada, ambos com duração igual a 1 (um) fim de semana.","Acondicionar os gêneros alimentícios para 1 (um) acampamento e uma jornada.","Preparar o material individual para 1 (um) acampamento e para uma jornada, ambos com duração igual a 1 (um) fim de semana.","Fazer 1 (um) projeto de 1 (um) acampamento suspenso, listando o material necessário, custos e os aspectos de segurança, e executá-lo.","Elaborar e executar uma programação de 1 (um) acampamento da matilha/patrulha, com duração igual a 1 (um) fim de semana."}	18	\N	Pré-requisitos: Ter acampado com a seção, ou matilha, ou patrulha, no mínimo:\r\n\r\nNível 1: 6 noites.\r\n\r\nNível 2: 12 noites.\r\n\r\nNível 3: 18 noites.\r\n\r\nNota Técnica 1: A contagem de noites acampadas deve levar em conta toda a vida escoteira do jovem, portanto, valem as noites acampadas nas seções anteriores.\r\n\r\nNota Técnica 2: Podem ser consideradas as pernoites realizadas em bivaques.\r\n\r\nNota Técnica 3: Bivaques são atividades de campo em que o pernoite é realizado em abrigo construído, e não em barracas. É mais usada com o Ramo Sênior, embora possa ser também usada no Ramo Escoteiro. Depende de treinamento prévio, boas condições de tempo e material disponível. Em alguns lugares do Brasil se entende bivaque como uma atividade no campo sem pernoite, semelhante a uma excursão.\r\n\r\nFlexibilização: Grupos Escoteiros que acampam com menor frequência podem considerar noites acantonadas para os casos onde isto é a única coisa que impede a conquista do jovem.	4
48	Aquicultura	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Saber o que é aquicultura, quais suas características e quais espécies são considerados pescado.","Conhecer os cuidados básicos exigidos pela espécie de aquicultura a que se dedica.","Conhecer as modalidades de cultura e os métodos mais aplicados, pesquisando sobre os mais utilizados em sua região.","Manter uma criação, durante 1 (um) período adequado à espécie a que se dedica, e fazer 1 (um) prato para ser degustado pela seção.","Conhecer os sistemas de alimentação, reprodução, prevenção de doenças e tratamento de águas ou condições de clima e correnteza.","Visitar uma aquicultura e elaborar relatório para apresentação à seção, destacando os beneficias resultantes para a comunidade local."}	6	\N	\N	5
32	Acampamento de Mínimo Impacto	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Pesquisar e apresentar 1 (um) conjunto de princípios e práticas de mínimo impacto à sua escolha (ex.: Leave no Trace/No Deje Rastro, Pega Leve, etc.).","Explicar como o planejamento e preparação antecipados de 1 (um) acampamento de mínimo impacto são importantes para maximizar a segurança, minimizar o impacto ambiental e melhorar o conforto da atividade.","Demonstrar como realizar o correto racionamento de alimentações para 1 (um) acampamento de 3 (três) dias e duas noites.","Demonstrar, durante 1 (um) acampamento, como escolher 1 (um) local apropriado em área pristina, para armar barracas e instalar cozinha de campo de forma a minimizar o impacto.","Demonstrar o uso de 1 (um) sistema viável para gerenciar lixo em acampamentos de mínimo impacto.","Explicar a importância de dispor corretamente os dejetos humanos em áreas com incidência de vida selvagem, levando em consideração a distância das fontes de água potável.","Explicar a importância de preservar evidências históricas e objetos naturais no ambiente que visita.","Demonstrar 1 (um) método viável para construção de fogueiras de baixo impacto, como escolher local apropriado, a madeira para combustível e como dispor da fogueira sem deixar marcas no local.","Demonstrar, quando em atividade, quais os procedimentos a serem adotados quando encontrar vida selvagem, visando não perturbar seus hábitos.","Quando em ambiente selvagem, demonstrar cordialidade e cortesia no encontro com outros visitantes, explicando também quais hábitos evitar de forma a preservar a experiência dos mesmos e boa imagem do Escotismo.","Demonstrar que compreende o que significa impacto social e como agir para minimizar o impacto das atividades escoteiras nos habitantes das áreas que visita.","Junto ao Grupo Escoteiro ou sua seção, elaborar uma campanha de conscientização sobre ética ambiental, bem como sua importância para a preservação do meio ambiente para as gerações futuras."}	12	\N	\N	4
33	Almoxarifado	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Demonstrar noções básicas do funcionamento de 1 (um) almoxarifado.","Selecionar corretamente o material para 1 (um) acampamento da seção.","Visitar 1 (um) almoxarifado de 1 (um) órgão público ou empresa privada entrevistando seu responsável, para conhecer a importância e a responsabilidade da função.","Encarregar-se do material da seção durante 1 (um) acampamento de final de semana.","Administrar o almoxarifado da seção por 1 (um) período mínimo de 3 (três) meses.","Organizar 1 (um) cadastro de fornecedores do material utilizado pela seção.","Realizar o inventário do material da seção, efetuando 1 (um) levantamento do valor em moeda corrente, para o caso de ser necessária a substituição de qualquer item.","Executar a manutenção apropriada no material de campo da seção.","Organizar o processo de controle de estoque do material utilizado pela seção."}	9	\N	\N	4
34	Cidadania do Mundo	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Pesquisar sobre a Organização Mundial do Movimento Escoteiro (WOSM), localização do Escritório Mundial, suas Regiões e respectivos Escritórios.","Identificar em 1 (um) planisfério pelo menos cinquenta países em que o Movimento Escoteiro tenha existência legal, em todas as Regiões Escoteiras.","Reconhecer o emblema escoteiro e a bandeira nacional de pelo menos trinta deles e explicar o significado do emblema oficial da Organização Mundial do Movimento Escoteiro.","Manter correspondência com 1 (um) escoteiro estrangeiro durante 6 ((seis) meses (mínimo de 5 (cinco) cartas), procurando aumentar seus conhecimentos gerais sobre a geografia, a história e os costumes do país em questão, não só por meio da correspondência, mas também pela leitura de livros.","Acampar com escoteiros estrangeiros, em atividades nacionais ou internacionais.","Participar de alguma atividade de caráter internacional promovida por uma Organização Escoteira ou Organização Internacional (ONU, UNESCO, UNICEF, UNHCR etc.).","Escrever 1 (um) artigo sobre os problemas atuais do mundo e como o Escotismo pode colaborar na busca de solução.","Identificar os 5 (cinco) países que possuem os maiores contingentes escoteiros na relação membros potenciais / membros efetivos e a razão deste sucesso.","Pesquisar e apresentar uma palestra sobre os principais Parques do Escotismo Mundial.","Montar 1 (um) painel com pelo menos quinze insígnias escoteiras estrangeiras.","Pesquisar e apresentar pelo menos 3 (três) exemplos de trabalhos comunitários desenvolvidos por associações escoteiras estrangeiras.","Relatar os esforços de 3 (três) organizações que se ocupem em promover a paz mundial, identificando sua metodologia de atuação e abrangência."}	12	\N	\N	4
35	Culinária	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Abrir 1 (uma) lata, cortar legumes e/ou frutas à sua escolha, preparar uma salada e uma bebida quente.","Identificar os utensílios necessários para a preparação de um prato definido pelo examinador.","Explicar as técnicas e os cuidados necessários ao limpar corretamente frutas, legumes e verduras evitando vírus, bactérias e fungos.","Fazer uma lista dos mantimentos com quantidades necessárias para uma refeição festiva para a seção.","Explicar as diferentes formas de conversação de alimentos sem refrigeração.","Preparar um cardápio equilibrado para 1 (um) acampamento de final de semana, calculando as quantidades dos gêneros alimentícios necessários e definindo um valor de cota individual para membro da sua matilha/patrulha.","Cozinhar para a matilha/patrulha durante 1 (um) acampamento de final de semana, demonstrando cuidados com a segurança e a higiene.","Projetar e participar da montagem da cozinha do canto da matilha/patrulha em 1 (um) acampamento, justificando os cuidados adotados para reduzir os riscos de incêndio e favorecer a segurança alimentar.","Limpar e preparar 1 (uma) peça de carne e 1 (um) peixe ou preparar 1 (uma) refeição utilizando proteína de soja como substituição das carnes.","Explicar o que é alimentação sustentável e quais são os benefícios para a sociedade e para o meio ambiente.","Apresentar o resultado de uma entrevista feita com um profissional da culinária, elencando as possibilidades de formação técnica, de empregabilidade e as vantagens e dificuldades da profissão.","Cite 5 (cinco) exemplos para cada um dos seguintes grupos alimentares: Frutas, Grãos, Laticínios, Vegetais e Proteínas."}	12	2022-05-01	Proposta de revisão: Equipe Projeto 1000 Hortas – Região Escoteira de São Paulo	4
36	Culinária Mateira	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Demonstrar pelo menos duas técnicas de conservação de alimentos no ambiente natural.","Conhecer os tipos de fogueiras apropriadas para culinária mateira. Preparar, acender e apagar corretamente uma fogueira.","Demonstrar habilidade em preparar as seguintes iguarias: pão a caçador, ovo no espeto, ovo no barro, batata recheada, arroz na abóbora.","Montar 1 (um) forno mateiro (forno de barro) e utilizá-lo na preparação de algum prato da culinária mateira.","Preparar 3 (três) receitas de sobremesa da culinária mateira.","Limpar e preparar uma ave, em forno mateiro, fogueira, enterrado ou na pedra.","Limpar e preparar 1 (um) peixe, em forno mateiro, fogueira, enterrado ou na pedra.","Preparar 2 (dois) tipos de bebida quente em fogueira.","Elaborar e executar 1 (um) cardápio variado de culinária mateira, sem o uso de utensílios, equilibrado para 1 (um) acampamento de final de semana, calculando as quantidades dos gêneros para a matilha/patrulha."}	9	\N	\N	4
49	Arte Digital	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Apresentar à sua seção 1 (um) programa de desenho digital a sua escolha, demonstrando o uso de diversas ferramentas disponíveis, como texturas e filtros de cor.","Explicar a importância do trabalho com layers, demonstrando a formatação de uma imagem utilizando esta ferramenta.","Organizar uma exposição em sua seção, contendo pelo menos 5 (cinco) de seus trabalhos.","Explicar ou à seção a importância dos efeitos de luz e sombra e quais as melhores técnicas para se conseguir os resultados desejados.","Explicar o que é e como funciona uma mesa digitalizadora, demonstrando seu uso à seção.","Fazer uma apresentação à matilha ou matilha/patrulha sobre a importância da paleta de cores selecionada para 1 (um) trabalho, utilizando recursos midiáticos de escolha livre (vídeos, apresentações de slides, cartazes.)"}	6	\N	\N	5
38	Fogo de Conselho	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Descrever as origens do Fogo de Conselho, seus objetivos, tipos e características.","Montar pelo menos 3 (três) tipos de fogueiras que sejam adequadas ao Fogo de Conselho, explicando as vantagens e desvantagens de cada uma delas, descrevendo os tipos de iscas que podem ser utilizadas em seu acendimento, bem como os principais procedimentos de segurança ao fazê-lo.","Elaborar e aplicar 1 (um) efeito especial para o acendimento de 1 (um) Fogo de Conselho, seguindo todos os procedimentos de segurança.","Escrever o roteiro de 1 (um) esquete, de acordo com tema definido pelo examinador, e apresentá-la em 1 (um) Fogo de Conselho. Todos os participantes do esquete devem estar caracterizados de acordo com o tema.","Assumir papel de animador em 1 (um) Fogo de Conselho de Grupo Escoteiro ou seção, dirigindo canções e brincadeiras.","Contar uma história em 1 (um) Fogo de Conselho de Grupo Escoteiro ou seção.","Confeccionar e apresentar o seu próprio “manto de Fogo de Conselho.","Planejar e coordenar 1 (um) Fogo de Conselho de seção em todos os seus aspectos, tais como: escolha do local, disposição dos participantes, preparação da fogueira, acendimento, programação, animação, etc.","Ter participado ativamente de 1 (um) Fogo de Conselho em atividade distrital, regional nacional ou internacional."}	9	\N	Pré-requisitos:\r\n\r\nTer participado de no mínimo:\r\n\r\nNível 1: 3 (três) Fogos de Conselho.\r\n\r\nNível 2: 7 (sete) Fogos de Conselho.\r\n\r\nNível 3: 10 (dez) Fogos de Conselho.	4
39	História do Escotismo	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Demonstrar que conhece a história do fundador do Movimento Escoteiro, Baden-Powell, destacando os principais marcos de sua vida, incluindo fatos da sua infância, carreira militar e atuação no Escotismo.","Apresentar a história das origens do Escotismo, destacando o primeiro acampamento na Ilha de Browsea. A apresentação deve ser ilustrada através de cartazes, fotos, vídeos ou outro recurso.","Identificar os principais momentos da história do Escotismo no Brasil, demonstrando conhecimentos básicos sobre cada 1 (um) deles, enfatizando as primeiras iniciativas e a fundação da União dos Escoteiros do Brasil.","Fazer uma exposição de fotos históricas do Movimento Escoteiro em sua sede escoteira, incluindo fotos locais e de eventos internacionais. As fotos devem conter legendas explicativas, indicando o ano e os detalhes sobre o fato.","Pesquisar e apresentar a história da criação do Ramo Lobinho, do Ramo Sênior e do Ramo Pioneiro.","Escolher 1 (um) escotista que tenha sido importante para o desenvolvimento do Escotismo (excetuando-se Baden-Powell) e pesquisar a sua biografia, relatando oralmente ou por escrito.","Pesquisar e apresentar uma palestra sobre o Escotismo no mundo, incluindo a estrutura mundial, o Escritório Mundial e os Centros Internacionais de Escotismo.","Realizar 1 (um) esquete de fogo de conselho, ou peça teatral, que represente algum fato histórico do Movimento Escoteiro ou da vida de Baden-Powell. Os personagens devem estar todos caracterizados.","Montar e apresentar 1 (um) álbum de fotografias e/ou gravuras sobre Gilwell Park, contando suas histórias.","Conhecer a história de seu Grupo Escoteiro, identificando os principais fatos históricos relevantes, demonstrando conhecimentos sobre as cores de seu lenço, sua bandeira, sua sede e principais personagens.","Pesquisar e apresentar, através de esquete ou peça teatral, a história de Caio Viana Martins. Os personagens devem estar todos caracterizados.","Demonstrar que conhece a biografia de Benjamin de Almeida Sodré, o “Velho Lobo”. "}	12	\N	\N	4
40	Lenhador	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Conhecer pelo menos 4 (quatro) tipos de machados e/ou machadinhas, descrevendo seu uso.","Descrever a diferença entre 1 (um) cabo canadense e 1 (um) reto, destacando suas aplicações.","Conhecer os principais tipos de serra de lenhador, traçador ou em arco, e seus usos.","Saber quando se deve usar madeira caída, madeira verde e quando se deve derrubar preventivamente árvores, citando as ferramentas adequadas para cada diferente tipo de árvore, bem como as regras de segurança pertinentes ao operador e ao entorno.","Descrever como é o canto de lenhador em 1 (um) acampamento, sua disposição no campo de matilha/patrulha e as técnicas de segurança que envolvem sua montagem, bem como outras orientações para evitar acidentes.","Afiar e conservar 1 (um) machado, uma machadinha, 1 (um) facão e uma serra, e travar e afiar 1 (um) serrote.","Demonstrar como portar e utilizar de forma correta o machado, a machadinha, a serra e o facão, descrevendo as regras de segurança no uso de cada uma destas ferramentas.","Demonstrar, com a ajuda de adulto, o uso de uma motosserra, destacando os aspectos legais que precisam ser observados.","Substituir o cabo de 1 (um) machado e de uma machadinha, bem como os tipos de madeiras utilizados.","Rachar 1 (um) toco de lenha, observando as regras de segurança.","Desgalhar uma árvore ou vara de madeira e bambu, e abrir 1 (um) tronco em “achas”, observando as regras de segurança.","Explicar como escolher corretamente e como fazer para dar maior durabilidade e resistência, evitando assim o corte desnecessário de madeira: vara de bambu na touceira, e sua conservação.","Explicar como escolher corretamente e como fazer para dar maior durabilidade e resistência, evitando assim o corte desnecessário de madeira: vara de madeira para produzir 1 (um) bastão.","Explicar como escolher corretamente e como fazer para dar maior durabilidade e resistência, evitando assim o corte desnecessário de madeira: tronco de árvore para lenha e para pioneirias.","Explicar a diferença entre 1 (um) cepo (explicando como é feito seu travamento) e 1 (um) cavalete de corte, explicando sua utilidade."}	15	\N	\N	4
41	Marinharia	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Reconhecer 8 (oito) tipos diferentes de embarcações locais.","Identificar as nomenclaturas da embarcação de guarnição (baleeiras, escaler ou veleiros) onde faz suas atividades de rotina, e ter desempenhado as funções de proeiro, bomba d’água e remador quando em atividade.","Demonstrar que sabe arrumar o material e pessoal em uma embarcação, compensando-a satisfatoriamente.","Conhecer o RIPEAM e saber o que fazer em casos de emergências estando a bordo ou avistando de terra uma embarcação com problemas.","Colaborar com pequenos trabalhos de apoio às embarcações: a) em praia, no cais, trapiche e em terra evitando a colisão e manuseando as defensas, ajudando a suspender em seco ou amarrando em poita; b) com o abastecimento de alimentos ou combustível de embarcações; c) dando informações úteis para navegadores que chegam a sua sede oportunamente.","Explicar a influência das correntes sobre a embarcação e saber interpretar a Tábua de Marés.","Demonstrar que sabe: a) organizar e preparar o material da embarcação montando-a; b) distribuir o pessoal em suas funções a bordo; c) compensar satisfatoriamente; d) desembarcar o pessoal com segurança, desmontar a embarcação, realizar a faxina e guardar todo o material.","Manobrar, sozinho, uma pequena embarcação a remo para largar, fundear, atracar, abicar em uma praia e desembarcar material de outra embarcação maior etc.","Conhecer a rosa-dos-ventos e demonstrar como fazer uso da bússola embarcado.","Lançar 1 (um) cabo de reboque, de uma embarcação para outra, e saber dar e receber reboque.","Conhecer os símbolos e saber interpretar uma carta náutica.","Demonstrar noções básicas de meteorologia e levantar a previsão do tempo para no mínimo duas atividades embarcadas realizadas por sua seção."}	12	\N	\N	4
42	Pioneiria	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Fazer e explicar a utilidade de pelo menos quinze nós.","Fazer as amarras quadrada e diagonal, conhecendo sua aplicação.","Fazer as amarras paralela e de tripé, conhecendo sua aplicação.","Construir 1 (um) fogão suspenso e uma mesa de campo.","Demonstrar que conhece as regras de segurança no manuseio de ferramentas.","Mostrar conhecimento sobre 1 (um) dos seguintes assuntos: movimentação de grandes pesos e estiramento de cabos, ancoragem de sustentação, jangadas, cabos de vai-e-vem ou passagens com cabos.","Construir 1 (um) pórtico ou latrina de campo.","Construir 1 (um) canto de lenhador, de acordo com as regras de segurança.","Construir 1 (um) abrigo natural para duas pessoas, utilizando meios existentes no local.","Projetar e coordenar a execução de uma pioneiria de médio porte.","Construir uma cozinha de acampamento.","Afiar ferramentas e conhecer os cuidados para sua manutenção."}	12	\N	\N	4
43	Rastreamento	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Reconhecer, pelo olfato, 8 (oito) em 10 (dez) substâncias de uso comum.","Reconhecer, pela audição, 8 (oito) em 10 (dez) ruídos comuns.","Reconhecer, pelo tato, doze em quinze objetos.","Reconhecer e explicar características que distinguem 5 (cinco) pegadas humanas (pessoa correndo, caminhando, com peso nas costas, andando de ré, mancando etc.).","Seguir satisfatoriamente 3 (três) pistas naturais de aproximadamente quinhentos metros.","Seguir uma pista com pelo menos mil e quinhentos metros e quarenta sinais de pista, identificando pelo menos trinta e 5 (cinco) sinais.","Desenhar e descrever corretamente 1 (um) objeto, depois de observá-lo durante 1 (um) minuto.","Interpretar com razoável correção 3 (três) histórias a partir de rastros na areia, no barro, na neve ou em outro tipo de solo.","Fazer os moldes em gesso de rastros de pássaros, animais, automóveis e bicicletas, rotulando-os com informações alusivas à data e ao local onde foram colhidos."}	9	\N	\N	4
44	Administração	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Entender a necessidade da administração do tempo em sua vida pessoal, demonstrando a importância desta gestão de tempo na organização nas tarefas individuais.","Compor o organograma do Escotismo Mundial, em todos os seus níveis, apresentando-o à seção.","Visitar uma empresa de qualquer ramo de atividade e apresentar 1 (um) relatório que permita demonstrar sua linha de produção e/ou de comercialização e/ ou de prestação de serviço.","Definir os conceitos de administração pública direta, indireta e fundacional.","Demonstrar para seu grupo, seção, ou matilha/patrulha os conceitos e a importância do BALANCED SCORECARD, da ANÁLISE SWOT e BENCHMARKING para uma empresa de qualquer ramo.","Realizar 1 (um) esquete demonstrando qual a diferença entre líder e chefe dentro de uma empresa ou organização.","Relatar a história da administração, seu surgimento, evolução e ideias durante o passar dos anos. Além de mostrar como era e como se entende hoje a profissão de administrador de empresas.","Compreender a origem e o significado da ferramenta 5S para uma empresa.","Fazer uma análise das 5 (cinco) maiores empresas que se destacaram no mercado internacional, demonstrando o porquê elas estão no topo do ranking."}	9	\N	\N	5
45	Agricultura	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Preparar a terra, na presença do examinador, para 1 (um) pequeno plantio de 2 (duas) verduras.","Explicar as diferenças entre fruta e verdura, listando as que se plantam e consomem em maior quantidade em sua comunidade, destacando as principais características (nutrientes).","Manejar os seguintes instrumentos de trabalho: pá, enxada, ancinho e colher de jardineiro.","Realizar 1 (um) processo de germinação e o transplante de uma planta.","Pesquisar e apresentar um trabalho sobre os riscos da agricultura, no que tange ao meio ambiente e à população.","Explicar o que é agronomia, agricultura, fruticultura, horticultura, floricultura e hidroponia.","Realizar uma apresentação a respeito das máquinas agrícolas tradicionais e modernas.","Fazer uma apresentação sobre a importância da agricultura no Brasil.","Cooperar nas tarefas de uma fazenda durante pelo menos 3 (três) dias.","Preparar uma horta, utilizando a hidroponia.","Verificar os níveis de desgaste da terra e conhecer as razões de recuperação, pelo manejo e remanejo de plantio.","Mencionar as pragas, enfermidades, insetos e parasitas que afetam os cultivos da região, indicando medidas corretivas naturais.","Ter conhecimentos, adquiridos pela prática dos seguintes trabalhos: arear, semear, transplantar, cultivar, regar, irrigar, ceifar, colher, secar, encinzar, trilhar, ensacar, etc., de acordo com os costumes da região, com as práticas da agricultura local e com os equipamentos existentes.","Conhecer os modos de manter a terra fértil com adubagem (fertilizantes químicos e naturais), rotação das culturas etc. – e quando utilizá-los.","Conhecer plantas medicinais da região e explicar os seus usos."}	15	2021-04-01	Proposta de revisão: Equipe do Projeto 1000 Hortas -Região Escoteira de São Paulo	5
46	Alfabetização	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Conhecer a importância da alfabetização para 1 (um) país.","Conhecer métodos de alfabetização para adultos e crianças.","Integrar 1 (um) grupo de alfabetização voluntário de sua comunidade, ajudando na preparação de material, ensinando leitura e aplicando atividades recreativas.","Organizar uma campanha de arrecadação de livros entre familiares e vizinhos para montar uma biblioteca e doá-los aos alfabetizadores.","Organizar sessões de leitura de textos em sua família e grupo de amigos, seguindo-se a análise comentada dos textos lidos.","Elaborar 1 (um) relato de sua experiência ao participar de uma equipe de alfabetização e apresentá-la à seção.","Conhecer a organização de uma campanha de alfabetização em sua comunidade, colaborando com sua realização.","Capacitar-se como alfabetizador voluntário.","Organizar uma campanha de alfabetização destinada a 1 (um) mínimo de duas pessoas, durante 1 (um) período de 3 (três) meses, em sua comunidade."}	9	\N	\N	5
47	Animação da Fé	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Frequentar com assiduidade e interesse as celebrações de sua religião.","Relatar os principais preceitos da religião que professa e demonstrar que os está cumprindo, consideradas as condições de sua idade.","Reconhecer e explicar os significados dos principais símbolos de sua religião.","Explicar para sua seção como é a forma de aproximação com o “Ser Superior” em sua religião (oração/prece/louvor/meditação/ ponto/mantra/etc.) e dar alguns exemplos.","Demonstrar que sabe cantar pelo menos 3 (três) músicas (cânticos/ hinos/pontos/ louvores/etc.) dentre as utilizadas frequentemente em momentos de expressão coletiva de sua religião.","Participar ativamente de uma celebração em sua comunidade religiosa, como organizador, leitor, músico, cantor ou em outra função própria de sua religião.","Conhecer alguns textos de sua religião e encontrá-los nos livros sagrados ou em outras fontes de consulta apropriadas.","Apresentar as origens e a história de sua religião.","Correlacionar os artigos da Lei Escoteira ou do lobinho com os seus princípios religiosos e discuti-los com o escotista.","Pesquisar e promover 1 (um) debate com a sua matilha/patrulha ou seção sobre a relação entre a intolerância religiosa e conflitos atuais no Brasil e no Mundo.","Realizar uma pesquisa sobre ao menos 4 (quatro) religiões, apontando suas similaridades e apresentando o resultado a seção.","Conhecer vultos de sua confissão religiosa que sejam exemplo de vivência dos valores expressos na Lei do Lobinho ou na Lei Escoteira.","Dirigir os momentos de reflexão / expressão de fé em pelos menos 3 (três) atividades da sua seção, utilizando textos, dinâmicas, orações/preces e música apropriada.","Participar de pelo menos uma ação social realizada por sua comunidade religiosa, na qual se pratica uma boa ação para com os semelhantes.","Demonstrar esforço para ampliar sua formação religiosa, participando de iniciativas proporcionadas por sua comunidade religiosa."}	15	\N	Pré-requisitos: Ser adepto praticante de uma religião.	5
50	Babá	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Demonstrar que conhece os telefones de emergência de sua localidade.","Descrever regras de segurança a serem observadas quando cuidando de crianças e bebês.","Explicar os cuidados de higiene a observar no trato com crianças e bebês.","Ter noções básicas de primeiros socorros.","Demonstrar como trocar a fralda de 1 (um) bebê.","Preparar uma mamadeira.","Distrair duas crianças, por mais de 4 (quatro) horas.","Explicar como tratar com doenças infantis comuns.","Trabalhar como voluntário durante pelo menos 5 (cinco) períodos, totalizando vinte horas, em uma creche, maternal ou jardim de infância, descrevendo seu funcionamento."}	9	\N	\N	5
51	Barismo	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Conhecer a história do café no Brasil.","Conhecer no mínimo 4 (quatro) métodos de preparo de café.","Conhecer os utensílios de trabalho de 1 (um) barista.","Entender os selos existentes em uma embalagem de café (BSA, ABIC de Pureza, ABIC de Qualidade, RAIN FOREST).","Saber as diferenças entre as classificações de café (Tradicional, Superior, Gourmet e Especial).","Saber degustar 1 (um) café, identificando: aroma, acidez, doçura, corpo, amargor.","Saber preparar 1 (um) café mateiro.","Conhecer as etapas do beneficiamento do café.","Saber a diferença entre café “robusta” e café “arábica”.","Conhecer os componentes de uma máquina de café expresso e seu correto funcionamento.","Conhecer e saber preparar 3 (três) bebidas usando uma máquina de expresso.","Saber o que é Latte Art e aplicar a técnica corretamente."}	12	\N	\N	5
52	Biblioteconomia	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Visitar mais de duas bibliotecas, conhecendo seu funcionamento.","Explicar onde adquirir livros novos e usados.","Ser usuário de alguma biblioteca.","Descrever 1 (um) sistema de classificação de livros.","Mostrar que os livros que possui estão organizados.","Organizar a biblioteca da seção e mantê-la por mais de 6 ((seis) meses.","Descrever as partes de 1 (um) livro.","Indicar pelo menos 6 ((seis) autores famosos e o gênero a que se dedicam.","Demonstrar os procedimentos adequados para cuidar e conservar os livros.","Explicar quais os insetos que atacam o papel e como evitar seu ataque.","Entrevistar uma bibliotecária e apresentar relato à seção.","Organizar e realizar uma campanha de aquisição de livros para a biblioteca da seção.","Demonstrar como encadernar livros.","Apresentar uma lista de pelo menos doze livros recomendados para crianças e jovens.","Montar a ficha bibliográfica de 2 (dois) livros."}	15	\N	\N	5
53	Bolsa de Valores	O jovem tem a liberdade de escolher quaisquer itens para a conquista do nível que desejar, não sendo obrigatório seguir a ordem da numeração dos mesmos.	{"Definir o que é uma Bolsa de Valores.","Explicar a importância da Bolsa de Valores para a economia do país.","Explicar o que são ações de uma empresa.","Conhecer a composição acionária de uma empresa de capital aberto.","Conhecer a estrutura do mercado acionário nacional.","Visitar uma corretora de valores e verificar seu funcionamento, apresentando relatório sobre a experiência.","Explicar como são feitas as operações de compra e venda de ações.","Explicar a globalização do mercado acionário mundial.","Participar de operação em uma simulação de Bolsa de Valores."}	9	\N	\N	5
\.


--
-- Data for Name: progressoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.progressoes (id, nome, descricao, ramo_id) FROM stdin;
1	Lobo Pata-Tenra	Primeira etapa da progressão do Ramo Lobinho, voltada para a integração à alcateia, ao conhecimento da Lei e Promessa do Lobinho e dos símbolos do Movimento Escoteiro.	1
2	Lobo Saltador	Etapa em que o lobinho amplia suas descobertas, desenvolvendo autonomia, convivência em grupo e habilidades básicas por meio das atividades da progressão pessoal.	1
3	Lobo Rastreador	Fase que incentiva a consolidação dos conhecimentos e competências adquiridos, estimulando a curiosidade, a observação e o compromisso com a vida em alcateia.	1
4	Lobo Caçador	Última etapa do desenvolvimento no Ramo Lobinho, marcada pelo aprofundamento das habilidades, participação ativa na alcateia e preparação para novos desafios no Movimento Escoteiro.	1
5	Pista	Primeira etapa da progressão do Ramo Escoteiro, destinada à adaptação à vida em patrulha, ao entendimento dos valores escoteiros e ao desenvolvimento das primeiras habilidades.	2
6	Trilha	Etapa que estimula o escoteiro a explorar novos conhecimentos, fortalecer o trabalho em equipe e ampliar sua autonomia por meio das atividades e desafios da tropa.	2
7	Rumo	Fase voltada ao aperfeiçoamento das competências pessoais, à liderança e ao protagonismo juvenil, incentivando a participação ativa na patrulha e na comunidade.	2
8	Travessia	Última etapa da progressão do Ramo Escoteiro, em que o jovem demonstra maturidade, espírito de serviço e preparo para a passagem ao Ramo Sênior.	2
9	Escalada	Primeira etapa da progressão do Ramo Sênior, focada na integração à tropa, no fortalecimento da autonomia e na superação de desafios pessoais e coletivos.	3
10	Conquista	Etapa intermediária do Ramo Sênior que incentiva o desenvolvimento da liderança, da responsabilidade e do planejamento de projetos e atividades.	3
11	Azimute	Etapa final do Ramo Sênior, caracterizada pela consolidação das competências adquiridas, pelo protagonismo juvenil e pela preparação para o Ramo Pioneiro.	3
12	Insígnia do Comprometimento	Reconhecimento concedido ao jovem do Ramo Pioneiro que demonstra dedicação, responsabilidade e compromisso contínuo com seus objetivos pessoais e com os valores escoteiros.	4
13	Insígnia da Cidadania	Reconhecimento do Ramo Pioneiro destinado ao jovem que participa ativamente da comunidade, exercendo a cidadania, o serviço voluntário e a transformação social.	4
\.


--
-- Data for Name: ramos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ramos (id, nome, idade_min, idade_max, descricao) FROM stdin;
1	Ramo Lobinho	6	10	Destinado a crianças de 6,5 a 10 anos, com atividades voltadas ao desenvolvimento pessoal por meio do ambiente da Jângal.
2	Ramo Escoteiro	11	14	Destinado a jovens de 11 a 14 anos, focado em vida ao ar livre, trabalho em equipe e sistema de patrulhas.
3	Ramo Sênior	15	17	Destinado a adolescentes de 15 a 17 anos, incentivando autonomia, liderança e superação de desafios.
4	Ramo Pioneiro	18	21	Destinado a jovens de 18 a 21 anos, com foco em projetos, serviço à comunidade e desenvolvimento da cidadania.
\.


--
-- Data for Name: ramosconhecimento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ramosconhecimento (id, nome, descricao) FROM stdin;
1	Ciência e Tecnologia	Desenvolve o interesse pela pesquisa, inovação e compreensão do funcionamento do mundo, estimulando o raciocínio lógico, a criatividade e o uso responsável da tecnologia.
2	Cultura	Incentiva a valorização das artes, da história, das tradições e da diversidade cultural, promovendo o respeito e o conhecimento sobre diferentes povos e costumes.
3	Desportos	Estimula a prática de atividades físicas e esportivas, contribuindo para a saúde, o trabalho em equipe, a disciplina e o espírito de superação.
4	Habilidades Escoteiras	Reúne conhecimentos e técnicas próprias do escotismo, como orientação, pioneiria, campismo e sobrevivência, fortalecendo a autonomia.
5	Serviços	Promove a solidariedade, a cidadania e o compromisso com a comunidade, incentivando ações de voluntariado e o desenvolvimento do espírito de servir ao próximo.
\.


--
-- Data for Name: usuarioespecialidades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarioespecialidades (id, usuario_id, especialidade_id, data_conquista, itens_concluidos, nivel) FROM stdin;
\.


--
-- Data for Name: usuarioprogressoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarioprogressoes (id, usuario_id, progressao_id, status, data_conclusao) FROM stdin;
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id, nome, email, senha, categoria, data_integracao, data_nascimento, ramo_id) FROM stdin;
\.


--
-- Name: especialidades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.especialidades_id_seq', 53, true);


--
-- Name: progressoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.progressoes_id_seq', 1, false);


--
-- Name: ramos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ramos_id_seq', 5, true);


--
-- Name: ramosconhecimento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ramosconhecimento_id_seq', 1, false);


--
-- Name: usuarioespecialidades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarioespecialidades_id_seq', 7, true);


--
-- Name: usuarioprogressoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarioprogressoes_id_seq', 4, true);


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 4, true);


--
-- Name: especialidades especialidades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialidades
    ADD CONSTRAINT especialidades_pkey PRIMARY KEY (id);


--
-- Name: progressoes progressoes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progressoes
    ADD CONSTRAINT progressoes_pkey PRIMARY KEY (id);


--
-- Name: ramos ramos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ramos
    ADD CONSTRAINT ramos_pkey PRIMARY KEY (id);


--
-- Name: ramosconhecimento ramosconhecimento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ramosconhecimento
    ADD CONSTRAINT ramosconhecimento_pkey PRIMARY KEY (id);


--
-- Name: usuarioespecialidades uk_usuario_especialidade; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarioespecialidades
    ADD CONSTRAINT uk_usuario_especialidade UNIQUE (usuario_id, especialidade_id);


--
-- Name: usuarioespecialidades usuarioespecialidades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarioespecialidades
    ADD CONSTRAINT usuarioespecialidades_pkey PRIMARY KEY (id);


--
-- Name: usuarioprogressoes usuarioprogressoes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarioprogressoes
    ADD CONSTRAINT usuarioprogressoes_pkey PRIMARY KEY (id);


--
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: especialidades fk_ramo_conhecimento; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialidades
    ADD CONSTRAINT fk_ramo_conhecimento FOREIGN KEY (ramo_conhecimento_id) REFERENCES public.ramosconhecimento(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: progressoes progressoes_ramo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progressoes
    ADD CONSTRAINT progressoes_ramo_id_fkey FOREIGN KEY (ramo_id) REFERENCES public.ramos(id);


--
-- Name: usuarioespecialidades usuarioespecialidades_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarioespecialidades
    ADD CONSTRAINT usuarioespecialidades_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


--
-- Name: usuarioprogressoes usuarioprogressoes_progressao_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarioprogressoes
    ADD CONSTRAINT usuarioprogressoes_progressao_id_fkey FOREIGN KEY (progressao_id) REFERENCES public.progressoes(id);


--
-- Name: usuarioprogressoes usuarioprogressoes_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarioprogressoes
    ADD CONSTRAINT usuarioprogressoes_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


--
-- Name: usuarios usuarios_ramo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_ramo_id_fkey FOREIGN KEY (ramo_id) REFERENCES public.ramos(id);


--
-- PostgreSQL database dump complete
--

\unrestrict fARaglHcpICLbJpWDvzdjPJL8YeesYNrXtpu67NNp3bRc0jCpYwkfQRZsLWWIfw

