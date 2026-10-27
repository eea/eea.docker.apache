#!/bin/sh
#
# Smoke tests for the eeacms/apache image.
#
#   ./test/run.sh eeacms/apache:latest
#
# Needs only docker on the host: requests are made with curl from inside
# the containers, so no ports are published.
#

IMAGE="${1:?usage: $0 <image>}"
PREFIX="apache-test-$$"
NET="$PREFIX-net"
FAILED=0

cleanup() {
  docker rm -f "$PREFIX-default" "$PREFIX-backend" "$PREFIX-proxy" >/dev/null 2>&1
  docker network rm "$NET" >/dev/null 2>&1
}
trap cleanup EXIT INT TERM

pass() { echo "ok   - $1"; }
fail() { echo "FAIL - $1"; FAILED=$((FAILED + 1)); }

# check <description> <command...>
check() {
  desc="$1"; shift
  if "$@" >/dev/null 2>&1; then pass "$desc"; else fail "$desc"; fi
}

# wait_ready <container>: wait up to 30s for apache to answer on port 80
wait_ready() {
  i=0
  while [ $i -lt 30 ]; do
    docker exec "$1" curl -sf -o /dev/null http://localhost/ 2>/dev/null && return 0
    [ "$(docker inspect -f '{{.State.Running}}' "$1" 2>/dev/null)" = "true" ] || break
    sleep 1; i=$((i + 1))
  done
  echo "---- logs of $1"; docker logs "$1" 2>&1 | tail -20
  return 1
}

# run_in <container> <shell command>: run a command inside a container
run_in() { c="$1"; shift; docker exec "$c" sh -c "$*"; }

cleanup
docker network create "$NET" >/dev/null

echo "# Image: $IMAGE"

#
# Default configuration
#
C="$PREFIX-default"
docker run -d --pull never --name "$C" --network "$NET" "$IMAGE" >/dev/null
if wait_ready "$C"; then pass "starts with default CMD and serves HTTP"; else fail "starts with default CMD and serves HTTP"; fi

check "config syntax is valid"            run_in "$C" "httpd -t"
check "HTTPS answers with self-signed cert" run_in "$C" "curl -skf -o /dev/null https://localhost/"
check "self-signed cert is not a CA"      run_in "$C" "openssl x509 -in /usr/local/apache2/conf/server.crt -noout -text | grep -q 'CA:FALSE'"
check "httpd is PID 1"                    run_in "$C" "ps -o pid,args | grep -q '^ *1 httpd -DFOREGROUND'"
check "workers run as www-data"           run_in "$C" "ps -o user,comm | grep -q '^www-data *httpd'"

for MOD in rewrite_module proxy_module proxy_http_module deflate_module ldap_module \
           authnz_ldap_module session_module session_cookie_module auth_form_module \
           request_module ssl_module socache_shmcb_module; do
  check "module $MOD is loaded" run_in "$C" "httpd -M 2>/dev/null | grep -q ' $MOD '"
done

check "server.key is root-only (600)"     run_in "$C" "[ \"\$(stat -c '%U %a' /usr/local/apache2/conf/server.key)\" = 'root 600' ]"
check "logs/ is owned by www-data"        run_in "$C" "[ \"\$(stat -c '%U' /usr/local/apache2/logs)\" = 'www-data' ]"
check "www-data cannot read server.key"   docker exec -u www-data "$C" sh -c "! cat /usr/local/apache2/conf/server.key"
check "www-data cannot write conf/"       docker exec -u www-data "$C" sh -c "! touch /usr/local/apache2/conf/test"

run_in "$C" "curl -s -o /dev/null -H 'X-Forwarded-For: 10.1.2.3' http://localhost/xff-ip"
run_in "$C" "curl -s -o /dev/null -H 'X-Forwarded-For: notanip' http://localhost/xff-noip"
sleep 1
check "access log uses X-Forwarded-For client IP" sh -c "docker logs '$C' 2>/dev/null | grep -q '^10.1.2.3 .*GET /xff-ip '"
check "non-IP X-Forwarded-For is not logged as client" sh -c "docker logs '$C' 2>/dev/null | grep 'GET /xff-noip ' | grep -qv '^notanip'"

check "reload succeeds"                   docker exec "$C" reload
sleep 2
check "still serving after reload"        run_in "$C" "curl -sf -o /dev/null http://localhost/"

#
# APACHE_CONFIG reverse proxy + APACHE_MODULES
#
B="$PREFIX-backend"
P="$PREFIX-proxy"
docker run -d --pull never --name "$B" --network "$NET" "$IMAGE" >/dev/null
docker run -d --pull never --name "$P" --network "$NET" \
  -e APACHE_MODULES="headers_module expires_module" \
  -e APACHE_CONFIG="<VirtualHost *:80>
  RewriteEngine On
  Header set X-Apache-Test ok
  RewriteRule ^/(.*) http://$B:80/\$1 [P,L]
</VirtualHost>" \
  "$IMAGE" >/dev/null
wait_ready "$B" >/dev/null
if wait_ready "$P"; then pass "starts with APACHE_CONFIG"; else fail "starts with APACHE_CONFIG"; fi

check "APACHE_MODULES loads extra modules" run_in "$P" "httpd -M 2>/dev/null | grep -q ' headers_module ' && httpd -M 2>/dev/null | grep -q ' expires_module '"
check "proxies requests to the backend"   run_in "$P" "curl -sf http://localhost/ | grep -q 'It works!'"
check "custom config is applied"          run_in "$P" "curl -sfI http://localhost/ | grep -qi '^X-Apache-Test: ok'"

echo
if [ "$FAILED" -gt 0 ]; then
  echo "# $FAILED test(s) FAILED"
  exit 1
fi
echo "# All tests passed"
