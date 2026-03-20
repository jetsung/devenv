#!/usr/bin/env bash

#============================================================
# File: fcitx.sh
# Description: 配置 Fcitx5 输入法环境变量
# URL: https://fcitx-im.org/
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

mkdir -p ~/.config/autostart && cp /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart

# /etc/profile.d/fcitx5.sh
{
    echo 'export INPUT_METHOD=fcitx'
    echo 'export GTK_IM_MODULE=fcitx'
    echo 'export QT_IM_MODULE=fcitx'
    echo 'export XMODIFIERS=@im=fcitx'
    echo 'export QT_QPA_PLATFORM=xcb'
} > /etc/profile.d/fcitx5.sh

fcitx5-diagnose

