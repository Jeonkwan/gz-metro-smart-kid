#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/ops/redeploy-preflight.sh \
    --ssh-host HOST \
    [--ssh-port 22] \
    [--mode https|http] \
    [--site-host HOSTNAME] \
    [--https-port 8443] \
    [--http-port 8080] \
    [--timeout 10]

Examples:
  scripts/ops/redeploy-preflight.sh \
    --ssh-host 54.254.63.109 \
    --mode https \
    --site-host gzmetro.mokamaker.space \
    --https-port 8443
EOF
}

ssh_host=""
ssh_port="22"
mode="https"
site_host=""
https_port="8443"
http_port="8080"
timeout_seconds="10"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ssh-host)
      ssh_host="$2"
      shift 2
      ;;
    --ssh-port)
      ssh_port="$2"
      shift 2
      ;;
    --mode)
      mode="$2"
      shift 2
      ;;
    --site-host)
      site_host="$2"
      shift 2
      ;;
    --https-port)
      https_port="$2"
      shift 2
      ;;
    --http-port)
      http_port="$2"
      shift 2
      ;;
    --timeout)
      timeout_seconds="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "$ssh_host" ]]; then
  echo "--ssh-host is required." >&2
  usage >&2
  exit 1
fi

if [[ "$mode" != "https" && "$mode" != "http" ]]; then
  echo "--mode must be either https or http." >&2
  exit 1
fi

if ! command -v nc >/dev/null 2>&1; then
  echo "nc is required for SSH reachability checks." >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required for site health checks." >&2
  exit 1
fi

echo "Checking SSH reachability: ${ssh_host}:${ssh_port}"
if ! nc -z -G "$timeout_seconds" "$ssh_host" "$ssh_port"; then
  echo "SSH reachability check failed for ${ssh_host}:${ssh_port}" >&2
  exit 1
fi

if [[ "$mode" = "https" ]]; then
  if [[ -z "$site_host" ]]; then
    echo "--site-host is required when --mode=https." >&2
    exit 1
  fi

  health_url="https://${site_host}:${https_port}"
else
  health_url="http://${ssh_host}:${http_port}"
fi

echo "Checking site reachability: ${health_url}"
if ! curl -Ik --max-time "$timeout_seconds" "$health_url" >/dev/null; then
  echo "Site reachability check failed for ${health_url}" >&2
  exit 1
fi

echo "Preflight checks passed."
