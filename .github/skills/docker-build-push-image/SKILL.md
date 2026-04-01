---
name: docker-build-push-image
description: "Use when rebuilding this repository's Docker image and pushing it to Docker Hub or another registry. Triggers: rebuild image, build image, push image, docker push, docker hub, publish container, push latest tag, build and push image."
---

# Docker Build And Push Image

## Goal
Build this repository's container image from the local Dockerfile and push the confirmed tag or tags to the confirmed registry.

## Required Inputs
- Image repository name, for example `jeonkwan/gz-metro-smart-kid`
- Primary tag, for example `latest`
- Target platform, defaulting to `linux/amd64`
- Whether to also push a dated rollback tag
- Confirmation that Docker authentication is ready for the target registry

## Required Confirmation Rule
Do not build or push anything until every required input is confirmed.

If any item is missing or ambiguous, ask concise follow-up questions with `vscode_askQuestions` or a direct user question and wait for the answers before proceeding.

## Workflow
1. Inspect the repo defaults before asking.
- Read `docs/run-guide.md`.
- Read `ansible/group_vars/all.yml` if deployment will use the same image.

2. Confirm required information.
- Confirm the target image repository.
- Confirm the primary tag.
- Confirm the target platform. Prefer `linux/amd64` for this repo because production runs on amd64.
- Confirm whether a rollback tag should also be pushed.
- Confirm Docker login is already valid for the target registry.

3. Verify prerequisites.
- Ensure `docker` is available.
- Ensure the repo root contains `Dockerfile`.

4. Run the repo script.
- Use `scripts/ops/docker-build-push.sh`.
- Pass the confirmed image, tag, and platform values.
- If the user asked for a rollback tag, pass it as `--extra-tag`.

5. Report the result.
- Summarize which tags were pushed.
- Include the pushed digest when available.
- If push fails because authentication is missing, stop and tell the user exactly that.

## Guardrails
- Never assume Docker login is valid without user confirmation or successful tool evidence.
- Never change deployment config files just to publish an image.
- Prefer the repo defaults, but still confirm them before pushing.
- Prefer a local `linux/amd64` build and push. Treat remote build as deployment fallback only, not the default publish path.

## Assets
- `scripts/ops/docker-build-push.sh`
- `docs/run-guide.md`

## Done Criteria
- The image is built successfully.
- Every confirmed tag was pushed successfully.
- The user receives the final tag list and digest.
