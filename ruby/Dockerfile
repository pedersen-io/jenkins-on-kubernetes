FROM build-jenkins-base

USER root

# Install Ruby and common native build dependencies.
RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
        ruby-full \
        build-essential \
        git \
        ca-certificates && \
    gem install bundler --no-document && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/jenkins
