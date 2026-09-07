FROM build-jenkins-base

USER root

# Install C/C++ toolchain and common diagnostics tools
RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
        build-essential \
        gcc \
        g++ \
        make \
        cmake \
        ninja-build \
        pkg-config \
        gdb \
        valgrind && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/jenkins
