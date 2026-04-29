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

```text
index.html          ← Main single-page app
marked.min.js       ← Browser Markdown renderer
Dockerfile          ← Caddy-based container image definition
entrypoint.sh       ← Generates the runtime Caddyfile from env vars
.env.example        ← Example container environment values
ansible/            ← Deployment inventory, vars, and playbook
docs/               ← Run guide and content workflow docs
scripts/ops/        ← Helper scripts for image publish and redeploy
.vscode/            ← VS Code launch and task configuration
data/
  en/               ← English Markdown content for each line
  zh/               ← Chinese Markdown content for each line
server.pl           ← Simple Perl static server helper
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
scripts/ops/redeploy-server.sh \
  --inventory ansible/inventory/hosts.ini \
  --playbook ansible/playbooks/deploy.yml \
  --limit gz-metro
```

The helper script runs preflight checks, installs Ansible collections, and then executes the playbook. The default deployment pulls `jeonkwan/gz-metro-smart-kid:latest` from Docker Hub, creates named volumes to persist TLS certificates, and starts the container with HTTPS on port 8443 via automatic Let's Encrypt certificates using ACME HTTP-01 on port 80.

Preferred workflow: build and push a `linux/amd64` image locally, then deploy by pulling that image on the server. The remote-build path exists only as a fallback when a compatible published image is unavailable.

Customise `ansible/group_vars/all.yml` to change the image name or tag, deployment mode, hostname, ports, or ACME email.

**To roll back** to a previous release, either set `image_tag` in `ansible/group_vars/all.yml` or pass `--image-tag 20260401` to `scripts/ops/redeploy-server.sh`, then redeploy.

## Copilot Workflow Skills

This repo now includes reusable Copilot skills for operations workflows:

- `.github/skills/docker-build-push-image/` for confirming build and push inputs before publishing a container image
- `.github/skills/redeploy-server/` for confirming deployment inputs before running the Ansible redeploy workflow
- `.github/skills/generate-line-stamp/` for generating consistent blue-ink collector stamps for metro lines

Supporting scripts live under `scripts/ops/`:

- `scripts/ops/docker-build-push.sh`
- `scripts/ops/redeploy-preflight.sh`
- `scripts/ops/redeploy-server.sh`

## 📝 Updating Content

Each metro line has two Markdown files:

- `data/en/<line-id>.md` — English content
- `data/zh/<line-id>.md` — Chinese content

Edit the Markdown files to update facts, add stations, or fix typos. For local development, just refresh the page after editing. For the production container workflow, rebuild and push the image, then redeploy the server.

## 🌐 Alternative Hosting

Because the app is client-side, you can also serve the folder from any static host that can return the Markdown files over HTTP:

- GitHub Pages via `.github/workflows/deploy-pages.yml`
- Netlify or Vercel
- Any web server

To publish with GitHub Pages, enable **Settings → Pages → Build and deployment → GitHub Actions**. The workflow deploys `index.html`, `marked.min.js`, the `data/` directory, and a `.nojekyll` file from `main`.

The repository's primary production workflow is the Docker image plus the Ansible deployment described above.

## 📋 Lines Covered

Guangzhou Lines 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 18, 21, 22, 24 · APM Line · Haizhu Tram · Huangpu Tram 1 & 2 · Guangfo Line · Foshan Lines 2 & 3 · Nanhai Tram 1
