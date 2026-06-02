<?php

    $host = "localhost";
    $port = "5432";
    $dbname = "azimute";
    $user = "postgres";
    $password = "postgres";

    $conexao = new PDO(
        "pgsql:host=$host;
        port=$port;
        dbname=$dbname",
        $user,
        $password
    )

?>