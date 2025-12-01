<?php
require_once 'config.php';

$message = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user = $_POST['username'] ?? '';
    $pass = $_POST['password'] ?? '';

    // INTENTIONALLY VULNERABLE
    $sql = "SELECT * FROM users WHERE username='$user' AND password='$pass'";
    $res = $mysqli->query($sql);

    if ($res && $res->num_rows > 0) {
        // any row = success
        header("Location: panel.php");
        exit;
    } else {
        $message = "Login failed";
    }
}
?>
<!DOCTYPE html>
<html>
<head>
  <title>EMR Login</title>
</head>
<body>
  <h1>EMR Login</h1>
  <?php if ($message): ?>
    <p style="color:red;"><?php echo htmlspecialchars($message); ?></p>
  <?php endif; ?>
  <form method="POST">
    <label>Username: <input type="text" name="username"></label><br>
    <label>Password: <input type="password" name="password"></label><br>
    <button type="submit">Login</button>
  </form>
  <p>Hint for CTF: maybe the DB trusts your input too much.</p>
</body>
</html>
