<?php
require_once 'config.php';

$term = $_GET['term'] ?? '';
$error = '';
$rows = [];

if ($term !== '') {
    // Vulnerable SQL search (deliberately concat user input)
    $sql = "SELECT mrn AS c1, name AS c2, note AS c3 FROM patients WHERE mrn LIKE '%$term%' OR name LIKE '%$term%'";
    $result = $mysqli->query($sql);
    if ($result) {
        while ($row = $result->fetch_assoc()) {
            $rows[] = $row;
        }
    } else {
        $error = $mysqli->error;
    }
}

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
    <?php if ($error): ?>
      <p style="color:red;">DB error: <?php echo htmlspecialchars($error); ?></p>
    <?php endif; ?>
    <?php if ($rows): ?>
      <table border="1" cellpadding="4">
        <tr><th>Col1</th><th>Col2</th><th>Col3</th></tr>
        <?php foreach ($rows as $row): ?>
          <tr>
            <td><?php echo htmlspecialchars($row['c1']); ?></td>
            <td><?php echo htmlspecialchars($row['c2']); ?></td>
            <td><?php echo htmlspecialchars($row['c3']); ?></td>
          </tr>
        <?php endforeach; ?>
      </table>
      <p>Legacy query pulls from patients table; creative inputs (UNION, wildcards) may reveal other data.</p>
    <?php endif; ?>
    <p>If your JavaScript executes, you will see the flag in the rendered output.</p>
    <script>
      // XSS flag kept server-side for rendering when attacker payload runs
      const xssFlag = "<?php echo $FLAG_XSS; ?>";
    </script>
  <?php endif; ?>
</body>
</html>
