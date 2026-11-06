# Ruby Agent

[Ruby](https://www.ruby-lang.org/)

A Jenkins agent image for building and testing Ruby applications and gems.

## Why this agent exists
This image supplies the Ruby runtime and package tooling needed to run Ruby applications and gem-based CI pipelines without custom configuration on each Jenkins node.

## What it builds
This agent is used for Ruby application execution, dependency installation, native extension builds, and validation of gems and Ruby service projects.

## Common use cases
- Ruby service and library pipelines
- Bundler-based dependency resolution
- Gem build and packaging tasks
- CI validation for Rails and Ruby tooling workflows

| Capability | Tools |
| --- | --- |
| Run Ruby applications | [Ruby](https://www.ruby-lang.org/) |
| Manage Ruby dependencies | [Bundler](https://bundler.io/) |
| Build native extensions | [build-essential](https://wiki.debian.org/BuildEssential) |
| Work with source repositories | [Git](https://git-scm.com/) |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.