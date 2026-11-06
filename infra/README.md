# Infrastructure Agent

[Kubernetes](https://kubernetes.io/), [Helm](https://helm.sh/), and [AWS](https://aws.amazon.com/)

A Jenkins agent image for infrastructure automation, Kubernetes delivery, and platform workflows.

## Why this agent exists
This image gives Jenkins the infrastructure validation and platform tooling needed to render manifests, check deployments, and enforce quality gates across Kubernetes, IaC, and cloud automation workflows.

## What it builds
This agent is used to validate Kubernetes manifests, render Helm charts, review infrastructure definitions, and support platform delivery automation for both Kubernetes and AWS-based deployments.

## Common use cases
- Helm chart rendering and validation
- Kubernetes manifest linting and deployment checks
- OpenTofu/Terraform-driven platform automation
- Infrastructure policy and compliance validation
- AWS CLI automation for ECR, IAM, EC2, S3, and EKS workflows

| Capability | Tools |
| --- | --- |
| Manage Terraform and OpenTofu | [Terraform](https://developer.hashicorp.com/terraform), [OpenTofu](https://opentofu.org/) (`tofu`) |
| Render and validate Helm charts | [Helm](https://helm.sh/) |
| Validate Kubernetes manifests | [`kubectl`](https://kubernetes.io/docs/reference/kubectl/), [kubeconform](https://github.com/yannh/kubeconform) |
| Process YAML and structured data | [yq](https://mikefarah.gitbook.io/yq) |
| Check IaC quality and policy compliance | [checkov](https://www.checkov.io/) |
| Manage AWS resources and identities | [AWS CLI](https://aws.amazon.com/cli/) (`aws`) |
| Connect to EC2 instances | [AWS Session Manager plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html) |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.
