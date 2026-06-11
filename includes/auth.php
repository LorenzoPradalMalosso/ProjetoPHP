<?php

    if (session_status() !== PHP_SESSION_ACTIVE) {
        session_start();
    }

    if (!isset($_SESSION["usuario_id"])) {
        $scriptDir = trim(str_replace("\\", "/", dirname($_SERVER["SCRIPT_NAME"] ?? "")), "/");
        $basePath = basename($scriptDir) === "pages" ? "../" : "";

        header("Location: {$basePath}login.php");
        exit;
    }

?>
