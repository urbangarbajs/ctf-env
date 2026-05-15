<?php
require __DIR__ . '/config.php';

$name = $_GET['name'] ?? 'Slovenija';
$stmt = db()->prepare('
    SELECT a.*, c.name AS category, j.name AS author
    FROM articles a
    JOIN categories c ON c.id = a.category_id
    JOIN journalists j ON j.id = a.journalist_id
    WHERE c.name = ?
    ORDER BY a.published_at DESC
');
$stmt->execute([$name]);
$articles = $stmt->fetchAll();

render_header($name);
?>
<section class="content">
    <h1><?= h($name) ?></h1>
    <div class="list">
        <?php foreach ($articles as $article): ?>
            <article>
                <div class="meta"><?= h($article['author']) ?> · <?= h($article['published_at']) ?></div>
                <h2><a href="/article.php?id=<?= (int)$article['id'] ?>"><?= h($article['title']) ?></a></h2>
                <p><?= h($article['lead_text']) ?></p>
            </article>
        <?php endforeach; ?>
    </div>
</section>
<?php
render_sidebar();
render_footer();
