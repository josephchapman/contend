#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl

# The 'export' is required because the script is piped into another shell (install | sh)
export INSTALLROOT="/usr/local"

echo "Downloading and Installing linkerd ..."
curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/install | sh

echo "Cleaning up ..."
unset INSTALLROOT
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "Configuring Bash completion (linkerd) ..."
tee -a /etc/skel/.bash_aliases > /dev/null \
<<'EOF'
source <(linkerd completion bash)
EOF
# non-login shell for all users

echo "Linkerd installed"