# Changelog

## 2026-10-27 (2.4-3.5)

- Upgrade to Apache 2.4.69 on Alpine 3.24; the image is now built `FROM httpd:2.4.69-alpine` instead of compiling Apache
- Fix `reload` on Alpine (`#!/bin/sh`, there is no bash)
- Fix the `X-Forwarded-For` regex for proxy logs: the dots were unescaped, so almost any value counted as an IP
- Only `logs/` is writable by `www-data`; `conf/` and `server.key` (mode `600`) stay owned by `root`.
  Child images that need Apache to write under `/usr/local/apache2` must `chown` that path themselves
- Default self-signed certificate is no longer a CA and has `subjectAltName=DNS:localhost`; key generation is quiet
- Remove Debian leftover `rm -rf /run/httpd/*` from the entrypoint
- Jenkins: build, run `test/run.sh` smoke tests, and only then push the image to Docker Hub

# 2019-10-08 (2.4-2.6)

- Configure proxy & combined logs to log both direct and proxy forwarded request client IPs.

# 2019-07-04 (2.4-2.5)

- Release 2.5

## 2019-04-25 (2.4-2.4)

- Release 2.4

## 2017-05-11 (2.4-2.1)

- Cleanup: Remove `apache` user as there was already a dedicated one for Apache called `www-data`

## 2017-05-10 (2.4-2.0)

- Release stable and immutable version 2.4-2.0

- Release alpine versions with `http2` support

- Add Apache conf support via environment variable `APACHE_CONFIG`

- Add SSL support via environment vars `APACHE_SSL_*`

- Drop chaperone process manager

## 2017-02-23 (2.4-1.0)

- Release stable and immutable version 2.4-1.0

## 2016-02-10

- Changed chaperone's setup.service type to 'oneshot'


## 2016-01-20

- Enabled mod_deflate


## 2016-01-18

- Switch to official httpd Docker image - Debian based (`:2.4s`)

- Added chaperone process manager


## 2015-06-04

- Apache 2.4.6 (`:2.4`)


## 2015-05-11

- Apache 2.2.15 (`:2.2`)
