## Generic Docker image for Apache HTTP server based on CentOS

This image is generic, thus you can obviously re-use it within
your non-related EEA projects.

### Supported tags and respective Dockerfile links

  - `:2.4`, `:latest` (apache 2.4.6)
  - `:2.2` (apache 2.2.15)


### Base docker image

 - [hub.docker.com](https://registry.hub.docker.com/u/eeacms/httpd)


### Source code

  - [github.com](http://github.com/eea/eea.docker.httpd)


### Installation

1. Install [Docker](https://www.docker.com/).

## Usage


### Run with Docker Compose

Here is a basic example of a `docker-compose.yml` file using the `eeacms/apache` docker image:

    apache:
      image: eeacms/apache
      volume:
      - conf.d/virtual-host.conf:/:/etc/httpd/conf.d/vh-my-app.conf
      ports:
      - "80:80"
      links:
      - webapp

    webapp:
      image: razvan3895/nodeserver

### Run it with Docker
        
    $ docker run -it --rm -v conf.d:/etc/httpd/conf.d -p 80:80 eeacms/apache


### Extend it

Build a `Dockerfile` with something similar:

    FROM eeacms/apache
    ADD your-file.conf /etc/httpd/conf/httpd.conf


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
