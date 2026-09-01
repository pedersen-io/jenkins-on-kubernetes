FROM build-jenkins-base

USER root

# node, angular-cli, vue-cli, npx
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends nodejs && \
    npm install -g yarn && \
    npm install -g @angular/cli && \
    npm install -g @vue/cli && \
    npm cache clean --force && \
    rm -rf /var/lib/apt/lists/*

# chrome-headless-shell: headless-only Chrome for Testing build, no full browser/GUI stack
RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
        unzip \
        libnss3 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libcups2 \
        libxkbcommon0 \
        libgbm1 \
        libasound2 \
        libpango-1.0-0 \
        libxcomposite1 \
        libxdamage1 \
        libxfixes3 \
        libxrandr2 && \
    rm -rf /var/lib/apt/lists/* && \
    download_url=$(curl -fsSL https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json | \
        jq -r '.channels.Stable.downloads."chrome-headless-shell"[] | select(.platform=="linux64") | .url') && \
    curl -fsSL -o /tmp/chrome-headless-shell.zip "$download_url" && \
    unzip -q /tmp/chrome-headless-shell.zip -d /opt && \
    mv /opt/chrome-headless-shell-linux64 /opt/chrome-headless-shell && \
    ln -sf /opt/chrome-headless-shell/chrome-headless-shell /usr/local/bin/chrome-headless-shell && \
    rm -f /tmp/chrome-headless-shell.zip