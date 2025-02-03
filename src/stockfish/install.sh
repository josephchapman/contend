#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl

echo "Creating TMP directory ..."
TMP=$(mktemp -d /tmp/stockfish.XXXXXX)

echo "Downloading stockfish ..."
curl -fsSL -o ${TMP}/stockfish-ubuntu-x86-64.tar https://github.com/official-stockfish/Stockfish/releases/download/sf_${STOCKFISH_VERSION}/stockfish-ubuntu-x86-64.tar

echo "Untarring stockfish ..."
tar -xvf ${TMP}/stockfish-ubuntu-x86-64.tar -C ${TMP}/

echo "Installing stockfish ..."
mv ${TMP}/stockfish/stockfish-ubuntu-x86-64 /usr/local/bin/stockfish

echo "Cleaning up ..."
rm -rf ${TMP}
unset TMP
unset stockfish_VERSION
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "stockfish installed"