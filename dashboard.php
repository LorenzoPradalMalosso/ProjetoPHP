<?php
    require_once "includes/auth.php";
    require_once "database/conexao.php";

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

    $stmt = $conexao->prepare("
        SELECT
            u.*,
            r.nome AS ramo_nome
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
        FROM usuarioprogressoes
        WHERE usuario_id = :usuario_id
    ");
    $stmt->execute(["usuario_id" => $usuarioId]);
    $progressoesRegistradas = (int) $stmt->fetchColumn();

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

    $pontos = ($progressoesConcluidas * 120) + ($especialidadesConquistadas * 80);
    $conquistas = $progressoesConcluidas + $especialidadesConquistadas;

    if ($ramoId !== null) {
        $stmt = $conexao->prepare("
            SELECT
                p.nome,
                COALESCE(up.status, 'pendente') AS status,
                up.data_conclusao
            FROM progressoes p
            LEFT JOIN usuarioprogressoes up
                   ON up.progressao_id = p.id
                  AND up.usuario_id = :usuario_id
            WHERE p.ramo_id = :ramo_id
            ORDER BY p.id
            LIMIT 6
        ");
        $stmt->execute([
            "usuario_id" => $usuarioId,
            "ramo_id" => (int) $ramoId
        ]);
    } else {
        $stmt = $conexao->prepare("
            SELECT
                p.nome,
                COALESCE(up.status, 'pendente') AS status,
                up.data_conclusao
            FROM progressoes p
            LEFT JOIN usuarioprogressoes up
                   ON up.progressao_id = p.id
                  AND up.usuario_id = :usuario_id
            ORDER BY p.id
            LIMIT 6
        ");
        $stmt->execute(["usuario_id" => $usuarioId]);
    }
    $progressos = $stmt->fetchAll(PDO::FETCH_ASSOC);

    if (empty($progressos)) {
        $progressos = [
            ["nome" => "Descoberta", "status" => "pendente", "data_conclusao" => null],
            ["nome" => "Escalada", "status" => "pendente", "data_conclusao" => null],
            ["nome" => "Travessia", "status" => "pendente", "data_conclusao" => null],
            ["nome" => "Aventura", "status" => "pendente", "data_conclusao" => null],
            ["nome" => "Desafio", "status" => "pendente", "data_conclusao" => null],
            ["nome" => "Liderança", "status" => "pendente", "data_conclusao" => null],
        ];
    }

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
        LIMIT 4
    ");
    $stmt->execute(["usuario_id" => $usuarioId]);
    $especialidadesRecentes = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $objetivos = array_slice(array_values(array_filter($progressos, function ($item) {
        return !in_array($item["status"], ["concluída", "concluida", "concluÃ­da"], true);
    })), 0, 3);

    if (empty($objetivos)) {
        $objetivos = array_slice($progressos, 0, 3);
    }
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Azimute</title>
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="app-body">
    <div class="app-shell">
        <aside class="app-sidebar">
            <a class="app-logo" href="dashboard.php" aria-label="Dashboard Azimute">
                <img src="assets/img/Logo_Nome_Claro.png" alt="Azimute">
            </a>

            <nav class="app-nav" aria-label="Navegação do sistema">
                <a class="active" href="dashboard.php"><span>⌂</span> Dashboard</a>
                <a href="pages/perfil.php"><span>○</span> Perfil</a>
                <a href="pages/progressoes.php"><span>□</span> Progressões</a>
                <a href="pages/especialidades.php"><span>◇</span> Especialidades</a>
                <a href="#"><span>☆</span> Conquistas</a>
                <a href="#"><span>☷</span> Atividades</a>
                <a href="logout.php"><span>↳</span> Sair</a>
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
                    <span class="avatar"><?= e(substr($usuario["nome"] ?? "A", 0, 1)) ?></span>
                    <div>
                        <strong><?= e($usuario["nome"] ?? "Usuário") ?></strong>
                        <span><?= e($usuario["ramo_nome"] ?? "Ramo não informado") ?></span>
                    </div>
                </div>
            </header>

            <section class="dashboard-hero">
                <div>
                    <h1>Olá, <?= e(explode(" ", $usuario["nome"] ?? "Escoteiro")[0]) ?>!</h1>
                    <p>Acompanhe sua jornada escoteira e continue conquistando.</p>
                </div>

                <div class="context-cards">
                    <article>
                        <span class="context-icon">R</span>
                        <div>
                            <small>Ramo Atual</small>
                            <strong><?= e($usuario["ramo_nome"] ?? "Não informado") ?></strong>
                        </div>
                    </article>
                    <article>
                        <span class="context-icon green">T</span>
                        <div>
                            <small>Categoria</small>
                            <strong><?= e($usuario["categoria"] ?? "Não informada") ?></strong>
                        </div>
                    </article>
                </div>
            </section>

            <section class="metric-grid" aria-label="Resumo da jornada">
                <article class="metric-card progress-card">
                    <h2>Progressão Geral</h2>
                    <div class="progress-ring" style="--value: <?= $percentualProgresso ?>;">
                        <strong><?= $percentualProgresso ?>%</strong>
                    </div>
                    <p><?= $progressoesConcluidas ?> de <?= $totalProgressoes ?> itens concluídos</p>
                </article>

                <article class="metric-card">
                    <span class="metric-icon">E</span>
                    <h2>Especialidades</h2>
                    <strong><?= $especialidadesConquistadas ?></strong>
                    <p>Conquistadas</p>
                </article>

                <article class="metric-card">
                    <span class="metric-icon gold">C</span>
                    <h2>Conquistas</h2>
                    <strong><?= $conquistas ?></strong>
                    <p>Registradas</p>
                </article>

                <article class="metric-card">
                    <span class="metric-icon blue">P</span>
                    <h2>Pontos</h2>
                    <strong><?= number_format($pontos, 0, ",", ".") ?></strong>
                    <p>Pontos acumulados</p>
                </article>
            </section>

            <section class="dashboard-grid">
                <article class="app-panel progression-panel">
                    <div class="panel-heading">
                        <h2>Progressão do Ramo: <?= e($usuario["ramo_nome"] ?? "Atual") ?></h2>
                        <a href="pages/progressoes.php">Ver todas</a>
                    </div>

                    <div class="progression-track">
                        <?php foreach ($progressos as $progresso): ?>
                            <?php
                                $done = in_array($progresso["status"], ["concluída", "concluida", "concluÃ­da"], true);
                            ?>
                            <div class="progress-step <?= $done ? "done" : "" ?>">
                                <span></span>
                                <strong><?= e($progresso["nome"]) ?></strong>
                                <small><?= $done ? formatDateBr($progresso["data_conclusao"] ?? null) : "Em andamento" ?></small>
                            </div>
                        <?php endforeach; ?>
                    </div>

                    <div class="wide-progress">
                        <span style="width: <?= $percentualProgresso ?>%;"></span>
                    </div>
                    <p class="progress-caption">Seu progresso atual <strong><?= $percentualProgresso ?>%</strong></p>
                </article>

                <article class="app-panel objectives-panel">
                    <div class="panel-heading">
                        <h2>Próximos Objetivos</h2>
                    </div>

                    <div class="objective-list">
                        <?php foreach ($objetivos as $objetivo): ?>
                            <div class="objective-item">
                                <span></span>
                                <div>
                                    <strong><?= e($objetivo["nome"]) ?></strong>
                                    <small>Status: <?= e($objetivo["status"]) ?></small>
                                </div>
                            </div>
                        <?php endforeach; ?>
                    </div>
                </article>

                <article class="app-panel journey-panel">
                    <div class="panel-heading">
                        <h2>Resumo da sua jornada</h2>
                    </div>
                    <div class="bar-chart" aria-label="Gráfico visual de resumo">
                        <span style="height: 42%;"></span>
                        <span style="height: 58%;"></span>
                        <span style="height: 52%;"></span>
                        <span style="height: 72%;"></span>
                        <span style="height: 61%;"></span>
                        <span style="height: 83%;"></span>
                    </div>
                </article>

                <article class="app-panel specialties-panel">
                    <div class="panel-heading">
                        <h2>Especialidades Recentes</h2>
                        <a href="pages/especialidades.php">Ver todas</a>
                    </div>

                    <?php if (empty($especialidadesRecentes)): ?>
                        <p class="empty-state">Nenhuma especialidade registrada ainda.</p>
                    <?php else: ?>
                        <div class="specialty-list">
                            <?php foreach ($especialidadesRecentes as $especialidade): ?>
                                <div>
                                    <strong><?= e($especialidade["nome"]) ?></strong>
                                    <span><?= e($especialidade["ramo_conhecimento"] ?? "Sem ramo") ?> • Nível <?= (int) $especialidade["nivel"] ?></span>
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
