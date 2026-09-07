FROM build-jenkins-base

USER root

# Install Java build tooling for Maven and Gradle workflows.
RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
        default-jdk \
        maven \
        gradle \
        ca-certificates \
        curl \
        unzip && \
    rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH="$JAVA_HOME/bin:${PATH}"

WORKDIR /home/jenkins
