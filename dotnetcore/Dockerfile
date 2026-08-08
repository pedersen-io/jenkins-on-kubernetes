FROM build-jenkins-base

USER root

# Install runtime dependencies required by .NET
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libicu-dev \
    zlib1g \
    libgcc-s1 \
    libstdc++6 \
    ca-certificates \
    curl \
    gnupg \
    lsb-release && \
    rm -rf /var/lib/apt/lists/*

# Install Docker CLI
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg \
        -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
        > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends docker-ce-cli && \
    rm -rf /var/lib/apt/lists/*

# Install .NET SDKs
RUN curl -fsSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh && \
    chmod +x /tmp/dotnet-install.sh && \
    /tmp/dotnet-install.sh --channel 6.0 --quality GA --install-dir /usr/share/dotnet && \
    /tmp/dotnet-install.sh --channel 8.0 --quality GA --install-dir /usr/share/dotnet && \
    /tmp/dotnet-install.sh --channel 10.0 --quality GA --install-dir /usr/share/dotnet && \
    ln -sf /usr/share/dotnet/dotnet /usr/local/bin/dotnet && \
    rm /tmp/dotnet-install.sh

ENV DOTNET_ROOT=/usr/share/dotnet
ENV PATH="/usr/share/dotnet:${PATH}"

# Verify installation
RUN dotnet --list-sdks && \
    docker --version

USER root
WORKDIR /home/jenkins