#!/usr/bin/env bash

echo "Installing saml2aws ..."
apt -y update
DEBIAN_FRONTEND=noninteractive apt -y install \
    curl

echo "Creating tmp directory ..."
TMP=$(mktemp -d /tmp/saml2aws.XXXXXX)

SAML2AWS_VERSION="2.36.19" # temporary fix for GitHub API rate limit issue

echo "Downloading saml2aws ..."
curl -fsSL \
    -o ${TMP}/saml2aws_${SAML2AWS_VERSION}_linux_amd64.tar.gz \
    https://github.com/Versent/saml2aws/releases/download/v${SAML2AWS_VERSION}/saml2aws_${SAML2AWS_VERSION}_linux_amd64.tar.gz

tar -xzvf ${TMP}/saml2aws_${SAML2AWS_VERSION}_linux_amd64.tar.gz -C ${TMP}/

echo "chmod-ing saml2aws ..."
chmod u+x ${TMP}/saml2aws

echo "Installing saml2aws ..."
mv ${TMP}/saml2aws /usr/local/bin/saml2aws

echo "Cleaning up ..."
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "saml2aws installed"