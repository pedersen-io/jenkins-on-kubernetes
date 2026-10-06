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

## Reusable Jenkins deploy preflight

This repository includes reusable scripts for Kubernetes deploy validation and Helm deployment:

- Script: [scripts/helm-preflight.sh](scripts/helm-preflight.sh)
- Script: [scripts/helm-validate.sh](scripts/helm-validate.sh)
- Script: [scripts/helm-render.sh](scripts/helm-render.sh)
- Script: [scripts/helm-diff.sh](scripts/helm-diff.sh)
- Script: [scripts/helm-deploy.sh](scripts/helm-deploy.sh)
- Script: [scripts/helm-version.sh](scripts/helm-version.sh)
- Script: [scripts/docker-build.sh](scripts/docker-build.sh)
- Script: [scripts/docker-push.sh](scripts/docker-push.sh)
- Make target (generic): `make k8s-deploy-preflight`
- Make target: `make helm-preflight`
- Make target (render validation): `make helm-validate`
- Make target (render manifests to file): `make helm-render`
- Make target (show release diff): `make helm-diff`
- Make target (Helm deploy): `make helm-deploy`
- Make target (set app version + image tag from deploy SHA): `make helm-version`
- Make target (preflight + Helm upgrade): `make helm-upgrade-ci`
- Make target (docker build): `make docker-build`
- Make target (docker push): `make docker-push`
- Make target (docker build + push tags): `make docker-build-push`

The preflight verifies kubeconfig/context and checks RBAC before deploy steps run. The deploy script handles `helm upgrade --install` and optional override flags.

### Jenkins credentials and environment

Provide these Jenkins string credentials:

- `digital-ocean-pat`
- `digital-ocean-k8s-cluster`

Map them to these environment variables in your pipeline:

- `DIGITALOCEAN_ACCESS_TOKEN`
- `DIGITALOCEAN_K8S_CLUSTER`

Optional environment variables for customization:

- `HELM_NAMESPACE` (default: `jenkins`)
- `K8S_TARGET_NAMESPACE` (overrides `HELM_NAMESPACE` for RBAC checks)
- `K8S_RBAC_RESOURCES` (space-separated, default: `secrets`)
- `K8S_RBAC_VERBS` (space-separated, default: `get list create update patch`)
- `DOCTL_KUBECONFIG_SAVE` (`1` by default; set `0` to skip doctl kubeconfig save)
- `DOCTL_ACCESS_TOKEN` and `DO_CLUSTER_NAME` as alternates to `DIGITALOCEAN_*`

Optional Helm deploy variables:

- `HELM_RELEASE`, `HELM_CHART`, `HELM_NAMESPACE`
- `HELM_VALUES` and `HELM_CASC_VALUES` (used by default)
- `HELM_VALUES_FILES` (overrides values file list)
- `HELM_SET_KV` (space-separated `key=value` list, each passed as `--set-string`)
- `HELM_SET_VERSION_KEY` + `HELM_SET_VERSION` (for version/tag style set values)
- `HELM_IMAGE_NAME_KEY` + `HELM_IMAGE_NAME`
- `HELM_IMAGE_TAG_KEY` + `HELM_IMAGE_TAG`
- `HELM_SET_ARGS` (raw extra `--set` or `--set-string` flags)
- `HELM_EXTRA_ARGS` (other Helm flags like `--atomic` or `--timeout 10m`)
- `HELM_APP_VERSION_KEY` (default: `appVersion`, used by `helm-version`)
- `HELM_VALIDATE_SERVER_DRY_RUN` (`1` enables kubectl server-side dry-run in `helm-validate`)
- `HELM_RENDER_OUTPUT_PATH` (output path used by `helm-render`, default `./helm-rendered.yaml`)

Optional Docker build/push variables:

- `DOCKER_IMAGE_NAME` (required by `docker-build-push`)
- `DOCKER_TAGS` (space-separated tags, default `latest`)
- `DOCKERFILE_PATH` (default `Dockerfile`)
- `DOCKER_CONTEXT` (default `.`)
- `DOCKER_BUILD_ARGS` (raw docker build args)

### Jenkinsfile snippet

Keep Jenkinsfiles minimal and call Make targets or checked-in scripts.

```groovy
pipeline {
  agent {
    label 'build-jenkins-base'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Deploy preflight + helm upgrade') {
      steps {
        withCredentials([
          string(credentialsId: 'digital-ocean-pat', variable: 'DIGITALOCEAN_ACCESS_TOKEN'),
          string(credentialsId: 'digital-ocean-k8s-cluster', variable: 'DIGITALOCEAN_K8S_CLUSTER')
        ]) {
          sh 'make helm-upgrade-ci'
        }
      }
    }
  }
}
```

If you only want validation and not deploy, run:

```bash
make k8s-deploy-preflight
```

Equivalent command:

```bash
make helm-preflight
```

Example deploy with explicit image and chart set values:

