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

echo "Downloading and installing tfswitch ..."
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/master/install.sh | bash

echo "tfswitch installed"

echo "Downloading and installing tgswitch ..."
curl -L https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | bash

echo "tgswitch installed"
