## Apache HTTP server Docker image

This image is generic, thus you can obviously re-use it within
your non-related EEA projects.

 - Debian: **Bookworm**
 - Alpine: **3.19**
 - Apache: **2.4.62**
 - Expose: **80**

> **_NOTE:_** Debian Bullseye needs docker >= 18 in order to work. File permissions are not functional with older versions of docker. Use alpine version on hosts with older versions of docker.

### Supported tags and respective Dockerfile links

  - `:latest` [*Dockerfile*](https://github.com/eea/eea.docker.apache/blob/master/debian/Dockerfile) - Debian: **Bookworm**, Apache: **2.4.62**
  - `:alpine` [*Dockerfile*](https://github.com/eea/eea.docker.apache/blob/master/alpine/Dockerfile) - Alpine: **3.19**, Apache: **2.4.62**

### Stable and immutable tags
  - `:2.4-3.3` [*Dockerfile*](https://github.com/eea/eea.docker.apache/tree/2.4-3.3/debian/Dockerfile) -  Debian: **Bullseye** Apache: **2.4.62** Release: **3.3**
  - `:2.4-3.3-alpine` [*Dockerfile*](https://github.com/eea/eea.docker.apache/tree/2.4-3.3-alpine/alpine/Dockerfile) - Alpine: **3.19** Apache: **2.4.62** Release: **3.3**

See [older versions](https://github.com/eea/eea.docker.apache/releases)

### Changes

 - [CHANGELOG.md](https://github.com/eea/eea.docker.apache/blob/master/CHANGELOG.md)


### Base docker image

 - [hub.docker.com](https://hub.docker.com/r/eeacms/apache)


### Source code

  - [github.com](http://github.com/eea/eea.docker.apache)


### Installation

1. Install [Docker](https://www.docker.com/).

2. Install [Docker Compose](https://docs.docker.com/compose/).


## Usage

### Run with Docker Compose

Here is a basic example of a `docker-compose.yml` file using the `eeacms/apache` docker image:

    version: "2"
    services:
      apache:
        image: eeacms/apache:latest
        ports:
        - "80:80"
        depends_on:
        - plone
        environment:
          APACHE_CONFIG: |-
            <VirtualHost *:80>
                ServerAdmin contact@localhost
                ServerName localhost
                ErrorLog /var/log/apache.log

                RewriteEngine On
                RewriteRule ^/(.*) http://plone:8080/VirtualHostBase/http/localhost:80/VirtualHostRoot/$$1 [P,L]
            </VirtualHost>
      plone:
        image: plone


### Run it with Docker

    $ docker run -it --rm -v conf.d/virtual-host.conf:/usr/local/apache2/conf/extra/vh-my-app.conf -p 80:80 eeacms/apache


## Supported environment variables

* `APACHE_MODULES` Load more apache modules, space separated (e.g. `APACHE_MODULES=file_cache_module cache_module cache_disk_module watchdog_module`)
* `APACHE_INCLUDE` Include extra config files, space separated (e.g. `APACHE_INCLUDE=conf/extra/httpd-mpm.conf conf/extra/httpd-languages.conf`)
* `APACHE_CONFIG` Provide entire Apache VH conf. Useful with `docker-compose.yml`
* `APACHE_CONFIG_URL` Provide external VH conf URL (e.g. `APACHE_CONFIG_URL=http://github.com/org/repo/vh-example.conf`)
* `APACHE_SSL_CERT` Provide Apache SSL certificate. Will be saved within container at `/usr/local/apache2/conf/server.crt`.
* `APACHE_SSL_CHAIN` Provide Apache SSL chain. Will be saved within container at `/usr/local/apache2/conf/server-chain.crt`.
* `APACHE_SSL_KEY` Provide Apache SSL key. Will be saved within container at `/usr/local/apache2/conf/server.key`. (**WARNING**: Never commit the SSL key on GitHub)

### Deprecated environment variables. Please use `APACHE_CONFIG` or `APACHE_CONFIG_URL`

* `CONFIG_URL` Provide external VH conf URL (e.g. `CONFIG_URL=http://github.com/org/repo/vh-example.conf`)
* `SERVER_ADMIN` Email address of the Web server administrator (e.g. `SERVER_ADMIN=contact@example.com`)
* `SERVER_NAME` Specifies a hostname and port number (matching the Listen directive) for the server (e.g. `SERVER_NAME=www.example.com`)
* `SERVER_ALIAS` Alternate names for a host used when matching requests to name-virtual hosts (e.g. `SERVER_ALIAS=example.com`)
* `RewriteCond` Defines a condition under which rewriting will take place (e.g. `RewriteCond=%{HTTP_HOST} ^example\.com [NC]`)
* `RewriteRule` Defines rules for the rewriting engine (e.g. `RewriteRule=^/(.*) http://haproxy:5000/VirtualHostBase/http/example.com:80/Plone/VirtualHostRoot/$1 [P,L]`)


### Reload configuration file for Apache

    $ docker exec <name-of-your-container> reload


### Extend it

Build a `Dockerfile` with something similar:

    FROM eeacms/apache:latest
    ADD your-file.conf /usr/local/apache2/conf/extra/vh-my-app.conf


## Copyright and license

The Initial Owner of the Original Code is European Environment Agency (EEA).
All Rights Reserved.

The Original Code is free software;
you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation;
either version 2 of the License, or (at your option) any later
version.


## Funding

[European Environment Agency (EU)](http://eea.europa.eu)
