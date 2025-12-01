FROM php:8.2-apache

RUN docker-php-ext-install mysqli

# copy app
COPY app/ /var/www/html/

# optional, if you want simple perms
RUN chown -R www-data:www-data /var/www/html
