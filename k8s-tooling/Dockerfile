FROM build-jenkins-base

USER root

# Install interactive diagnostics and Kubernetes operations tooling.
RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
        bash \
        dnsutils \
        git \
        iproute2 \
        iputils-ping \
        less \
        nano \
        netcat-openbsd \
        procps \
        unzip \
        wget && \
    rm -rf /var/lib/apt/lists/*

RUN YQ_VERSION=$(curl -fsSL https://api.github.com/repos/mikefarah/yq/releases/latest | jq -r '.tag_name') && \
    curl -fsSL -o /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" && \
    chmod +x /usr/local/bin/yq && \
    KUSTOMIZE_VERSION=$(curl -fsSL https://api.github.com/repos/kubernetes-sigs/kustomize/releases/latest | jq -r '.tag_name' | sed 's#kustomize/##') && \
    curl -fsSL -o /tmp/kustomize.tar.gz "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz" && \
    tar -xzf /tmp/kustomize.tar.gz -C /usr/local/bin && \
    rm -f /tmp/kustomize.tar.gz && \
    STERN_VERSION=$(curl -fsSL https://api.github.com/repos/stern/stern/releases/latest | jq -r '.tag_name') && \
    curl -fsSL -o /tmp/stern.tar.gz "https://github.com/stern/stern/releases/download/${STERN_VERSION}/stern_${STERN_VERSION#v}_linux_amd64.tar.gz" && \
    tar -xzf /tmp/stern.tar.gz -C /tmp && \
    install -m 0755 /tmp/stern /usr/local/bin/stern && \
    rm -f /tmp/stern /tmp/stern.tar.gz && \
    KUBECTX_VERSION=$(curl -fsSL https://api.github.com/repos/ahmetb/kubectx/releases/latest | jq -r '.tag_name') && \
    curl -fsSL -o /tmp/kubectx.tar.gz "https://github.com/ahmetb/kubectx/releases/download/${KUBECTX_VERSION}/kubectx_${KUBECTX_VERSION#v}_linux_x86_64.tar.gz" && \
    tar -xzf /tmp/kubectx.tar.gz -C /tmp && \
    install -m 0755 /tmp/kubectx /usr/local/bin/kubectx && \
    install -m 0755 /tmp/kubens /usr/local/bin/kubens && \
    rm -f /tmp/kubectx /tmp/kubens /tmp/kubectx.tar.gz

WORKDIR /home/jenkins
