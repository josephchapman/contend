#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl

echo "Creating TMP directory ..."
TMP=$(mktemp -d /tmp/go.XXXXXX)

echo "Downloading go ..."
curl -fsSL -o ${TMP}/go${GO_VERSION}.linux-amd64.tar.gz https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz

echo "Untarring go ..."
tar -xvzf ${TMP}/go${GO_VERSION}.linux-amd64.tar.gz -C ${TMP}/

echo "Installing go ..."
mv ${TMP}/go /usr/local/


echo "Configuring Bash completion (go) ..."
tee -a /etc/skel/.bash_aliases > /dev/null \
<<EOF
export PATH=\${PATH}:/usr/local/go/bin
EOF
# non-login shell for all users

echo "Cleaning up ..."
rm -rf ${TMP}
unset TMP
unset GO_VERSION
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "go installed"