#!/usr/bin/env bash

#============================================================
# File: chromium.sh
# Description: 安装 Chromium 浏览器
# URL: https://www.chromium.org/
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

mkdir -p "$HOME/.local/share/applications/"

curl -L https://fx4.cn/chromium | bash
