From ubuntu:16.04

MAINTAINER Peter Dave Hello <hsu@peterdavehello.org>
ENV DEBIAN_FRONTEND noninteractive

# Pick a Ubuntu apt mirror site for better speed
# ref: https://launchpad.net/ubuntu/+archivemirrors
ENV UBUNTU_APT_SITE bouyguestelecom.ubuntu.lafibre.info

# Disable src package source
RUN sed -i 's/^deb-src\ /\#deb-src\ /g' /etc/apt/sources.list

# Replace origin apt pacakge site with the mirror site
RUN sed -E -i "s/([a-z]+.)?archive.ubuntu.com/$UBUNTU_APT_SITE/g" /etc/apt/sources.list
RUN sed -i "s/security.ubuntu.com/$UBUNTU_APT_SITE/g" /etc/apt/sources.list

RUN apt update         && \
    apt upgrade -y     && \
    apt install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
        locales               \
        coreutils             \
        util-linux            \
        bsdutils              \
        file                  \
        openssl               \
        ca-certificates       \
        ssh                   \
        wget                  \
        patch                 \
        sudo                  \
        htop                  \
        dstat                 \
        vim                   \
        tmux                  \
        curl                  \
        git                   \
        jq                    \
        bash-completion       && \
    apt clean                 && \
    rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8

COPY . /theme-manager
WORKDIR /theme-manager

RUN git submodule update --init --recursive --depth 1
RUN curl -o- https://cdn.rawgit.com/creationix/nvm/v0.33.2/install.sh | bash && \
    bash -c 'source $HOME/.nvm/nvm.sh && \
    nvm install 4 && \
    nvm cache clear && \
    npm install --prefix "/theme-manager"'

EXPOSE 3000

ENTRYPOINT /bin/bash

CMD ['node','server.js']
