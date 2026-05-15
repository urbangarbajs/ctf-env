<?php
require __DIR__ . '/config.php';

$q = $_GET['q'] ?? '';
$rows = [];
$error = null;

if ($q !== '') {
    $sql = "SELECT a.id, a.title, c.name AS category, j.name AS author, DATE_FORMAT(a.published_at, '%Y-%m-%d %H:%i') AS published_at FROM articles a JOIN categories c ON c.id = a.category_id JOIN journalists j ON j.id = a.journalist_id WHERE a.title LIKE '%$q%' OR a.lead_text LIKE '%$q%' OR a.body LIKE '%$q%' OR c.name LIKE '%$q%' ORDER BY a.published_at DESC LIMIT 50";

    try {
        $rows = db()->query($sql)->fetchAll();
    } catch (Throwable $e) {
        $error = $e->getMessage();
    }
}

render_header('Iskanje');
?>
<section class="content">
    <h1>Iskanje novic</h1>
    <!-- Search backend returns 5 columns: id,title,category,author,published_at -->
    <form class="wide-search" method="get">
        <input name="q" value="<?= h($q) ?>" placeholder="Vpiši iskalni niz">
        <button type="submit">Išči</button>
    </form>
    <?php if ($error): ?>
        <div class="debug">SQL napaka: <?= h($error) ?></div>
    <?php endif; ?>
    <div class="results">
        <?php foreach ($rows as $row): ?>
            <article class="result">
                <div class="meta">#<?= h((string)$row['id']) ?> · <?= h((string)$row['category']) ?> · <?= h((string)$row['author']) ?> · <?= h((string)$row['published_at']) ?></div>
                <h2><a href="/article.php?id=<?= urlencode((string)$row['id']) ?>"><?= h((string)$row['title']) ?></a></h2>
            </article>
        <?php endforeach; ?>
    </div>
</section>
<?php
render_sidebar();
render_footer();
