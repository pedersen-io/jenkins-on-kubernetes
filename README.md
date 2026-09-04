# Jenkins on Kubernetes

Production-minded Jenkins controller and agent image pipeline for Kubernetes-based CI.

Project website: https://jenksin.pedersen.io

## Why this project exists

I have spent years building CI/CD systems in Bamboo, GitLab CI, and GitHub Actions. This Jenkins setup is where I can do the same kind of platform work on my own terms, without vendor constraints, and keep learning by shipping.

I run it on my Kubernetes cluster so I can test architecture and workflow patterns end to end: image design, agent behavior, pipeline flow, and day-2 operations.

- CI architecture that is simple to reason about and easy to operate
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

All images are published to Docker Hub with both `latest` and git SHA tags.

## Repo layout

Agent directories:

- dotnetcore/: .NET agent image (Dockerfile + Makefile)
- golang/: Go agent image (Dockerfile + Makefile)
- node/: Node.js agent image (Dockerfile + Makefile)
- python/: Python agent image (Dockerfile + Makefile)

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

## AI agent runbook

If you are an AI coding/build agent modifying this repo, follow these rules:

1. Keep each agent folder structure consistent: `Dockerfile` + `Makefile`.
2. Start language agent Dockerfiles from `FROM build-jenkins-base` unless there is a clear reason not to.
3. Keep image naming consistent: `derekpedersen/build-<language>`.
4. Keep `GIT_COMMIT_SHA ?= $(shell git rev-parse HEAD)` in every agent Makefile.
5. Keep `build` and `publish-docker` targets in every agent Makefile.
6. When adding a new agent, update `AGENT_DIRS` in the root `Makefile`.
7. Prefer minimal, targeted changes over broad refactors.
8. Validate with at least:

```bash
grep -n 'AGENT_DIRS' Makefile
make -n build-agents
```

Definition of done for agent changes:

- Builds complete locally for affected images.
- Naming conventions and target conventions are preserved.
- README and deployment notes stay aligned with Docker Hub usage.

## Architecture notes and tradeoffs

- Current workflow prioritizes straightforward Docker-based builds.
- If using host Docker socket mounts inside Kubernetes agents, treat that as a privileged capability and scope access carefully.
- For stricter multi-tenant isolation, migrate build stages to Kaniko or BuildKit rootless patterns.
