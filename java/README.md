# Java Agent

A Jenkins agent image for building and testing Java applications with Maven or Gradle.

| Capability | Tools |
| --- | --- |
| Compile and run Java applications | Default JDK |
| Build and manage project dependencies | Maven, Gradle |

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.