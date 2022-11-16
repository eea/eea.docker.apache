# Changelog

# 2022-11-16 (2.4-2.9)

- Apache 2.4.54
- Rollback to debian:10 and alpine:3.13 to be compatible with rancher 1.6
- Fix grep bug

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
