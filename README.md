# craftcms-php-docker

[![Docker images](https://github.com/Saboteur777/craftcms-php-docker/actions/workflows/docker-images.yml/badge.svg)](https://github.com/Saboteur777/craftcms-php-docker/actions/workflows/docker-images.yml)
![Docker Pull count](https://badgen.net/docker/pulls/webmenedzser/craftcms-php)
![Last commit](https://badgen.net/github/last-commit/Saboteur777/craftcms-php-docker)
![Keybase.io PGP](https://badgen.net/keybase/pgp/Saboteur777)

**This Docker image aims to be as simple as possible to run Craft CMS - if you have special dependencies, define this image as a base in your Dockerfile (FROM: webmenedzser/craftcms-php:latest) and extend it as you like.**

The image is based on the php:fpm-alpine image.

### Automatic builds

GitHub Actions rebuilds the `7.4`, `8.1`, `8.2` and `8.5` tags daily at 03:17 UTC and after changes to their build files on `master`. You can also start a build from **Actions > Docker images > Run workflow**. Pull requests build and check the images without publishing them.

Each build pulls the current base images and runs without Docker's layer cache, so it also refreshes packages installed during the build. Updates to an existing base-image tag are picked up by the next daily build. Switching to another PHP version or changing a pinned Alpine version requires a Dockerfile change.

The workflow checks PHP, Composer and the FPM configuration before pushing each `linux/amd64` image to `webmenedzser/craftcms-php`. Each PHP version runs independently, so a failed build does not stop the others. The workflow only updates the four version tags; it does not assign `latest`.

To enable publishing, add these repository secrets under **Settings > Secrets and variables > Actions**:

- `DOCKERHUB_USERNAME`: the Docker Hub account with push access to `webmenedzser/craftcms-php`.
- `DOCKERHUB_TOKEN`: a Docker Hub access token with write permission for that repository.

The workflow must be on the default branch (`master`) for the schedule to run. Disable any Docker Hub autobuild rules that publish the same tags once this workflow is in use.

[GitHub may delay scheduled runs and disables them in public repositories after 60 days without repository activity](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#schedule). Re-enable the workflow in the Actions tab if this happens. A daily rebuild can only include updates that upstream still provides for the chosen PHP and Alpine versions.

### Pre-installed Composer in the image

Composer 2 is copied from `composer/composer:2-bin`, as described in the [Composer Docker documentation](https://getcomposer.org/doc/00-intro.md#docker-image). The daily build pulls its current version, so there is no installer checksum to update manually.

You can run it with the following command (if the service based on this image is called `php` in your `docker-compose.yml`):

```
docker-compose exec php composer <COMMAND>
```

### Change user and group of PHP
You can change which user should run PHP - just build your image by extending this one, e.g.:

**Dockerfile**
```
FROM: webmenedzser/craftcms-php:latest

[...]
RUN apk add shadow && usermod -u 1000 www-data && groupmod -g 1000 www-data
[...]
```

This will change both the UID and GID of `www-data` user (which is the default to run PHP) to 1000.

### Add custom PHP settings
You can easily add new PHP settings to the image. Just place your `.ini` file in e.g. the `.docker/php` folder, and `COPY` it:

**Dockerfile**
```
FROM: webmenedzser/craftcms-php:latest

[...]
COPY .docker/php/settings-override.ini /usr/local/etc/php/conf.d/
[...]
```
Opcache is enabled by default, so if you want to disable it (for local dev) you can do it with the method mentioned above:

**disable-opcache.ini**
```
opcache.enable = 0;
```

### Example usage

**docker-compose.yml**

```
version: '3.6'
services:
  web:
    image: webmenedzser/craftcms-nginx:latest
    volumes:
      - ./:/var/www/

  php:
    image: webmenedzser/craftcms-php:latest
    volumes:
      - ./:/var/www/

  database:
    image: mariadb:latest
    volumes:
     - database_volume:/var/lib/mysql

volumes:
  database_volume: {}
```

Sister image: [craftcms-nginx](https://github.com/Saboteur777/craftcms-nginx-docker)
