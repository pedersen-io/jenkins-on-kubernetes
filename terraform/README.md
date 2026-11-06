# Terraform / OpenTofu Agent

A Jenkins agent image for infrastructure-as-code workflows using Terraform and OpenTofu.

| Capability | Tools |
| --- | --- |
| Manage Terraform code | Terraform CLI |
| Work with OpenTofu code | OpenTofu (`tofu`) |
| Validate IaC quality | TFLint |
| Support multi-cloud operations | Docker CLI, kubectl, Helm, cloud CLIs from the base image |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.
