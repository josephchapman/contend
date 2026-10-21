#!/usr/bin/env bash

echo "Configuring timezone ..."
export TZ=Europe/London

echo "Installing utilities ..."
apt -y update
DEBIAN_FRONTEND=noninteractive apt -y install \
    ansible \
    bash-completion \
    cmake \
    curl \
    dnsutils \
    gcc \
    g++ \
    git \
    iproute2 \
    iputils-ping \
    jq \
    ldap-utils \
    less \
    locales \
    make \
    netcat-openbsd \
    pwgen \
    python3 \
    python3-pip \
    python3-numpy \
    python3-scipy \
    python-is-python3 \
    redis-tools \
    ripgrep \
    sudo \
    unzip \
    vim-tiny \
    wget \
    yamllint \
    zip

echo "Cleaning up ..."
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

# Required for any 'source <(xxx completion bash)', otherwise:
# bash: _get_comp_words_by_ref: command not found
# echo "Configuring Bash completion ..."
# echo "source /etc/bash_completion" | tee -a /etc/profile.d/custom_bash_completions.sh > /dev/null

echo "Configuring locales ..."
locale-gen en_US.UTF-8
echo "Locales configured"

echo "Installing uv ..."
curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/usr/local/bin" sh
echo "uv installed"

tee -a /etc/skel/.bash_aliases > /dev/null \
<< 'EOF'
alias grep='rg'
EOF

echo "Utils installed"