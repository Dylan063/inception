# docker build -t wordpress .
# docker run --env-file ../../.env wordpress
# docker run -it --env-file ../../.env wordpress

# www-data use and group already present and is 33 in most system

# Penultimate stable version of debian
FROM debian:bullseye

# No "apt-get upgrade -y" for stability and reproducibility.
# 'set -eux' present for : exit on errors (-e), on unset variables (-u), and print commands before executing (-x).
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
# php 7.4 for this version of debian 
# try to install only the bare minimum based on https://make.wordpress.org/hosting/handbook/server-environment/ required for WordPress site to work
        php \
        php-fpm \
        php-json \
        php-mysql \
# mariadb 10.5 for this version of debian
        mariadb-client \
# Install manually wordpress and wordpress-cli in the docker-entrypoint.sh to avoid installing wordpress package that will install (apache2, ...)
        ca-certificates \
        wget \
    ; \
# Remove "apt-get update" cache
    rm -rf /var/lib/apt/lists/*; \
    mkdir /docker-entrypoint.d

WORKDIR /var/www/html/

# The php.ini reference was taken after php-fpm install with docker cp at '/etc/php/7.4/fpm/php.ini'
COPY conf/php_fpm_ini_block.txt /docker-entrypoint.d/
COPY tools/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9000

CMD ["php-fpm7.4", "-F"]
