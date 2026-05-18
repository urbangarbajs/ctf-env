<?php
require __DIR__ . '/config.php';
render_header('O portalu');
?>
<section class="content">
    <h1>O NovaPress Slovenija</h1>
    <p>NovaPress Slovenija je izmišljena medijska hiša za laboratorijske vaje. Portal prikazuje dnevne novice, vreme, rubrike in uredniške informacije.</p>
    <p>Uredništvo trenutno preizkuša nov notranji delovni tok za pripravo osnutkov, preverjanje virov in usklajevanje objav med novinarji.</p>
</section>
<?php
render_sidebar();
render_footer();
