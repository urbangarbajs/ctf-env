<?php
require __DIR__ . '/config.php';

$breaking = db()->query('
    SELECT a.*, c.name AS category, j.name AS author
    FROM articles a
    JOIN categories c ON c.id = a.category_id
    JOIN journalists j ON j.id = a.journalist_id
    ORDER BY a.breaking DESC, a.published_at DESC
    LIMIT 8
')->fetchAll();

$latest = db()->query('
    SELECT a.*, c.name AS category, j.name AS author
    FROM articles a
    JOIN categories c ON c.id = a.category_id
    JOIN journalists j ON j.id = a.journalist_id
    ORDER BY a.published_at DESC
    LIMIT 10 OFFSET 8
')->fetchAll();

render_header('Naslovnica');
?>
<section class="content">
    <div class="breaking-label">V živo · zadnje novice</div>
    <?php $hero = array_shift($breaking); ?>
    <article class="hero">
        <div class="meta"><?= h($hero['category']) ?> · <?= h($hero['author']) ?> · <?= h($hero['published_at']) ?></div>
        <h1><a href="/article.php?id=<?= (int)$hero['id'] ?>"><?= h($hero['title']) ?></a></h1>
        <p><?= h($hero['lead_text']) ?></p>
    </article>
    <div class="grid">
        <?php foreach ($breaking as $article): ?>
            <article class="card">
                <div class="meta"><?= h($article['category']) ?> · <?= h($article['author']) ?></div>
                <h2><a href="/article.php?id=<?= (int)$article['id'] ?>"><?= h($article['title']) ?></a></h2>
                <p><?= h($article['lead_text']) ?></p>
            </article>
        <?php endforeach; ?>
    </div>
    <h2 class="section-title">Najnovejše</h2>
    <div class="list">
        <?php foreach ($latest as $article): ?>
            <article>
                <div class="meta"><?= h($article['category']) ?> · <?= h($article['author']) ?> · <?= h($article['published_at']) ?></div>
                <h2><a href="/article.php?id=<?= (int)$article['id'] ?>"><?= h($article['title']) ?></a></h2>
                <p><?= h($article['lead_text']) ?></p>
            </article>
        <?php endforeach; ?>
    </div>
</section>
<?php
render_sidebar();
render_footer();
