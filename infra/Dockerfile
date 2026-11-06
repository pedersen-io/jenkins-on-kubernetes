FROM build-jenkins-base

USER root

# Install IaC and platform delivery tooling.
RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
        ca-certificates \
        curl \
        unzip \
        python3 \
        python3-pip \
        jq \
        git && \
    rm -rf /var/lib/apt/lists/*

# Install Terraform and OpenTofu
ARG TERRAFORM_VERSION=""
ARG OPENTOFU_VERSION=""
RUN set -eux; \
    if [ -z "${TERRAFORM_VERSION}" ]; then \
        TERRAFORM_VERSION="$(curl -fsSL https://api.github.com/repos/hashicorp/terraform/releases/latest | jq -r .tag_name | sed 's/^v//')"; \
    fi; \
    curl -fsSL -o /tmp/terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"; \
    unzip -o /tmp/terraform.zip -d /tmp/terraform-bin; \
    install -o root -g root -m 0755 /tmp/terraform-bin/terraform /usr/local/bin/terraform; \
    rm -rf /tmp/terraform.zip /tmp/terraform-bin; \
    if [ -z "${OPENTOFU_VERSION}" ]; then \
        OPENTOFU_VERSION="$(curl -fsSL https://api.github.com/repos/opentofu/opentofu/releases/latest | jq -r .tag_name | sed 's/^v//')"; \
    fi; \
    curl -fsSL -o /tmp/opentofu.tar.gz "https://github.com/opentofu/opentofu/releases/download/v${OPENTOFU_VERSION}/tofu_${OPENTOFU_VERSION}_linux_amd64.tar.gz"; \
    tar -xzf /tmp/opentofu.tar.gz -C /tmp; \
    install -o root -g root -m 0755 /tmp/tofu /usr/local/bin/tofu; \
    rm -f /tmp/opentofu.tar.gz /tmp/tofu; \
    terraform version; \
    tofu version

# Install YAML processing and Kubernetes manifest validation
RUN curl -fsSL "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64" -o /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq && \
    KUBECONFORM_VERSION="$(curl -fsSL https://api.github.com/repos/yannh/kubeconform/releases/latest | jq -r .tag_name)" && \
    curl -fsSL -o /tmp/kubeconform.tar.gz "https://github.com/yannh/kubeconform/releases/download/${KUBECONFORM_VERSION}/kubeconform-linux-amd64.tar.gz" && \
    tar -xzf /tmp/kubeconform.tar.gz -C /tmp && \
    install -o root -g root -m 0755 /tmp/kubeconform /usr/local/bin/kubeconform && \
    rm -f /tmp/kubeconform.tar.gz /tmp/kubeconform

# Install policy linting for IaC validation.
RUN pip3 install --no-cache-dir checkov

# Install AWS tooling for infrastructure automation and EKS workflows.
RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip && \
    unzip -o /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/aws /tmp/awscliv2.zip && \
    curl -fsSL -o /tmp/session-manager-plugin.deb \
    "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" && \
    dpkg -i /tmp/session-manager-plugin.deb && \
    rm -f /tmp/session-manager-plugin.deb

WORKDIR /home/jenkins
