#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    sudo

echo "Configuring Login defs ..."
# -E Extended Regex is required for '?'
sed -i -E -e 's/^\s*(#\s*)?UMASK\s*\S*\s*$/UMASK		077/' /etc/login.defs
sed -i -E -e 's/^\s*(#\s*)?USERGROUPS_ENAB\s*\S*\s*$/USERGROUPS_ENAB no/' /etc/login.defs

echo "Resolving existing UID/GID 1000 collisions ..."
while IFS= read -r EXISTING_USER; do
  if [ "${EXISTING_USER}" = "${USERNAME}" ]; then
    echo "User ${USERNAME} already has UID 1000"
  else
    echo "Changing UID for ${EXISTING_USER} from 1000 to 1001"
    usermod -u 1001 ${EXISTING_USER}
  fi
done < <(awk -F: '$3 == 1000 {print $1}' /etc/passwd)

while IFS= read -r EXISTING_GROUP; do
  if [ "${EXISTING_GROUP}" = "${USERNAME}" ]; then
    echo "Group ${USERNAME} already has GID 1000"
  else
    echo "Changing GID for ${EXISTING_GROUP} from 1000 to 1001"
    groupmod -g 1001 ${EXISTING_GROUP}
  fi
done < <(awk -F: '$3 == 1000 {print $1}' /etc/group)

if ! getent group "${USERNAME}" > /dev/null; then
  echo "Creating group ${USERNAME}"
  groupadd -g 1000 "${USERNAME}"
fi

tee -a /etc/skel/.bash_aliases > /dev/null \
<<'EOF'
PS1='[\[\033[1;32m\]\u\[\033[m\]@\[\033[1;35m\]\h\[\033[m\] \[\033[1;34m\]\W\[\033[m\]]\$ '
alias checkcert='echo "${CERT}" | openssl x509 -noout -subject -issuer -dates'
EOF

echo "Creating user ..."
useradd -u ${UID} -U -G root -m -s /bin/bash ${USERNAME}
sudo -u ${USERNAME} -g ${USERNAME} mkdir /home/${USERNAME}/.config/
sudo -u ${USERNAME} -g ${USERNAME} mkdir /home/${USERNAME}/.ssh/
sudo -u ${USERNAME} -g ${USERNAME} mkdir /home/${USERNAME}/Documents/
sudo -u ${USERNAME} -g ${USERNAME} mkdir /home/${USERNAME}/bin/
tee -a /home/${USERNAME}/.bash_aliases > /dev/null \
<<EOF
if [[ ":\${PATH}:" != *":/home/${USERNAME}/bin:"* ]]; then
  export PATH=\${PATH}:/home/${USERNAME}/bin
fi
if [[ ":\${PATH}:" != *":/home/${USERNAME}/.local/bin:"* ]]; then
  export PATH=\${PATH}:/home/${USERNAME}/.local/bin
fi
EOF

echo "Assigning groups ..."
if [ -f /root/required_groups ]; then
  while IFS="" read -r GROUP || [ -n "$GROUP" ]
  do
    usermod -aG ${GROUP} ${USERNAME}
  done < /root/required_groups
fi

if [ "${DOCKER_GROUP}" = "true" ]; then
  usermod -aG docker ${USERNAME}
  echo "Added user to docker group"
fi

echo "User created"
