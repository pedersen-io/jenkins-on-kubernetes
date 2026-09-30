# Ruby Agent

A Jenkins agent image for building and testing Ruby applications and gems.

| Capability | Tools |
| --- | --- |
| Run Ruby applications | Ruby |
| Manage Ruby dependencies | Bundler |
| Build native extensions | build-essential |
| Work with source repositories | Git |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.