<?php
    $connection = pg_connect("host=".getenv("PGSQL_HOSTNAME")." dbname=".getenv("PGSQL_DATABASE")." user=".getenv("PGSQL_USER")." password=".getenv("PGSQL_PASSWORD"));
    if($connection) {
        exit;
    } else {
        exit(1);
    }
?>
