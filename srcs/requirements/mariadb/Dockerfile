FROM debian:bullseye

# create 'mysql' user and group or just change id:gid (1042) (if not exist is specified with home directory as '/var/lib/mysql' mount and '/usr/sbin/nologin')
RUN if getent passwd mysql > /dev/null; then \
        groupmod -g 1042 mysql && usermod -u 1042 mysql; \
    else \
        groupadd -g 1042 mysql && useradd -u 1042 -g mysql -M -d /var/lib/mysql -s /usr/sbin/nologin mysql; \
    fi

RUN apt-get update -y
RUN apt-get install mariadb-server -y

COPY conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf

COPY sh/init_db.sh init_db.sh
RUN chmod +x /init_db.sh

ENTRYPOINT ["/init_db.sh"]

# mariadbd not mariadbd-safe cause the official image choose mariadb.
CMD ["mariadbd"]
