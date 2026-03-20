#!/usr/bin/env bash

#============================================================
# File: flameshot.sh
# Description: 安装 Flameshot 截图工具
# URL: https://flameshot.org/
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

if command -v dnf &>/dev/null; then
    sudo dnf install -y flameshot
elif command -v apt &>/dev/null; then
    sudo apt install -y flameshot
fi
