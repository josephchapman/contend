#!/usr/bin/env bash

echo "Installing utilities ..."
apt -y update
DEBIAN_FRONTEND=noninteractive apt -y install \
    ansible \
    cloud-utils \
    gpg \
    libvirt-clients \
    virtinst \
    whois

    # cloud-utils -> cloud-localds
    # libvirt-clients -> virsh
    # virtinst -> virt-install
    # whois -> mkpasswd

echo "Cleaning up ..."
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "Utils installed"