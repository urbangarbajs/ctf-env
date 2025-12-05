<?php
// DB config from environment
$DB_HOST = getenv('DB_HOST') ?: 'db_emr';
$DB_USER = getenv('DB_USER') ?: 'emrAdmin';
$DB_PASS = getenv('DB_PASS') ?: 'P@ssw0rd!';
$DB_NAME = getenv('DB_NAME') ?: 'emr_db';

// flag from env
$FLAG_SQLI = getenv('FLAG_SQLI') ?: 'FLAG{DEFAULT_SQLI_FLAG}';
$FLAG_XSS = getenv('FLAG_XSS') ?: 'FLAG{DEFAULT_XSS_FLAG}';

$mysqli = new mysqli($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
if ($mysqli->connect_errno) {
    die("DB connection failed: " . $mysqli->connect_error);
}
?>
