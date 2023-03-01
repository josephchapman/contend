#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl \
    gpg \
    lsb-release \
    libcap2-bin  # for `setcap`, otherwise vault installation shows:
                 # /var/lib/dpkg/info/vault.postinst: line 36: setcap: command not found

echo "Downloading Hashicorp GPG key ..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/hashicorp.gpg > /dev/null

echo "Adding Hashicorp repository ..."
tee /etc/apt/sources.list.d/hashicorp.list > /dev/null \
<<EOF
deb [arch=amd64,signed-by=/etc/apt/trusted.gpg.d/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main
EOF

echo "Installing Vault CLI ..."
apt-get update
apt -y install \
    vault

echo "Cleaning up ..."
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "Configuring Bash completion (vault) ..."
# 'vault -autocomplete-install' just adds the 'complete' line to '.bashrc'
# The following line does it manually
echo "complete -C /usr/bin/vault vault" | tee -a /etc/bash.bashrc > /dev/null
# non-login shell for all users

echo "Vault installed"
