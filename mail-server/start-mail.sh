#!/bin/bash
set -e

service postfix start
service dovecot start
touch /var/log/dovecot.log /var/log/mail.log

echo "Mail services running (Postfix/Dovecot)."
postfix status || true
tail -f /var/log/dovecot.log /var/log/mail.log
