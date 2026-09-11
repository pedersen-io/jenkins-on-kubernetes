# AGENTS.md

This file is the canonical operating guide for external AI coding and build agents working in this repository.

If there is any conflict between this file, the README, or editor-specific guidance, follow this file.

## Repository purpose

This repository builds and publishes Jenkins agent Docker images for Kubernetes-based CI workloads. The base image is created from the root Dockerfile and is reused by language-specific agent images such as dotnetcore, golang, node, python, rust, java, php, ruby, and others.

## Required conventions

- Preserve the repository's existing pattern for agent folders.
- Each agent folder should contain a Dockerfile and a Makefile.
- Every agent Dockerfile should start with `FROM build-jenkins-base` unless there is a clear reason not to.
- Keep image names consistent with the repo naming scheme: `derekpedersen/build-jenkins-<language>`.
- Use `GIT_COMMIT_SHA ?= $(shell git rev-parse HEAD)` in every agent Makefile.
- Keep the standard `build` and `publish-docker` targets in each agent Makefile.
- Keep changes small and repo-consistent rather than broad refactors.
- Do not add unrelated tooling or dependencies unless required by the runtime or build process.

## Root build workflow

- Update the root `AGENT_DIRS` list in the root `Makefile` whenever a new agent folder is added.
- Keep the build order aligned with the existing folders.
- Treat `AGENT_DIRS` in the root `Makefile` as the build source of truth.
- Keep Docker Hub image names, the README image list, and Jenkins pipeline stages aligned with the actual agent folders.
- Keep `values.yaml` aligned with any deployment changes that affect image names or pod templates.

## When adding or changing an agent

1. Inspect a similar existing agent folder such as `golang/` or `node/` to match conventions.
2. Create or modify the Dockerfile and Makefile in the target agent folder.
3. Keep the Docker build conventions and image naming consistent with existing agents.
4. Add the folder name to `AGENT_DIRS` in the root `Makefile` when adding a new agent.
5. Keep docs aligned with the new or changed image list.
6. Validate the repo with the required checks before finishing.

## Required validation

Run at least:

```bash
grep -n 'AGENT_DIRS' Makefile
ls -1
make -n build-agents
```

If a change affects a published image name or build behavior, also verify the affected Dockerfile and Makefile still match the existing repo conventions.

## Definition of done

A change is complete only when:

- affected agent layouts still follow the repo pattern,
- naming conventions and Makefile targets remain consistent,
- `AGENT_DIRS` remains the build source of truth,
- README and deployment notes stay aligned with actual Docker Hub usage,
- repo verification checks pass.

## Supplemental guidance

- This repository also contains editor-specific guidance in `.github/copilot-instructions.md`.
- That file is supplemental only and should stay aligned with this file.
- Keep the repo’s Docker-first, Jenkins-on-Kubernetes approach intact unless the task explicitly requires a design change.
