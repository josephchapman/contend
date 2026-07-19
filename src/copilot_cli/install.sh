#!/usr/bin/env bash
set -euo pipefail

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl

echo "Cleaning up ..."
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "Downloading and installing copilot cli ..."
curl -fsSL https://gh.io/copilot-install | bash

echo "copilot cli installed"