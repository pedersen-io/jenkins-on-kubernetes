# Java Agent

A Jenkins agent image for building and testing Java applications with a Maven-first CI workflow.

| Capability | Tools |
| --- | --- |
| Compile and run Java applications | JDK 17 |
| Build and manage project dependencies | Maven, Gradle |
| Run JVM CI pipelines | Git, curl, unzip |

This image is optimized for Java projects using Maven, while still leaving Gradle available for teams that rely on it. The Maven local repository is configured under `/home/jenkins/.m2/repository` to keep dependency cache behavior consistent across jobs.

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.