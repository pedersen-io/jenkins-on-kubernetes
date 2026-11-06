FROM build-jenkins-base

USER root

ARG JAVA_VERSION=17

# Install Java build tooling for Maven-first JVM pipelines.
RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
        openjdk-${JAVA_VERSION}-jdk \
        maven \
        gradle \
        ca-certificates \
        curl \
        git \
        unzip && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:${PATH}"
ENV MAVEN_OPTS="-Dmaven.repo.local=/home/jenkins/.m2/repository"

RUN mkdir -p /home/jenkins/.m2 && \
    chown -R jenkins:jenkins /home/jenkins/.m2

WORKDIR /home/jenkins

RUN java -version && \
    mvn -version
