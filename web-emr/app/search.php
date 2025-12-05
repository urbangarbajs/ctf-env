<?php
require_once 'config.php';

$term = $_GET['term'] ?? '';

// Intentionally reflected XSS: do not sanitize
$logLine = sprintf("[%s] User search term: %s\n", date('c'), $term);
file_put_contents('/tmp/search.log', $logLine, FILE_APPEND);
?>
<!DOCTYPE html>
<html>
<head>
  <title>Patient Search</title>
</head>
<body>
  <h1>Legacy Search</h1>
  <form method="GET">
    <label>Search term: <input type="text" name="term" value="<?php echo $term; ?>"></label>
    <button type="submit">Search</button>
  </form>

  <?php if ($term): ?>
    <h2>Results for: <?php echo $term; ?></h2>
    <p>Nothing found. Maybe try a different payload?</p>
    <p>Debug echo: <?php echo $term; ?></p>
    <p>Hint: Admin reviews <code>/tmp/search.log</code>. Reflected payloads render directly here.</p>
    <p>If your JavaScript executes, you will see the flag in the rendered output.</p>
    <script>
      // XSS flag kept server-side for rendering when attacker payload runs
      const xssFlag = "<?php echo $FLAG_XSS; ?>";
    </script>
  <?php endif; ?>
</body>
</html>
