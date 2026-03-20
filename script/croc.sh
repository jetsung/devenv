#!/usr/bin/env bash

#============================================================
# File: croc.sh
# Description: 安装 Croc 文件传输工具
# URL: https://schollz.com/software/croc6/
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

curl -L https://fx4.cn/croc | bash
