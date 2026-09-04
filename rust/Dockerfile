FROM build-jenkins-base

USER root

# Install Rust toolchain and common build dependencies
RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
        ca-certificates \
        curl \
        build-essential \
        pkg-config \
        libssl-dev && \
    curl https://sh.rustup.rs -sSf | sh -s -- -y --profile minimal && \
    /root/.cargo/bin/rustup component add rustfmt clippy && \
    ln -sf /root/.cargo/bin/cargo /usr/local/bin/cargo && \
    ln -sf /root/.cargo/bin/rustc /usr/local/bin/rustc && \
    ln -sf /root/.cargo/bin/rustup /usr/local/bin/rustup && \
    rm -rf /var/lib/apt/lists/*

ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /home/jenkins
