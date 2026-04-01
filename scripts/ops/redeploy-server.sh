#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/ops/redeploy-server.sh \
    --inventory ansible/inventory/hosts.ini \
    --playbook ansible/playbooks/deploy.yml \
    [--limit HOST_LIMIT] \
    [--image-tag TAG] \
    [--skip-preflight] \
    [--skip-galaxy]

Examples:
  scripts/ops/redeploy-server.sh \
    --inventory ansible/inventory/hosts.ini \
    --playbook ansible/playbooks/deploy.yml

  scripts/ops/redeploy-server.sh \
    --inventory ansible/inventory/hosts.ini \
    --playbook ansible/playbooks/deploy.yml \
    --limit gz-metro \
    --image-tag 20260401
EOF
}

inventory=""
playbook=""
limit=""
image_tag=""
skip_preflight="false"
skip_galaxy="false"

read_first_yaml_value() {
  local file_path="$1"
  local key="$2"

  awk -F': *' -v wanted_key="$key" '
    $1 == wanted_key {
      value = $2
      sub(/[[:space:]]+#.*$/, "", value)
      sub(/^[[:space:]]+/, "", value)
      sub(/[[:space:]]+$/, "", value)
      gsub(/^"|"$/, "", value)
      print value
      exit
    }
  ' "$file_path"
}

read_inventory_host_value() {
  local file_path="$1"

  awk '
    /^[[:space:]]*#/ { next }
    /^[[:space:]]*\[/ { next }
    NF == 0 { next }
    {
      for (field_index = 1; field_index <= NF; field_index++) {
        if ($field_index ~ /^ansible_host=/) {
          split($field_index, parts, "=")
          print parts[2]
          exit
        }
      }
    }
  ' "$file_path"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --inventory)
      inventory="$2"
      shift 2
      ;;
    --playbook)
      playbook="$2"
      shift 2
      ;;
    --limit)
      limit="$2"
      shift 2
      ;;
    --image-tag)
      image_tag="$2"
      shift 2
      ;;
    --skip-preflight)
      skip_preflight="true"
      shift 1
      ;;
    --skip-galaxy)
      skip_galaxy="true"
      shift 1
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

if [[ -z "$inventory" || -z "$playbook" ]]; then
  echo "Both --inventory and --playbook are required." >&2
  usage >&2
  exit 1
fi

if ! command -v ansible-playbook >/dev/null 2>&1; then
  echo "ansible-playbook is required but not installed or not on PATH." >&2
  exit 1
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

if [[ ! -f "$inventory" ]]; then
  echo "Inventory file not found: $inventory" >&2
  exit 1
fi

if [[ ! -f "$playbook" ]]; then
  echo "Playbook file not found: $playbook" >&2
  exit 1
fi

if [[ "$skip_preflight" != "true" ]]; then
  preflight_script="scripts/ops/redeploy-preflight.sh"
  vars_file="ansible/group_vars/all.yml"

  if [[ ! -x "$preflight_script" ]]; then
    echo "Preflight script not found or not executable: $preflight_script" >&2
    exit 1
  fi

  if [[ ! -f "$vars_file" ]]; then
    echo "Vars file not found: $vars_file" >&2
    exit 1
  fi

  ssh_host="$(read_inventory_host_value "$inventory")"
  deploy_mode="$(read_first_yaml_value "$vars_file" "deploy_mode")"
  site_host="$(read_first_yaml_value "$vars_file" "site_host")"
  https_port="$(read_first_yaml_value "$vars_file" "https_port")"
  http_port="$(read_first_yaml_value "$vars_file" "http_port")"

  if [[ -z "$ssh_host" ]]; then
    echo "Could not determine ansible_host from inventory: $inventory" >&2
    exit 1
  fi

  if [[ -z "$deploy_mode" ]]; then
    echo "Could not determine deploy_mode from $vars_file" >&2
    exit 1
  fi

  preflight_cmd=("$preflight_script" --ssh-host "$ssh_host" --mode "$deploy_mode")

  if [[ "$deploy_mode" = "https" ]]; then
    preflight_cmd+=(--site-host "$site_host" --https-port "${https_port:-8443}")
  else
    preflight_cmd+=(--http-port "${http_port:-8080}")
  fi

  echo "Running preflight checks"
  "${preflight_cmd[@]}"
fi

if [[ "$skip_galaxy" != "true" ]]; then
  if [[ ! -f ansible/requirements.yml ]]; then
    echo "ansible/requirements.yml not found." >&2
    exit 1
  fi

  echo "Installing Ansible collections from ansible/requirements.yml"
  ansible-galaxy collection install -r ansible/requirements.yml
fi

cmd=(ansible-playbook -i "$inventory" "$playbook")

if [[ -n "$limit" ]]; then
  cmd+=(--limit "$limit")
fi

if [[ -n "$image_tag" ]]; then
  cmd+=(-e "image_tag=${image_tag}")
fi

echo "Running: ${cmd[*]}"
"${cmd[@]}"
