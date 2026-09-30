FROM jenkins/inbound-agent:latest

USER root

# Install kubectl/Docker CLI dependencies (no compiler toolchain needed, CLIs are prebuilt binaries)
RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        lsb-release \
        jq \
        make && \
    rm -rf /var/lib/apt/lists/*

# Install kubectl, add jenkins to docker group, and install Helm
RUN curl -fsSL -o /tmp/kubectl \
        "https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl && \
    rm -f /tmp/kubectl && \
    groupadd -f docker && \
    usermod -aG docker jenkins && \
    curl -fsSL -o /tmp/get_helm.sh \
        https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod 700 /tmp/get_helm.sh && \
    /tmp/get_helm.sh && \
    rm -f /tmp/get_helm.sh

# Install Docker CLI only
# Docker daemon runs on the Kubernetes node.
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | \
        gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
        > /etc/apt/sources.list.d/docker.list && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends docker-ce-cli && \
    rm -rf /var/lib/apt/lists/*

# Install cloud CLIs for multi-cloud Kubernetes workflows.
# Note: there is no direct Azure equivalent named "eksctl";
# Azure operations are handled via Azure CLI (`az aks ...`).
RUN DOCTL_VERSION="$(curl -fsSL https://api.github.com/repos/digitalocean/doctl/releases/latest | jq -r .tag_name | sed 's/^v//')" && \
    curl -fsSL -o /tmp/doctl.tar.gz "https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VERSION}/doctl-${DOCTL_VERSION}-linux-amd64.tar.gz" && \
    tar -xzf /tmp/doctl.tar.gz -C /tmp doctl && \
    install -o root -g root -m 0755 /tmp/doctl /usr/local/bin/doctl && \
    rm -f /tmp/doctl.tar.gz /tmp/doctl && \
    EKSCTL_TAG="$(curl -fsSL https://api.github.com/repos/eksctl-io/eksctl/releases/latest | jq -r .tag_name)" && \
    curl -fsSL -o /tmp/eksctl.tar.gz "https://github.com/eksctl-io/eksctl/releases/download/${EKSCTL_TAG}/eksctl_Linux_amd64.tar.gz" && \
    tar -xzf /tmp/eksctl.tar.gz -C /tmp eksctl && \
    install -o root -g root -m 0755 /tmp/eksctl /usr/local/bin/eksctl && \
    rm -f /tmp/eksctl.tar.gz /tmp/eksctl && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
        gpg --dearmor -o /etc/apt/keyrings/google-cloud.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/google-cloud.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
        > /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | \
        gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg && \
    chmod go+r /etc/apt/keyrings/microsoft.gpg && \
    AZ_REPO="bookworm" && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ ${AZ_REPO} main" \
        > /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
        azure-cli \
        google-cloud-cli && \
    rm -rf /var/lib/apt/lists/*

# Verify installed tools
RUN echo "=== Docker ===" && \
    docker --version && \
    echo "=== kubectl ===" && \
    kubectl version --client && \
    echo "=== Helm ===" && \
    helm version --short && \
    echo "=== doctl ===" && \
    doctl version && \
    echo "=== eksctl ===" && \
    eksctl version && \
    echo "=== gcloud ===" && \
    gcloud --version && \
    echo "=== az ===" && \
    az version

# Stay root so docker.sock works
USER root

WORKDIR /home/jenkins

ENTRYPOINT ["jenkins-agent"]
