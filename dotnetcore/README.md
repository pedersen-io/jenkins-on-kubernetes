# .NET Agent

[.NET](https://dotnet.microsoft.com/)

A Jenkins agent image for building and testing .NET applications with the .NET 10 SDK.

## Why this agent exists
This image gives Jenkins the .NET SDK and runtime dependencies needed for consistent builds across ASP.NET, library, and CLI projects without requiring per-job environment drift.

## What it builds
This agent is used to compile .NET code, restore packages, run tests, and package applications for deployment in modern .NET workloads.

## Common use cases
- ASP.NET Core and web API pipelines
- Library, console, and service builds
- Automated test execution with `dotnet test`
- CI publishing for NuGet and deployment artifacts

| Capability | Tools |
| --- | --- |
| Build and test .NET projects | [.NET SDK 10.0](https://dotnet.microsoft.com/) (`dotnet`) |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.