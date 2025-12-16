<?php
// DB config from environment
$DB_HOST = getenv('DB_HOST') ?: 'db_emr';
$DB_USER = getenv('DB_USER') ?: 'emrAdmin';
$DB_PASS = getenv('DB_PASS') ?: 'P@ssw0rd2026!';
$DB_NAME = getenv('DB_NAME') ?: 'emr_db';

// flag from env
$FLAG_SQLI = getenv('FLAG_SQLI') ?: 'HC-CTF{MRN-2026-CTF-02}';
$FLAG_XSS = getenv('FLAG_XSS') ?: 'HC-CTF{XSS_RELOADED}';

$mysqli = new mysqli($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME);
if ($mysqli->connect_errno) {
    die("DB connection failed: " . $mysqli->connect_error);
}
?>
