FROM build-jenkins-base

USER root

# node, angular-cli, vue-cli, npx
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs && \
    npm install -g yarn && \
    npm install -g @angular/cli && \
    npm install -g @vue/cli

# chrome
RUN curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/google-chrome-archive-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get -y install google-chrome-stable