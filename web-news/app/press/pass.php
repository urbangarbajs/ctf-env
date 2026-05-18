<?php
require __DIR__ . '/../config.php';

$passes = [
    '1001' => ['name' => 'Lara Vidmar', 'role' => 'novinarka', 'status' => 'javno potrjen'],
    '1002' => ['name' => 'Tadej Hribar', 'role' => 'zunanji urednik', 'status' => 'javno potrjen'],
    '1003' => ['name' => 'Tina Mlakar', 'role' => 'vremenska urednica', 'status' => 'javno potrjen'],
    '9001' => ['name' => 'Zaupni uredniški vir', 'role' => 'neobjavljen profil', 'status' => 'interno', 'flag' => 'NP2-CTF{IDOR_UNPUBLISHED_PRESS_PASS}'],
];

$id = (string)($_GET['id'] ?? '1001');
if (!isset($passes[$id])) {
    http_response_code(404);
    render_header('Press pass ni najden');
    echo '<section class="content"><h1>Press pass ni najden</h1></section>';
    render_sidebar();
    render_footer();
    exit;
}

$pass = $passes[$id];
render_header('Press pass');
?>
<section class="content narrow">
    <h1>NovaPress press pass</h1>
    <div class="press-pass">
        <div class="meta">ID <?= h($id) ?> · <?= h($pass['status']) ?></div>
        <h2><?= h($pass['name']) ?></h2>
        <p><?= h($pass['role']) ?></p>
        <?php if (isset($pass['flag'])): ?>
            <p class="flag"><?= h($pass['flag']) ?></p>
        <?php endif; ?>
    </div>
</section>
<?php
render_sidebar();
render_footer();
