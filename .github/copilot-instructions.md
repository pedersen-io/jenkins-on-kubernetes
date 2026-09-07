# Copilot instructions for this repository

This repository’s canonical guidance for external AI agents lives in the root `AGENTS.md` file. That file is the source of truth for repo conventions, image naming, and agent build workflow.

This file is supplemental and should stay aligned with `AGENTS.md`.

## Project purpose
This repository builds and publishes Jenkins agent Docker images for Kubernetes-based CI workloads. The base image is created from the root Dockerfile and is used by language-specific agent images such as dotnetcore, golang, node, and python.

## Repo conventions
- Keep each agent folder consistent with the repo pattern: `Dockerfile` + `Makefile`.
- Start language-specific agent Dockerfiles from `FROM build-jenkins-base` unless there is a specific reason not to.
- Keep image names consistent with `derekpedersen/build-<language>`.
- Use `GIT_COMMIT_SHA ?= $(shell git rev-parse HEAD)` in agent Makefiles.
- Keep the standard `build` and `publish-docker` targets in each agent Makefile.

## Root build workflow
- Update the root `AGENT_DIRS` list in `Makefile` whenever a new agent folder is added.
- Keep the build order aligned with the existing folders.
- The repo uses `docker build` and `docker push` patterns for both base and agent images.

## Files to inspect before making changes
- `AGENTS.md` for the canonical external-agent rules
- `Makefile` for root build and agent registration
- A similar existing agent folder such as `golang` or `node` for structure and conventions
- `values.yaml` when changes affect Jenkins pod templates or image names

## Preferred change style
- Prefer small, repo-consistent changes over broad refactors.
- Do not add unrelated tooling or dependencies unless required by the task.
- Keep Docker layers simple and focused on the required runtime or build tools.
- Preserve existing naming, target names, and CI conventions.

## Quick validation

```bash
grep -n 'AGENT_DIRS' Makefile
ls -1
```
