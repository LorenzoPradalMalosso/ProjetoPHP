<?php
    $scriptDir = trim(str_replace("\\", "/", dirname($_SERVER["SCRIPT_NAME"] ?? "")), "/");
    $basePath = basename($scriptDir) === "pages" ? "../" : "";
    $pageTitle = $pageTitle ?? "Azimute";
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= htmlspecialchars($pageTitle) ?></title>
    <link rel="stylesheet" href="<?= $basePath ?>assets/css/style.css">
</head>
<body>
    <header class="site-header">
        <a class="brand" href="<?= $basePath ?>index.php" aria-label="Página inicial da Azimute">
            <img class="brand-symbol" src="<?= $basePath ?>assets/img/Logo_Claro.png" alt="">
            <img class="brand-wordmark" src="<?= $basePath ?>assets/img/Nome_Claro.png" alt="Azimute">
        </a>

        <nav class="main-nav" aria-label="Menu principal">
            <a href="<?= $basePath ?>index.php#inicio">Início</a>
            <a href="<?= $basePath ?>index.php#interface">Interface</a>
            <a href="<?= $basePath ?>index.php#sobre">Sobre</a>
        </nav>

        <a class="btn btn-primary header-login" href="<?= $basePath ?>login.php">Entrar</a>
    </header>
