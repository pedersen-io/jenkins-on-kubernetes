FROM build-jenkins-base

USER root

# Install infrastructure automation tooling for Terraform and OpenTofu workflows.
RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
        unzip \
        ca-certificates \
        curl \
        jq && \
    rm -rf /var/lib/apt/lists/*

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

RUN curl -fsSL https://github.com/terraform-linters/tflint/releases/latest/download/tflint_linux_amd64.zip -o /tmp/tflint.zip && \
    unzip -o /tmp/tflint.zip -d /tmp/tflint-bin && \
    install -o root -g root -m 0755 /tmp/tflint-bin/tflint /usr/local/bin/tflint && \
    rm -rf /tmp/tflint.zip /tmp/tflint-bin

WORKDIR /home/jenkins
