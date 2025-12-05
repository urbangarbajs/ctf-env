<?php
require_once 'config.php';

// No session validation for CTF purposes
$patients = $mysqli->query("SELECT mrn, note FROM patients WHERE note LIKE '%CTF%'");
$patientFlag = '';
if ($patients && $row = $patients->fetch_assoc()) {
    $patientFlag = $row['mrn'];
}
?>
<!DOCTYPE html>
<html>
<head>
  <title>EMR Panel</title>
</head>
<body>
  <h1>Welcome to EMR Admin Panel</h1>
  <p>Because you bypassed login protection, here is your SQLi flag:</p>
  <pre><?php echo htmlspecialchars($FLAG_SQLI); ?></pre>

  <h2>Patient inventory</h2>
  <p>Look for patient notes to finish the task: <strong><?php echo htmlspecialchars($patientFlag); ?></strong></p>

  <p>Try enumerating other data in the DB too…</p>
  <p>Need search? Use the vulnerable <a href="search.php?term=test">search form</a>.</p>
</body>
</html>
