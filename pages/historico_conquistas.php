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

    function conquestIcon(string $type): string
    {
        return $type === "progressao" ? "route" : "badge-check";
    }

    function conquestClass(string $type): string
    {
        return $type === "progressao" ? "timeline-progressao" : "timeline-especialidade";
    }

    $stmt = $conexao->prepare("
        SELECT
            u.nome,
            r.nome AS ramo_nome
        FROM usuarios u
        LEFT JOIN ramos r ON r.id = u.ramo_id
        WHERE u.id = :id
    ");
    $stmt->execute(["id" => $usuarioId]);
    $usuario = $stmt->fetch(PDO::FETCH_ASSOC) ?: [];

    $stmt = $conexao->prepare("
        SELECT *
        FROM (
            SELECT
                'progressao' AS tipo,
                p.nome AS titulo,
                COALESCE(r.nome, 'Progressão') AS categoria,
                p.descricao AS descricao,
                up.data_conclusao AS data_evento,
                NULL::INTEGER AS nivel,
                NULL::INTEGER AS itens_concluidos,
                NULL::INTEGER AS quantidade_itens,
                120 AS pontos,
                up.id AS origem_id
            FROM usuarioprogressoes up
            INNER JOIN progressoes p ON p.id = up.progressao_id
            LEFT JOIN ramos r ON r.id = p.ramo_id
            WHERE up.usuario_id = :usuario_id_progressao
              AND up.status IN ('concluída', 'concluida', 'concluÃ­da')

            UNION ALL

            SELECT
                'especialidade' AS tipo,
                e.nome AS titulo,
                COALESCE(rc.nome, 'Especialidade') AS categoria,
                e.descricao AS descricao,
                ue.data_conquista AS data_evento,
                ue.nivel AS nivel,
                COALESCE(array_length(ue.itens_concluidos, 1), 0)::INTEGER AS itens_concluidos,
                e.quantidade_itens AS quantidade_itens,
                80 AS pontos,
                ue.id AS origem_id
            FROM usuarioespecialidades ue
            INNER JOIN especialidades e ON e.id = ue.especialidade_id
            LEFT JOIN ramosconhecimento rc ON rc.id = e.ramo_conhecimento_id
            WHERE ue.usuario_id = :usuario_id_especialidade
        ) conquistas
        ORDER BY
            CASE
                WHEN data_evento ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN data_evento::DATE
                ELSE NULL
            END DESC NULLS LAST,
            origem_id DESC
    ");
    $stmt->execute([
        "usuario_id_progressao" => $usuarioId,
        "usuario_id_especialidade" => $usuarioId
    ]);
    $conquistas = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $totalConquistas = count($conquistas);
    $totalProgressoes = count(array_filter($conquistas, function ($conquista) {
        return ($conquista["tipo"] ?? "") === "progressao";
    }));
    $totalEspecialidades = $totalConquistas - $totalProgressoes;
    $totalPontos = array_sum(array_map(function ($conquista) {
        return (int) ($conquista["pontos"] ?? 0);
    }, $conquistas));
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Histórico de Conquistas | Azimute</title>
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
                <a href="progressoes.php"><i data-lucide="route"></i> Progressões</a>
                <a href="especialidades.php"><i data-lucide="badge-check"></i> Especialidades</a>
                <a class="active" href="historico_conquistas.php"><i data-lucide="trophy"></i> Conquistas</a>
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

            <section class="page-heading history-heading">
                <div>
                    <p>Conquistas</p>
                    <h1>Histórico da jornada</h1>
                    <span><?= $totalConquistas ?> conquista<?= $totalConquistas === 1 ? "" : "s" ?> registrada<?= $totalConquistas === 1 ? "" : "s" ?></span>
                </div>
            </section>

            <section class="history-summary-grid" aria-label="Resumo de conquistas">
                <article>
                    <span>Progressões</span>
                    <strong><?= $totalProgressoes ?></strong>
                </article>
                <article>
                    <span>Especialidades</span>
                    <strong><?= $totalEspecialidades ?></strong>
                </article>
                <article>
                    <span>Pontos</span>
                    <strong><?= number_format($totalPontos, 0, ",", ".") ?></strong>
                </article>
            </section>

            <?php if (empty($conquistas)): ?>
                <article class="app-panel">
                    <p class="empty-state">Nenhuma conquista registrada ainda. Conclua uma progressão ou registre uma especialidade para iniciar sua linha do tempo.</p>
                </article>
            <?php else: ?>
                <section class="vertical-timeline" aria-label="Linha do tempo de conquistas">
                    <?php foreach ($conquistas as $conquista): ?>
                        <?php
                            $tipo = (string) $conquista["tipo"];
                            $isEspecialidade = $tipo === "especialidade";
                        ?>
                        <article class="timeline-entry <?= e(conquestClass($tipo)) ?>">
                            <div class="timeline-marker" aria-hidden="true">
                                <i data-lucide="<?= e(conquestIcon($tipo)) ?>"></i>
                            </div>

                            <div class="timeline-card">
                                <div class="timeline-card-header">
                                    <div>
                                        <span class="timeline-type"><?= $isEspecialidade ? "Especialidade" : "Progressão" ?></span>
                                        <h2><?= e($conquista["titulo"] ?? "Conquista") ?></h2>
                                    </div>
                                    <time datetime="<?= e($conquista["data_evento"] ?? "") ?>"><?= formatDateBr($conquista["data_evento"] ?? null) ?></time>
                                </div>

                                <p><?= e($conquista["descricao"] ?? "") ?></p>

                                <div class="timeline-meta">
                                    <span><?= e($conquista["categoria"] ?? "Sem categoria") ?></span>
                                    <?php if ($isEspecialidade): ?>
                                        <span>Nível <?= (int) $conquista["nivel"] ?></span>
                                        <span><?= (int) $conquista["itens_concluidos"] ?>/<?= (int) $conquista["quantidade_itens"] ?> itens</span>
                                    <?php endif; ?>
                                    <span><?= (int) $conquista["pontos"] ?> pontos</span>
                                </div>
                            </div>
                        </article>
                    <?php endforeach; ?>
                </section>
            <?php endif; ?>
        </main>
    </div>
</body>
</html>
