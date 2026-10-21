#!/usr/bin/env bash

echo "Installing requirements ..."
apt update
apt install -y \
    bash-completion \
    curl \
    git \
    jq \
    unzip

echo "Cleaning up ..."
apt clean
apt -y autoremove
rm -rf /var/lib/apt/lists/*

echo "Downloading and installing tfswitch ..."
curl -fsSL https://raw.githubusercontent.com/warrensbox/terraform-switcher/master/install.sh | bash
echo "tfswitch installed"

echo "Downloading and installing tgswitch ..."
curl -fsSL https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | bash
echo "tgswitch installed"

echo "Configuring bash aliases ..."
tee -a /etc/skel/.bash_aliases \
<< 'EOF'
tfplan_summary() (
  set -o pipefail
  terraform plan -json |
  jq -s -r '
    (
      map(select(.type == "change_summary") | .["@message"])
    )
    +
    (
      map(select(.type == "planned_change" and .change.action != "read"))
      | group_by(.change.action)
      | map(
        . as $group
        | ($group[0].change.action) as $action
        | (if $action == "create" then "\u001b[32m"
          elif $action == "update" then "\u001b[33m"
          elif $action == "delete" or $action == "destroy"then "\u001b[31m"
          else "\u001b[0m"
          end) as $color
        | "\u001b[0m\($action):\n"
        + ($group | map("  \($color)\(.change.resource.addr)\u001b[0m") | join("\n"))
        )
    )
    | .[]
  '
)

EOF