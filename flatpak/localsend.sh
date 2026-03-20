#!/usr/bin/env bash

#============================================================
# File: localsend.sh
# Description: 安装 LocalSend 局域网文件传输工具 (Flatpak)
# URL: https://localsend.org/download
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.1.0
# CreatedAt: 2026-02-18
# UpdatedAt: 2026-02-27
#============================================================

if [[ -n "${DEBUG:-}" ]]; then
    set -eux
else
    set -euo pipefail
fi

FLATPAK_ID="org.localsend.localsend_app"
CMD="flatpak install flathub $FLATPAK_ID"

echo "https://localsend.org/download"

echo "https://flathub.org/en/apps/$FLATPAK_ID"
echo "$CMD"

$CMD
