# Run Guide

This site is a static web app. It loads Markdown content with `fetch()`, so it must be served over HTTP—opening `index.html` directly (`file://`) will not work.

## Local HTTP mode

### Quick start with Docker (recommended)
```bash
docker run --rm -p 8080:8080 \
	-e DEPLOY_MODE=http \
	jeonkwan/gz-metro-smart-kid:latest
```
Open `http://localhost:8080`.

### Python server
```bash
python3 -m http.server 8000
```
Open `http://localhost:8000`.

### Perl server helper
```bash
perl server.pl
```
Open `http://localhost:8080`.

### VS Code
Use the `Open Metro Explorer` configuration from `.vscode/launch.json` — it starts the Python server and opens the browser automatically.

## Environment variables

| Variable | Default | Purpose |
|---|---|---|
| `DEPLOY_MODE` | `http` | `http` for plain HTTP, `https` for automatic TLS |
| `HTTP_PORT` | `8080` | Port for HTTP mode |
| `SITE_HOST` | — | Public hostname (required in HTTPS mode) |
| `HTTPS_PORT` | `8443` | HTTPS serving port |
| `ACME_EMAIL` | — | Let's Encrypt registration email (required in HTTPS mode) |

Use `.env.example` as a reference for `docker run` or to create your own env file for `--env-file`.

## Building the image

Repo helper script:

```bash
scripts/ops/docker-build-push.sh \
	--image jeonkwan/gz-metro-smart-kid \
	--tag latest \
	--platform linux/amd64 \
	--extra-tag $(date +%Y%m%d)
```

Equivalent raw Docker commands:

```bash
docker buildx build --builder desktop-linux --platform linux/amd64 --load \
	-t jeonkwan/gz-metro-smart-kid:latest .
docker push jeonkwan/gz-metro-smart-kid:latest
```

For this repo, prefer publishing `linux/amd64` locally because production runs on amd64. On Apple Silicon macOS, Docker Desktop can still build and run `linux/amd64` containers.

Tag releases with a date so you can roll back:
```bash
docker tag jeonkwan/gz-metro-smart-kid:latest jeonkwan/gz-metro-smart-kid:$(date +%Y%m%d)
docker push jeonkwan/gz-metro-smart-kid:$(date +%Y%m%d)
```

## Server deployment with Ansible

Requires Ansible locally with the `community.docker` collection:
```bash
ansible-galaxy collection install -r ansible/requirements.yml
```

Preferred repo helper:
```bash
scripts/ops/redeploy-server.sh \
	--inventory ansible/inventory/hosts.ini \
	--playbook ansible/playbooks/deploy.yml \
	--limit gz-metro
```

Direct Ansible command:
```bash
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/deploy.yml
```

Optional standalone preflight:
```bash
scripts/ops/redeploy-preflight.sh \
	--ssh-host 54.254.63.109 \
	--mode https \
	--site-host gzmetro.mokamaker.space \
	--https-port 8443

scripts/ops/redeploy-server.sh \
	--inventory ansible/inventory/hosts.ini \
	--playbook ansible/playbooks/deploy.yml \
	--limit gz-metro
```

The playbook:
1. Skips Docker install if already present
2. Creates named volumes (`caddy_data`, `caddy_config`) to persist TLS certs across restarts
3. Pulls the image from Docker Hub by default
4. Replaces any existing container idempotently
5. Starts with HTTPS mode on port `8443`, ACME HTTP-01 validation on port `80`
6. Health-checks the HTTPS endpoint and reports status

The helper script wraps that flow and also supports `--image-tag`, `--image-source`, `--skip-preflight`, and `--skip-galaxy`.

If the published image is missing a compatible target-platform manifest, the playbook also supports a remote-build fallback via `-e image_source=build`. Keep that as fallback only.

### Rollback
```bash
scripts/ops/redeploy-server.sh \
	--inventory ansible/inventory/hosts.ini \
	--playbook ansible/playbooks/deploy.yml \
	--limit gz-metro \
	--image-tag 20260401
```

## Content updates

Edit `data/en/*.md` or `data/zh/*.md` and refresh locally for development. To publish those changes to the server, rebuild the image, push it, and re-run the redeploy helper or Ansible playbook. The container will be replaced with the new image within seconds.

## GitHub Pages deployment

This repository can also publish to GitHub Pages with the workflow at `.github/workflows/deploy-pages.yml`.

1. In GitHub, open **Settings → Pages**
2. Under **Build and deployment**, choose **GitHub Actions**
3. Push to `main` or run the workflow manually

The workflow publishes only:
- `index.html`
- `marked.min.js`
- `data/`

The route identifiers in `index.html` currently match the Markdown filenames under both `data/en/` and `data/zh/`, so no filename refactor is needed for Pages.

## Copilot Skills

This repo includes two workflow skills for these operations:
- `.github/skills/docker-build-push-image/`
- `.github/skills/redeploy-server/`

Both skills are designed to confirm every required input before running build, push, or remote deployment commands.
The redeploy workflow also includes a preflight check script for SSH reachability and current site health.
