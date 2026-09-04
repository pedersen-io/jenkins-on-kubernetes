# Copilot instructions for this repository

## Project purpose
This repository builds and publishes Jenkins agent Docker images for Kubernetes-based CI workloads. The base image is created from the root Dockerfile and is used by language-specific agent images such as dotnetcore, golang, node, and python.

## Code conventions
- Preserve the repo’s existing pattern for agent folders.
- Each agent folder should contain a `Dockerfile` and a `Makefile`.
- Every agent `Dockerfile` should start from `FROM build-jenkins-base` unless there is a specific reason not to.
- Keep image names consistent with the existing naming scheme: `derekpedersen/build-<language>`.
- Use `GIT_COMMIT_SHA ?= $(shell git rev-parse HEAD)` in agent Makefiles.
- Keep the standard `build` and `publish-docker` targets in each agent Makefile.

## Root build workflow
- Update the root `AGENT_DIRS` list in `Makefile` whenever a new agent folder is added.
- Keep the build order aligned with the existing folders.
- The repo uses `docker build` and `docker push` patterns for both base and agent images.

## Files to inspect before making changes
- `Makefile` for root build and agent registration
- A similar existing agent folder such as `golang` or `node` for structure and conventions
- `values.yaml` when changes affect Jenkins pod templates or image names

## Preferred change style
- Prefer small, repo-consistent changes over broad refactors.
- Do not add unrelated tooling or dependencies unless required by the task.
- Keep Docker layers simple and focused on the required runtime or build tools.
- Preserve existing naming, target names, and CI conventions.

## When adding a new language agent
1. Create a new folder with the language name.
2. Add a `Dockerfile` tailored for that runtime/toolchain.
3. Add a `Makefile` with the same `build` and `publish-docker` pattern as other agents.
4. Add the folder name to the root `AGENT_DIRS` in `Makefile`.
5. Verify the change with a quick repository check such as `grep -n 'AGENT_DIRS' Makefile` and `ls -1`.
