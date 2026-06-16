# Azimute

Sistema web simples para gerenciamento da vida escoteira e progressão pessoal.

O Azimute permite cadastro e login de usuários, visualização de perfil, acompanhamento de progressões e registro de especialidades. A aplicação foi desenvolvida com PHP, HTML, CSS e PostgreSQL.

## Como Executar o Sistema

### Requisitos

Antes de executar o Azimute, verifique se os seguintes requisitos estão instalados:

- PHP 8.0 ou superior
- Extensão PDO PostgreSQL habilitada (`pdo_pgsql`)
- PostgreSQL instalado e em execução
- Navegador moderno compatível com HTML5
- Git (opcional, para clonagem do repositório)

### Obtenção do Projeto

Clone o repositório utilizando Git:

```bash
git clone https://github.com/LorenzoPradalMalosso/ProjetoPHP.git
```

Acesse a pasta do projeto:

```bash
cd ProjetoPHP
```

### Banco de Dados

O Azimute utiliza PostgreSQL para persistência dos dados.

Crie o banco:

```bash
createdb azimute
```

Execute o script de estrutura e dados iniciais:

```bash
psql -d azimute -f backup.sql
```

As credenciais de conexão ficam em:

```text
database/conexao.php
```

Por padrão, o projeto usa:

```text
host: localhost
porta: 5432
banco: azimute
usuário: postgres
senha: postgres
```

Caso seu ambiente use outro usuário ou senha, altere esses dados em `database/conexao.php`.

### Inicialização do Servidor

Na raiz do projeto, execute:

```bash
php -S localhost:8000
```

O servidor embutido do PHP será iniciado na porta 8000.

### Acesso à Aplicação

Abra o navegador e acesse:

```text
http://localhost:8000
```

## Funcionalidades

- Cadastro de usuários com validação de senha mínima de 8 caracteres
- Login com sessão de usuário
- Dashboard com resumo da jornada escoteira
- Perfil do usuário
- Registro e atualização de progressões
- Registro e atualização de especialidades

## Estrutura Principal

```text
assets/              Arquivos CSS, JavaScript e imagens
database/            Conexão e script SQL do banco
includes/            Arquivos auxiliares de layout e autenticação
pages/               Páginas internas da aplicação
cadastro.php         Cadastro de usuários
login.php            Login de usuários
dashboard.php        Tela inicial após login
```

## Regras de Negócio

- O usuário deve possuir email único.
- A senha deve possuir no mínimo 8 caracteres.
- O usuário deve estar autenticado para registrar progressões e especialidades.
- Progressões pertencem a um ramo escoteiro.
- Especialidades pertencem a um ramo de conhecimento.
