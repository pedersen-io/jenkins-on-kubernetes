FROM jenkins/inbound-agent:latest

USER root

# Install build tools, kubectl dependencies, docker CLI dependencies
RUN apt-get update -qq && \
    apt-get install -qqy \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        lsb-release \
        build-essential \
        jq \
        libapparmor-dev \
        libseccomp-dev \
    && rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install Docker CLI only
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | \
    gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    > /etc/apt/sources.list.d/docker.list && \
    apt-get update -qq && \
    apt-get install -qqy docker-ce-cli && \
    rm -rf /var/lib/apt/lists/*

# Add Jenkins user to docker group
RUN groupadd -f docker && \
    usermod -aG docker jenkins

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh && \
    rm get_helm.sh

# Stay root so docker.sock works
USER root

WORKDIR /home/jenkins

ENTRYPOINT ["jenkins-agent"]