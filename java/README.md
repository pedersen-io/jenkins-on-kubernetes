# Java Agent

[Java](https://www.java.com/en/)

A Jenkins agent image for building and testing Java applications with a Maven-first CI workflow.

## Why this agent exists
This image gives Jenkins a consistent Java runtime and the dependency-management tooling needed to build JVM projects reliably across repos, teams, and pipelines.

## What it builds
This agent is used for compiling Java source, resolving dependencies, packaging JAR and WAR artifacts, and running JVM-based test suites for libraries, APIs, and services.

## Common use cases
- Maven and Gradle build pipelines
- Spring Boot, Quarkus, and Micronaut applications
- Java library packaging and release automation
- JUnit-based test execution and artifact publishing

| Capability | Tools |
| --- | --- |
| Compile and run Java applications | [JDK 17](https://openjdk.org/projects/jdk/17/) |
| Build and manage project dependencies | [Maven](https://maven.apache.org/), [Gradle](https://gradle.org/) |
| Run JVM CI pipelines | [Git](https://git-scm.com/), [curl](https://curl.se/), [unzip](https://infozip.sourceforge.net/UnZip.html) |

This image is optimized for Java projects using Maven, while still leaving Gradle available for teams that rely on it. The Maven local repository is configured under `/home/jenkins/.m2/repository` to keep dependency cache behavior consistent across jobs.

Built on `build-jenkins-base`, which provides the Jenkins agent runtime, Docker CLI, Kubernetes and cloud CLIs, and common build utilities.