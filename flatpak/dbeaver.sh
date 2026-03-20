#!/usr/bin/env bash

#============================================================
# File: dbeaver.sh
# Description: 安装 DBeaver Community 数据库管理工具 (Flatpak)
# URL: https://dbeaver.io/download/
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

FLATPAK_ID="io.dbeaver.DBeaverCommunity"
CMD="flatpak install flathub $FLATPAK_ID"

echo "https://dbeaver.io/download/"

echo "https://flathub.org/en/apps/$FLATPAK_ID"
echo "$CMD"

$CMD
