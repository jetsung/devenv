#!/usr/bin/env bash

install_rpm() {
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

    sudo dnf check-update
    sudo dnf install -y code
    sudo dnf install -y code-insiders
}

install_apt() {
    echo TODO
}

main() {
    install_rpm
}

main "$@"
