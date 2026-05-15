<?php
require __DIR__ . '/config.php';

$articleId = (int)($_POST['article_id'] ?? 1);
$author = trim($_POST['author_name'] ?? 'Anonimni bralec');
$body = $_POST['body'] ?? '';

if ($body !== '') {
    $stmt = db()->prepare('
        INSERT INTO comments (article_id, author_name, body, created_at, status)
        VALUES (?, ?, ?, NOW(), "pending")
    ');
    $stmt->execute([$articleId, $author ?: 'Anonimni bralec', $body]);
}

header('Location: /article.php?id=' . $articleId . '#comments');
