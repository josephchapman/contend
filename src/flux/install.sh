#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl

echo "Downloading and Installing Flux ..."
curl -s https://fluxcd.io/install.sh | bash

echo "Configuring Bash completion (flux) ..."
tee -a /etc/skel/.bash_aliases > /dev/null \
<<'EOF'
source <(flux completion bash)
EOF
# non-login shell for all users

echo "Cleaning up ..."
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "Flux installed"