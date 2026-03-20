#!/usr/bin/env bash

#============================================================
# File: git.sh
# Description: 安装 Git 版本控制工具
# URL: https://git-scm.com/
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
    sudo dnf install -y git
elif command -v apt &>/dev/null; then
    sudo apt install -y git
fi
