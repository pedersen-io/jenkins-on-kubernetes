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

| Agent | README | Docker Hub image |
| --- | --- | --- |
| .NET | [dotnetcore](dotnetcore/README.md) | [build-jenkins-dotnetcore](https://hub.docker.com/r/derekpedersen/build-jenkins-dotnetcore) |
| Go | [golang](golang/README.md) | [build-jenkins-golang](https://hub.docker.com/r/derekpedersen/build-jenkins-golang) |
| Node.js | [node](node/README.md) | [build-jenkins-node](https://hub.docker.com/r/derekpedersen/build-jenkins-node) |
| Python | [python](python/README.md) | [build-jenkins-python](https://hub.docker.com/r/derekpedersen/build-jenkins-python) |
| Rust | [rust](rust/README.md) | [build-jenkins-rust](https://hub.docker.com/r/derekpedersen/build-jenkins-rust) |
| C/C++ | [c](c/README.md) | [build-jenkins-c](https://hub.docker.com/r/derekpedersen/build-jenkins-c) |
| Java | [java](java/README.md) | [build-jenkins-java](https://hub.docker.com/r/derekpedersen/build-jenkins-java) |
| PHP | [php](php/README.md) | [build-jenkins-php](https://hub.docker.com/r/derekpedersen/build-jenkins-php) |
| Ruby | [ruby](ruby/README.md) | [build-jenkins-ruby](https://hub.docker.com/r/derekpedersen/build-jenkins-ruby) |
| Kubernetes tooling | [k8s-tooling](k8s-tooling/README.md) | [build-jenkins-k8s-tooling](https://hub.docker.com/r/derekpedersen/build-jenkins-k8s-tooling) |
| Playwright | [playwright](playwright/README.md) | [build-jenkins-playwright](https://hub.docker.com/r/derekpedersen/build-jenkins-playwright) |

All images are published to Docker Hub with both `latest` and git SHA tags.

## Trivy outputs

Trivy helpers and generated artifacts now live under `.trivy/`:

- Script: `.trivy/scan-image.sh`
- Script: `.trivy/trivy-summary.sh`
- Raw scan reports: `.trivy/reports/`
- Rendered summary artifacts: `.trivy/summary/`

The Jenkins pipeline archives report artifacts from `.trivy/reports/*.json`, `.trivy/reports/*.txt`, `.trivy/summary/*.html`, and `.trivy/summary/*.md`.

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

Install or upgrade Jenkins with both the base Helm values and the separate CasC file:

```bash
make helm-upgrade-init
```

The repo keeps deployment defaults in [values.yaml](values.yaml) and Jenkins configuration-as-code in [jenkins-casc.yaml](jenkins-casc.yaml). Helm merges them automatically with `-f values.yaml -f jenkins-casc.yaml`.

If using GitHub OAuth via JCasC, create the OAuth secret before running Helm upgrade so Jenkins has credentials at startup:

```bash
kubectl -n jenkins create secret generic jenkins-github-oauth \
  --from-literal=client-id=<GITHUB_OAUTH_CLIENT_ID> \
  --from-literal=client-secret=<GITHUB_OAUTH_CLIENT_SECRET> \
  --dry-run=client -o yaml | kubectl apply -f -
```

Apply order for auth changes:

1. Create or update the `jenkins-github-oauth` secret.
2. Run `make helm-upgrade-init`.

If auth is misconfigured and you are locked out, fix the config in [values.yaml](values.yaml) and/or [jenkins-casc.yaml](jenkins-casc.yaml), then re-run Helm upgrade to reapply JCasC.

Get admin password:

```bash
kubectl -n jenkins get secret jenkins -o jsonpath='{.data.jenkins-admin-password}' | base64 --decode
```

## AI agent guidance

See [AGENTS.md](AGENTS.md) for the canonical instructions for AI coding and build agents working in this repository.

