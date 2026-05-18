#!/bin/sh
set -eu

for user in ana.zupan matic.kovac tina.mlakar it.podpora editorial-bot; do
    if ! id "$user" >/dev/null 2>&1; then
        adduser --allow-bad-names --disabled-password --gecos "" "$user" >/dev/null 2>&1
    fi
    printf 'Novapress2026!\nNovapress2026!\n' | smbpasswd -s -a "$user" >/dev/null 2>&1 || true
done

mkdir -p /run/samba /var/run/samba
chmod -R a+rX /srv/samba/public /srv/samba/editorial
chmod -R 0777 /srv/samba/dropbox

nmbd --foreground --no-process-group &
exec smbd --foreground --no-process-group
