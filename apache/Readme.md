## Generic Docker image for Apache HTTP server

This image is generic, thus you can obviously re-use it within
your non-related EEA projects.

### Warning

Latest builds of this image is based on the official Apache image, which is Debian
based instead of CentOS. Please update your deployment accordingly.

 - Debian Jessie
 - Apache 2.4

### Supported tags and respective Dockerfile links

  - `:latest` [*Dockerfile*](https://github.com/eea/eea.docker.apache/blob/master/Dockerfile) (Debian Jessie - default)
  - `:2.4s` [*Dockerfile*](https://github.com/eea/eea.docker.apache/blob/2.4s/Dockerfile) (Debian Jessie)
  - `:2.4` [*Dockerfile*](https://github.com/eea/eea.docker.apache/blob/2.4/Dockerfile) (CentOS 7)
  - `:2.2` [*Dockerfile*](https://github.com/eea/eea.docker.apache/blob/2.2/Dockerfile) (CentOS 6)

### Changes

 - [CHANGELOG.md](https://github.com/eea/eea.docker.apache/blob/master/CHANGELOG.md)

### Base docker image

 - [hub.docker.com](https://registry.hub.docker.com/u/eeacms/apache)


### Source code

  - [github.com](http://github.com/eea/eea.docker.apache)


### Installation

1. Install [Docker](https://www.docker.com/).

## Usage


### Run with Docker Compose

Here is a basic example of a `docker-compose.yml` file using the `eeacms/apache` docker image:

    apache:
      image: eeacms/apache
      volumes:
      - conf.d/virtual-host.conf:/usr/local/apache2/conf/extra/vh-my-app.conf
      ports:
      - "80:80"
      links:
      - webapp

    webapp:
      image: eeacms/plone

### Run it with Docker

    $ docker run -it --rm -v conf.d/virtual-host.conf:/usr/local/apache2/conf/extra/vh-my-app.conf -p 80:80 eeacms/apache


### Run it with environment variable set in apache.env

* `CONFIG_URL` Provide external VH conf URL
* `SERVER_ADMIN` Email address of the Web server administrator
* `SERVER_NAME` Specifies a hostname and port number (matching the Listen directive) for the server
* `SERVER_ALIAS` Alternate names for a host used when matching requests to name-virtual hosts
* `RewriteCond` Defines a condition under which rewriting will take place
* `RewriteRule` Defines rules for the rewriting engine


### Reload configuration file for Apache

    $ docker exec <name-of-your-container> reload


### Extend it

Build a `Dockerfile` with something similar:

    FROM eeacms/apache
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
