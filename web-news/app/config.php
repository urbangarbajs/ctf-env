<?php
declare(strict_types=1);

function db(): PDO
{
    static $pdo = null;
    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $host = getenv('DB_HOST') ?: '10.10.20.21';
    $db = getenv('DB_NAME') ?: 'news_portal';
    $user = getenv('DB_USER') ?: 'newsUser';
    $pass = getenv('DB_PASS') ?: 'NewsPortal2026!';
    $dsn = "mysql:host={$host};dbname={$db};charset=utf8mb4";

    $pdo = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);

    return $pdo;
}

function h(?string $value): string
{
    return htmlspecialchars((string)$value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function categories(): array
{
    return db()->query('SELECT name, slug FROM categories ORDER BY id')->fetchAll();
}

function most_read(): array
{
    return db()->query('
        SELECT a.id, a.title, c.name AS category
        FROM articles a
        JOIN categories c ON c.id = a.category_id
        ORDER BY (a.breaking * 20) + a.id DESC
        LIMIT 6
    ')->fetchAll();
}

function render_header(string $title = 'NovaPress Slovenija'): void
{
    $xssFlag = getenv('FLAG_XSS') ?: 'NP-CTF{STORED_XSS_IN_NEWSROOM}';
    ?>
<!doctype html>
<html lang="sl">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= h($title) ?> | NovaPress Slovenija</title>
    <link rel="stylesheet" href="/style.css">
    <script>window.NP_XSS_FLAG = "<?= h($xssFlag) ?>";</script>
</head>
<body>
<header class="site-header">
    <div class="topline">Petek, 15. maj 2026 · Neodvisni javni portal</div>
    <div class="masthead">
        <a class="logo" href="/index.php">NovaPress <span>Slovenija</span></a>
        <form class="search" action="/search.php" method="get">
            <input name="q" placeholder="Iskanje novic" autocomplete="off">
            <button type="submit">Išči</button>
        </form>
    </div>
    <nav class="nav">
        <?php foreach (categories() as $cat): ?>
            <a href="/category.php?name=<?= urlencode($cat['name']) ?>"><?= h($cat['name']) ?></a>
        <?php endforeach; ?>
        <a href="/about.php">O nas</a>
    </nav>
</header>
<main class="layout">
    <?php
}

function render_sidebar(): void
{
    ?>
<aside class="sidebar">
    <section class="weather-card">
        <h2>Vreme</h2>
        <div class="temp">18°C</div>
        <p>Ljubljana: spremenljivo oblačno, popoldne možne plohe.</p>
        <a href="/weather.php">Podrobna napoved</a>
    </section>
    <section>
        <h2>Najbolj brano</h2>
        <ol class="most-read">
            <?php foreach (most_read() as $item): ?>
                <li><a href="/article.php?id=<?= (int)$item['id'] ?>"><?= h($item['title']) ?></a></li>
            <?php endforeach; ?>
        </ol>
    </section>
    <section class="newsletter">
        <h2>E-novice</h2>
        <form method="post" action="/about.php">
            <input type="email" name="email" placeholder="ime@primer.si">
            <button type="submit">Prijava</button>
        </form>
    </section>
</aside>
    <?php
}

function render_footer(): void
{
    ?>
</main>
<footer class="footer">
    <span>NovaPress Slovenija</span>
    <a href="/robots.txt">robots.txt</a>
    <a href="/moderator-review.php">Uredniški pregled</a>
</footer>
</body>
</html>
    <?php
}
