<?php
$url = parse_url(getenv("DATABASE_URL"));
$host = $url["host"] ?? null;
$username = $url["user"] ?? null;
$password = $url["pass"] ?? null;
$database = substr($url["path"] ?? "", 1);

putenv("DB_HOST=$host");
putenv("DB_USERNAME=$username");
putenv("DB_PASSWORD=$password");
putenv("DB_DATABASE=$database");

