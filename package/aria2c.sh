#!/usr/bin/env bash

#============================================================
# File: aria2c.sh
# Description: 安装 aria2 下载工具
# URL: https://aria2.github.io/
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
    sudo dnf install -y aria2c
elif command -v apt &>/dev/null; then
    sudo apt install -y aria2
fi
