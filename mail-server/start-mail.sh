#!/bin/bash
set -e

mkdir -p /mail/matic.kovac@novapress.local/{cur,new,tmp}
chown -R vmail:mail /mail

service dovecot start
python3 /usr/local/bin/smtp-stub.py &
touch /var/log/dovecot.log /var/log/mail.log

echo "NovaPress mail services running (SMTP stub + Dovecot)."
tail -f /var/log/dovecot.log /var/log/mail.log
