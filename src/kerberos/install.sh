#!/usr/bin/env bash

echo "Installing Kerberos and WinRM for python ..."
apt -y update
DEBIAN_FRONTEND=noninteractive apt -y install \
    krb5-user \
    libkrb5-dev \
    sshpass \
    python3-requests-kerberos \
    python3-winrm

echo "Cleaning up ..."
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "Kerberos installed."