#!/usr/bin/env bash

echo "Configuring timezone ..."
export TZ=Europe/London

echo "Installing utilities ..."
apt -y update
DEBIAN_FRONTEND=noninteractive apt -y install \
    ansible \
    bash-completion \
    curl \
    dnsutils \
    git \
    iproute2 \
    iputils-ping \
    jq \
    less \
    redis-tools \
    sudo \
    unzip \
    vim-tiny \
    wget \
    yamllint

echo "Cleaning up ..."
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

# Required for any 'source <(xxx completion bash)', otherwise:
# bash: _get_comp_words_by_ref: command not found
# echo "Configuring Bash completion ..."
# echo "source /etc/bash_completion" | tee -a /etc/profile.d/custom_bash_completions.sh > /dev/null

echo "Utils installed"