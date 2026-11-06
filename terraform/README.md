# Terraform / OpenTofu Agent

[Terraform](https://developer.hashicorp.com/terraform) and [OpenTofu](https://opentofu.org/)

A Jenkins agent image for infrastructure-as-code workflows using Terraform and OpenTofu.

## Why this agent exists
This image gives Jenkins the IaC tooling needed to validate, plan, and apply infrastructure definitions in a portable and repeatable way across cloud and Kubernetes platforms.

## What it builds
This agent is used to run Terraform and OpenTofu configurations, validate modules, and support multi-cloud infrastructure automation with platform tooling already present in the base image.

## Common use cases
- Terraform plan and apply pipelines
- OpenTofu-based IaC validation
- TFLint and policy checks for infrastructure code
- Cloud and Kubernetes operations that need Docker, Helm, and `kubectl`

| Capability | Tools |
| --- | --- |
| Manage Terraform code | [Terraform CLI](https://developer.hashicorp.com/terraform) |
| Work with OpenTofu code | [OpenTofu](https://opentofu.org/) (`tofu`) |
| Validate IaC quality | [TFLint](https://github.com/terraform-linters/tflint) |
| Support multi-cloud operations | [Docker CLI](https://docs.docker.com/engine/reference/commandline/cli/), [`kubectl`](https://kubernetes.io/docs/reference/kubectl/), [Helm](https://helm.sh/), cloud CLIs from the base image |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.
