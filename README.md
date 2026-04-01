# 🚇 Guangzhou Metro Explorer — Smart Kid Edition

A colourful, kid-friendly static website that lets children explore every metro line in Guangzhou and nearby Foshan/Nanhai. Click any line button to read fun facts, key stations, and cool trivia in English or Chinese.

## ✨ Features
- 🎨 Colour-coded buttons for every metro line
- 🇨🇳 / 🇬🇧 EN / 中文 language toggle
- 🔊 Read-aloud button using the Web Speech API
- 📱 Responsive layout for phones, tablets, and desktops
- 💫 Animated sparkle background
- 📄 Markdown-driven content with separate English and Chinese files

## 🗂️ Project Structure
```
index.html          ← Main single-page app
Dockerfile          ← Caddy-based container image definition
entrypoint.sh       ← Selects HTTP or HTTPS mode from env vars at startup
Caddyfile           ← Caddy config template (generated at runtime by entrypoint.sh)
.env.example        ← Environment variable reference
ansible/            ← Ansible playbook for server deployment
  inventory/        ← Target host definitions
  group_vars/       ← Deployment variables (image, host, ports, email)
  playbooks/        ← deploy.yml — idempotent pull-and-run playbook
.vscode/            ← VS Code run and debug configuration
data/
  en/               ← English Markdown content for each line
  zh/               ← Chinese Markdown content for each line
```

## 🚀 How to Run the Site

This project uses `fetch()` to load Markdown files, so it must be served over HTTP. Opening `index.html` directly with `file://` will not work.

### Option 1: Docker — local HTTP mode (simplest)
```bash
docker run --rm -p 8080:8080 \
  -e DEPLOY_MODE=http \
  jeonkwan/gz-metro-smart-kid:latest
```
Open `http://localhost:8080`.

### Option 2: Python HTTP server
```bash
python3 -m http.server 8000
```
Open `http://localhost:8000`.

### Option 3: VS Code Run and Debug
Use the `Open Metro Explorer` launch profile in `.vscode/launch.json` (starts the Python server and opens the browser automatically).

## 🚢 Deploying to a Server (Ansible)

Prerequisites: Ansible installed locally, `community.docker` collection installed.

```bash
ansible-galaxy collection install -r ansible/requirements.yml
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/deploy.yml
```

The playbook pulls `jeonkwan/gz-metro-smart-kid:latest` from Docker Hub, creates named volumes to persist TLS certificates, and starts the container with HTTPS on port 8443 via automatic Let's Encrypt certificates (ACME HTTP-01 on port 80).

Customise `ansible/group_vars/all.yml` to change hostname, ports, image tag, or ACME email.

**To roll back** to a previous release, set `image_tag` in `group_vars/all.yml` to the target date tag (e.g., `20260401`) and re-run the playbook.

## Copilot Workflow Skills

This repo now includes reusable Copilot skills for operations workflows:
- `.github/skills/docker-build-push-image/` for confirming build and push inputs before publishing a container image
- `.github/skills/redeploy-server/` for confirming deployment inputs before running the Ansible redeploy workflow

Supporting scripts live under `scripts/ops/`:
- `scripts/ops/docker-build-push.sh`
- `scripts/ops/redeploy-preflight.sh`
- `scripts/ops/redeploy-server.sh`

## 📝 Updating Content
Each metro line has two Markdown files:
- `data/en/<line-id>.md` — English content
- `data/zh/<line-id>.md` — Chinese content

Edit the Markdown files to update facts, add stations, or fix typos. Refresh the page after editing; no build step is needed for content changes.

## 🌐 Deploying
Drop the folder on any static hosting service:
- GitHub Pages
- Netlify or Vercel
- Any web server

## 📋 Lines Covered
Guangzhou Lines 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 18, 21, 22, 24 · APM Line · Haizhu Tram · Huangpu Tram 1 & 2 · Guangfo Line · Foshan Lines 2 & 3 · Nanhai Tram 1
