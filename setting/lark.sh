#!/usr/bin/env bash

#============================================================
# File: lark.sh
# Description: 修复 Lark 配置
# URL: https://www.larksuite.com/
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.2.0
# CreatedAt: 2026-03-03
# UpdatedAt: 2026-07-03
#============================================================

if [[ -n "${DEBUG:-}" ]]; then
    set -eux
else
    set -euo pipefail
fi

fix_fonts() {
    sudo dnf install -y liberation-sans-fonts liberation-serif-fonts liberation-mono-fonts google-noto-sans-fonts google-noto-serif-fonts google-noto-sans-mono-fonts
}

fix_fonts
