FROM build-jenkins-base

USER root

# Install Node.js and Playwright browsers for browser-based test runs.
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends nodejs && \
    npm install -g playwright && \
    playwright install --with-deps chromium firefox webkit && \
    npm cache clean --force && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/jenkins
