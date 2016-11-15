#!/bin/bash

# Make sure we're not confused by old, incompletely-shutdown httpd
# context after restarting the container.  httpd won't start correctly
# if it thinks it is already running.
rm -rf /run/httpd/*

if [ ! -z "$APACHE_MODULES" ]; then
  for MOD in $APACHE_MODULES; do
    sed -i 's|#LoadModule $MOD|LoadModule $MOD|' /usr/local/apache2/conf/httpd.conf
  done
fi

if [ ! -z "$APACHE_INCLUDE" ]; then
  for CONF in $APACHE_INCLUDE; do
    sed -i 's|#Include $CONF|Include $CONF|' /usr/local/apache2/conf/httpd.conf
  done
fi

if [ ! -z "$CONFIG_URL" ]; then
  curl -o /usr/local/apache2/conf/extra/vh-my-app.conf -SL $CONFIG_URL
fi


if [ -f /usr/local/apache2/conf/extra/vh-*.conf ]; then
  echo 'Using mounted config file'
else
  CONFIG_FILE='/usr/local/apache2/conf/extra/vh-my-app.conf'
  echo '<VirtualHost *:80>' > $CONFIG_FILE
  echo "ServerAdmin $SERVER_ADMIN" >> $CONFIG_FILE
  echo "ServerName $SERVER_NAME" >> $CONFIG_FILE
  echo "ServerAlias $ServerAlias" >> $CONFIG_FILE
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

# needed for ssl support; server.crt and server.key files
# are referenced in the default ssl configuration ("httpd-ssl.conf")
if [ ! -f /usr/local/apache2/conf/server.crt -o \
     ! -f /usr/local/apache2/conf/server.key ]; then
  openssl req -x509 -nodes -newkey rsa:2048 \
          -keyout /usr/local/apache2/conf/server.key \
          -out /usr/local/apache2/conf/server.crt \
          -subj "/C=../ST=./L=./O=./OU=./CN=localhost"
  chown apache:apache /usr/local/apache2/conf/server.crt \
                      /usr/local/apache2/conf/server.key
fi
