#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    sudo

echo "Configuring Login defs ..."
# -E Extended Regex is required for '?'
sed -i -E -e 's/^\s*(#\s*)?UMASK\s*\S*\s*$/UMASK		077/' /etc/login.defs
sed -i -E -e 's/^\s*(#\s*)?USERGROUPS_ENAB\s*\S*\s*$/USERGROUPS_ENAB no/' /etc/login.defs

echo "Creating user ..."
useradd -u ${UID} -U -G root -m -s /bin/bash ${USERNAME}
sudo -u ${USERNAME} -g ${USERNAME} mkdir /home/${USERNAME}/.config/
sudo -u ${USERNAME} -g ${USERNAME} touch /home/${USERNAME}/.bash_aliases
sudo -u ${USERNAME} -g ${USERNAME} mkdir /home/${USERNAME}/bin/
tee -a /home/${USERNAME}/.bash_aliases > /dev/null \
<<EOF
if [[ ":\${PATH}:" != *":/home/${USERNAME}/bin:"* ]]; then
  export PATH=\${PATH}:/home/${USERNAME}/bin
fi
EOF

tee -a /home/${USERNAME}/.bash_aliases > /dev/null \
<<EOF
PS1='[\[\033[1;32m\]\u\[\033[m\]@\[\033[1;35m\]\h\[\033[m\] \[\033[1;34m\]\W\[\033[m\]]\$ '
EOF

echo "Assigning groups ..."
if [ -f /root/required_groups ]; then
  while IFS="" read -r GROUP || [ -n "$GROUP" ]
  do
    usermod -aG ${GROUP} ${USERNAME}
  done < /root/required_groups
fi

echo "User created"
