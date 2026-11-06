# Kubernetes Tooling Agent

[Kubernetes](https://kubernetes.io/) and [Helm](https://helm.sh/)

A Jenkins agent image for Kubernetes diagnostics, cluster operations, and manifest workflows.

## Why this agent exists
This image provides the Kubernetes, Helm, and operational tooling needed to validate cluster state, deploy manifests, and troubleshoot environment issues directly from Jenkins jobs.

## What it builds
This agent is used to inspect and render Kubernetes manifests, verify deployments, and support release validation across clusters and namespaces.

## Common use cases
- `kubectl` validation and cluster health checks
- Helm chart rendering and deployment verification
- Kustomize and YAML-based platform workflows
- Troubleshooting pods, services, DNS, and network connectivity

| Capability | Tools |
| --- | --- |
| Inspect and compose Kubernetes resources | [`kubectl`](https://kubernetes.io/docs/reference/kubectl/), [Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/), [yq](https://mikefarah.gitbook.io/yq) |
| Follow and filter pod logs | [stern](https://github.com/stern/stern) |
| Switch Kubernetes contexts and namespaces | [kubectx](https://github.com/ahmetb/kubectx), [kubens](https://github.com/ahmetb/kubectx) |
| Diagnose connectivity and host processes | [`dig`](https://www.isc.org/dhcp/), [ping](https://man7.org/linux/man-pages/man8/ping.8.html), [ip](https://man7.org/linux/man-pages/man8/ip.8.html), [netcat](https://nmap.org/ncat/), [ps](https://man7.org/linux/man-pages/man1/ps.1.html) |

Built on `build-jenkins-base`, which also provides the Jenkins agent runtime, Docker CLI, Helm, cloud CLIs, and common build utilities.