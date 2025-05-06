FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:4096 -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=PACA/L=Nice/O=42/OU=42/CN=dravaono.42.fr/UID=dravaono"

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/mime.types /etc/nginx/mime.types
COPY tools/script.sh /script.sh

RUN chmod -R 755 /var/www
RUN chown -R www-data:www-data /var/www

EXPOSE 9000

STOPSIGNAL SIGQUIT

RUN chmod +x /script.sh

ENTRYPOINT ["/script.sh"]

CMD ["nginx", "-g", "daemon off;"]