#!/bin/sh
set -eu

COOKIE_JAR=/tmp/novapress-cookies.txt

while true; do
    date -u '+[%Y-%m-%dT%H:%M:%SZ] NovaPress editor traffic cycle'
    curl -sS -m 8 -c "$COOKIE_JAR" http://10.10.20.11/login.php >/dev/null || true
    curl -sS -m 8 -b "$COOKIE_JAR" -c "$COOKIE_JAR" \
        -X POST http://10.10.20.11/login.php \
        --data 'username=ana.zupan' \
        --data 'password=Urednica2026!' >/dev/null || true
    curl -sS -m 8 -b "$COOKIE_JAR" http://10.10.20.11/editor/dashboard.php >/dev/null || true
    curl -sS -m 8 -H 'X-API-Key: np2-api-key-preview-2026' \
        http://10.10.20.61:8080/api/articles >/dev/null || true
    sleep 30
done
