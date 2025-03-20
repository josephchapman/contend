#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl

echo "Creating tmp directory ..."
TMP=$(mktemp -d /tmp/argocdcli.XXXXXX)

ARGOCD_VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

echo "Downloading ArgoCD CLI ..."
curl -fsSL \
    -o ${TMP}/argocd-${ARGOCD_VERSION} \
    https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64

echo "chmod-ing ArgoCD CLI ..."
chmod +x ${TMP}/argocd-${ARGOCD_VERSION}

echo "Installing ArgoCD CLI ..."
mv ${TMP}/argocd-${ARGOCD_VERSION} /usr/local/bin/argocd 

echo "Cleaning up ..."
rm -rf ${TMP}
unset TMP
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*


# echo "Configuring Bash completion (argo workflows) ..."
# # echo "source <(argo completion bash)" | tee -a /home/md/.bash_aliases /root/.bash_aliases
# # echo "source <(argo completion bash)" | tee -a /etc/profile.d/custom_bash_completions.sh > /dev/null
# echo "source <(argo completion bash)" | tee -a /etc/bash.bashrc > /dev/null
# # non-login shell for all users

echo "ArgoCD CLI installed"