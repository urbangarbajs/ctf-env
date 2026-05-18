<?php
require __DIR__ . '/../config.php';

function lab_allowed_url(string $url): array
{
    $parts = parse_url($url);
    if (!$parts || !isset($parts['scheme'], $parts['host'])) {
        return [false, 'URL ni veljaven.'];
    }

    $scheme = strtolower($parts['scheme']);
    if (!in_array($scheme, ['http', 'https'], true)) {
        return [false, 'Dovoljena sta samo HTTP in HTTPS.'];
    }

    $host = $parts['host'];
    $ip = filter_var($host, FILTER_VALIDATE_IP) ? $host : gethostbyname($host);
    if (!filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4)) {
        return [false, 'Gostitelja ni mogoče razrešiti.'];
    }

    $long = ip2long($ip);
    $start = ip2long('10.10.20.1');
    $end = ip2long('10.10.20.254');
    if ($long < $start || $long > $end) {
        return [false, 'Predogled je omejen na laboratorijsko omrežje.'];
    }

    return [true, $ip];
}

$url = trim($_GET['url'] ?? '');
$body = null;
$error = null;

if ($url !== '') {
    [$ok, $message] = lab_allowed_url($url);
    if ($ok) {
        $context = stream_context_create([
            'http' => [
                'timeout' => 4,
                'ignore_errors' => true,
                'header' => "User-Agent: NovaPressPreview/2026\r\n",
            ],
        ]);
        $body = @file_get_contents($url, false, $context);
        if ($body === false) {
            $error = 'Predogled vira ni uspel.';
        }
    } else {
        $error = $message;
    }
}

render_header('Predogled virov');
?>
<section class="content">
    <h1>Predogled zunanjega vira</h1>
    <p>Uredniško orodje prikaže kratek predogled vira pred pripravo osnutka.</p>
    <form class="wide-search" method="get">
        <input name="url" value="<?= h($url) ?>" placeholder="http://primer.local/vir">
        <button type="submit">Prikaži</button>
    </form>
    <?php if ($error): ?><div class="error"><?= h($error) ?></div><?php endif; ?>
    <?php if ($body !== null && !$error): ?>
        <pre class="preview"><?= h(substr($body, 0, 5000)) ?></pre>
    <?php endif; ?>
</section>
<?php
render_sidebar();
render_footer();
