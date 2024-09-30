#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl

echo "Creating TMP directory ..."
TMP=$(mktemp -d /tmp/cmctl.XXXXXX)

echo "Downloading cmctl ..."
curl -fsSL -o ${TMP}/cmctl-linux-amd64.tar.gz https://github.com/cert-manager/cert-manager/releases/latest/download/cmctl-linux-amd64.tar.gz

echo "Untarring cmctl ..."
tar -xvzf ${TMP}/cmctl-linux-amd64.tar.gz -C ${TMP}/

echo "Installing cmctl ..."
mv ${TMP}/cmctl /usr/local/bin/

echo "Configuring Bash completion (cmctl) ..."
echo "source <(cmctl completion bash)" | tee -a /etc/bash.bashrc > /dev/null
# non-login shell for all users

echo "Cleaning up ..."
rm -rf ${TMP}
unset TMP
unset CMCTL_VERSION
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "cmctl installed"