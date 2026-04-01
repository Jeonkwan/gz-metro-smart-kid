#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/ops/docker-build-push.sh --image IMAGE --tag TAG [--extra-tag EXTRA_TAG]

Examples:
  scripts/ops/docker-build-push.sh --image jeonkwan/gz-metro-smart-kid --tag latest
  scripts/ops/docker-build-push.sh --image jeonkwan/gz-metro-smart-kid --tag latest --extra-tag 20260401
EOF
}

image=""
tag=""
extra_tag=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --image)
      image="$2"
      shift 2
      ;;
    --tag)
      tag="$2"
      shift 2
      ;;
    --extra-tag)
      extra_tag="$2"
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

if [[ -z "$image" || -z "$tag" ]]; then
  echo "Both --image and --tag are required." >&2
  usage >&2
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required but not installed or not on PATH." >&2
  exit 1
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

if [[ ! -f Dockerfile ]]; then
  echo "Dockerfile not found in repo root: $repo_root" >&2
  exit 1
fi

primary_ref="${image}:${tag}"

echo "Building ${primary_ref}"
docker build -t "$primary_ref" .

if [[ -n "$extra_tag" ]]; then
  extra_ref="${image}:${extra_tag}"
  echo "Tagging ${extra_ref}"
  docker tag "$primary_ref" "$extra_ref"
fi

echo "Pushing ${primary_ref}"
docker push "$primary_ref"

if [[ -n "$extra_tag" ]]; then
  echo "Pushing ${extra_ref}"
  docker push "$extra_ref"
fi
