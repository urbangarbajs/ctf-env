<?php
require __DIR__ . '/config.php';

$comments = db()->query('
    SELECT cm.*, a.title
    FROM comments cm
    JOIN articles a ON a.id = cm.article_id
    ORDER BY cm.created_at DESC
    LIMIT 25
')->fetchAll();

render_header('Uredniški pregled komentarjev');
?>
<section class="content">
    <h1>Uredniški pregled komentarjev</h1>
    <p class="lead">Simulacija zaslona, ki ga uredniki uporabljajo za hiter pregled zadnjih komentarjev.</p>
    <?php foreach ($comments as $comment): ?>
        <article class="moderation-item">
            <div class="meta"><?= h($comment['title']) ?> · <?= h($comment['author_name']) ?> · <?= h($comment['created_at']) ?></div>
            <div class="comment-body"><?= $comment['body'] ?></div>
        </article>
    <?php endforeach; ?>
</section>
<?php
render_sidebar();
render_footer();
