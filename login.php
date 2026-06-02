<?php

    require_once "database/conexao.php";

    session_start();

    // Se já estiver logado
    if (isset($_SESSION["usuario_id"])) {
        header("Location: dashboard.php");
        exit;
    }

    $mensagem = "";

    if ($_SERVER["REQUEST_METHOD"] === "POST") {

        $email = trim($_POST["email"]);
        $senha = $_POST["senha"];

        $stmt = $conexao->prepare("
            SELECT *
            FROM usuarios
            WHERE email = :email
        ");

        $stmt->execute([
            "email" => $email
        ]);

        $usuario = $stmt->fetch(PDO::FETCH_ASSOC);

        if (
            $usuario &&
            password_verify($senha, $usuario["senha"])
        ) {

            $_SESSION["usuario_id"] = $usuario["id"];
            $_SESSION["usuario_nome"] = $usuario["nome"];
            $_SESSION["usuario_categoria"] = $usuario["categoria"];
            $_SESSION["usuario_ramo_id"] = $usuario["ramo_id"];

            header("Location: dashboard.php");
            exit;
        } else {

            $mensagem = "Email ou senha incorretos.";
        }
    }

    include "includes/header.php";
?>

<section>
    <div>
        <h2>Entrar na Azimute</h2>

        <?php if (!empty($mensagem)): ?>
            <p><?= htmlspecialchars($mensagem) ?></p>
        <?php endif; ?>

        <form method="POST">
            <div>
                <label for="email">Email</label>
                <input
                    type="email"
                    id="email"
                    name="email"
                    required>
            </div>
            <div>
                <label for="senha">Senha</label>
                <input
                    type="password"
                    id="senha"
                    name="senha"
                    required>
            </div>
            <button type="submit">
                Entrar
            </button>
        </form>
        <p>
            Não possui conta?
            <a href="cadastro.php">Cadastre-se</a>
        </p>
    </div>
</section>

<?php include "includes/footer.php"; ?>