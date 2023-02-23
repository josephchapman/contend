#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl \
    unzip \
    wget

echo "Creating TMP directory ..."
TMP=$(mktemp -d /tmp/aws.XXXXXX)

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "${TMP}/awscliv2.zip"
unzip -d ${TMP}/ ${TMP}/awscliv2.zip
${TMP}/aws/install

echo "Downloading SSM plugin ..."
wget -O ${TMP}/session-manager-plugin.deb https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb

echo "Installing SSM plugin ..."
dpkg -i ${TMP}/session-manager-plugin.deb

echo "Cleaning up ..."
rm -rf ${TMP}
unset TMP
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "Configuring Bash completion (aws) ..."
echo "complete -C '/usr/local/bin/aws_completer' aws" | tee -a /etc/bash.bashrc > /dev/null
# non-login shell for all users

echo "AWS CLI installation complete"