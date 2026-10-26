#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl \
    xz-utils

echo "Creating TMP directory ..."
TMP=$(mktemp -d /tmp/node.XXXXXX)

echo "Downloading node ..."
curl -fsSL -o ${TMP}/node-v${NODE_VERSION}-linux-x64.tar.xz https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz

echo "Untarring node ..."
tar -xvJf ${TMP}/node-v${NODE_VERSION}-linux-x64.tar.xz -C ${TMP}/

echo "Installing node ..."
cp -r ${TMP}/node-v${NODE_VERSION}-linux-x64/{bin,include,lib,share} /usr/local/

echo "Configuring Bash completion (npm) ..."
tee -a /etc/skel/.bash_aliases > /dev/null \
<<'EOF'
source <(npm completion bash)
EOF
# non-login shell for all users

echo "Cleaning up ..."
rm -rf ${TMP}
unset TMP
unset CMCTL_VERSION
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "nodejs installed"