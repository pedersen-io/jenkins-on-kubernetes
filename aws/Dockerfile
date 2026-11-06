FROM build-jenkins-base

USER root

# Install AWS tooling for EKS and cloud automation workflows.
RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
        ca-certificates \
        curl \
        unzip \
        gnupg && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip && \
    unzip -o /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/aws /tmp/awscliv2.zip

RUN curl -fsSL -o /tmp/session-manager-plugin.deb \
    "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" && \
    dpkg -i /tmp/session-manager-plugin.deb && \
    rm -f /tmp/session-manager-plugin.deb

WORKDIR /home/jenkins
