#!/bin/sh
set -eu

apt-get update
apt-get install --yes --no-install-recommends \
    bash-completion \
    ca-certificates \
    curl \
    file \
    fzf \
    git \
    gosu \
    jq \
    less \
    locales \
    nano \
    openssh-client \
    ripgrep \
    sudo \
    tmux \
    unzip \
    vim \
    wget \
    xz-utils \
    zsh
rm -rf /var/lib/apt/lists/*
