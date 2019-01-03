# craftcms-php-docker

**This Docker image aims to be as simple as possible to run Craft CMS - if you have special dependencies, define this image as a base in your Dockerfile (FROM: webmenedzser/craftcms-php) and extend it as you like.**

The image will be based on the php:fpm-alpine image, which ships the latest stable PHP.

Current PHP version is **7.3.0**

### Change user and group of PHP
You can change which user should run PHP - just build your image by extending this one, e.g.: 

```
FROM: webmenedzser/craftcms-php

[...]
RUN apk add shadow && usermod -u 1000 www-data && groupmod -g 1000 www-data
[...]
```

This will change the UID and GID of `www-data` user (which is the default one to run PHP) to 1000:1000. 

### Add custom PHP settings
You can easily add new PHP settings to the image. Just place your `.ini` file(s) in e.g. the `.docker/php` folder, and add it: 

```
FROM: webmenedzser/craftcms-php

[...]
ADD .docker/php/php-settings.ini /usr/local/etc/php/conf.d/
[...]
```
