#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl \
    python3 # required for autocomplete

echo "Creating tmp directory ..."
TMP=$(mktemp -d /tmp/gcloud.XXXXXX)

echo "Downloading gcloud ..."
curl https://sdk.cloud.google.com > ${TMP}/install.sh

echo "Installing gcloud ..."
bash ${TMP}/install.sh \
    --disable-prompts \
    --install-dir=/usr/bin

echo "Cleaning up ..."
rm -rf ${TMP}
unset TMP
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "Configuring Bash completion (gcloud) ..."
tee -a /etc/skel/.bash_aliases > /dev/null \
<<'EOF'
source /usr/bin/google-cloud-sdk/path.bash.inc
EOF
# non-login shell for all users
tee -a /etc/skel/.bash_aliases > /dev/null \
<<'EOF'
source /usr/bin/google-cloud-sdk/completion.bash.inc
EOF
# non-login shell for all users

echo "Installing gcloud extentions (beta) ..."
/usr/bin/google-cloud-sdk/bin/gcloud components install beta

echo "Installing gcloud extentions (gke-gcloud-auth-plugin) ..."
/usr/bin/google-cloud-sdk/bin/gcloud components install gke-gcloud-auth-plugin

echo "Installing gcloud extentions (python numpy)..."
$(/usr/bin/google-cloud-sdk/bin/gcloud info --format="value(basic.python_location)") -m pip install numpy

echo "gcloud installed"