# Azimute

Sistema web simples para acompanhamento da jornada escoteira, com cadastro de usuários, login, dashboard, perfil, progressões, especialidades e histórico de conquistas.

O projeto foi desenvolvido com PHP, HTML, CSS, JavaScript e PostgreSQL.

## Funcionalidades

- Página inicial com apresentação do projeto e acesso para login ou cadastro.
- Cadastro de usuários com nome, email, senha, categoria, ramo, data de integração e data de nascimento.
- Validação de senha com mínimo de 8 caracteres.
- Login com sessão de usuário.
- Dashboard com resumo da jornada escoteira, progresso geral, especialidades, conquistas e pontos.
- Perfil com dados pessoais, resumo escoteiro, progressões recentes e especialidades recentes.
- Registro e atualização de progressões por ramo escoteiro.
- Registro e atualização de especialidades por ramo de conhecimento.
- Cálculo automático do nível da especialidade conforme os itens concluídos.
- Busca, filtro e paginação no catálogo de especialidades.
- Histórico de conquistas em formato de linha do tempo.
- Logout do usuário.

## Requisitos

Antes de executar o Azimute, verifique se os seguintes itens estão instalados:

- PHP 8.0 ou superior
- Extensão PDO PostgreSQL habilitada (`pdo_pgsql`)
- PostgreSQL instalado e em execução
- Navegador moderno compatível com HTML5
- Git, caso deseje clonar o repositório

## Como Executar

Clone o repositório:

```bash
git clone https://github.com/LorenzoPradalMalosso/ProjetoPHP.git
```

Acesse a pasta do projeto:

```bash
cd ProjetoPHP
```

Crie o banco de dados:

```bash
createdb azimute
```

Importe a estrutura e os dados iniciais:

```bash
psql -d azimute -f backup.sql
```

Inicie o servidor embutido do PHP na raiz do projeto:

```bash
php -S localhost:8000
```

Acesse no navegador:

```text
http://localhost:8000
```

## Banco de Dados

O Azimute utiliza PostgreSQL para persistência dos dados. O arquivo principal de conexão fica em:

```text
database/conexao.php
```

Configuração padrão do projeto:

```text
host: localhost
porta: 5432
banco: azimute
usuário: postgres
senha: postgres
```

Caso seu ambiente use outro usuário, senha, porta ou nome de banco, altere esses dados em `database/conexao.php`.

O script `backup.sql` contém a estrutura do banco e dados iniciais, incluindo ramos, progressões, ramos de conhecimento, especialidades e registros de exemplo.

### Modelo de Dados

O banco usa o schema `public` e chaves primárias inteiras com sequências (`*_id_seq`). A estrutura principal é formada por tabelas de cadastro/base e tabelas que registram as conquistas de cada usuário.

#### `usuarios`

Armazena os dados de cadastro e autenticação dos usuários.

| Campo | Tipo | Restrições | Descrição |
| --- | --- | --- | --- |
| `id` | `integer` | PK, auto incremento | Identificador do usuário |
| `nome` | `varchar(255)` | NOT NULL | Nome completo |
| `email` | `varchar(255)` | NOT NULL, UNIQUE | Email usado no login |
| `senha` | `varchar(255)` | NOT NULL | Senha armazenada com hash |
| `categoria` | `varchar(30)` | NOT NULL | Categoria do usuário no sistema |
| `data_integracao` | `varchar(10)` | NOT NULL | Data de integração informada no cadastro |
| `data_nascimento` | `varchar(10)` | NOT NULL | Data de nascimento informada no cadastro |
| `ramo_id` | `integer` | FK opcional | Ramo escoteiro associado ao usuário |

#### `ramos`

Define os ramos escoteiros usados no cadastro e no filtro de progressões.

| Campo | Tipo | Restrições | Descrição |
| --- | --- | --- | --- |
| `id` | `integer` | PK, auto incremento | Identificador do ramo |
| `nome` | `varchar(30)` | NOT NULL | Nome do ramo |
| `idade_min` | `integer` | NOT NULL | Idade mínima do ramo |
| `idade_max` | `integer` | NOT NULL | Idade máxima do ramo |
| `descricao` | `text` | NOT NULL | Descrição do ramo |

#### `progressoes`

Catálogo de progressões disponíveis por ramo escoteiro.

| Campo | Tipo | Restrições | Descrição |
| --- | --- | --- | --- |
| `id` | `integer` | PK, auto incremento | Identificador da progressão |
| `nome` | `varchar(30)` | NOT NULL | Nome da progressão |
| `descricao` | `text` | NOT NULL | Descrição da progressão |
| `ramo_id` | `integer` | FK opcional | Ramo ao qual a progressão pertence |

#### `usuarioprogressoes`

Registra o andamento de cada usuário em cada progressão.

| Campo | Tipo | Restrições | Descrição |
| --- | --- | --- | --- |
| `id` | `integer` | PK, auto incremento | Identificador do registro |
| `usuario_id` | `integer` | FK opcional | Usuário vinculado |
| `progressao_id` | `integer` | FK opcional | Progressão vinculada |
| `status` | `varchar(30)` | NOT NULL, DEFAULT `pendente`, CHECK | Status da progressão |
| `data_conclusao` | `varchar(10)` | NOT NULL | Data registrada para conclusão ou atualização |

