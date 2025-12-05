FROM ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    dovecot-imapd dovecot-pop3d postfix && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -r -u 150 -g mail vmail

COPY dovecot.conf /etc/dovecot/dovecot.conf
COPY dovecot.passwd /etc/dovecot/dovecot.passwd
COPY postfix-main.cf /etc/postfix/main.cf
COPY maildir/ /mail/
COPY start-mail.sh /usr/local/bin/start-mail.sh

RUN chmod 640 /etc/dovecot/dovecot.passwd && chown root:root /etc/dovecot/dovecot.passwd
RUN chmod +x /usr/local/bin/start-mail.sh

EXPOSE 25 110 143 587

CMD ["/usr/local/bin/start-mail.sh"]
