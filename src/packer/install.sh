#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl \
    gpg \
    lsb-release

echo "Downloading Hashicorp GPG key ..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/hashicorp.gpg > /dev/null

echo "Adding Hashicorp repository ..."
tee /etc/apt/sources.list.d/hashicorp.list > /dev/null \
<<EOF
deb [arch=amd64,signed-by=/etc/apt/trusted.gpg.d/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main
EOF

echo "Installing Packer ..."
apt-get update
apt -y install \
    packer

echo "Cleaning up ..."
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "Configuring Bash completion (packer) ..."
# 'packer -autocomplete-install' just adds the 'complete' line to '.bashrc'
# The following line does it manually
tee -a /etc/skel/.bash_aliases > /dev/null \
<<'EOF'
complete -C /usr/bin/packer packer
EOF
# non-login shell for all users

echo "Packer installed"