FROM jenkins/inbound-agent:latest

USER root

# Install build tools, kubectl dependencies, and Docker CLI dependencies
RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        lsb-release \
        build-essential \
        jq \
        libapparmor-dev \
        libseccomp-dev && \
    rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN curl -fsSL -o /tmp/kubectl \
        "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl && \
    rm -f /tmp/kubectl

# Install Docker CLI only
# Docker daemon runs on the Kubernetes node.
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | \
        gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
        > /etc/apt/sources.list.d/docker.list && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends docker-ce-cli && \
    rm -rf /var/lib/apt/lists/*

# Add Jenkins user to docker group
RUN groupadd -f docker && \
    usermod -aG docker jenkins

# Install Helm
RUN curl -fsSL -o /tmp/get_helm.sh \
        https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod 700 /tmp/get_helm.sh && \
    /tmp/get_helm.sh && \
    rm -f /tmp/get_helm.sh

# Verify installed tools
RUN echo "=== Docker ===" && \
    docker --version && \
    echo "=== kubectl ===" && \
    kubectl version --client && \
    echo "=== Helm ===" && \
    helm version --short

# Stay root so docker.sock works
USER root

WORKDIR /home/jenkins

ENTRYPOINT ["jenkins-agent"]
