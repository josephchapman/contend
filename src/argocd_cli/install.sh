#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl

echo "Creating tmp directory ..."
TMP=$(mktemp -d /tmp/argocdcli.XXXXXX)

# ARGOCD_VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

ARGOCD_VERSION="v3.4.4" # temporary fix for GitHub API rate limit issue

echo "Downloading ArgoCD CLI ..."
curl -fsSL \
    -o ${TMP}/argocd-${ARGOCD_VERSION} \
    https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64

echo "Setting ownership ..."
chown root:root ${TMP}/argocd-${ARGOCD_VERSION}

echo "Setting permissions ..."
chmod 0755 ${TMP}/argocd-${ARGOCD_VERSION}

echo "Installing ArgoCD CLI ..."
mv ${TMP}/argocd-${ARGOCD_VERSION} /usr/local/bin/argocd 

echo "Cleaning up ..."
rm -rf ${TMP}
unset TMP
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*


echo "Configuring Bash completion (argocd cli) ..."
tee -a /etc/skel/.bash_aliases > /dev/null \
<<'EOF'
source <(argocd completion bash)
EOF
# non-login shell for all users

echo "ArgoCD CLI installed"