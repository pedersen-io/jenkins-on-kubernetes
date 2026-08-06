FROM build-jenkins-base

USER root

# go
RUN GO_VERSION=$(curl -fsSL 'https://go.dev/VERSION?m=text' | tr -d '\r' | head -n 1) && \
    curl -fsSL --output /tmp/${GO_VERSION}.linux-amd64.tar.gz "https://dl.google.com/go/${GO_VERSION}.linux-amd64.tar.gz" && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf /tmp/${GO_VERSION}.linux-amd64.tar.gz && \
    rm /tmp/${GO_VERSION}.linux-amd64.tar.gz
ENV GOROOT=/usr/local/go
ENV GOBIN=$GOROOT/bin
ENV PATH=$GOROOT/bin:$PATH
RUN mkdir -p /home/jenkins/go/bin && \
    mkdir -p /home/jenkins/go/src && \
    mkdir -p /home/jenkins/go/pkg && \
    curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh && \
    go install golang.org/x/tools/go/packages@latest && \
    go install github.com/golang/mock/mockgen@latest && \
    download_url=$(curl -s https://api.github.com/repos/go-swagger/go-swagger/releases/latest | jq -r '.assets[] | select(.name | contains("'"$(uname | tr '[:upper:]' '[:lower:]')"'"_amd64)) | .browser_download_url') && \
    curl -o /usr/local/bin/swagger -L "$download_url" && \
    chmod +x /usr/local/bin/swagger
ENV GOROOT=/usr/local/go
ENV GOPATH=/home/jenkins/go:/root/workspace/go
ENV PATH=/home/jenkins/go/bin:/root/workspace/go/bin:$PATH

ENTRYPOINT ["jenkins-slave"]