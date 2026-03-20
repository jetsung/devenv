#!/usr/bin/env bash

#============================================================
# File: prek.sh
# Description: 安装 Prek 工具
# URL: https://github.com/sohaha/prek
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

curl -L https://fx4.cn/prek | bash
