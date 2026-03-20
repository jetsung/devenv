#!/usr/bin/env bash

#============================================================
# File: netease-cloud-music.sh
# Description: 安装网易云音乐 GTK 客户端 (Flatpak)
# URL: https://github.com/gmg137/netease-cloud-music-gtk
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

FLATPAK_ID="com.github.gmg137.netease-cloud-music-gtk"
CMD="flatpak install flathub $FLATPAK_ID"

echo "https://github.com/gmg137/netease-cloud-music-gtk"

echo "https://flathub.org/en/apps/$FLATPAK_ID"
echo "$CMD"

$CMD
