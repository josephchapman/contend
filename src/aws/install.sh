#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl \
    unzip \
    wget

echo "Creating TMP directory ..."
TMP=$(mktemp -d /tmp/aws.XXXXXX)

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "${TMP}/awscliv2.zip"
unzip -d ${TMP}/ ${TMP}/awscliv2.zip
${TMP}/aws/install

echo "Downloading SSM plugin ..."
wget -O ${TMP}/session-manager-plugin.deb https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb

echo "Installing SSM plugin ..."
dpkg -i ${TMP}/session-manager-plugin.deb

echo "Cleaning up ..."
rm -rf ${TMP}
unset TMP
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "Adding .aws/ and aliases to skel ..."
mkdir -p /etc/skel/.aws/
tee -a /etc/skel/.bash_aliases > /dev/null \
<<'EOF'
# AWS Bash Completion
complete -C '/usr/local/bin/aws_completer' aws

# AWS Login Function
awslogin() {
    read -p "Enter AWS Profile Name: " profile_name
    if [ -z "$profile_name" ]; then
        echo "Error: No profile name provided."
        return 1
    fi
    export AWS_PROFILE="$profile_name"
    echo "AWS profile set to '$AWS_PROFILE'."
    aws sso login
    aws sts get-caller-identity
}

EOF

echo "AWS CLI installation complete"