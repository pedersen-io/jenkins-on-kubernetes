FROM build-jenkins-base

USER root

ARG TERRAFORM_VERSION=1.10.5

# Install Terraform CLI from official release artifacts.
RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends unzip && \
    rm -rf /var/lib/apt/lists/* && \
    curl -fsSL -o /tmp/terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip -q /tmp/terraform.zip -d /tmp && \
    install -m 0755 /tmp/terraform /usr/local/bin/terraform && \
    rm -f /tmp/terraform /tmp/terraform.zip

WORKDIR /home/jenkins
