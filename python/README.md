# Python Agent

[Python](https://www.python.org/)

A Jenkins agent image for Python development, package installation, and automated testing.

## Why this agent exists
This image provides a ready-to-use Python runtime and the common packaging and test tools Jenkins needs to run Python workloads consistently across repos.

## What it builds
This agent is used to install dependencies, run Python services and scripts, execute tests, and enforce formatting or linting across Python projects.

## Common use cases
- Python app and library builds
- `pip` and virtualenv-driven dependency flows
- pytest and CI validation pipelines
- Formatting and linting with Black and Flake8

| Capability | Tools |
| --- | --- |
| Run Python projects and manage packages | [Python 3](https://www.python.org/), [pip](https://pip.pypa.io/), [venv](https://docs.python.org/3/library/venv.html) |
| Run tests | [pytest](https://docs.pytest.org/) |
| Format and lint Python code | [Black](https://black.readthedocs.io/), [Flake8](https://flake8.pycqa.org/) |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.