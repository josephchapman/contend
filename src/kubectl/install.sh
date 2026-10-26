#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl

echo "Cleaning up ..."
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "Downloading kubectl ..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

echo "Downloading checksum file ..."
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

echo "If checksum valid, installing kubectl ..."
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo "Adding .kube/ to skel ..."
mkdir -p /etc/skel/.kube/

echo "Configuring Bash completion (kubectl), alias (kubectl -> k), and autocomplete..."
tee -a /etc/skel/.bash_aliases > /dev/null \
<<'EOF'
source <(kubectl completion bash)
alias k=kubectl
complete -o default -F __start_kubectl k
EOF
# non-login shell for all users

echo "kubectl installed"