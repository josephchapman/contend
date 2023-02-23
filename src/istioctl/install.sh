#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl

echo "Getting Istio version ..."
ISTIO_VERSION="$(curl -sL https://github.com/istio/istio/releases | \
    grep -o 'releases/[0-9]*.[0-9]*.[0-9]*/' | sort -V | \
    tail -1 | awk -F'/' '{ print $2}')"

echo "Creating TMP directory ..."
TMP=$(mktemp -d /tmp/istioctl.XXXXXX)

echo "Downloading Istio ..."
curl -fsSL -o ${TMP}/istio-${ISTIO_VERSION}-linux-amd64.tar.gz https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-linux-amd64.tar.gz

echo "Untarring Istio ..."
tar -xvzf ${TMP}/istio-${ISTIO_VERSION}-linux-amd64.tar.gz -C ${TMP}/

echo "Installing Istio ..."
mv ${TMP}/istio-${ISTIO_VERSION}/bin/istioctl /usr/local/bin/
mv ${TMP}/istio-${ISTIO_VERSION}/tools/istioctl.bash /usr/local/bin/

echo "Cleaning up ..."
rm -rf ${TMP}
unset TMP
unset ISTIO_VERSION
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "Configuring Bash completion (istioctl) ..."
echo "source /usr/local/bin/istioctl.bash" | tee -a /etc/bash.bashrc > /dev/null
# non-login shell for all users

echo "Istio installed"