# Go Agent

[Go](https://go.dev/)

A Jenkins agent image for building, testing, documenting, and developing Go projects.

## Why this agent exists
This image packages the Go toolchain and common development helpers so Jenkins can build Go services, CLIs, and libraries in a repeatable environment without custom setup on each worker.

## What it builds
This agent compiles Go code, resolves dependencies, runs tests, generates API docs, and supports tooling for service development and API contract work.

## Common use cases
- Go service and CLI builds
- Unit and integration test pipelines
- Swagger/OpenAPI generation and API docs
- Code generation workflows with `gopls` and `mockgen`

| Capability | Tools |
| --- | --- |
| Compile and manage Go projects | [Go toolchain](https://go.dev/), [`go`](https://go.dev/) |
| Go language support and mock generation | [`gopls`](https://github.com/golang/tools), [`mockgen`](https://github.com/golang/mock) |
| Generate Swagger/OpenAPI definitions | [`swagger`](https://github.com/go-swagger/go-swagger) (go-swagger) |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.