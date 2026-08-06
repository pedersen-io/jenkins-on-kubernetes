FROM jenkins/inbound-agent:latest

USER root

# apt-get update, build essentials, kubectl
RUN apt-get update -qq && \
    apt-get install -qqy apt-transport-https ca-certificates curl gnupg2 lsb-release build-essential jq libapparmor-dev libseccomp-dev && \
    apt-get update -y && \
    apt-get install -y kubectl

# docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
        apt-key fingerprint 0EBFCD88 && \
        echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
        apt-get update -qq && \
        apt-get install -qqy docker-ce && \
        usermod -aG docker jenkins
RUN gpasswd -a jenkins docker

# helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh

ENTRYPOINT ["jenkins-agent"]