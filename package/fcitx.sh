#!/usr/bin/env bash

#============================================================
# File: fcitx.sh
# Description: 安装 Fcitx5 输入法框架及中文支持
# URL: https://fcitx-im.org/
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
    sudo dnf install -y fcitx5 \
        fcitx5-autostart \
        fcitx5-chinese-addons \
        fcitx5-configtool \
        fcitx5-gtk \
        fcitx5-qt \
        fcitx5-rime \
        kcm-fcitx5
elif command -v apt &>/dev/null; then
    sudo apt install -y fcitx5 \
        fcitx5-autostart \
        fcitx5-chinese-addons \
        fcitx5-config-qt \
        fcitx5-gtk \
        fcitx5-qt \
        fcitx5-rime \
        kcm-fcitx5
fi
