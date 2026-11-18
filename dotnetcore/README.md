# .NET Agent

A Jenkins agent image for building and testing .NET applications with stable .NET SDK tracks.

| Capability | Tools |
| --- | --- |
| Build and test .NET projects | .NET SDK 10.x GA and 11.x GA (`dotnet`) |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.