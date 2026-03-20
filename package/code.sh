#!/usr/bin/env bash

#============================================================
# File: code.sh
# Description: 安装 Visual Studio Code 和 VS Code Insiders
# URL: https://code.visualstudio.com/
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.1.0
# CreatedAt: 2026-03-14
# UpdatedAt: 2026-03-14
#============================================================

if [[ -n "${DEBUG:-}" ]]; then
    set -eux
else
    set -euo pipefail
fi

install_dnf() {
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

    sudo dnf check-update
    sudo dnf install -y code
    sudo dnf install -y code-insiders
}

install_apt() {
    sudo apt-get install wget gpg &&
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg &&
    sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg &&
    rm -f microsoft.gpg

    sudo apt install apt-transport-https
    sudo apt install -y code
    sudo apt install -y code-insiders
}

main() {
    echo "https://code.visualstudio.com/"
    echo

    if command -v dnf &>/dev/null; then
        install_dnf
    elif command -v apt &>/dev/null; then
        install_apt
    fi
}

main "$@"
