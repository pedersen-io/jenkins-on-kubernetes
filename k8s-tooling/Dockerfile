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

RUN yq_url=$(curl -fsSL https://api.github.com/repos/mikefarah/yq/releases/latest | \
        jq -r '.assets[] | select(.name == "yq_linux_amd64") | .browser_download_url') && \
    test -n "$yq_url" && \
    curl -fsSL -o /usr/local/bin/yq "$yq_url" && \
    chmod +x /usr/local/bin/yq && \
    kustomize_url=$(curl -fsSL https://api.github.com/repos/kubernetes-sigs/kustomize/releases/latest | \
        jq -r '.assets[] | select(.name | test("kustomize_.*_linux_amd64\\.tar\\.gz$")) | .browser_download_url' | head -n 1) && \
    test -n "$kustomize_url" && \
    curl -fsSL -o /tmp/kustomize.tar.gz "$kustomize_url" && \
    tar -xzf /tmp/kustomize.tar.gz -C /usr/local/bin && \
    rm -f /tmp/kustomize.tar.gz && \
    stern_url=$(curl -fsSL https://api.github.com/repos/stern/stern/releases/latest | \
        jq -r '.assets[] | select(.name | test("stern_.*_linux_amd64\\.tar\\.gz$")) | .browser_download_url' | head -n 1) && \
    test -n "$stern_url" && \
    curl -fsSL -o /tmp/stern.tar.gz "$stern_url" && \
    tar -xzf /tmp/stern.tar.gz -C /tmp && \
    install -m 0755 /tmp/stern /usr/local/bin/stern && \
    rm -f /tmp/stern /tmp/stern.tar.gz && \
    kubectx_url=$(curl -fsSL https://api.github.com/repos/ahmetb/kubectx/releases/latest | \
        jq -r '.assets[] | select(.name | test("kubectx_.*_linux_x86_64\\.tar\\.gz$")) | .browser_download_url' | head -n 1) && \
    test -n "$kubectx_url" && \
    curl -fsSL -o /tmp/kubectx.tar.gz "$kubectx_url" && \
    tar -xzf /tmp/kubectx.tar.gz -C /tmp && \
    install -m 0755 /tmp/kubectx /usr/local/bin/kubectx && \
    install -m 0755 /tmp/kubens /usr/local/bin/kubens && \
    rm -f /tmp/kubectx /tmp/kubens /tmp/kubectx.tar.gz

WORKDIR /home/jenkins
