# Go Agent

A Jenkins agent image for building, testing, documenting, and developing Go projects.

| Capability | Tools |
| --- | --- |
| Compile and manage Go projects | Go toolchain, `go` |
| Go language support and mock generation | `gopls`, `mockgen` |
| Generate Swagger/OpenAPI definitions | `swagger` (go-swagger) |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.