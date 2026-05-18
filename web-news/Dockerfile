FROM php:8.2-apache

RUN docker-php-ext-install pdo_mysql mysqli

COPY novapress-apache.conf /etc/apache2/conf-available/novapress-apache.conf
COPY app/ /var/www/html/

RUN a2enconf novapress-apache \
    && chown -R www-data:www-data /var/www/html

EXPOSE 80
