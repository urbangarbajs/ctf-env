<?php
require __DIR__ . '/config.php';

$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';
    if ($username === 'ana.zupan' && $password === 'Urednica2026!') {
        setcookie('NPSESSID', 'np2-ana-session-2026', 0, '/', '', false, false);
        header('Location: /editor/dashboard.php');
        exit;
    }
    $error = 'Napačno uporabniško ime ali geslo.';
}

render_header('Prijava uredništva');
?>
<section class="content narrow">
    <h1>Prijava uredništva</h1>
    <?php if ($error): ?><p class="error"><?= h($error) ?></p><?php endif; ?>
    <form class="login-form" method="post">
        <label>Uporabniško ime <input name="username" autocomplete="username"></label>
        <label>Geslo <input name="password" type="password" autocomplete="current-password"></label>
        <button type="submit">Prijava</button>
    </form>
</section>
<?php
render_sidebar();
render_footer();
