#!/bin/bash

# Make sure we're not confused by old, incompletely-shutdown httpd
# context after restarting the container.  httpd won't start correctly
# if it thinks it is already running.
rm -rf /run/httpd/*

CONFIG_FILE='/etc/httpd/conf.d/vh-my-app.conf'


if [ -f /etc/httpd/conf.d/vh-*.conf ]; then
  echo 'Using mounted config file'
else
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

exec /usr/sbin/apachectl -D FOREGROUND
