#!/usr/bin/env bash

# Detect OS
if [ -f /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    OS=$NAME
fi

if [[ "$OS" == *"Debian"* ]] || [[ "$OS" == *"Ubuntu"* ]]; then
    # Debian/Ubuntu
    sudo apt-get update
    sudo apt-get install -y gcc g++ make libc6-dev
    sudo apt-get install -y rpm cpio
elif [[ "$OS" == *"Fedora"* ]] || [[ "$OS" == *"CentOS"* ]] || [[ "$OS" == *"Red Hat"* ]]; then
    # Fedora/RHEL/CentOS
    sudo dnf install -y gcc gcc-c++ make glibc-devel
    sudo dnf install -y rpm-build cpio
else
    echo "Unsupported OS: $OS"
    exit 1
fi