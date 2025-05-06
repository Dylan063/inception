#!/bin/bash

# this script can be recall without problem if the root password haven't change

# 'set -eu' present for : exit on errors (-e), on unset variables (-u), and print commands before executing (-x).
# No -x because it show to mutch .env variables
set -eu

# Start MariaDB service
# It can show "ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)" but start anyway (> /dev/null 2>&1 hide it),
# didn't use 'mariadbd-safe &' to avoid running background program even if it gonna be close at the end
service mariadb start > /dev/null 2>&1

# Wait for MariaDB service (mariadb-admin eq. to mysqladmin)
# Can maybe be remove because mariadb start have a wait build in
ready=false
for attempt in {1..10}; do
  if mariadb-admin -u root --password=${MYSQL_ROOT_PASSWORD} ping >/dev/null 2>&1; then
    ready=true
    break
  fi
  echo "(1s), attempt ($attempt/10), Waiting for MariaDB to be ready..."
  sleep 1
done
if [ "$ready" = true ]; then
  echo "MariaDB configuration script successfully start."
else
  echo "Failed to connect to MariaDB after 10 attempts."
  exit 1
fi

# This part combine mariadb-secure-installation with requirement from inception subject (mariadb eq. to mysql)
# -s silent, -f force the command to execute even if there are errors, -e executed directly from the command line
mariadb -u root --password=${MYSQL_ROOT_PASSWORD} -sfe "
  CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
  ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
  GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;

  -- Delete remote 'root' capabilities
  DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

  -- Delete anonymous users
  DELETE FROM mysql.user WHERE User='';

  -- Drop database 'test'
  DROP DATABASE IF EXISTS test;
  -- Remove lingering permissions to the 'test' database
  DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

  CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
  ALTER USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

  CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
  GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
  
  FLUSH PRIVILEGES;
"

# Add a sleep to avoid mysqladmin "ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/run/mysqld/mysqld.sock' (2)"
sleep 1
ready=false
for attempt in {1..10}; do
  if mariadb-admin -u root --password=${MYSQL_ROOT_PASSWORD} shutdown >/dev/null 2>&1; then
    ready=true
    break
  fi
  echo "(1s) Attempt ($attempt/10) to shutdown MariaDB configuration script..."
  sleep 1
done
if [ "$ready" = true ]; then
  echo "MariaDB configuration script successfully shutdown."
else
  echo "Failed to shutdown MariaDB configuration script after 10 attempts."
  exit 2
fi

exec "$@"
