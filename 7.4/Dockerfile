FROM php:7.4-fpm-alpine3.12
MAINTAINER Otto Radics <hello@ottoradics.com>

# From: https://github.com/craftcms/docker/blob/main/8.1/Dockerfile
# setup general options for environment variables
ARG PHP_MEMORY_LIMIT_ARG="256M"
ENV PHP_MEMORY_LIMIT=${PHP_MEMORY_LIMIT_ARG}
ARG PHP_MAX_EXECUTION_TIME_ARG="120"
ENV PHP_MAX_EXECUTION_TIME=${PHP_MAX_EXECUTION_TIME_ARG}
ARG PHP_UPLOAD_MAX_FILESIZE_ARG="20M"
ENV PHP_UPLOAD_MAX_FILESIZE=${PHP_UPLOAD_MAX_FILESIZE_ARG}
ARG PHP_MAX_INPUT_VARS_ARG="1000"
ENV PHP_MAX_INPUT_VARS=${PHP_MAX_INPUT_VARS_ARG}
ARG PHP_POST_MAX_SIZE_ARG="8M"
ENV PHP_POST_MAX_SIZE=${PHP_POST_MAX_SIZE_ARG}

# setup opcache for environment variables
ARG PHP_OPCACHE_ENABLE_ARG="1"
ENV PHP_OPCACHE_ENABLE=$PHP_OPCACHE_ENABLE_ARG
ARG PHP_OPCACHE_REVALIDATE_FREQ_ARG="0"
ENV PHP_OPCACHE_REVALIDATE_FREQ=$PHP_OPCACHE_REVALIDATE_FREQ_ARG
ARG PHP_OPCACHE_VALIDATE_TIMESTAMPS_ARG="0"
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=$PHP_OPCACHE_VALIDATE_TIMESTAMPS_ARG
ARG PHP_OPCACHE_MAX_ACCELERATED_FILES_ARG="10000"
ENV PHP_OPCACHE_MAX_ACCELERATED_FILES=$PHP_OPCACHE_MAX_ACCELERATED_FILES_ARG
ARG PHP_OPCACHE_MEMORY_CONSUMPTION_ARG="128"
ENV PHP_OPCACHE_MEMORY_CONSUMPTION=$PHP_OPCACHE_MEMORY_CONSUMPTION_ARG
ARG PHP_OPCACHE_MAX_WASTED_PERCENTAGE_ARG="10"
ENV PHP_OPCACHE_MAX_WASTED_PERCENTAGE=$PHP_OPCACHE_MAX_WASTED_PERCENTAGE_ARG
ARG PHP_OPCACHE_INTERNED_STRINGS_BUFFER_ARG="16"
ENV PHP_OPCACHE_INTERNED_STRINGS_BUFFER=$PHP_OPCACHE_INTERNED_STRINGS_BUFFER_ARG
ARG PHP_OPCACHE_FAST_SHUTDOWN_ARG="1"
ENV PHP_OPCACHE_FAST_SHUTDOWN=$PHP_OPCACHE_FAST_SHUTDOWN_ARG

# Fixes: https://github.com/nystudio107/craft-retour/issues/57
# Related: https://github.com/docker-library/php/issues/240,
# Fix found here: https://github.com/graze/docker-php-alpine/blob/master/7.1/Dockerfile#L56
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted gnu-libiconv

# Add custom PHP settings
ADD php-settings.ini /usr/local/etc/php/conf.d/

COPY --from=composer/composer:2-bin /composer /usr/local/bin/composer

# GitHub sources keep a version placeholder that PECL normally replaces.
ARG IMAGICK_VERSION=3.8.1

RUN apk add --no-cache \
      autoconf \
      freetype-dev \
      g++ \
      gifsicle \
      git \
      gmp-dev \
      icu-dev \
      imagemagick \
      imagemagick-dev \
      jpegoptim \
      libjpeg-turbo-dev \
      libpng-dev \
      libwebp-dev \
      libwebp \
      libwebp-tools \
      libxml2-dev \
      libzip-dev \
      make \
      mariadb-client \
      mariadb-connector-c \
      optipng \
      shadow \
      tzdata && \
    curl -fsSL --retry 5 --retry-delay 2 --connect-timeout 15 --max-time 120 \
      "https://github.com/Imagick/imagick/archive/refs/tags/${IMAGICK_VERSION}.tar.gz" \
      -o /tmp/imagick.tar.gz && \
    mkdir -p /tmp/imagick && \
    tar -xzf /tmp/imagick.tar.gz -C /tmp/imagick --strip-components=1 && \
    sed -i "s/@PACKAGE_VERSION@/${IMAGICK_VERSION}/g" /tmp/imagick/php_imagick.h && \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install /tmp/imagick gd gmp intl pdo_mysql soap zip && \
    rm -rf /tmp/imagick /tmp/imagick.tar.gz && \
    docker-php-ext-enable opcache
