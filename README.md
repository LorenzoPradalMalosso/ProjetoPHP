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
