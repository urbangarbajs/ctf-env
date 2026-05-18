<?php
require __DIR__ . '/../config.php';

if (($_COOKIE['NPSESSID'] ?? '') !== 'np2-ana-session-2026') {
    http_response_code(403);
    render_header('Dostop zavrnjen');
    echo '<section class="content"><h1>Dostop zavrnjen</h1><p>Potrebna je uredniška seja.</p></section>';
    render_sidebar();
    render_footer();
    exit;
}

render_header('Uredniška nadzorna plošča');
?>
<section class="content">
    <h1>Uredniška nadzorna plošča</h1>
    <p>Prijavljena urednica: Ana Zupan</p>
    <p>Sejni pregled: NP2-CTF{CLEARTEXT_HTTP_SESSION_CAPTURED}</p>
    <div class="status-box">Notranji API za osnutke je v pilotnem načinu. Pregled povezav poteka ročno pred objavo.</div>
</section>
<?php
render_sidebar();
render_footer();
