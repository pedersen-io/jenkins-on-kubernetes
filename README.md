# Jenkins on Kubernetes

Production-oriented Jenkins CI/CD for Kubernetes.

[Project website](https://jenksin.pedersen.io)

## Project overview

This repository packages a self-hosted Jenkins environment for Kubernetes. It provides a shared inbound-agent base image, specialized agent images, and pipelines for publishing images and deploying Jenkins.

The setup is intended for evaluating CI/CD architecture and operational patterns. It favors reproducible Docker builds and Kubernetes-native agents while keeping deployment separate from image publishing.

## Images

Docker Hub profile: [derekpedersen](https://hub.docker.com/u/derekpedersen)

Base inbound-agent image:

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

Images are published to Docker Hub with `latest` and Git commit SHA tags.

## Image vulnerability reports

Trivy scan and summary scripts are in `.trivy/`:

| Artifact | Location |
| --- | --- |
| Scan script | `.trivy/scan-image.sh` |
| Summary script | `.trivy/trivy-summary.sh` |
| Raw JSON and text reports | `.trivy/reports/` |
| Rendered HTML and Markdown summaries | `.trivy/summary/` |

The Jenkins pipeline archives the JSON and text scan reports and the HTML and Markdown summaries.

## Deploy to Kubernetes

Create the namespace:

```bash
kubectl create namespace jenkins
```

Create a Docker Hub pull secret in the `jenkins` namespace:

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

The `helm-upgrade-init` target initializes the Helm repository and installs or upgrades Jenkins using [values.yaml](values.yaml) and [jenkins-casc.yaml](jenkins-casc.yaml). The latter contains Jenkins Configuration as Code (JCasC).

To enable GitHub OAuth through JCasC, create or update the Kubernetes secret before deploying so the credentials are available at startup:

```bash
kubectl -n jenkins create secret generic jenkins-github-oauth \
  --from-literal=client-id=<GITHUB_OAUTH_CLIENT_ID> \
  --from-literal=client-secret=<GITHUB_OAUTH_CLIENT_SECRET> \
  --dry-run=client -o yaml | kubectl apply -f -
```

Apply authentication changes in this order:

1. Create or update the `jenkins-github-oauth` secret.
2. Run `make helm-upgrade-init` to apply the configuration.

If an authentication change prevents access to Jenkins, correct the configuration in [values.yaml](values.yaml) or [jenkins-casc.yaml](jenkins-casc.yaml), then run the upgrade target again.

Retrieve the Jenkins admin password:

```bash
kubectl -n jenkins get secret jenkins -o jsonpath='{.data.jenkins-admin-password}' | base64 --decode
```

## AI agent guidance

See [AGENTS.md](AGENTS.md) for the canonical instructions for AI coding and build agents in this repository.

