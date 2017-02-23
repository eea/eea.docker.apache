## Apache HTTP server Docker image

This image is generic, thus you can obviously re-use it within
your non-related EEA projects.

This image is generic, thus you can obviously re-use it within
your non-related EEA projects.

 - Debian: **Jessie**
 - Apache: **2.4**
 - Expose: **80**

### Supported tags and respective Dockerfile links

  - `:latest` [*Dockerfile*](https://github.com/eea/eea.docker.apache/blob/master/apache/Dockerfile) - Debian: **Jessie**, Apache: **2.4**

### Stable and immutable tags
  - `:2.4-1.0` [*Dockerfile*](https://github.com/eea/eea.docker.apache/tree/2.4-1.0/apache/Dockerfile) - Apache: **2.4** Release: **1.0**

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
        image: eeacms/apache
        ports:
        - "80:80"
        depends_on:
        - plone
        environment:
          SERVER_ADMIN: "helpdesk@plone.dev"
          SERVER_NAME: "plone.dev"
          RewriteRule: "^/(.*) http://plone:8080/VirtualHostBase/http/plone.dev:80/VirtualHostRoot/$$1 [P,L]"
      plone:
        image: plone

### Run it with Docker

    $ docker run -it --rm -v conf.d/virtual-host.conf:/usr/local/apache2/conf/extra/vh-my-app.conf -p 80:80 eeacms/apache


### Run it with environment variable set in apache.env

* `CONFIG_URL` Provide external VH conf URL (e.g. `CONFIG_URL=http://github.com/org/repo/vh-example.conf`)
* `SERVER_ADMIN` Email address of the Web server administrator (e.g. `SERVER_ADMIN=contact@example.com`)
* `SERVER_NAME` Specifies a hostname and port number (matching the Listen directive) for the server (e.g. `SERVER_NAME=www.example.com`)
* `SERVER_ALIAS` Alternate names for a host used when matching requests to name-virtual hosts (e.g. `SERVER_ALIAS=example.com`)
* `RewriteCond` Defines a condition under which rewriting will take place (e.g. `RewriteCond=%{HTTP_HOST} ^example\.com [NC]`)
* `RewriteRule` Defines rules for the rewriting engine (e.g. `RewriteRule=^/(.*) http://haproxy:5000/VirtualHostBase/http/example.com:80/Plone/VirtualHostRoot/$1 [P,L]`)
* `APACHE_MODULES` Load more apache modules, space separated (e.g. `APACHE_MODULES=file_cache_module cache_module cache_disk_module watchdog_module`)
* `APACHE_INCLUDE` Include extra config files, space separated (e.g. `APACHE_INCLUDE=conf/extra/httpd-mpm.conf conf/extra/httpd-languages.conf`)


### Reload configuration file for Apache

    $ docker exec <name-of-your-container> reload


### Extend it

Build a `Dockerfile` with something similar:

    FROM eeacms/apache:2.4-1.0
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
