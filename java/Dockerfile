FROM build-jenkins-base

USER root

# Install Java build tooling for Maven and Gradle workflows.
RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
        openjdk-17-jdk \
        maven \
        gradle \
        ca-certificates \
        curl \
        unzip && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:${PATH}"

WORKDIR /home/jenkins
