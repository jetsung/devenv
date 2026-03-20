#!/usr/bin/env bash

#============================================================
# File: base.sh
# Description: 安装基础开发工具 (gcc, make, rpm 等)
# URL: https://fx4.cn/base
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.1.0
# CreatedAt: 2026-03-03
# UpdatedAt: 2026-03-14
#============================================================

if [[ -n "${DEBUG:-}" ]]; then
    set -eux
else
    set -euo pipefail
fi

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