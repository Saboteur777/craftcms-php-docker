# Use this image as base
FROM php:fpm-alpine
MAINTAINER Otto Radics <otto@webmenedzser.hu>

# Install Craft CMS requirements
RUN apk add --no-cache --virtual .build-deps \
      libxml2-dev \
      shadow \
      autoconf \
      g++ \
      make && \
    apk add --no-cache \
      imagemagick-dev \
      imagemagick \
      icu-dev \
      libzip-dev \
      mariadb-client && \
    pecl install imagick-beta && \
    docker-php-ext-install intl pdo_mysql zip && \
    docker-php-ext-enable imagick opcache && \
    apk del .build-deps

# Add custom PHP settings
ADD php-settings.ini /usr/local/etc/php/conf.d/
