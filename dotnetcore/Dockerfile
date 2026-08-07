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
        curl && \
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
RUN dotnet --list-sdks

USER jenkins
WORKDIR /home/jenkins