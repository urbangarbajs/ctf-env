FROM php:8.2-apache

RUN apt-get update && apt-get install -y openssl openssh-server && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install mysqli
RUN a2enmod headers rewrite ssl

# self-signed certificate for HTTPS (CTF only)
RUN mkdir -p /etc/apache2/ssl && \
    openssl req -x509 -nodes -days 3650 -subj "/CN=healthyclinic" \
    -newkey rsa:2048 \
    -keyout /etc/apache2/ssl/selfsigned.key \
    -out /etc/apache2/ssl/selfsigned.crt

# mimic old Apache banner for CTF identification
COPY apache.conf /etc/apache2/conf-enabled/zz_ctf.conf
COPY ssl.conf /etc/apache2/sites-available/ssl.conf
RUN a2ensite ssl.conf

# copy app
COPY app/ /var/www/html/

RUN chown -R www-data:www-data /var/www/html

RUN mkdir -p /var/run/sshd
COPY start-web.sh /usr/local/bin/start-web.sh
RUN chmod +x /usr/local/bin/start-web.sh

CMD ["/usr/local/bin/start-web.sh"]
