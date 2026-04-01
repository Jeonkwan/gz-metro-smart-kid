---
name: redeploy-server
description: "Use when redeploying this repository to the configured server with Ansible after a content or image change. Triggers: redeploy server, deploy again, rerun deploy, pull latest image, redeploy production, run ansible deploy, restart container on server."
---

# Redeploy Server

## Goal
Redeploy the repository's container to the configured server using the checked-in Ansible playbook and the confirmed deployment target information.

## Required Inputs
- Inventory path
- Playbook path
- Target host or host limit
- Image tag to deploy, or explicit confirmation to use the default tag
- Confirmation that remote SSH access is expected to work

## Required Confirmation Rule
Do not run any remote deployment command until every required input is confirmed.

If any required item is missing, unclear, or contradictory, ask follow-up questions first and wait for the answers.

## Workflow
1. Inspect the repo defaults before asking.
- Read `docs/run-guide.md`.
- Read `ansible/inventory/hosts.ini`.
- Read `ansible/group_vars/all.yml`.
- Read `ansible/playbooks/deploy.yml`.

2. Confirm required information.
- Confirm the inventory path.
- Confirm the playbook path.
- Confirm the target host alias or limit.
- Confirm the image tag to deploy, or confirm that the default configured tag should be used.
- Confirm the user wants the remote deployment attempted now.

3. Verify prerequisites.
- Ensure `ansible-playbook` is available.
- Ensure the `community.docker` collection is installed or install it from `ansible/requirements.yml`.
- Run the repo preflight check first to verify SSH reachability and the current site endpoint.

4. Run the repo script.
- Use `scripts/ops/redeploy-server.sh`.
- Pass the confirmed inventory, playbook, limit, and optional image tag.

5. If the deployment fails.
- Collect the exact failure.
- If it is a network or SSH problem, test the configured host reachability and summarize the evidence.
- Do not silently retry destructive remote operations.

6. Report the result.
- State whether deployment succeeded.
- If successful, include the deployed tag and the target host.
- If blocked, identify the exact missing access or prerequisite.

## Guardrails
- Never assume the user wants `latest` unless they confirmed that the default tag should be used.
- Never edit inventory or deployment variables just to force a deployment unless the user explicitly asks.
- If the image has not been built and pushed yet, say so and use the `docker-build-push-image` skill first.

## Assets
- `scripts/ops/redeploy-preflight.sh`
- `scripts/ops/redeploy-server.sh`
- `ansible/requirements.yml`
- `ansible/inventory/hosts.ini`
- `ansible/group_vars/all.yml`
- `ansible/playbooks/deploy.yml`

## Done Criteria
- All required deployment inputs were confirmed before execution.
- The playbook ran against the confirmed target.
- The result and any blocking evidence were reported clearly.
