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

# Install .NET SDK
RUN curl -fsSL https://dot.net/v1/dotnet-install.sh \
        -o /tmp/dotnet-install.sh && \
    chmod +x /tmp/dotnet-install.sh && \
    /tmp/dotnet-install.sh \
        --channel 10.0 \
        --quality GA \
        --install-dir /usr/share/dotnet && \
    ln -sf /usr/share/dotnet/dotnet /usr/local/bin/dotnet && \
    rm -f /tmp/dotnet-install.sh

# Configure .NET environment
ENV DOTNET_ROOT=/usr/share/dotnet
ENV PATH="/usr/share/dotnet:${PATH}"

# Verify .NET installation
RUN echo "=== Installed .NET SDKs ===" && \
    dotnet --list-sdks

USER root

WORKDIR /home/jenkins
