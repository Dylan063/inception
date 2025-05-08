FROM debian:bullseye

# Install required packages
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        php \
        php-fpm \
        php-json \
        php-mysql \
        mariadb-client \
        ca-certificates \
        wget \
        netcat \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir /docker-entrypoint.d

WORKDIR /var/www/html/

# Copy configuration files
COPY conf/php_fpm_ini_block.txt /docker-entrypoint.d/
COPY tools/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm7.4", "-F"]
