#!/usr/bin/env bash

#============================================================
# File: sqlite.sh
# Description: 安装 SQLite 数据库
# URL: https://www.sqlite.org/
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.1.0
# CreatedAt: 2026-03-14
# UpdatedAt: 2026-03-14
#============================================================

if [[ -n "${DEBUG:-}" ]]; then
    set -eux
else
    set -euo pipefail
fi

if command -v dnf &>/dev/null; then
    sudo dnf install -y sqlite3
elif command -v apt &>/dev/null; then
    sudo apt install -y sqlite3
fi
