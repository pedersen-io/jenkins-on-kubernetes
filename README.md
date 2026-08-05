# Jenkins on DigitalOcean Kubernetes (DOKS)

This repository contains Jenkins controller and agent configuration for running Jenkins in-cluster on DigitalOcean Kubernetes (DOKS).

## Deploying Jenkins to DigitalOcean Kubernetes (DOKS)

This project publishes build images to Docker Hub and avoids provider-specific tooling in the controller images. The sections below outline high-level steps to deploy Jenkins in-cluster on DOKS and get CI building and pushing images.

Prerequisites:
- `doctl`, `kubectl`, and `helm` installed and authenticated
- A DOKS cluster created and kubeconfig available
- Docker Hub credentials for pushing/pulling images

Quick steps:

1. Provision a DOKS cluster (example):

```bash
doctl kubernetes cluster create my-doks-cluster --region nyc1 --node-pool "name=default;size=s-2vcpu-4gb;count=3"
doctl kubernetes cluster kubeconfig save my-doks-cluster
```

2. Create `jenkins` namespace:

```bash
kubectl create namespace jenkins
```

3. Create Docker Hub secret (used for image pulls/pushes):

```bash
kubectl -n jenkins create secret docker-registry regcred \
  --docker-username=<DOCKER_USER> \
  --docker-password=<DOCKER_PASS> \
  --docker-email=<EMAIL>
```

4. Provide Jenkins Configuration as Code (CasC):
- Option A: Keep using the raw GitHub URL in `casCGlobalConfig.configurationPath` (ensure accessibility).
- Option B: Create a ConfigMap and mount your own CasC YAML into the Jenkins controller.

```bash
kubectl -n jenkins create configmap jenkins-casc --from-file=jenkins-casc.yaml
```

5. Install Jenkins with Helm (example):

```bash
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm install jenkins jenkins/jenkins -n jenkins -f jenkins-values.yaml
```

6. Ensure the Jenkins Kubernetes cloud and pod templates (in your CasC YAML and `ContainersConfig.yaml`) reference the Docker Hub image names and, if necessary, reference the `regcred` imagePullSecret.

7. Build strategy:
- Current repo uses host `docker.sock` mounts in pod templates. This may work if your DOKS node image runs Docker and hostPath mounts are allowed. Mounting the host socket grants privileged access to the node — consider security implications.
- Recommended alternative: use Kaniko or BuildKit for in-cluster builds (no host docker). If you need, add a Kaniko executor stage in `Jenkinsfile` and an image-pull secret.

8. Cleanup old cloud provider credentials: Remove legacy provider-specific credential entries from any CasC YAML if they are no longer needed.

Verification:
- Trigger a Jenkins pipeline that builds and pushes an image; confirm the image appears in Docker Hub and agents connect successfully.

If you want, I can add an example `values.yaml` for Helm that mounts a CasC ConfigMap and a sample Kaniko pipeline stage.
