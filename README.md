# Jenkins on Kubernetes

Production-minded Jenkins controller and agent image pipeline for Kubernetes-based CI.

Project website: https://jenksin.pedersen.io

## Why this project exists

I have spent years designing and operating CI/CD systems across Bamboo, GitLab CI, GitHub Actions, and similar platforms. This Jenkins setup gives me a free, open ecosystem to self-host, keep learning, and ship improvements quickly.

I run it on my Kubernetes cluster to test architecture and workflow patterns end to end: image design, agent behavior, pipeline flow, and day-2 operations.

- Straightforward CI architecture that is easy to reason about and operate
- Reproducible image builds and release workflows
- Kubernetes-native Jenkins agent patterns
- Practical tradeoffs between speed, reliability, and security

## What this repo builds

Docker Hub profile: [derekpedersen](https://hub.docker.com/u/derekpedersen)

Base image:

- `derekpedersen/build-jenkins-base` ([repo](https://hub.docker.com/r/derekpedersen/build-jenkins-base))

Agent images:

- `derekpedersen/build-dotnetcore` ([repo](https://hub.docker.com/r/derekpedersen/build-dotnetcore))
- `derekpedersen/build-golang` ([repo](https://hub.docker.com/r/derekpedersen/build-golang))
- `derekpedersen/build-node` ([repo](https://hub.docker.com/r/derekpedersen/build-node))
- `derekpedersen/build-python` ([repo](https://hub.docker.com/r/derekpedersen/build-python))
- `derekpedersen/build-rust` ([repo](https://hub.docker.com/r/derekpedersen/build-rust))
- `derekpedersen/build-c` ([repo](https://hub.docker.com/r/derekpedersen/build-c))
- `derekpedersen/build-java` ([repo](https://hub.docker.com/r/derekpedersen/build-java))
- `derekpedersen/build-php` ([repo](https://hub.docker.com/r/derekpedersen/build-php))
- `derekpedersen/build-ruby` ([repo](https://hub.docker.com/r/derekpedersen/build-ruby))
- `derekpedersen/build-k8s-tooling` ([repo](https://hub.docker.com/r/derekpedersen/build-k8s-tooling))
- `derekpedersen/build-playwright` ([repo](https://hub.docker.com/r/derekpedersen/build-playwright))

All images are published to Docker Hub with both `latest` and git SHA tags.

## Repo layout

Agent directories:

- dotnetcore/: .NET agent image (Dockerfile + Makefile)
- golang/: Go agent image (Dockerfile + Makefile)
- node/: Node.js agent image (Dockerfile + Makefile)
- python/: Python agent image (Dockerfile + Makefile)
- rust/: Rust agent image (Dockerfile + Makefile)
- c/: C/C++ agent image (Dockerfile + Makefile)
- java/: Java agent image (Dockerfile + Makefile)
- php/: PHP agent image (Dockerfile + Makefile)
- ruby/: Ruby agent image (Dockerfile + Makefile)
- k8s-tooling/: Kubernetes diagnostics and operations image (Dockerfile + Makefile)
- playwright/: Browser testing image for Playwright runs (Dockerfile + Makefile)

## Quickstart for developers

Prerequisites:

- Docker
- GNU Make
- kubectl
- helm
- Docker Hub account with push access

Build and publish all images:

```bash
make build-publish-all
```

Build everything without pushing:

```bash
make build-agents
```

Publish base image only:

```bash
make publish-docker
```

## Deploy Jenkins on Kubernetes

Create namespace:

```bash
kubectl create namespace jenkins
```

Create Docker Hub pull secret:

```bash
kubectl -n jenkins create secret docker-registry regcred \
  --docker-username=<DOCKER_USER> \
  --docker-password=<DOCKER_PASS> \
  --docker-email=<EMAIL>
```

Install or upgrade Jenkins:

```bash
make helm-upgrade-init
```

Get admin password:

```bash
kubectl -n jenkins get secret jenkins -o jsonpath='{.data.jenkins-admin-password}' | base64 --decode
```

## AI agent guidance

This repository’s canonical AI-agent instructions live in the root `AGENTS.md` file. That file is the source of truth for external AI coding and build agents.

If there is any mismatch between the README and `AGENTS.md`, follow `AGENTS.md`.

Short version:

1. Keep each agent folder consistent with `Dockerfile` + `Makefile`.
2. Start language-specific agent Dockerfiles from `FROM build-jenkins-base` when appropriate.
3. Keep image naming aligned with `derekpedersen/build-<language>`.
4. Preserve `GIT_COMMIT_SHA ?= $(shell git rev-parse HEAD)` and the standard `build` / `publish-docker` targets.
5. Update `AGENT_DIRS` in the root `Makefile` whenever a new agent is added.
6. Validate with a quick repo check such as:

```bash
grep -n 'AGENT_DIRS' Makefile
ls -1
```

The root `AGENT_DIRS` value and the agent folders in this repo remain the build metadata source of truth.

## Architecture notes and tradeoffs

- Current workflow prioritizes straightforward Docker-based builds.
- If using host Docker socket mounts inside Kubernetes agents, treat that as a privileged capability and scope access carefully.
- For stricter multi-tenant isolation, migrate build stages to Kaniko or BuildKit rootless patterns.
