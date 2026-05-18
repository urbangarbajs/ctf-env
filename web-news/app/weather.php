<?php
require __DIR__ . '/config.php';
render_header('Vreme');
?>
<section class="content">
    <h1>Vremenska napoved</h1>
    <p>Ljubljana: 18°C, spremenljivo oblačno. Popoldne so možne kratkotrajne plohe.</p>
    <p>Primorska: do 22°C, zmeren jugozahodnik. Gorenjska: sveže jutro, čez dan oblačnost nad hribi.</p>
</section>
<?php
render_sidebar();
render_footer();
