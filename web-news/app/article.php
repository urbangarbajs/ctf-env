<?php
require __DIR__ . '/config.php';

$id = (int)($_GET['id'] ?? 1);
$stmt = db()->prepare('
    SELECT a.*, c.name AS category, j.name AS author, j.email AS author_email
    FROM articles a
    JOIN categories c ON c.id = a.category_id
    JOIN journalists j ON j.id = a.journalist_id
    WHERE a.id = ?
');
$stmt->execute([$id]);
$article = $stmt->fetch();

if (!$article) {
    http_response_code(404);
    render_header('Novica ni najdena');
    echo '<section class="content"><h1>Novica ni najdena</h1></section>';
    render_sidebar();
    render_footer();
    exit;
}

$comments = db()->prepare('SELECT * FROM comments WHERE article_id = ? ORDER BY created_at DESC');
$comments->execute([$id]);

render_header($article['title']);
?>
<section class="content">
    <article class="article">
        <div class="meta"><?= h($article['category']) ?> · <?= h($article['author']) ?> · <?= h($article['published_at']) ?></div>
        <h1><?= h($article['title']) ?></h1>
        <p class="lead"><?= h($article['lead_text']) ?></p>
        <?php foreach (preg_split('/\n+/', $article['body']) as $paragraph): ?>
            <p><?= h($paragraph) ?></p>
        <?php endforeach; ?>
        <div class="byline">Avtor: <?= h($article['author']) ?> · <?= h($article['author_email']) ?></div>
    </article>

    <section class="comments">
        <h2>Komentarji bralcev</h2>
        <form class="comment-form" action="/comment.php" method="post">
            <input type="hidden" name="article_id" value="<?= (int)$article['id'] ?>">
            <label>Ime <input name="author_name" required maxlength="120"></label>
            <label>Komentar <textarea name="body" rows="5" required></textarea></label>
            <button type="submit">Oddaj komentar</button>
        </form>
        <?php foreach ($comments as $comment): ?>
            <div class="comment">
                <strong><?= h($comment['author_name']) ?></strong>
                <span><?= h($comment['created_at']) ?> · <?= h($comment['status']) ?></span>
                <div class="comment-body"><?= $comment['body'] ?></div>
            </div>
        <?php endforeach; ?>
    </section>
</section>
<?php
render_sidebar();
render_footer();
