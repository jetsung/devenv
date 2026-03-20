#!/usr/bin/env bash

#============================================================
# File: gimp.sh
# Description: 安装 GIMP 图像编辑器 (Flatpak)
# URL: https://www.gimp.org/downloads/
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.1.0
# CreatedAt: 2026-02-19
# UpdatedAt: 2026-02-27
#============================================================

if [[ -n "${DEBUG:-}" ]]; then
    set -eux
else
    set -euo pipefail
fi

FLATPAK_ID="org.gimp.GIMP"
CMD="flatpak install flathub $FLATPAK_ID"

echo "https://www.gimp.org/downloads/"

echo "https://flathub.org/en/apps/$FLATPAK_ID"
echo "$CMD"

$CMD