Valores aceitos em `status`: `pendente`, `concluida` e `rejeitada`.

#### `ramosconhecimento`

Define os ramos de conhecimento usados para agrupar especialidades.

| Campo | Tipo | Restrições | Descrição |
| --- | --- | --- | --- |
| `id` | `integer` | PK, auto incremento | Identificador do ramo de conhecimento |
| `nome` | `varchar(30)` | NOT NULL | Nome do ramo de conhecimento |
| `descricao` | `text` | NOT NULL | Descrição do ramo de conhecimento |

#### `especialidades`

Catálogo de especialidades disponíveis no sistema.

| Campo | Tipo | Restrições | Descrição |
| --- | --- | --- | --- |
| `id` | `integer` | PK, auto incremento | Identificador da especialidade |
| `nome` | `varchar(255)` | NOT NULL | Nome da especialidade |
| `descricao` | `text` | NOT NULL | Descrição da especialidade |
| `itens` | `text[]` | NOT NULL | Lista de itens/requisitos da especialidade |
| `quantidade_itens` | `integer` | NOT NULL, CHECK `> 0` | Total de itens da especialidade |
| `data_versao` | `date` | DEFAULT `CURRENT_DATE` | Data da versão da especialidade |
| `nota_tecnica` | `text` | Opcional | Observações ou nota técnica |
| `ramo_conhecimento_id` | `integer` | NOT NULL, FK | Ramo de conhecimento da especialidade |

#### `usuarioespecialidades`

Registra as especialidades conquistadas por cada usuário.

| Campo | Tipo | Restrições | Descrição |
| --- | --- | --- | --- |
| `id` | `integer` | PK, auto incremento | Identificador do registro |
| `usuario_id` | `integer` | FK opcional | Usuário vinculado |
| `especialidade_id` | `integer` | UNIQUE com `usuario_id` | Especialidade vinculada |
| `data_conquista` | `varchar(10)` | NOT NULL | Data de conquista |
| `itens_concluidos` | `integer[]` | NOT NULL, DEFAULT `{}` | Itens concluídos pelo usuário |
| `nivel` | `integer` | NOT NULL, CHECK entre 1 e 3 | Nível calculado da especialidade |

A combinação `usuario_id + especialidade_id` é única, permitindo apenas um registro por especialidade para cada usuário. O dump atual cria chave estrangeira para `usuario_id`; `especialidade_id` é usado como referência lógica pelo sistema nas consultas com `especialidades.id`.

### Relacionamentos

| Origem | Destino | Tipo | Uso |
| --- | --- | --- | --- |
| `usuarios.ramo_id` | `ramos.id` | Muitos para um | Define o ramo do usuário |
| `progressoes.ramo_id` | `ramos.id` | Muitos para um | Agrupa progressões por ramo |
| `usuarioprogressoes.usuario_id` | `usuarios.id` | Muitos para um | Liga progressões ao usuário |
| `usuarioprogressoes.progressao_id` | `progressoes.id` | Muitos para um | Liga o registro à progressão |
| `especialidades.ramo_conhecimento_id` | `ramosconhecimento.id` | Muitos para um | Agrupa especialidades por ramo de conhecimento |
| `usuarioespecialidades.usuario_id` | `usuarios.id` | Muitos para um | Liga especialidades ao usuário |
| `usuarioespecialidades.especialidade_id` | `especialidades.id` | Referência lógica | Liga o registro à especialidade nas consultas |

### Dados Iniciais

O arquivo `backup.sql` também importa dados iniciais com `COPY`, incluindo:

- catálogo de `ramos`;
- catálogo de `progressoes`;
- catálogo de `ramosconhecimento`;
- catálogo de `especialidades`;

## Estrutura Principal

```text
assets/                         Arquivos CSS, JavaScript, imagens e ícones
database/conexao.php            Conexão com o PostgreSQL
includes/                       Arquivos de layout e autenticação
pages/especialidades.php        Catálogo e registro de especialidades
pages/historico_conquistas.php  Histórico de conquistas
pages/perfil.php                Perfil do usuário
pages/progressoes.php           Registro de progressões
backup.sql                      Script do banco de dados
cadastro.php                    Cadastro de usuários
dashboard.php                   Tela inicial após login
index.php                       Página inicial do projeto
login.php                       Login de usuários
logout.php                      Encerramento da sessão
```

## Regras de Negócio

- O usuário deve possuir email único.
- A senha deve possuir no mínimo 8 caracteres.
- O usuário deve estar autenticado para acessar dashboard, perfil, progressões, especialidades e histórico de conquistas.
- Progressões pertencem a um ramo escoteiro.
- Especialidades pertencem a um ramo de conhecimento.
- Uma especialidade registrada para o usuário armazena os itens concluídos, a data de conquista e o nível.
- O nível da especialidade é calculado automaticamente com base na quantidade de itens concluídos.
- O histórico de conquistas reúne progressões concluídas e especialidades registradas.
