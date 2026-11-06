# AWS Agent

A Jenkins agent image for AWS infrastructure, EKS operations, and cloud automation workflows.

| Capability | Tools |
| --- | --- |
| Manage AWS resources and identities | AWS CLI (`aws`) |
| Work with EC2, IAM, S3, and ECR | AWS CLI command set |
| Connect to EC2 instances | AWS Session Manager plugin |
| Support Kubernetes workloads on AWS | `kubectl`, `helm`, `eksctl` from the base image |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.
