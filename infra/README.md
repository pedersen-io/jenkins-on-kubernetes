# Infrastructure Agent

A Jenkins agent image for infrastructure automation, Kubernetes delivery, and platform workflows.

| Capability | Tools |
| --- | --- |
| Manage Terraform and OpenTofu | Terraform, OpenTofu (`tofu`) |
| Render and validate Helm charts | `helm` |
| Validate Kubernetes manifests | `kubectl`, `kubeconform` |
| Process YAML and structured data | `yq` |
| Check IaC quality and policy compliance | `checkov` |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.
