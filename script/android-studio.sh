#!/usr/bin/env bash

#============================================================
# File: android-studio.sh
# Description: 安装 Android Studio IDE
# URL: https://developer.android.com/studio
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

curl -L https://fx4.cn/androidstudio | bash
