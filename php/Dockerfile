FROM build-jenkins-base

USER root

# Install PHP CLI tooling for Composer-based application builds.
RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
        php-cli \
        composer \
        php-curl \
        php-mbstring \
        php-xml \
        php-zip \
        php-sqlite3 \
        git \
        unzip && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/jenkins
