#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl

echo "Creating tmp directory ..."
TMP=$(mktemp -d /tmp/crossplane.XXXXXX)
cd ${TMP}/

echo "Downloading and installing Crossplane CLI ..."
curl -sL https://raw.githubusercontent.com/crossplane/crossplane/master/install.sh | sh

install -o root -g root -m 0755 kubectl-crossplane /usr/local/bin/

echo "Cleaning up ..."
cd -
rm -rf ${TMP}
unset TMP
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "Crossplane CLI installed"