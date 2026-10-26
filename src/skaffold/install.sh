#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl

echo "Creating tmp directory ..."
TMP=$(mktemp -d /tmp/skaffold.XXXXXX)

echo "Downloading skaffold ..."
curl -Lo ${TMP}/skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64

echo "Installing skaffold ..."
install ${TMP}/skaffold /usr/local/bin/

echo "Cleaning up ..."
rm -rf ${TMP}
unset TMP
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "Configuring Bash completion (skaffold) ..."
tee -a /etc/skel/.bash_aliases > /dev/null \
<<'EOF'
source <(skaffold completion bash)
EOF
# non-login shell for all users

echo "skaffold installed"