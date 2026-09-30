# Python Agent

A Jenkins agent image for Python development, package installation, and automated testing.

| Capability | Tools |
| --- | --- |
| Run Python projects and manage packages | Python 3, pip, venv |
| Run tests | pytest |
| Format and lint Python code | Black, Flake8 |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.