<?php
require_once 'config.php';
// in real life you'd check session; for CTF we keep it simple

?>
<!DOCTYPE html>
<html>
<head>
  <title>EMR Panel</title>
</head>
<body>
  <h1>Welcome to EMR Admin Panel</h1>
  <p>Because you bypassed login protection, here is your flag:</p>
  <pre><?php echo htmlspecialchars($FLAG_SQLI); ?></pre>

  <p>Try enumerating other data in the DB too…</p>
</body>
</html>
