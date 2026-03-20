#!/usr/bin/env bash

#============================================================
# File: lark.sh
# Description: 配置飞书桌面快捷方式
# URL: https://www.larksuite.com/
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

sudo sed -i 's#NoDisplay=.*#NoDisplay=false#' /usr/share/applications/bytedance-lark.desktop

sudo update-desktop-database
sudo update-desktop-database /usr/share/applications

if [ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$DESKTOP_SESSION" = "plasma" ]; then
    kbuildsycoca6 --noincremental
fi

sudo update-mime-database /usr/share/mime

desktop-file-validate /usr/share/applications/bytedance-lark.desktop