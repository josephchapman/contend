#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl

echo "Creating TMP directory ..."
TMP=$(mktemp -d /tmp/step.XXXXXX)

echo "Downloading step ..."
curl -fsSL -o ${TMP}/step-cli_${STEP_VERSION}_amd64.deb https://github.com/smallstep/cli/releases/download/v${STEP_VERSION}/step-cli_${STEP_VERSION}_amd64.deb

echo "Installing step ..."
dpkg -i ${TMP}/step-cli_${STEP_VERSION}_amd64.deb

echo "Configuring Bash completion (step) ..."
echo "source <(step completion bash)" | tee -a /etc/bash.bashrc > /dev/null
# non-login shell for all users

echo "Cleaning up ..."
rm -rf ${TMP}
unset TMP
unset step_VERSION
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "step installed"