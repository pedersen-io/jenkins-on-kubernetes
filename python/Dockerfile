FROM build-jenkins-base

USER root

# Install Python runtime and tooling
RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
        python3 \
        python3-pip \
        python3-venv \
        python3-dev \
        ca-certificates \
        curl && \
    ln -sf /usr/bin/python3 /usr/local/bin/python && \
    ln -sf /usr/bin/pip3 /usr/local/bin/pip && \
    python -m pip install --upgrade pip setuptools wheel && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
    pytest \
    black \
    flake8

WORKDIR /home/jenkins
