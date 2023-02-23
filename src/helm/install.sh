#!/usr/bin/env bash

HELM_PLUGINS_LIST=(
    https://github.com/databus23/helm-diff
    https://github.com/quintush/helm-unittest
)

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl \
    git # required for plugin installation

echo "Configuring shared environment"
mkdir -p /usr/local/share/helm/config/registry/
mkdir -p /usr/local/share/helm/plugins/
mkdir -p /usr/local/share/helm/cache/repository/

tee -a /etc/bash.bashrc > /dev/null \
<<EOF
export HELM_DATA_HOME=/usr/local/share/helm/
export HELM_PLUGINS=/usr/local/share/helm/plugins/
export HELM_CONFIG_HOME=/usr/local/share/helm/config/
export HELM_REGISTRY_CONFIG=/usr/local/share/helm/config/registry/config.json
export HELM_REPOSITORY_CONFIG=/usr/local/share/helm/config/repositories.yaml
export HELM_REPOSITORY_CACHE=/usr/local/share/helm/cache/repository/
export HELM_CACHE_HOME=/usr/local/share/helm/cache/
EOF

export HELM_DATA_HOME=/usr/local/share/helm/
export HELM_PLUGINS=/usr/local/share/helm/plugins/
export HELM_CONFIG_HOME=/usr/local/share/helm/config/
export HELM_REGISTRY_CONFIG=/usr/local/share/helm/config/registry/config.json
export HELM_REPOSITORY_CONFIG=/usr/local/share/helm/config/repositories.yaml
export HELM_REPOSITORY_CACHE=/usr/local/share/helm/cache/repository/
export HELM_CACHE_HOME=/usr/local/share/helm/cache/

echo "Creating TMP directory ..."
TMP=$(mktemp -d /tmp/helm.XXXXXX)

echo "Downloading Helm ..."
curl -fsSL -o ${TMP}/get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3

echo "Helm installer permissions ..."
chmod 700 ${TMP}/get_helm.sh

echo "Installing Helm ..."
${TMP}/get_helm.sh

echo "Cleaning up ..."
rm -rf ${TMP}
unset TMP
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "Configuring Bash completion (helm) ..."
echo "source <(helm completion bash)" | tee -a /etc/bash.bashrc > /dev/null
# non-login shell for all users

echo "Installing Helm plugins ..."
for HELM_PLUGIN in ${HELM_PLUGINS_LIST[*]}; do
    HELM_PLUGINS=/usr/local/share/helm/plugins/ helm plugin install ${HELM_PLUGIN}
done

echo "Helm installed"