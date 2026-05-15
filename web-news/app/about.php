<?php
require __DIR__ . '/config.php';

$docs = db()->query('SELECT * FROM business_documents ORDER BY fiscal_year DESC, id')->fetchAll();

render_header('O nas');
?>
<section class="content">
    <h1>NovaPress Slovenija</h1>
    <p class="lead">NovaPress Slovenija je izmišljena medijska hiša s sedežem v Ljubljani. Portal objavlja dnevne novice, vremenske informacije, komentarje bralcev in poslovne vsebine za oglaševalce.</p>
    <h2>Poslovni oddelek</h2>
    <p>Za oglaševanje in partnerstva pišite na oglasi@novapress.local. Notranji dokumenti so v poslovni bazi portala in niso namenjeni javni objavi.</p>
    <div class="list">
        <?php foreach ($docs as $doc): ?>
            <article>
                <div class="meta"><?= h($doc['owner_department']) ?> · <?= h($doc['classification']) ?> · <?= h((string)$doc['fiscal_year']) ?></div>
                <h2><?= h($doc['doc_title']) ?></h2>
                <p><?= h($doc['summary']) ?></p>
            </article>
        <?php endforeach; ?>
    </div>
</section>
<?php
render_sidebar();
render_footer();
