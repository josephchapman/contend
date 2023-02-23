#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl

echo "Creating tmp directory ..."
TMP=$(mktemp -d /tmp/argo.XXXXXX)

echo "Downloading Argo Workflows ..."
curl -fsSL \
    -o ${TMP}/argo-linux-amd64.gz \
    https://github.com/argoproj/argo-workflows/releases/latest/download/argo-linux-amd64.gz

echo "Unzipping Argo Workflows ..."
gunzip ${TMP}/argo-linux-amd64.gz

echo "chmod-ing Argo Workflows ..."
chmod +x ${TMP}/argo-linux-amd64

echo "Installing Argo Workflows ..."
mv ${TMP}/argo-linux-amd64 /usr/local/bin/argo

echo "Cleaning up ..."
rm -rf ${TMP}
unset TMP
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*


echo "Configuring Bash completion (argo workflows) ..."
# echo "source <(argo completion bash)" | tee -a /home/md/.bash_aliases /root/.bash_aliases
# echo "source <(argo completion bash)" | tee -a /etc/profile.d/custom_bash_completions.sh > /dev/null
echo "source <(argo completion bash)" | tee -a /etc/bash.bashrc > /dev/null
# non-login shell for all users

echo "Argo Workflows installed"