#!/usr/bin/env bash

#============================================================
# File: obsidian.sh
# Description: 安装 Obsidian 笔记软件 (Flatpak)
# URL: https://obsidian.md/download
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

FLATPAK_ID="md.obsidian.Obsidian"
CMD="flatpak install flathub $FLATPAK_ID"

echo "https://obsidian.md/download"

echo "https://flathub.org/en/apps/$FLATPAK_ID"
echo "$CMD"

$CMD
