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

Copy `.env.example` to `.env` and adjust for your deployment.

## Building the image

```bash
docker build -t jeonkwan/gz-metro-smart-kid:latest .
docker push jeonkwan/gz-metro-smart-kid:latest
```

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

Deploy:
```bash
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/deploy.yml
```

The playbook:
1. Skips Docker install if already present
2. Creates named volumes (`caddy_data`, `caddy_config`) to persist TLS certs across restarts
3. Pulls the image from Docker Hub
4. Replaces any existing container idempotently
5. Starts with HTTPS mode on port `8443`, ACME HTTP-01 validation on port `80`
6. Health-checks the HTTPS endpoint and reports status

### Rollback
```bash
# Edit ansible/group_vars/all.yml: set image_tag to the date of the target release
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/deploy.yml
```

## Content updates

Edit `data/en/*.md` or `data/zh/*.md`, rebuild the image, push, and re-run the Ansible playbook. The container will be replaced with the new image within seconds.