```bash
make HELM_RELEASE=jupyter-hub \
  HELM_NAMESPACE=jupyter-hub \
  HELM_CHART=jupyterhub/jupyterhub \
  HELM_VALUES=./values.yaml \
  HELM_CASC_VALUES= \
  HELM_IMAGE_NAME_KEY=singleuser.image.name \
  HELM_IMAGE_TAG_KEY=singleuser.image.tag \
  HELM_IMAGE_NAME=docker.io/derekpedersen/jupyter-datascience-notebook \
  HELM_IMAGE_TAG=999e948226cce2289f6166141bea9079e29e4323 \
  HELM_EXTRA_ARGS='--create-namespace' \
  helm-upgrade-ci
```

Example `helm-version` usage (set appVersion and image tag to deploy SHA):

```bash
make HELM_RELEASE=jupyter-hub \
  HELM_NAMESPACE=jupyter-hub \
  HELM_CHART=jupyterhub/jupyterhub \
  HELM_VALUES=./values.yaml \
  HELM_CASC_VALUES= \
  DEPLOY_GIT_SHA=999e948226cce2289f6166141bea9079e29e4323 \
  HELM_APP_VERSION_KEY=appVersion \
  HELM_IMAGE_TAG_KEY=singleuser.image.tag \
  helm-version
```

Example `helm-validate` usage:

```bash
make HELM_RELEASE=jenkins \
  HELM_NAMESPACE=jenkins \
  HELM_CHART=jenkins/jenkins \
  HELM_VALUES=values.yaml \
  HELM_CASC_VALUES=jenkins-casc.yaml \
  helm-validate
```

Example `helm-render` usage:

```bash
make HELM_RELEASE=jenkins \
  HELM_NAMESPACE=jenkins \
  HELM_CHART=jenkins/jenkins \
  HELM_RENDER_OUTPUT_PATH=./artifacts/jenkins-rendered.yaml \
  helm-render
```

Example `docker-build-push` usage:

```bash
make DOCKER_IMAGE_NAME=derekpedersen/build-jenkins-base \
  DOCKER_TAGS="latest $(git rev-parse HEAD)" \
  DOCKERFILE_PATH=Dockerfile \
  DOCKER_CONTEXT=. \
  docker-build-push
```

Example separate Docker build then push usage:

```bash
make DOCKER_IMAGE_NAME=derekpedersen/build-jenkins-base \
  DOCKER_TAGS="latest $(git rev-parse HEAD)" \
  DOCKERFILE_PATH=Dockerfile \
  DOCKER_CONTEXT=. \
  docker-build

make DOCKER_IMAGE_NAME=derekpedersen/build-jenkins-base \
  DOCKER_TAGS="latest $(git rev-parse HEAD)" \
  docker-push
```

Jenkins parameter example for deploy repositories:

```groovy
parameters {
  string(name: 'DEPLOY_GIT_SHA', defaultValue: '', description: 'Git SHA to deploy')
}

stage('Deploy with version pin') {
  steps {
    withCredentials([
      string(credentialsId: 'digital-ocean-pat', variable: 'DIGITALOCEAN_ACCESS_TOKEN'),
      string(credentialsId: 'digital-ocean-k8s-cluster', variable: 'DIGITALOCEAN_K8S_CLUSTER')
    ]) {
      sh '''
        make HELM_RELEASE=jupyter-hub \
          HELM_NAMESPACE=jupyter-hub \
          HELM_CHART=jupyterhub/jupyterhub \
          HELM_VALUES=./values.yaml \
          HELM_CASC_VALUES= \
          DEPLOY_GIT_SHA="${DEPLOY_GIT_SHA}" \
          HELM_APP_VERSION_KEY=appVersion \
          HELM_IMAGE_TAG_KEY=singleuser.image.tag \
          helm-version
      '''
    }
  }
}
```

### Jenkinsfile snippet for external repositories

If another repository wants to reuse this deploy logic, check out this repository into a subdirectory and run the shared targets from there.

```groovy
pipeline {
  agent {
    label 'build-jenkins-base'
  }

  stages {
    stage('Checkout app repository') {
      steps {
        checkout scm
      }
    }

    stage('Checkout shared deploy tooling') {
      steps {
        dir('jenkins-on-kubernetes') {
          git branch: 'main', url: 'https://github.com/pedersen-io/jenkins-on-kubernetes.git'
        }
      }
    }

    stage('Deploy preflight + helm upgrade') {
      steps {
        withCredentials([
          string(credentialsId: 'digital-ocean-pat', variable: 'DIGITALOCEAN_ACCESS_TOKEN'),
          string(credentialsId: 'digital-ocean-k8s-cluster', variable: 'DIGITALOCEAN_K8S_CLUSTER')
        ]) {
          dir('jenkins-on-kubernetes') {
            sh 'make HELM_NAMESPACE=jenkins helm-upgrade-ci'
          }
        }
      }
    }
  }
}
```

If you only want the preflight from an external repository, run:

```groovy
dir('jenkins-on-kubernetes') {
  sh 'make HELM_NAMESPACE=jenkins k8s-deploy-preflight'
}
```

## AI agent guidance

See [AGENTS.md](AGENTS.md) for the canonical instructions for AI coding and build agents in this repository.

