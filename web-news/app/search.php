<?php
require __DIR__ . '/config.php';

$q = trim($_GET['q'] ?? '');
$rows = [];

if ($q !== '') {
    $stmt = db()->prepare('
        SELECT a.id, a.title, c.name AS category, j.name AS author, DATE_FORMAT(a.published_at, "%Y-%m-%d %H:%i") AS published_at
        FROM articles a
        JOIN categories c ON c.id = a.category_id
        JOIN journalists j ON j.id = a.journalist_id
        WHERE a.title LIKE ? OR a.lead_text LIKE ? OR a.body LIKE ? OR c.name LIKE ?
        ORDER BY a.published_at DESC
        LIMIT 50
    ');
    $needle = '%' . $q . '%';
    $stmt->execute([$needle, $needle, $needle, $needle]);
    $rows = $stmt->fetchAll();
}

render_header('Iskanje');
?>
<section class="content">
    <h1>Iskanje novic</h1>
    <form class="wide-search" method="get">
        <input name="q" value="<?= h($q) ?>" placeholder="Vpiši iskalni niz">
        <button type="submit">Išči</button>
    </form>
    <div class="results">
        <?php foreach ($rows as $row): ?>
            <article class="result">
                <div class="meta">#<?= h((string)$row['id']) ?> · <?= h((string)$row['category']) ?> · <?= h((string)$row['author']) ?> · <?= h((string)$row['published_at']) ?></div>
                <h2><a href="/article.php?id=<?= urlencode((string)$row['id']) ?>"><?= h((string)$row['title']) ?></a></h2>
            </article>
        <?php endforeach; ?>
        <?php if ($q !== '' && !$rows): ?>
            <p>Ni zadetkov za izbrani iskalni niz.</p>
        <?php endif; ?>
    </div>
</section>
<?php
render_sidebar();
render_footer();
