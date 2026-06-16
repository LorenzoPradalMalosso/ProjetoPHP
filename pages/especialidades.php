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

    function pageUrl(array $overrides = []): string
    {
        $params = $_GET;

        foreach ($overrides as $key => $value) {
            if ($value === null || $value === "") {
                unset($params[$key]);
            } else {
                $params[$key] = $value;
            }
        }

        $query = http_build_query($params);

        return $query === "" ? "especialidades.php" : "especialidades.php?{$query}";
    }

    function decodeItems(?string $json): array
    {
        if (empty($json)) {
            return [];
        }

        $items = json_decode($json, true);

        return is_array($items) ? $items : [];
    }

    function selectedItemsFromPost(int $maxItems): array
    {
        $items = $_POST["itens_concluidos"] ?? [];

        if (!is_array($items)) {
            $items = [$items];
        }

        $selected = [];

        foreach ($items as $item) {
            $itemNumber = (int) $item;

            if ($itemNumber >= 1 && $itemNumber <= $maxItems) {
                $selected[$itemNumber] = $itemNumber;
            }
        }

        ksort($selected);

        return array_values($selected);
    }

    function pgIntArrayLiteral(array $values): string
    {
        return "{" . implode(",", array_map("intval", $values)) . "}";
    }

    function calculateSpecialtyLevel(int $totalItems, int $completedItems): int
    {
        if ($totalItems <= 0 || $completedItems <= 0) {
            return 0;
        }

        if ($completedItems >= $totalItems) {
            return 3;
        }

        if ($completedItems >= (int) ceil(($totalItems * 2) / 3)) {
            return 2;
        }

        if ($completedItems >= (int) ceil($totalItems / 3)) {
            return 1;
        }

        return 0;
    }

    function minimumItemsForLevel(int $totalItems, int $level): int
    {
        if ($level === 3) {
            return $totalItems;
        }

        return (int) ceil(($totalItems * $level) / 3);
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

    if ($_SERVER["REQUEST_METHOD"] === "POST") {
        $especialidadeId = (int) ($_POST["especialidade_id"] ?? 0);
        $dataConquista = $_POST["data_conquista"] ?: date("Y-m-d");

        $stmt = $conexao->prepare("
            SELECT id, quantidade_itens
            FROM especialidades
            WHERE id = :id
        ");
        $stmt->execute(["id" => $especialidadeId]);
        $especialidade = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$especialidade) {
            $mensagem = "Especialidade não encontrada.";
        } else {
            $totalItens = (int) $especialidade["quantidade_itens"];
            $itensConcluidos = selectedItemsFromPost($totalItens);
            $nivel = calculateSpecialtyLevel($totalItens, count($itensConcluidos));
            $minimoNivel1 = minimumItemsForLevel($totalItens, 1);

            if (count($itensConcluidos) === 0) {
                $mensagem = "Selecione pelo menos um item concluido para registrar a especialidade.";
            } elseif ($nivel === 0) {
                $mensagem = "Para registrar esta especialidade, selecione pelo menos {$minimoNivel1} item(ns) concluido(s).";
            } else {
                $stmt = $conexao->prepare("
                INSERT INTO usuarioespecialidades (
                    usuario_id,
                    especialidade_id,
                    data_conquista,
                    itens_concluidos,
                    nivel
                )
                VALUES (
                    :usuario_id,
                    :especialidade_id,
                    :data_conquista,
                    CAST(:itens_concluidos AS INT[]),
                    :nivel
                )
                ON CONFLICT (usuario_id, especialidade_id)
                DO UPDATE SET
                    data_conquista = EXCLUDED.data_conquista,
                    itens_concluidos = EXCLUDED.itens_concluidos,
                    nivel = EXCLUDED.nivel
            ");

                $stmt->execute([
                    "usuario_id" => $usuarioId,
                    "especialidade_id" => $especialidadeId,
                    "data_conquista" => $dataConquista,
                    "itens_concluidos" => pgIntArrayLiteral($itensConcluidos),
                    "nivel" => $nivel
                ]);

                $mensagem = "Especialidade registrada com sucesso. Nivel {$nivel} calculado automaticamente.";
            }
        }
    }

    $busca = trim($_GET["busca"] ?? "");
    $ramoConhecimentoId = (int) ($_GET["ramo"] ?? 0);
    $paginaAtual = max(1, (int) ($_GET["pagina"] ?? 1));
    $porPagina = 12;
    $offset = ($paginaAtual - 1) * $porPagina;

    $stmt = $conexao->prepare("
        SELECT
            COUNT(e.id)::int AS total,
            COUNT(ue.id)::int AS conquistadas
        FROM especialidades e
        LEFT JOIN usuarioespecialidades ue
               ON ue.especialidade_id = e.id
              AND ue.usuario_id = :usuario_id
    ");
    $stmt->execute(["usuario_id" => $usuarioId]);
    $totais = $stmt->fetch(PDO::FETCH_ASSOC) ?: ["total" => 0, "conquistadas" => 0];

    $stmt = $conexao->prepare("
        SELECT
            rc.id,
            rc.nome,
            COUNT(e.id)::int AS total,
            COUNT(ue.id)::int AS conquistadas
        FROM ramosconhecimento rc
        LEFT JOIN especialidades e ON e.ramo_conhecimento_id = rc.id
        LEFT JOIN usuarioespecialidades ue
               ON ue.especialidade_id = e.id
              AND ue.usuario_id = :usuario_id
        GROUP BY rc.id, rc.nome
        ORDER BY rc.id
    ");
    $stmt->execute(["usuario_id" => $usuarioId]);
    $ramosConhecimento = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $where = [];
    $params = ["usuario_id" => $usuarioId];

    if ($ramoConhecimentoId > 0) {
        $where[] = "e.ramo_conhecimento_id = :ramo";
        $params["ramo"] = $ramoConhecimentoId;
    }

    if ($busca !== "") {
        $where[] = "(e.nome ILIKE :busca OR e.descricao ILIKE :busca OR rc.nome ILIKE :busca)";
        $params["busca"] = "%{$busca}%";
    }

    $whereSql = empty($where) ? "" : "WHERE " . implode(" AND ", $where);

    $stmt = $conexao->prepare("
        SELECT COUNT(*)::int
        FROM especialidades e
        LEFT JOIN ramosconhecimento rc ON rc.id = e.ramo_conhecimento_id
        {$whereSql}
    ");
    $stmt->execute(array_filter($params, function ($key) {
        return $key !== "usuario_id";
    }, ARRAY_FILTER_USE_KEY));
    $totalFiltrado = (int) $stmt->fetchColumn();
    $totalPaginas = max(1, (int) ceil($totalFiltrado / $porPagina));

    if ($paginaAtual > $totalPaginas) {
        $paginaAtual = $totalPaginas;
        $offset = ($paginaAtual - 1) * $porPagina;
    }

    $stmt = $conexao->prepare("
        SELECT
            e.id,
            e.nome,
            e.descricao,
            e.quantidade_itens,
            array_to_json(e.itens) AS itens_json,
            rc.id AS ramo_conhecimento_id,
            rc.nome AS ramo_conhecimento,
            ue.nivel,
            ue.data_conquista,
            COALESCE(array_length(ue.itens_concluidos, 1), 0) AS itens_concluidos,
            array_to_json(COALESCE(ue.itens_concluidos, ARRAY[]::INTEGER[])) AS itens_concluidos_json
        FROM especialidades e
        LEFT JOIN ramosconhecimento rc ON rc.id = e.ramo_conhecimento_id
        LEFT JOIN usuarioespecialidades ue
               ON ue.especialidade_id = e.id
              AND ue.usuario_id = :usuario_id
        {$whereSql}
        ORDER BY rc.id, e.nome
        LIMIT {$porPagina}
        OFFSET {$offset}
    ");
    $stmt->execute($params);
    $especialidades = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Especialidades | Azimute</title>
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
                <a class="active" href="especialidades.php"><i data-lucide="badge-check"></i> Especialidades</a>
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

            <section class="page-heading specialty-heading">
                <div>
                    <p>Especialidades</p>
                    <h1>Catálogo de especialidades</h1>
                    <span><?= (int) $totais["conquistadas"] ?> de <?= (int) $totais["total"] ?> especialidades registradas</span>
                </div>
            </section>

            <section class="specialty-summary-grid" aria-label="Resumo por ramo de conhecimento">
                <a class="filter-card <?= $ramoConhecimentoId === 0 ? "active" : "" ?>" href="<?= e(pageUrl(["ramo" => null, "pagina" => 1])) ?>">
                    <span>Todas</span>
                    <strong><?= (int) $totais["total"] ?></strong>
                    <small><?= (int) $totais["conquistadas"] ?> registradas</small>
                </a>
                <?php foreach ($ramosConhecimento as $ramo): ?>
                    <a class="filter-card <?= $ramoConhecimentoId === (int) $ramo["id"] ? "active" : "" ?>" href="<?= e(pageUrl(["ramo" => (int) $ramo["id"], "pagina" => 1])) ?>">
                        <span><?= e($ramo["nome"]) ?></span>
                        <strong><?= (int) $ramo["total"] ?></strong>
                        <small><?= (int) $ramo["conquistadas"] ?> registradas</small>
                    </a>
                <?php endforeach; ?>
            </section>

            <form class="specialty-toolbar" method="GET">
                <div>
                    <label for="busca">Buscar</label>
                    <input
                        type="search"
                        id="busca"
                        name="busca"
                        placeholder="Nome, descrição ou ramo"
                        value="<?= e($busca) ?>">
                </div>
                <div>
                    <label for="ramo">Ramo de conhecimento</label>
                    <select id="ramo" name="ramo">
                        <option value="">Todos os ramos</option>
                        <?php foreach ($ramosConhecimento as $ramo): ?>
                            <option value="<?= (int) $ramo["id"] ?>" <?= $ramoConhecimentoId === (int) $ramo["id"] ? "selected" : "" ?>>
                                <?= e($ramo["nome"]) ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <button type="submit">Filtrar</button>
                <a class="btn btn-outline" href="especialidades.php">Limpar</a>
            </form>

            <?php if (!empty($mensagem)): ?>
                <p class="app-message"><?= e($mensagem) ?></p>
            <?php endif; ?>

            <div class="results-line">
                <span><?= $totalFiltrado ?> resultado<?= $totalFiltrado === 1 ? "" : "s" ?></span>
                <span>Página <?= $paginaAtual ?> de <?= $totalPaginas ?></span>
            </div>

            <?php if (empty($especialidades)): ?>
                <article class="app-panel">
                    <p class="empty-state">Nenhuma especialidade encontrada para os filtros selecionados.</p>
                </article>
            <?php else: ?>
                <section class="records-grid specialty-records">
                    <?php foreach ($especialidades as $especialidade): ?>
                        <?php
                            $conquistada = !empty($especialidade["data_conquista"]);
                            $itens = decodeItems($especialidade["itens_json"] ?? null);
                            $itensConcluidos = array_map("intval", decodeItems($especialidade["itens_concluidos_json"] ?? null));
                            $itensConcluidosSet = array_fill_keys($itensConcluidos, true);
                            $totalItensCard = (int) $especialidade["quantidade_itens"];
                            $minimoNivel1Card = minimumItemsForLevel($totalItensCard, 1);
                            $minimoNivel2Card = minimumItemsForLevel($totalItensCard, 2);
                        ?>
                        <article class="record-card specialty-card <?= $conquistada ? "is-done" : "" ?>">
                            <div class="record-card-heading">
                                <div>
                                    <span class="knowledge-badge knowledge-<?= (int) $especialidade["ramo_conhecimento_id"] ?>">
                                        <?= e($especialidade["ramo_conhecimento"] ?? "Sem ramo") ?>
                                    </span>
                                    <h2><?= e($especialidade["nome"]) ?></h2>
                                    <p><?= e($especialidade["descricao"]) ?></p>
                                </div>
                                <span class="status-badge <?= $conquistada ? "level-badge level-" . (int) $especialidade["nivel"] : "status-pendente" ?>">
                                    <?= $conquistada ? "Nível " . (int) $especialidade["nivel"] : "Pendente" ?>
                                </span>
                            </div>

                            <dl class="compact-info">
                                <div>
                                    <dt>Itens</dt>
                                    <dd><?= (int) $especialidade["itens_concluidos"] ?>/<?= (int) $especialidade["quantidade_itens"] ?></dd>
                                </div>
                                <div>
                                    <dt>Conquista</dt>
                                    <dd><?= formatDateBr($especialidade["data_conquista"] ?? null) ?></dd>
                                </div>
                            </dl>

                            <?php if (!empty($itens)): ?>
                                <details class="item-details" <?= !empty($itensConcluidos) ? "open" : "" ?>>
                                    <summary>Selecionar itens concluídos</summary>
                                    <ol class="specialty-items">
                                        <?php foreach ($itens as $indice => $item): ?>
                                            <?php $itemNumero = $indice + 1; ?>
                                            <li>
                                                <label class="specialty-item-option" for="item-<?= (int) $especialidade["id"] ?>-<?= $itemNumero ?>">
                                                    <input
                                                        type="checkbox"
                                                        id="item-<?= (int) $especialidade["id"] ?>-<?= $itemNumero ?>"
                                                        name="itens_concluidos[]"
                                                        value="<?= $itemNumero ?>"
                                                        form="especialidade-form-<?= (int) $especialidade["id"] ?>"
                                                        data-specialty-item="<?= (int) $especialidade["id"] ?>"
                                                        data-total-items="<?= $totalItensCard ?>"
                                                        data-min-level-one="<?= $minimoNivel1Card ?>"
                                                        data-min-level-two="<?= $minimoNivel2Card ?>"
                                                        <?= isset($itensConcluidosSet[$itemNumero]) ? "checked" : "" ?>>
                                                    <span><?= e((string) $item) ?></span>
                                                </label>
                                            </li>
                                        <?php endforeach; ?>
                                    </ol>
                                </details>
                            <?php endif; ?>

                            <form id="especialidade-form-<?= (int) $especialidade["id"] ?>" class="inline-form" method="POST">
                                <input type="hidden" name="especialidade_id" value="<?= (int) $especialidade["id"] ?>">
                                <div>
                                    <label>Nível automático</label>
                                    <div class="auto-level-box" data-auto-level-for="<?= (int) $especialidade["id"] ?>">
                                        <?= $conquistada ? "Nivel " . (int) $especialidade["nivel"] : "Selecione os itens" ?>
                                    </div>
                                    <small class="level-rule">
                                        N1: <?= $minimoNivel1Card ?> | N2: <?= $minimoNivel2Card ?> | N3: <?= $totalItensCard ?>
                                    </small>
                                </div>
                                <div>
                                    <label for="data-<?= (int) $especialidade["id"] ?>">Data</label>
                                    <input
                                        type="date"
                                        id="data-<?= (int) $especialidade["id"] ?>"
                                        name="data_conquista"
                                        value="<?= e($especialidade["data_conquista"] ?? date("Y-m-d")) ?>">
                                </div>
                                <button type="submit">
                                    <?= $conquistada ? "Atualizar" : "Registrar" ?>
                                </button>
                            </form>
                        </article>
                    <?php endforeach; ?>
                </section>

                <nav class="pagination" aria-label="Paginação de especialidades">
                    <?php if ($paginaAtual > 1): ?>
                        <a href="<?= e(pageUrl(["pagina" => $paginaAtual - 1])) ?>">Anterior</a>
                    <?php else: ?>
                        <span>Anterior</span>
                    <?php endif; ?>

                    <strong><?= $paginaAtual ?> / <?= $totalPaginas ?></strong>

                    <?php if ($paginaAtual < $totalPaginas): ?>
                        <a href="<?= e(pageUrl(["pagina" => $paginaAtual + 1])) ?>">Próxima</a>
                    <?php else: ?>
                        <span>Próxima</span>
                    <?php endif; ?>
                </nav>
            <?php endif; ?>
        </main>
    </div>
</body>
</html>
