<?php
    require_once "../includes/auth.php";
    require_once "../database/conexao.php";

    $usuarioId = $_SESSION["usuario_id"];

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

    function calculateAge(?string $date): string
    {
        if (empty($date)) {
            return "Não informado";
        }

        try {
            $birth = new DateTime($date);
            return (string) $birth->diff(new DateTime())->y;
        } catch (Exception $exception) {
            return "Não informado";
        }
    }

    $stmt = $conexao->prepare("
        SELECT
            u.*,
            r.nome AS ramo_nome,
            r.descricao AS ramo_descricao
        FROM usuarios u
        LEFT JOIN ramos r ON r.id = u.ramo_id
        WHERE u.id = :id
    ");
    $stmt->execute(["id" => $usuarioId]);
    $usuario = $stmt->fetch(PDO::FETCH_ASSOC) ?: [];

    $ramoId = $usuario["ramo_id"] ?? null;

    if ($ramoId !== null) {
        $stmt = $conexao->prepare("
            SELECT COUNT(*)::int
            FROM progressoes
            WHERE ramo_id = :ramo_id
        ");
        $stmt->execute(["ramo_id" => (int) $ramoId]);
    } else {
        $stmt = $conexao->query("
            SELECT COUNT(*)::int
            FROM progressoes
        ");
    }
    $totalProgressoes = (int) $stmt->fetchColumn();

    $stmt = $conexao->prepare("
        SELECT COUNT(*)::int
        FROM usuarioprogressoes
        WHERE usuario_id = :usuario_id
          AND status IN ('concluída', 'concluida', 'concluÃ­da')
    ");
    $stmt->execute(["usuario_id" => $usuarioId]);
    $progressoesConcluidas = (int) $stmt->fetchColumn();

    $stmt = $conexao->prepare("
        SELECT COUNT(*)::int
        FROM usuarioespecialidades
        WHERE usuario_id = :usuario_id
    ");
    $stmt->execute(["usuario_id" => $usuarioId]);
    $especialidadesConquistadas = (int) $stmt->fetchColumn();

    $percentualProgresso = $totalProgressoes > 0
        ? min(100, (int) round(($progressoesConcluidas / $totalProgressoes) * 100))
        : 0;

    $stmt = $conexao->prepare("
        SELECT
            p.nome,
            up.status,
            up.data_conclusao
        FROM usuarioprogressoes up
        INNER JOIN progressoes p ON p.id = up.progressao_id
        WHERE up.usuario_id = :usuario_id
        ORDER BY up.id DESC
        LIMIT 5
    ");
    $stmt->execute(["usuario_id" => $usuarioId]);
    $progressoesRecentes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $stmt = $conexao->prepare("
        SELECT
            e.nome,
            rc.nome AS ramo_conhecimento,
            ue.nivel,
            ue.data_conquista,
            COALESCE(array_length(ue.itens_concluidos, 1), 0) AS itens_concluidos,
            e.quantidade_itens
        FROM usuarioespecialidades ue
        INNER JOIN especialidades e ON e.id = ue.especialidade_id
        LEFT JOIN ramosconhecimento rc ON rc.id = e.ramo_conhecimento_id
        WHERE ue.usuario_id = :usuario_id
        ORDER BY ue.id DESC
        LIMIT 6
    ");
    $stmt->execute(["usuario_id" => $usuarioId]);
    $especialidadesRecentes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $stmt = $conexao->prepare("
        SELECT
            COALESCE(rc.nome, 'Sem ramo') AS ramo_conhecimento,
            COUNT(*)::int AS total
        FROM usuarioespecialidades ue
        INNER JOIN especialidades e ON e.id = ue.especialidade_id
        LEFT JOIN ramosconhecimento rc ON rc.id = e.ramo_conhecimento_id
        WHERE ue.usuario_id = :usuario_id
        GROUP BY rc.nome
        ORDER BY total DESC, ramo_conhecimento
        LIMIT 5
    ");
    $stmt->execute(["usuario_id" => $usuarioId]);
    $especialidadesPorRamo = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $nome = $usuario["nome"] ?? "Usuário";
    $idade = calculateAge($usuario["data_nascimento"] ?? null);
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Perfil | Azimute</title>
    <link rel="stylesheet" href="../assets/css/style.css">
</head>
<body class="app-body">
    <div class="app-shell">
        <aside class="app-sidebar">
            <a class="app-logo" href="../dashboard.php" aria-label="Dashboard Azimute">
                <img src="../assets/img/Logo_Nome_Claro.png" alt="Azimute">
            </a>

            <nav class="app-nav" aria-label="Navegação do sistema">
                <a href="../dashboard.php"><span>⌂</span> Dashboard</a>
                <a class="active" href="perfil.php"><span>○</span> Perfil</a>
                <a href="progressoes.php"><span>□</span> Progressões</a>
                <a href="especialidades.php"><span>◇</span> Especialidades</a>
                <a href="#"><span>☆</span> Conquistas</a>
                <a href="#"><span>☷</span> Atividades</a>
                <a href="../logout.php"><span>↳</span> Sair</a>
            </nav>

            <div class="law-card">
                <strong>Deixa o mundo um pouco melhor do que o encontraste.</strong>
                <span>Lei Escoteira</span>
            </div>
        </aside>

        <main class="app-main">
            <header class="app-topbar">
                <button class="menu-button" type="button" aria-label="Abrir menu">☰</button>
                <div class="topbar-user">
                    <span class="avatar"><?= e(substr($nome, 0, 1)) ?></span>
                    <div>
                        <strong><?= e($nome) ?></strong>
                        <span><?= e($usuario["ramo_nome"] ?? "Ramo não informado") ?></span>
                    </div>
                </div>
            </header>

            <section class="profile-header">
                <div class="profile-identity">
                    <span class="profile-avatar"><?= e(substr($nome, 0, 1)) ?></span>
                    <div>
                        <p>Perfil escoteiro</p>
                        <h1><?= e($nome) ?></h1>
                        <span><?= e($usuario["categoria"] ?? "Categoria não informada") ?> • <?= e($usuario["ramo_nome"] ?? "Ramo não informado") ?></span>
                    </div>
                </div>

                <div class="profile-progress-card">
                    <small>Progressão geral</small>
                    <strong><?= $percentualProgresso ?>%</strong>
                    <div class="wide-progress">
                        <span style="width: <?= $percentualProgresso ?>%;"></span>
                    </div>
                </div>
            </section>

            <section class="profile-grid">
                <article class="app-panel personal-panel">
                    <div class="panel-heading">
                        <h2>Dados pessoais</h2>
                    </div>

                    <dl class="info-list">
                        <div>
                            <dt>Nome completo</dt>
                            <dd><?= e($usuario["nome"] ?? "Não informado") ?></dd>
                        </div>
                        <div>
                            <dt>E-mail</dt>
                            <dd><?= e($usuario["email"] ?? "Não informado") ?></dd>
                        </div>
                        <div>
                            <dt>Categoria</dt>
                            <dd><?= e($usuario["categoria"] ?? "Não informada") ?></dd>
                        </div>
                        <div>
                            <dt>Ramo</dt>
                            <dd><?= e($usuario["ramo_nome"] ?? "Não informado") ?></dd>
                        </div>
                        <div>
                            <dt>Data de nascimento</dt>
                            <dd><?= formatDateBr($usuario["data_nascimento"] ?? null) ?></dd>
                        </div>
                        <div>
                            <dt>Idade</dt>
                            <dd><?= $idade === "Não informado" ? $idade : "{$idade} anos" ?></dd>
                        </div>
                        <div>
                            <dt>Integração</dt>
                            <dd><?= formatDateBr($usuario["data_integracao"] ?? null) ?></dd>
                        </div>
                    </dl>
                </article>

                <article class="app-panel profile-summary-panel">
                    <div class="panel-heading">
                        <h2>Resumo escoteiro</h2>
                    </div>

                    <div class="profile-stats">
                        <div>
                            <strong><?= $progressoesConcluidas ?></strong>
                            <span>Progressões concluídas</span>
                        </div>
                        <div>
                            <strong><?= $especialidadesConquistadas ?></strong>
                            <span>Especialidades conquistadas</span>
                        </div>
                        <div>
                            <strong><?= $totalProgressoes ?></strong>
                            <span>Etapas do ramo</span>
                        </div>
                    </div>

                    <p class="profile-note">
                        <?= e($usuario["ramo_descricao"] ?? "Continue registrando sua jornada para acompanhar sua evolução com mais clareza.") ?>
                    </p>
                </article>

                <article class="app-panel">
                    <div class="panel-heading">
                        <h2>Progressões recentes</h2>
                    </div>

                    <?php if (empty($progressoesRecentes)): ?>
                        <p class="empty-state">Nenhuma progressão registrada ainda.</p>
                    <?php else: ?>
                        <div class="timeline-list">
                            <?php foreach ($progressoesRecentes as $progressao): ?>
                                <div>
                                    <span></span>
                                    <div>
                                        <strong><?= e($progressao["nome"]) ?></strong>
                                        <small><?= e($progressao["status"]) ?> • <?= formatDateBr($progressao["data_conclusao"] ?? null) ?></small>
                                    </div>
                                </div>
                            <?php endforeach; ?>
                        </div>
                    <?php endif; ?>
                </article>

                <article class="app-panel">
                    <div class="panel-heading">
                        <h2>Especialidades recentes</h2>
                    </div>

                    <?php if (empty($especialidadesRecentes)): ?>
                        <p class="empty-state">Nenhuma especialidade registrada ainda.</p>
                    <?php else: ?>
                        <div class="specialty-list">
                            <?php foreach ($especialidadesRecentes as $especialidade): ?>
                                <div>
                                    <strong><?= e($especialidade["nome"]) ?></strong>
                                    <span>
                                        <?= e($especialidade["ramo_conhecimento"] ?? "Sem ramo") ?>
                                        • Nível <?= (int) $especialidade["nivel"] ?>
                                        • <?= (int) $especialidade["itens_concluidos"] ?>/<?= (int) $especialidade["quantidade_itens"] ?> itens
                                    </span>
                                </div>
                            <?php endforeach; ?>
                        </div>
                    <?php endif; ?>
                </article>

                <article class="app-panel profile-wide-panel">
                    <div class="panel-heading">
                        <h2>Especialidades por ramo de conhecimento</h2>
                    </div>

                    <?php if (empty($especialidadesPorRamo)): ?>
                        <p class="empty-state">Os dados aparecerão aqui quando houver especialidades cadastradas.</p>
                    <?php else: ?>
                        <div class="knowledge-bars">
                            <?php foreach ($especialidadesPorRamo as $ramo): ?>
                                <?php
                                    $barWidth = $especialidadesConquistadas > 0
                                        ? max(8, (int) round(((int) $ramo["total"] / $especialidadesConquistadas) * 100))
                                        : 0;
                                ?>
                                <div>
                                    <div>
                                        <strong><?= e($ramo["ramo_conhecimento"]) ?></strong>
                                        <span><?= (int) $ramo["total"] ?></span>
                                    </div>
                                    <span class="knowledge-track"><i style="width: <?= $barWidth ?>%;"></i></span>
                                </div>
                            <?php endforeach; ?>
                        </div>
                    <?php endif; ?>
                </article>
            </section>
        </main>
    </div>
</body>
</html>
