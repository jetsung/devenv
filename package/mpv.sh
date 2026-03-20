#!/usr/bin/env bash

#============================================================
# File: mpv.sh
# Description: 安装 mpv 媒体播放器
# URL: https://mpv.io/
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
    sudo dnf install -y mpv
elif command -v apt &>/dev/null; then
    sudo apt install -y mpv
fi
