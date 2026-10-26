#!/usr/bin/env bash

echo "Installing SOPS ..."
apt -y update
DEBIAN_FRONTEND=noninteractive apt -y install \
    curl

echo "Creating tmp directory ..."
TMP=$(mktemp -d /tmp/sops.XXXXXX)

SOPS_VERSION="3.13.3" # temporary fix for GitHub API rate limit issue

echo "Downloading SOPS ..."
curl -fsSL \
    -o ${TMP}/sops \
    https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64

echo "Setting ownership ..."
chown root:root ${TMP}/sops

echo "Setting permissions ..."
chmod 0755 ${TMP}/sops

echo "Installing SOPS ..."
mv ${TMP}/sops /usr/local/bin/sops

echo "Cleaning up ..."
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "SOPS installed"