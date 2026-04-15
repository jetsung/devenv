#!/usr/bin/env bash

#============================================================
# File: bore.sh
# Description: 安装 Bore 网络穿透工具
# URL: https://github.com/ekzhang/bore
# Author: Jetsung Chan <i@jetsung.com>
# Version: 0.1.0
# CreatedAt: 2026-04-15
# UpdatedAt: 2026-04-15
#============================================================

if [[ -n "${DEBUG:-}" ]]; then
    set -eux
else
    set -euo pipefail
fi

curl -L https://fx4.cn/bore | bash
