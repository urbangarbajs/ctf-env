<?php
require __DIR__ . '/config.php';

render_header('Vreme');
?>
<section class="content">
    <h1>Vreme</h1>
    <div class="weather-grid">
        <article><h2>Ljubljana</h2><div class="temp">18°C</div><p>Spremenljivo oblačno, popoldne možna ploha.</p></article>
        <article><h2>Maribor</h2><div class="temp">20°C</div><p>Delno jasno, zvečer šibak severni veter.</p></article>
        <article><h2>Koper</h2><div class="temp">22°C</div><p>Pretežno oblačno, ob morju jugozahodnik.</p></article>
        <article><h2>Kranjska Gora</h2><div class="temp">14°C</div><p>Popoldne plohe, nad 1800 metri možnost sodre.</p></article>
    </div>
</section>
<?php
render_sidebar();
render_footer();
