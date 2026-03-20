#!/usr/bin/env bash

#============================================================
# File: blesh.sh
# Description: 安装 ble.sh Bash 行编辑增强工具
# URL: https://github.com/akinomyoga/ble.sh
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.1.0
# CreatedAt: 2026-03-03
# UpdatedAt: 2026-03-03
#============================================================

if [[ -n "${DEBUG:-}" ]]; then
    set -eux
else
    set -euo pipefail
fi

if [[ -f "$HOME/.local/share/blesh/ble.sh" ]]; then
    echo "ble.sh is already installed"
    exit 0
fi

# 检查 gawk 是否已安装
if ! command -v gawk &>/dev/null; then
    # 检测包管理器并安装 gawk
    if command -v dnf &>/dev/null; then
        sudo dnf install -y gawk
    elif command -v apt &>/dev/null; then
        sudo apt install -y gawk
    else
        echo "Unsupported package manager. Please install gawk manually."
        exit 1
    fi
fi

pushd "/tmp" >/dev/null || exit
git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local
popd >/dev/null || exit