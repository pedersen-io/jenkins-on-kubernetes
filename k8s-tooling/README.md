# Kubernetes Tooling Agent

A Jenkins agent image for Kubernetes diagnostics, cluster operations, and manifest workflows.

| Capability | Tools |
| --- | --- |
| Inspect and compose Kubernetes resources | `kubectl`, Kustomize, yq |
| Follow and filter pod logs | stern |
| Switch Kubernetes contexts and namespaces | kubectx, kubens |
| Diagnose connectivity and host processes | `dig` and DNS utilities, `ping`, `ip`, netcat, `ps` |

Built on `build-jenkins-base`, which also provides the Jenkins agent runtime, Docker CLI, Helm, cloud CLIs, and common build utilities.