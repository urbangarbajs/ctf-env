FROM ubuntu:22.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    dovecot-imapd dovecot-pop3d postfix python3 && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -r -u 150 -g mail vmail

RUN echo "srv-news-mail.novapress.local" > /etc/mailname
COPY dovecot.conf /etc/dovecot/dovecot.conf
COPY dovecot.passwd /etc/dovecot/dovecot.passwd
COPY postfix-main.cf /etc/postfix/main.cf
COPY postfix-master.cf /tmp/postfix-master.cf
COPY maildir/ /mail/
COPY smtp-stub.py /usr/local/bin/smtp-stub.py
COPY start-mail.sh /usr/local/bin/start-mail.sh

RUN chmod 640 /etc/dovecot/dovecot.passwd && chown dovecot:dovecot /etc/dovecot/dovecot.passwd && \
    chmod +x /usr/local/bin/start-mail.sh /usr/local/bin/smtp-stub.py && \
    chown -R vmail:mail /mail && \
    cat /tmp/postfix-master.cf >> /etc/postfix/master.cf && \
    newaliases

EXPOSE 25 110 143 587

CMD ["/usr/local/bin/start-mail.sh"]
