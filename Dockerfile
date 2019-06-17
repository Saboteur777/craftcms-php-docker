# Use this image as base
FROM php:fpm-alpine
MAINTAINER Otto Radics <otto@webmenedzser.hu>

# Install Craft CMS requirements
RUN apk add --no-cache --virtual .build-deps \
      libxml2-dev \
      shadow \
      autoconf \
      g++ \
      libpng-dev \
      make && \
    apk add --no-cache \
      composer \
      imagemagick-dev \
      imagemagick \
      icu-dev \
      libzip-dev \
      mariadb-client && \
    pecl install imagick-beta && \
    docker-php-ext-install gd intl pdo_mysql soap zip && \
    docker-php-ext-enable imagick opcache && \
    apk del .build-deps

# Fixes: https://github.com/nystudio107/craft-retour/issues/57
# Related: https://github.com/docker-library/php/issues/240, 
# Fix found here: https://github.com/graze/docker-php-alpine/blob/master/7.1/Dockerfile#L56
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted \
        gnu-libiconv

# Add custom PHP settings
ADD php-settings.ini /usr/local/etc/php/conf.d/
