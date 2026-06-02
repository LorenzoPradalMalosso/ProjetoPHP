<?php

    require_once "database/conexao.php";

    $mensagem = "";

    if ($_SERVER["REQUEST_METHOD"] === "POST") {

        $nome = trim($_POST["nome"]);
        $email = trim($_POST["email"]);
        $senha = password_hash($_POST["senha"], PASSWORD_DEFAULT);
        $categoria = $_POST["categoria"];
        $ramo_id = $_POST["ramo_id"];
        $data_integracao = $_POST["data_integracao"];
        $data_nascimento = $_POST["data_nascimento"];

        // VERIFICA SE O EMAIL JÁ EXISTE
        $stmt = $conexao->prepare(
            "SELECT id FROM usuarios WHERE email = :email"
        );

        $stmt->execute([
            "email" => $email
        ]);

        if ($stmt->fetch()) {
            $mensagem = "Este email já está cadastrado.";
        } else {
            try {
                $sql = "
                    INSERT INTO usuarios (
                        nome,
                        email,
                        senha,
                        categoria,
                        ramo_id,
                        data_integracao,
                        data_nascimento
                    )
                    VALUES (
                        :nome,
                        :email,
                        :senha,
                        :categoria,
                        :ramo_id,
                        :data_integracao,
                        :data_nascimento
                    )
                ";

                $stmt = $conexao->prepare($sql);

                $stmt->execute([
                    "nome" => $nome,
                    "email" => $email,
                    "senha" => $senha,
                    "categoria" => $categoria,
                    "ramo_id" => $ramo_id,
                    "data_integracao" => $data_integracao,
                    "data_nascimento" => $data_nascimento
                ]);

                $mensagem = "Usuário cadastrado com sucesso!";
                $_SESSION['mensagem'] = "Usuário cadastrado com sucesso!";
                header("Location: login.php");
                exit;
            }
            catch (PDOException $e) {
                $mensagem = "Erro ao cadastrar o usuário";
            }
        }
    }
    $ramos = $conexao->query("
        SELECT id, nome
        FROM ramos
        ORDER BY id
    ")->fetchAll(PDO::FETCH_ASSOC);

    include "includes/header.php";
?>

<section>
    <div>
        <div>
            <div>
                <div>
                    <div>
                        <h2>Cadastre-se na Azimute</h2>
                        <p>
                            Preencha seus dados para começar sua jornada escoteira.
                        </p>
                        <?php if (!empty($mensagem)): ?>
                            <p><?= htmlspecialchars($mensagem) ?></p>
                        <?php endif; ?>
                        <form method="POST">
                            <div>
                                <label for="nome">Nome completo</label>
                                <input
                                    type="text"
                                    id="nome"
                                    name="nome"
                                    placeholder="Digite seu nome"
                                    required>
                            </div>
                            <div>
                                <label for="email">Email</label>
                                <input
                                    type="email"
                                    id="email"
                                    name="email"
                                    placeholder="Digite seu email"
                                    required>
                            </div>
                            <div>
                                <label for="senha">Senha</label>
                                <input
                                    type="password"
                                    id="senha"
                                    name="senha"
                                    placeholder="Crie uma senha"
                                    required>
                            </div>
                            <div>
                                <label for="categoria">Categoria</label>
                                <select
                                    id="categoria"
                                    name="categoria"
                                    required>
                                    <option value="">
                                        Selecione uma categoria
                                    </option>
                                    <option value="Escoteiro">
                                        Escoteiro
                                    </option>
                                    <option value="Escotista">
                                        Escotista
                                    </option>
                                </select>
                            </div>
                            <div>
                                <label for="ramo_id">Ramo</label>
                                <select
                                    id="ramo_id"
                                    name="ramo_id"
                                    required>
                                    <option value="">
                                        Selecione um ramo
                                    </option>
                                    <?php foreach ($ramos as $ramo): ?>
                                        <option value="<?= $ramo['id'] ?>">
                                            <?= htmlspecialchars($ramo['nome']) ?>
                                        </option>
                                    <?php endforeach; ?>
                                </select>
                            </div>
                            <div>
                                <label for="data_integracao">
                                    Data de integração
                                </label>
                                <input
                                    type="date"
                                    id="data_integracao"
                                    name="data_integracao"
                                    required>
                            </div>
                            <div>
                                <label for="data_nascimento">
                                    Data de nascimento
                                </label>
                                <input
                                    type="date"
                                    id="data_nascimento"
                                    name="data_nascimento"
                                    required>
                            </div>
                            <button type="submit">
                                Criar conta
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<?php include "includes/footer.php"; ?>