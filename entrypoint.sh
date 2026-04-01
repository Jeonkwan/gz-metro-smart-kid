#!/bin/sh
set -e

DEPLOY_MODE="${DEPLOY_MODE:-http}"
SITE_HOST="${SITE_HOST:-localhost}"
HTTP_PORT="${HTTP_PORT:-8080}"
HTTPS_PORT="${HTTPS_PORT:-8443}"
ACME_EMAIL="${ACME_EMAIL:-}"

if [ "$DEPLOY_MODE" = "https" ]; then
  if [ -z "$SITE_HOST" ] || [ "$SITE_HOST" = "localhost" ]; then
    echo "ERROR: SITE_HOST must be set to a real hostname for HTTPS mode" >&2
    exit 1
  fi
  if [ -z "$ACME_EMAIL" ]; then
    echo "ERROR: ACME_EMAIL must be set for HTTPS mode" >&2
    exit 1
  fi

  cat > /etc/caddy/Caddyfile <<EOF
{
  http_port 80
  https_port ${HTTPS_PORT}
  email ${ACME_EMAIL}
}

${SITE_HOST}:${HTTPS_PORT} {
  root * /srv
  file_server
  encode gzip
  header {
    X-Frame-Options DENY
    X-Content-Type-Options nosniff
    Referrer-Policy strict-origin-when-cross-origin
  }
}
EOF
  echo "Starting Caddy in HTTPS mode: ${SITE_HOST}:${HTTPS_PORT}"

else
  cat > /etc/caddy/Caddyfile <<EOF
:${HTTP_PORT} {
  root * /srv
  file_server
  encode gzip
  header {
    X-Frame-Options DENY
    X-Content-Type-Options nosniff
    Referrer-Policy strict-origin-when-cross-origin
  }
}
EOF
  echo "Starting Caddy in HTTP mode on port ${HTTP_PORT}"

fi

exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
