#!/usr/bin/env bash

#============================================================
# File: obs-studio.sh
# Description: 安装 OBS Studio 直播录制软件
# URL: https://obsproject.com/
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
    sudo dnf install -y obs-studio
elif command -v apt &>/dev/null; then
    sudo apt install -y obs-studio
fi
