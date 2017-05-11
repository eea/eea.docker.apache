#!/bin/bash
set -e

#
# Make sure we're not confused by old, incompletely-shutdown httpd
# context after restarting the container.  httpd won't start correctly
# if it thinks it is already running.
#

rm -rf /run/httpd/*

#
# Apache extra modules
#

if [ ! -z "$APACHE_MODULES" ]; then
  for MOD in $APACHE_MODULES; do
    sed -i "s|#LoadModule $MOD|LoadModule $MOD|" /usr/local/apache2/conf/httpd.conf
  done
fi

if [ ! -z "$APACHE_INCLUDE" ]; then
  for CONF in $APACHE_INCLUDE; do
    sed -i "s|#Include $CONF|Include $CONF|" /usr/local/apache2/conf/httpd.conf
  done
fi

#
# Apache VH conf
#
if [ ! -z "$APACHE_CONFIG_URL" ]; then
  curl -o /usr/local/apache2/conf/extra/vh-my-app.conf -SL "$APACHE_CONFIG_URL"
else
  # BBB
  if [ ! -z "$CONFIG_URL" ]; then
    curl -o /usr/local/apache2/conf/extra/vh-my-app.conf -SL "$CONFIG_URL"
  fi
fi

if [ ! -z "$APACHE_CONFIG" ]; then
  echo "$APACHE_CONFIG" > /usr/local/apache2/conf/extra/vh-my-app.conf
fi

EXISTS=$(ls /usr/local/apache2/conf/extra/ | grep "vh-.*.conf")
if [ -z "$EXISTS" ]; then
  CONFIG_FILE="/usr/local/apache2/conf/extra/vh-my-app.conf"
  echo '<VirtualHost *:80>' > $CONFIG_FILE
  if [ ! -z "$SERVER_ADMIN" ]; then
    echo "ServerAdmin $SERVER_ADMIN" >> $CONFIG_FILE
  fi

  if [ ! -z "$SERVER_NAME" ]; then
    echo "ServerName $SERVER_NAME" >> $CONFIG_FILE
  fi

  if [ ! -z "$ServerAlias" ]; then
    echo "ServerAlias $ServerAlias" >> $CONFIG_FILE
  fi

  echo 'ErrorLog /var/log/apache.log' >> $CONFIG_FILE

  if [ ! -z "$RewriteRule" ]; then
    echo 'RewriteEngine On' >> $CONFIG_FILE
    if [ ! -z "$RewriteCond" ]; then
      echo "RewriteCond $RewriteCond" >> $CONFIG_FILE
    fi
    echo "RewriteRule $RewriteRule" >> $CONFIG_FILE
  fi
  echo '</VirtualHost>' >> $CONFIG_FILE
fi

#
# SSL
#
if [ ! -z "$APACHE_SSL_CERT" ]; then
    echo "$APACHE_SSL_CERT" > /usr/local/apache2/conf/server.crt
fi

if [ ! -z "$APACHE_SSL_KEY" ]; then
    echo "$APACHE_SSL_KEY" > /usr/local/apache2/conf/server.key
fi

if [ ! -z "$APACHE_SSL_CHAIN" ]; then
    echo "$APACHE_SSL_CHAIN" > /usr/local/apache2/conf/server-chain.crt
fi

#
# Default SSL if not provided via environment variables
#

if [ ! -f /usr/local/apache2/conf/server.crt -o \
     ! -f /usr/local/apache2/conf/server.key ]; then
  openssl req -x509 -nodes -newkey rsa:2048 \
          -keyout /usr/local/apache2/conf/server.key \
          -out /usr/local/apache2/conf/server.crt \
          -subj "/C=../ST=./L=./O=./OU=./CN=localhost"
fi

#
# Run
#
chown -R www-data:www-data /usr/local/apache2
exec "$@"
