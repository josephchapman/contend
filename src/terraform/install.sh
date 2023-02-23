#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl \
    git \
    unzip

echo "Cleaning up ..."
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "Downloading tfenv ..."
git clone https://github.com/tfutils/tfenv.git /usr/local/src/tfenv/ || \
git -C /usr/local/src/tfenv/ pull

echo "Installing tfenv ..."
ln -s /usr/local/src/tfenv/bin/* /usr/local/bin/

echo "Installing versions of Terraform ..."
tfenv install 1.3.7
tfenv install 1.2.8
tfenv install 1.1.9
tfenv install 1.0.11
tfenv install 0.15.5
tfenv install 0.14.11
tfenv install 0.13.7
tfenv install 0.12.31
tfenv install 0.11.15
tfenv use 1.3.7

echo "chmod version file ..."
# Allow all users to write to the version file
chmod 666 /usr/local/src/tfenv/version

echo "Configuring Bash completion (terraform) ..."
echo "complete -C /usr/local/src/tfenv/versions/1.3.7/terraform terraform" | tee -a /etc/bash.bashrc > /dev/null
# non-login shell for all users

echo "tfenv installed"


echo "Downloading and installing tgswitch ..."
curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | bash

echo "tgswitch installed"
