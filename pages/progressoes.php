<?php
    require_once "../includes/auth.php";
    require_once "../database/conexao.php";

    $usuarioId = $_SESSION["usuario_id"];
    $mensagem = "";

    function e(?string $value): string
    {
        return htmlspecialchars($value ?? "", ENT_QUOTES, "UTF-8");
    }

    function formatDateBr(?string $date): string
    {
        if (empty($date)) {
            return "Não informado";
        }

        $timestamp = strtotime($date);

        if ($timestamp === false) {
            return $date;
        }

        return date("d/m/Y", $timestamp);
    }

    function isDoneStatus(?string $status): bool
    {
        return $status === "concluida";
    }

    function statusBadgeClass(?string $status): string
    {
        if (isDoneStatus($status)) {
            return "status-concluida";
        }

        if ($status === "rejeitada") {
            return "status-rejeitada";
        }

        return "status-pendente";
    }

    $stmt = $conexao->prepare("
        SELECT
            u.nome,
            u.ramo_id,
            r.nome AS ramo_nome
        FROM usuarios u
        LEFT JOIN ramos r ON r.id = u.ramo_id
        WHERE u.id = :id
    ");
    $stmt->execute(["id" => $usuarioId]);
    $usuario = $stmt->fetch(PDO::FETCH_ASSOC) ?: [];
    $ramoId = $usuario["ramo_id"] ?? null;

    if ($_SERVER["REQUEST_METHOD"] === "POST") {
        $progressaoId = (int) ($_POST["progressao_id"] ?? 0);
        $status = $_POST["status"] ?? "pendente";
        $dataConclusao = $_POST["data_conclusao"] ?: date("Y-m-d");
        $statusValidos = ["pendente", "concluida", "rejeitada"];

        if (!in_array($status, $statusValidos, true)) {
            $mensagem = "Status inválido.";
        } else {
            $params = ["id" => $progressaoId];
            $sql = "SELECT id FROM progressoes WHERE id = :id";

            if ($ramoId !== null) {
                $sql .= " AND ramo_id = :ramo_id";
                $params["ramo_id"] = (int) $ramoId;
            }

            $stmt = $conexao->prepare($sql);
            $stmt->execute($params);

            if (!$stmt->fetch()) {
                $mensagem = "Progressão não encontrada para o seu ramo.";
            } else {
                $stmt = $conexao->prepare("
                    SELECT id
                    FROM usuarioprogressoes
                    WHERE usuario_id = :usuario_id
                      AND progressao_id = :progressao_id
                    LIMIT 1
                ");
                $stmt->execute([
                    "usuario_id" => $usuarioId,
                    "progressao_id" => $progressaoId
                ]);

                if ($stmt->fetch()) {
                    $stmt = $conexao->prepare("
                        UPDATE usuarioprogressoes
                        SET status = :status,
                            data_conclusao = :data_conclusao
                        WHERE usuario_id = :usuario_id
                          AND progressao_id = :progressao_id
                    ");
                } else {
                    $stmt = $conexao->prepare("
                        INSERT INTO usuarioprogressoes (
                            usuario_id,
                            progressao_id,
                            status,
                            data_conclusao
                        )
                        VALUES (
                            :usuario_id,
                            :progressao_id,
                            :status,
                            :data_conclusao
                        )
                    ");
                }

                $stmt->execute([
                    "usuario_id" => $usuarioId,
                    "progressao_id" => $progressaoId,
                    "status" => $status,
                    "data_conclusao" => $dataConclusao
                ]);

                $mensagem = "Progressão atualizada com sucesso.";
            }
        }
    }

    $params = ["usuario_id" => $usuarioId];
    $sql = "
        SELECT
            p.id,
            p.nome,
            p.descricao,
            COALESCE(up.status, 'pendente') AS status,
            up.data_conclusao
        FROM progressoes p
        LEFT JOIN (
            SELECT DISTINCT ON (progressao_id)
                progressao_id,
                status,
                data_conclusao
            FROM usuarioprogressoes
            WHERE usuario_id = :usuario_id
            ORDER BY progressao_id, id DESC
        ) up ON up.progressao_id = p.id
    ";

    if ($ramoId !== null) {
        $sql .= " WHERE p.ramo_id = :ramo_id";
        $params["ramo_id"] = (int) $ramoId;
    }

    $sql .= " ORDER BY p.id";

    $stmt = $conexao->prepare($sql);
    $stmt->execute($params);
    $progressoes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $totalProgressoes = count($progressoes);
    $progressoesConcluidas = count(array_filter($progressoes, function ($progressao) {
        return isDoneStatus($progressao["status"] ?? null);
    }));
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Progressões | Azimute</title>
    <link rel="stylesheet" href="../assets/css/style.css">
    <script src="https://unpkg.com/lucide@latest/dist/umd/lucide.min.js" defer></script>
    <script src="../assets/js/script.js" defer></script>
</head>
<body class="app-body">
    <div class="app-shell">
        <aside class="app-sidebar">
            <a class="app-logo" href="../dashboard.php" aria-label="Dashboard Azimute">
                <img src="../assets/img/Logo_Nome_Claro.png" alt="Azimute">
            </a>

            <nav class="app-nav" aria-label="Navegação do sistema">
                <a href="../dashboard.php"><i data-lucide="layout-dashboard"></i> Dashboard</a>
                <a href="perfil.php"><i data-lucide="user-round"></i> Perfil</a>
                <a class="active" href="progressoes.php"><i data-lucide="route"></i> Progressões</a>
                <a href="especialidades.php"><i data-lucide="badge-check"></i> Especialidades</a>
                <a href="historico_conquistas.php"><i data-lucide="trophy"></i> Conquistas</a>
                <a href="../logout.php"><i data-lucide="log-out"></i> Sair</a>
            </nav>

            <div class="law-card">
                <strong>Deixa o mundo um pouco melhor do que o encontraste.</strong>
                <span>Lei Escoteira</span>
            </div>
        </aside>

        <main class="app-main">
            <header class="app-topbar">
                <button class="menu-button" type="button" aria-label="Abrir menu"><i data-lucide="menu"></i></button>
                <div class="topbar-user">
                    <span class="avatar"><?= e(substr($usuario["nome"] ?? "A", 0, 1)) ?></span>
                    <div>
                        <strong><?= e($usuario["nome"] ?? "Usuário") ?></strong>
                        <span><?= e($usuario["ramo_nome"] ?? "Ramo não informado") ?></span>
                    </div>
                </div>
            </header>

            <section class="page-heading">
                <div>
                    <p>Progressões</p>
                    <h1>Progressão do Ramo: <?= e($usuario["ramo_nome"] ?? "Atual") ?></h1>
                    <span><?= $progressoesConcluidas ?> de <?= $totalProgressoes ?> etapas concluídas</span>
                </div>
            </section>

            <?php if (!empty($mensagem)): ?>
                <p class="app-message"><?= e($mensagem) ?></p>
            <?php endif; ?>

            <?php if (empty($progressoes)): ?>
                <article class="app-panel">
                    <p class="empty-state">Nenhuma progressão cadastrada para este ramo.</p>
                </article>
            <?php else: ?>
                <section class="records-grid">
                    <?php foreach ($progressoes as $progressao): ?>
                        <?php
                            $statusAtual = $progressao["status"] ?? "pendente";
                            $done = isDoneStatus($statusAtual);
                        ?>
                        <article class="record-card <?= $done ? "is-done" : "" ?>">
                            <div class="record-card-heading">
                                <div>
                                    <h2><?= e($progressao["nome"]) ?></h2>
                                    <p><?= e($progressao["descricao"]) ?></p>
                                </div>
                                <span class="status-badge <?= statusBadgeClass($statusAtual) ?>"><?= e($statusAtual) ?></span>
                            </div>

                            <form class="inline-form" method="POST">
                                <input type="hidden" name="progressao_id" value="<?= (int) $progressao["id"] ?>">
                                <div>
                                    <label for="status-<?= (int) $progressao["id"] ?>">Status</label>
                                    <select id="status-<?= (int) $progressao["id"] ?>" name="status">
                                        <option value="pendente" <?= $statusAtual === "pendente" ? "selected" : "" ?>>Pendente</option>
                                        <option value="concluida" <?= isDoneStatus($statusAtual) ? "selected" : "" ?>>Concluída</option>
                                        <option value="rejeitada" <?= $statusAtual === "rejeitada" ? "selected" : "" ?>>Rejeitada</option>
                                    </select>
                                </div>
                                <div>
                                    <label for="data-<?= (int) $progressao["id"] ?>">Data</label>
                                    <input
                                        type="date"
                                        id="data-<?= (int) $progressao["id"] ?>"
                                        name="data_conclusao"
                                        value="<?= e($progressao["data_conclusao"] ?? date("Y-m-d")) ?>">
                                </div>
                                <button type="submit">Salvar</button>
                            </form>

                            <small>Última data registrada: <?= formatDateBr($progressao["data_conclusao"] ?? null) ?></small>
                        </article>
                    <?php endforeach; ?>
                </section>
            <?php endif; ?>
        </main>
    </div>
    <script>
        window.addEventListener("DOMContentLoaded", function () {
            if (window.lucide) {
                window.lucide.createIcons();
            }
        });
    </script>
</body>
</html>
